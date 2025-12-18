import { actions } from "astro:actions";
import type { Selectors } from "./selectors";
import {
  postErrorMessageOnContactForm,
  postErrorMessageOnOtpForm,
} from "./post-error-message";

const fallbackErrorMsg =
  "No can do. I'm afraid joeac.net is a bit broken right now - sorry about that.";

export async function submitOtpForm(selectors: Selectors) {
  const { contactForm, otpDialog, successSection } = selectors;
  const otpForm = otpDialog.otpForm();
  otpDialog.submitButton()?.setAttribute("disabled", "");

  const otpFormData = new FormData(otpForm ?? undefined);
  const guess = [
    otpFormData.get("1"),
    otpFormData.get("2"),
    otpFormData.get("3"),
    otpFormData.get("4"),
    otpFormData.get("5"),
    otpFormData.get("6"),
  ].join("");

  const name = contactForm.nameElem()?.value;
  const email = contactForm.emailElem().value;
  const message = contactForm.messageElem()?.value;

  const verifyResult = await actions.otp.verify({ guess, userId: email });
  if (verifyResult.error) {
    otpDialog.submitButton()?.removeAttribute("disabled");
    postErrorMessageOnOtpForm(
      selectors,
      verifyResult.error?.toString() ?? fallbackErrorMsg,
    );
    return;
  }
  if (!verifyResult.data) {
    otpDialog.submitButton()?.removeAttribute("disabled");
    postErrorMessageOnOtpForm(selectors, "Incorrect OTP. Check your email?");
    otpDialog.firstOtpInput()?.focus();
    return;
  }
  const sendmailToken = verifyResult.data;

  const sendmailResult = await actions.sendmail({
    email,
    message: message,
    name: name,
    userId: email,
    token: sendmailToken,
  });
  if (sendmailResult.error) {
    const errorMsg = sendmailResult.error?.toString() ?? fallbackErrorMsg;
    postErrorMessageOnOtpForm(selectors, errorMsg);
    otpDialog.submitButton()?.removeAttribute("disabled");
    return;
  }

  const sentName = successSection.name();
  const sentEmail = successSection.email();
  const sentMessage = successSection.message();
  sentName && (sentName.textContent = name ?? "???");
  sentEmail && (sentEmail.textContent = email ?? "???");
  sentMessage && (sentMessage.textContent = message ?? "???");

  contactForm.self()?.remove();
  successSection.self()?.removeAttribute("hidden");
  otpDialog.submitButton()?.removeAttribute("disabled");
  otpDialog.self().close();
}
