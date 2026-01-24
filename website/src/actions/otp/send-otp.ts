import crypto from "node:crypto";
import { z } from "astro/zod";
import { defineAction } from "astro:actions";
import { db, gte, Otp, SentEmails } from "astro:db";
import { transporter } from "../sendmail";
import { MAX_DAILY_EMAILS } from "astro:env/server";

export default defineAction({
  input: z.object({
    email: z.string().email(),
    name: z.string().optional(),
    type: z.enum(["email"]),
  }),
  handler: sendOtp,
});

type OtpParams = {
  email: string;
  name?: string;
  type: "email";
};

async function sendOtp({ email, name }: OtpParams) {
  const otp = crypto.randomBytes(3).toString("hex").toLocaleUpperCase();
  const otpPretty = `${otp.slice(0, 3)}-${otp.slice(3)}`;

  const emailsSentLast24Hours = await db.$count(
    SentEmails,
    gte(SentEmails.sentAt, Date.now() - 1000 * 60 * 60 * 24),
  );
  if (emailsSentLast24Hours >= MAX_DAILY_EMAILS) {
    console.warn(
      `${name} <${email}> requested an OTP, but ${emailsSentLast24Hours} have already been sent, whereas the max daily load is ${MAX_DAILY_EMAILS}.`,
    );
    throw new Error(
      `${emailsSentLast24Hours} emails have been sent in the last 24 hours, but the max daily load is ${MAX_DAILY_EMAILS}.`,
    );
  }

  const info = await transporter.sendMail({
    from: `"Joe Carstairs" <me@joeac.net>`,
    to: `${name ? `"${name}" ` : ""}<${email}>`,
    subject: `joeac.net: your OTP is ${otpPretty}`,
    text: `
Someone tried to use this email address on joeac.net. If this was you,
your one-time passcode is ${otpPretty}. If this wasn't you, you don't need
to do anything.`,
  });
  console.log(
    `Sent OTP (${otpPretty}) to ${email}. Message ID: ${info.messageId}`,
  );

  await db
    .insert(SentEmails)
    .values({ messageId: info.messageId, sentAt: Date.now() });

  await db.insert(Otp).values({
    userId: email,
    value: otp,
    createdAt: Date.now(),
    validUntil: Date.now() + 1000 * 60 * 5,
  });
}
