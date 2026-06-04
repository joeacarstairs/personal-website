<?php namespace JoeacNet\Http\Config;

function dbScheme(): string|null
{
  return (string) getenv("DB_SCHEME");
}

function dbPath(): string|null
{
  return (string) getenv("DB_PATH");
}
