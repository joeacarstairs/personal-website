import { z } from "astro/zod";
import { defineAction } from "astro:actions";
import nodemailer from "nodemailer";
import {
  MAX_DAILY_EMAILS,
  LOCAL_SMTP_HOST,
  LOCAL_SMTP_PASSWORD,
  LOCAL_SMTP_PORT,
  LOCAL_SMTP_USER,
  CONTACT_MAILBOX,
  LOCAL_SMTP_ENVELOPE_FROM,
} from "astro:env/server";
import { and, db, eq, gte, SendmailToken, SentEmails } from "astro:db";

export default defineAction({
  input: z.object({
    email: z.string().email(),
    message: z.string().nonempty(),
    name: z.string().nonempty(),
    userId: z.string().nonempty(),
    token: z.string().nonempty(),
  }),
  handler: sendmail,
});

type SendEmailParams = {
  email: string;
  message: string;
  name: string;
  token: string;
  userId: string;
};

async function sendmail({
  name,
  email,
  message,
  token,
  userId,
}: SendEmailParams) {
  const isTokenCorrect =
    (await db.$count(
      SendmailToken,
      and(
        eq(SendmailToken.userId, userId),
        eq(SendmailToken.value, token),
        gte(SendmailToken.validUntil, Date.now()),
      ),
    )) > 0;
  if (!isTokenCorrect) {
    return false;
  }
  await db
    .delete(SendmailToken)
    .where(
      and(eq(SendmailToken.userId, userId), eq(SendmailToken.value, token)),
    );

  const emailsSentLast24Hours = await db.$count(
    SentEmails,
    gte(SentEmails.sentAt, Date.now() - 1000 * 60 * 60 * 24),
  );
  if (emailsSentLast24Hours > MAX_DAILY_EMAILS) {
    throw new Error(
      `${emailsSentLast24Hours} emails have been sent in the last 24 hours, but the max daily load is ${MAX_DAILY_EMAILS}.`,
    );
  }

  const info = await transporter.sendMail({
    from: LOCAL_SMTP_ENVELOPE_FROM,
    to: CONTACT_MAILBOX,
    subject: `joeac.net: ${name} left a message`,
    text: `${name} <${email}> sent you a message:\n\n\n${message}`,
  });
  await db
    .insert(SentEmails)
    .values({ messageId: info.messageId, sentAt: Date.now() });

  console.log("Sent an email to Joe. Message ID: ", info.messageId);
}

export const transporter = nodemailer.createTransport({
  host: LOCAL_SMTP_HOST,
  from: LOCAL_SMTP_ENVELOPE_FROM,
  port: LOCAL_SMTP_PORT,
  secure: false,
  authMethod: "PLAIN",
  auth: {
    type: "login",
    user: LOCAL_SMTP_USER,
    pass: LOCAL_SMTP_PASSWORD,
  },
});
