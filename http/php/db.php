<?php namespace JoeacNet\Http\Db;

use JoeacNet\Http\Config;

use PDO;

require_once __DIR__ . "/config.php";

function connectDb(): PDO
{
  $pdo = new PDO(Config\dbScheme() . ":" . Config\dbPath());
  $pdo = createTables($pdo);
  return $pdo;
}

function createTables(PDO $pdo): PDO
{
  $pdo->exec(
    <<<SQL
    CREATE TABLE IF NOT EXISTS otp (
      userId TEXT NOT NULL,
      value TEXT NOT NULL,
      createdAtUnixSecs INTEGER NOT NULL,
      validUntilUnixSecs INTEGER NOT NULL
    );
    SQL
    ,
  );

  $pdo->exec(
    <<<SQL
    CREATE TABLE IF NOT EXISTS send_email_token (
      userId TEXT NOT NULL,
      value TEXT NOT NULL,
      createdAtUnixSecs INTEGER NOT NULL,
      validUntilUnixSecs INTEGER NOT NULL
    );
    SQL
    ,
  );

  $pdo->exec(
    <<<SQL
    CREATE TABLE IF NOT EXISTS sent_emails (
      messageId TEXT NOT NULL,
      sentAtUnixSecs INTEGER NOT NULL
    );
    SQL
    ,
  );

  return $pdo;
}

function countEmailsSentLast24Hours(PDO $db): int
{
  $twentyFourHoursAgo = time() - 24 * 60 * 60;
  return (int) $db
    ->query(
      <<<SQL
      SELECT COUNT(*) as count
      FROM sent_emails
      WHERE sentAtUnixSecs >= $twentyFourHoursAgo;
      SQL
      ,
    )
    ->fetchColumn(0);
}

function insertSendEmailToken(PDO $db, string $userId, string $token)
{
  $createdAtUnixSecs = time();
  $validUntilUnixSecs = $createdAtUnixSecs + 60;
  $db
    ->prepare(
      <<<SQL
      INSERT
      INTO send_email_token
      (userId, value, createdAtUnixSecs, validUntilUnixSecs)
      VALUES
      (:userId, :token, :createdAtUnixSecs, :validUntilUnixSecs);
      SQL
      ,
    )
    ->execute([
      "userId" => $userId,
      "token" => $token,
      "createdAtUnixSecs" => $createdAtUnixSecs,
      "validUntilUnixSecs" => $validUntilUnixSecs,
    ]);
}

function isTokenValid(PDO $db, string $userId, string $token): int
{
  $now = time();
  $stmt = $db->prepare(
    <<<SQL
    SELECT COUNT(*) AS count
    FROM send_email_token
    WHERE userId = :userId
      AND value = :token
      AND validUntilUnixSecs >= :validUntilUnixSecs;
    SQL
    ,
  );
  $stmt->execute([
    "userId" => $userId,
    "token" => $token,
    "validUntilUnixSecs" => $now,
  ]);
  $validTokenCount = (int) $stmt->fetchColumn(0);
  return $validTokenCount > 0;
}

function deleteAllTokensForUser(PDO $db, string $userId)
{
  $db
    ->prepare(
      <<<SQL
      DELETE
      FROM send_email_token
      WHERE userId = :userId;
      SQL
      ,
    )
    ->execute(["userId" => $userId]);
}

function deleteAllOtpsForUser(PDO $db, string $userId)
{
  $db
    ->prepare(
      <<<SQL
      DELETE
      FROM otp
      WHERE userId = :userId;
      SQL
      ,
    )
    ->execute(["userId" => $userId]);
}

function recordSentEmail(PDO $db, string $messageId)
{
  $now = time();
  $stmt = $db->prepare(
    <<<SQL
    INSERT
    INTO sent_emails
    (messageId,  sentAtUnixSecs)
    VALUES
    (:messageId, :now);
    SQL
    ,
  );
  $stmt->execute(["messageId" => $messageId, "now" => $now]);
}

function insertOtp(PDO $db, string $userId, string $otp)
{
  $createdAtUnixSecs = time();
  $validUntilUnixSecs = $createdAtUnixSecs + 60 * 5;
  $db
    ->prepare(
      <<<SQL
      INSERT
      INTO otp
      (userId, value, createdAtUnixSecs, validUntilUnixSecs)
      VALUES
      (:userId, :otp, :createdAtUnixSecs, :validUntilUnixSecs)
      SQL
      ,
    )
    ->execute([
      "userId" => $userId,
      "otp" => $otp,
      "createdAtUnixSecs" => $createdAtUnixSecs,
      "validUntilUnixSecs" => $validUntilUnixSecs,
    ]);
}

function isOtpCorrect(
  PDO $db,
  string $userId,
  string $guess,
  int $leniencySecs,
): bool {
  $stmt = $db->prepare(
    <<<SQL
    SELECT
    COUNT(*) as count
    FROM otp
    WHERE userId = :userId
      AND value = :guess
      AND validUntilUnixSecs >= :validUntilUnixSecs
    SQL
    ,
  );
  $stmt->execute([
    "userId" => $userId,
    "guess" => $guess,
    "validUntilUnixSecs" => time() - $leniencySecs,
  ]);
  return $stmt->fetchColumn(0);
}
