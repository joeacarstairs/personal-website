<?php

use JoeacNet\Http\Config;
use JoeacNet\Http\Db;
use JoeacNet\Http\Mail;

require_once __DIR__ . "/../../vendor/autoload.php";
require_once __DIR__ . "/../../php/config.php";
require_once __DIR__ . "/../../php/db.php";
require_once __DIR__ . "/../../php/mail.php";

$db = Db\connectDb();

$payload = json_decode(file_get_contents("php://input"), true);
$name = getNameFromPayloadAndValidate($payload);
$email = getEmailFromPayloadAndValidate($payload);
$message = getMessageFromPayloadAndValidate($payload);
$token = getTokenFromPayloadAndValidate($payload);
$userId = getUserIdFromPayloadAndValidate($payload);

limitMaxDailyEmails($db);
verifyToken(db: $db, userId: $userId, token: $token);
Db\deleteAllTokensForUser($db, $userId);

$messageId = Mail\sendEmail(
  subject: "joeac.net: $name left a message",
  replyToEmail: $email,
  replyToName: $name,
  toEmail: Config\contactMailbox(),
  toName: Config\contactMailboxName(),
  body: "$name <$email> sent you a message:\n\n\n$message",
);
Db\recordSentEmail($db, $messageId);
syslog(LOG_INFO, "Sent an email to Joe. Message ID: $messageId");

http_response_code(200);
echo $messageId;
exit();

/// functions ///

function verifyToken(PDO $db, string $userId, string $token)
{
  if (!Db\isTokenValid($db, $userId, $token)) {
    http_response_code(400);
    echo "token is not valid";
    exit();
  }
}

function limitMaxDailyEmails(PDO $db)
{
  $countEmailsSentLast24Hours = Db\countEmailsSentLast24Hours($db);
  if ($countEmailsSentLast24Hours > Config\maxDailyEmails()) {
    $msg =
      "$countEmailsSentLast24Hours emails have been sent in the last 24 hours, but the max daily load is " .
      Config\maxDailyEmails() .
      ".";
    syslog(LOG_WARNING, $msg);
    http_response_code(500);
    echo $msg;
    exit();
  }
}

function getNameFromPayloadAndValidate(array $payload): string
{
  $name = (string) $payload["name"];
  if (is_null($name) || $name == "") {
    http_response_code(400);
    echo "name must not be empty";
    exit();
  }
  return $name;
}

function getEmailFromPayloadAndValidate(array $payload): string
{
  $email = (string) $payload["email"];
  if (is_null($email) || $email == "") {
    http_response_code(400);
    echo "email must not be empty";
    exit();
  }
  if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo "<$email> is not a valid email address.";
    exit();
  }
  return $email;
}

function getMessageFromPayloadAndValidate(array $payload): string
{
  $message = (string) $payload["message"];
  if (is_null($message) || $message == "") {
    http_response_code(400);
    echo "message must not be empty";
    exit();
  }
  return $message;
}

function getTokenFromPayloadAndValidate(array $payload): string
{
  $token = (string) $payload["token"];
  if (is_null($token) || $token == "") {
    http_response_code(400);
    echo "token must not be empty";
    exit();
  }
  return $token;
}

function getUserIdFromPayloadAndValidate(array $payload): string
{
  $userId = (string) $payload["userId"];
  if (is_null($userId) || $userId == "") {
    http_response_code(400);
    echo "userId must not be empty";
    exit();
  }
  return $userId;
}
