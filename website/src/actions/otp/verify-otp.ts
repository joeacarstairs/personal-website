import { randomBytes } from "node:crypto";
import { z } from "astro/zod";
import { defineAction } from "astro:actions";
import { and, db, eq, gte, Otp, SendmailToken } from "astro:db";

export default defineAction({
  input: z.object({
    guess: z.string().length(6),
    lenient: z.boolean().default(false),
    userId: z.string().nonempty(),
  }),
  handler: verifyOtp,
});

async function verifyOtp({ guess, lenient, userId }: VerifyOtpParams) {
  const leniency = lenient ? 1000 * 60 : 0;
  const isOtpCorrect =
    (await db.$count(
      Otp,
      and(
        eq(Otp.userId, userId),
        eq(Otp.value, guess),
        gte(Otp.validUntil, Date.now() - leniency),
      ),
    )) > 0;

  if (!isOtpCorrect) {
    return false;
  }

  await db.delete(Otp).where(and(eq(Otp.userId, userId), eq(Otp.value, guess)));

  const token = randomBytes(256).toString("hex");
  await db.insert(SendmailToken).values({
    userId,
    value: token,
    createdAt: Date.now(),
    validUntil: Date.now() + 60_000,
  });

  return token;
}

type VerifyOtpParams = {
  guess: string;
  lenient: boolean;
  userId: string;
};
