<?php namespace JoeacNet\Http\Config;

function maxDailyEmails(): int|null
{
  $maxDailyEmails = getenv("MAX_DAILY_EMAILS");
  if (!is_numeric($maxDailyEmails)) {
    return null;
  }
  return $maxDailyEmails;
}

function contactMailbox(): string|null
{
  return (string) getenv("CONTACT_MAILBOX");
}

function contactMailboxName(): string|null
{
  return (string) getenv("CONTACT_MAILBOX_NAME");
}

function localSmtpFrom(): string|null
{
  return (string) getenv("LOCAL_SMTP_FROM");
}

function localSmtpFromName(): string|null
{
  return (string) getenv("LOCAL_SMTP_FROM_NAME");
}

function localSmtpHost(): string|null
{
  return (string) getenv("LOCAL_SMTP_HOST");
}

function localSmtpPort(): string|null
{
  return (string) getenv("LOCAL_SMTP_PORT");
}

function localSmtpUser(): string|null
{
  return (string) getenv("LOCAL_SMTP_USER");
}

function localSmtpPass(): string|null
{
  return (string) getenv("LOCAL_SMTP_PASSWORD");
}

function dbScheme(): string|null
{
  return (string) getenv("DB_SCHEME");
}

function dbPath(): string|null
{
  return (string) getenv("DB_PATH");
}
