import { column, defineDb, defineTable } from "astro:db";

const Otp = defineTable({
  columns: {
    userId: column.text(),
    value: column.text(),
    createdAt: column.number(),
    validUntil: column.number(),
  },
});

const SendmailToken = defineTable({
  columns: {
    userId: column.text(),
    value: column.text(),
    createdAt: column.number(),
    validUntil: column.number(),
  },
});

const SentEmails = defineTable({
  columns: {
    messageId: column.text(),
    sentAt: column.number(),
  },
});

export default defineDb({
  tables: {
    Otp,
    SendmailToken,
    SentEmails,
  },
});
