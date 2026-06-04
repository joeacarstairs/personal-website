<?php namespace JoeacNet\Http\Mail;

use PHPMailer\PHPMailer\PHPMailer;

use JoeacNet\Http\Config;

require_once __DIR__ . "/../vendor/autoload.php";

function sendEmail(
  string $toEmail,
  string $toName,
  string $subject,
  string $body,
  string $replyToEmail = null,
  string $replyToName = null,
): string {
  $mail = new PHPMailer();
  $mail->isSMTP();
  $mail->Host = Config\localSmtpHost();
  $mail->Port = Config\localSmtpPort();
  $mail->SMTPAuth = true;
  $mail->PlainAuth = true;
  $mail->Username = Config\localSmtpUser();
  $mail->Password = Config\localSmtpPass();
  $mail->setFrom(Config\localSmtpFrom(), Config\localSmtpFromName());
  if (!is_null($replyToEmail)) {
    $mail->addReplyTo($replyToEmail, $replyToName);
  }
  $mail->addAddress($toEmail, $toName);
  $mail->isHTML(false);
  $mail->Subject = "joeac.net: $subject";
  $mail->Body = "$body";
  $mail->send();
  return $mail->getLastMessageID();
}
