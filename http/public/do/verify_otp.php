<?php

use JoeacNet\Http\Db;

require_once __DIR__ . "/../../php/db.php";

$db = Db\connectDb();

$payload = json_decode(file_get_contents("php://input"), true);
$guess = getGuessFromPayloadAndValidate($payload);
$leniencySecs = getLeniencySecsFromPayloadAndValidate($payload);
$userId = getUserIdFromPayloadAndValidate($payload);

if (
  !Db\isOtpCorrect(
    db: $db,
    userId: $userId,
    guess: $guess,
    leniencySecs: $leniencySecs,
  )
) {
  http_response_code(400);
  echo "OTP is not valid";
  exit();
}
Db\deleteAllOtpsForUser($db, $userId);
$token = bin2hex(random_bytes(256));
Db\insertSendEmailToken(db: $db, userId: $userId, token: $token);
http_response_code(200);
echo $token;
exit();

/// functions ///

function getGuessFromPayloadAndValidate(array $payload): string
{
  $guess = (string) $payload["guess"];
  if (strlen($guess) != 6) {
    http_response_code(400);
    echo "guess must be six characters long";
    exit();
  }
  return $guess;
}

function getLeniencySecsFromPayloadAndValidate(array $payload): int
{
  if ((bool) $payload["lenient"] ?? false) {
    return 60;
  }
  return 0;
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
