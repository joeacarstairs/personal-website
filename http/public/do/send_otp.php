<?php

use JoeacNet\Http\Config;
use JoeacNet\Http\Db;
use JoeacNet\Http\Mail;

require_once __DIR__ . "/../../php/config.php";
require_once __DIR__ . "/../../php/db.php";
require_once __DIR__ . "/../../php/mail.php";

const SEND_OTP_TYPES = ["email"];

$db = Db\connectDb();

$payload = json_decode(file_get_contents("php://input"), true);
$email = getEmailFromPayloadAndValidate($payload);
$name = getNameFromPayloadAndValidate($payload);
$type = getTypeFromPayloadAndValidate($payload);

limitMaxDailyEmails(db: $db, email: $email, name: $name);

$otp = strtoupper(bin2hex(random_bytes(3)));
$prettyOtp = substr($otp, 0, 3) . "-" . substr($otp, 3, 6);
Db\insertOtp(db: $db, userId: $email, otp: $otp);

try {
  $messageId = Mail\sendEmail(
    toEmail: $email,
    toName: $name,
    subject: "joeac.net: your OTP is $prettyOtp",
    body: <<<BODY
    Someone tried to use this email address on joeac.net. If this was you,
    your one-time passcode is $prettyOtp. If this wasn't you, you don't need
    to do anything.
    BODY,
  );
} catch (Exception $e) {
  error_log("Email could not be sent: $e");
  http_response_code(500);
  echo "Email could not be sent: $e";
  exit();
}

Db\recordSentEmail($db, $messageId);
syslog(LOG_INFO, "Sent OTP ($prettyOtp) to $email. Message ID: $messageId");

http_response_code(200);
echo $messageId;
exit();

/// functions ///

function limitMaxDailyEmails(PDO $db, string $email, string $name)
{
  $countEmailsSentLast24Hours = Db\countEmailsSentLast24Hours($db);
  if ($countEmailsSentLast24Hours > Config\maxDailyEmails()) {
    $msg =
      "$name <$email> requested an OTP email, but $countEmailsSentLast24Hours emails have already been sent, whereas the max daily load is " .
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

function getTypeFromPayloadAndValidate(array $payload): string
{
  $type = (string) $payload["type"];
  if (!in_array($type, SEND_OTP_TYPES)) {
    http_response_code(400);
    echo "type must be one of: " . SEND_OTP_TYPES;
    exit();
  }
  return $type;
}
