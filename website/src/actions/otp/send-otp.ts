import crypto from "node:crypto";
import { z } from "astro/zod";
import { defineAction } from "astro:actions";
import { db, Otp } from "astro:db";
import { transporter } from "../sendmail";

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

  await db.insert(Otp).values({
    userId: email,
    value: otp,
    createdAt: Date.now(),
    validUntil: Date.now() + 1000 * 60 * 5,
  });
}
