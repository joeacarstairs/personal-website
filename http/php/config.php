<?php namespace JoeacNet\Http\Config;

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
