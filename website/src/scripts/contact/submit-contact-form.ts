import { actions } from "astro:actions";
import { postErrorMessageOnContactForm } from "./post-error-message";
import { resetResendButton } from "./reset-resend-button";
import type { Selectors } from "./selectors";

const fallbackErrorMsg =
  "No can do. I'm afraid joeac.net is a bit broken right now - sorry about that.";

export async function submitContactForm(
  selectors: Selectors,
  resendButtonInterval: NodeJS.Timeout | undefined,
): Promise<Result> {
  const { contactForm, otpDialog } = selectors;

  const name = contactForm.nameElem()?.value;
  const email = contactForm.emailElem().value;

  contactForm.submitButton()?.setAttribute("disabled", "");
  const sendOtpResult = await actions.otp.send({ type: "email", name, email });
  if (sendOtpResult.error) {
    const errorMsg = sendOtpResult.error?.toString() ?? fallbackErrorMsg;
    postErrorMessageOnContactForm(selectors, errorMsg);
    throw sendOtpResult.error;
  }

  const otpRecipient = otpDialog.otpRecipient();
  email && otpRecipient && (otpRecipient.textContent = `<${email}>`);
  const otpValidUntil = otpDialog.otpValidUntil();
  const validUntil = new Date(Date.now() + 1000 * 60 * 5);
  otpValidUntil &&
    (otpValidUntil.textContent = `until ${validUntil.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}`);

  const dialog = otpDialog.self();
  dialog.showModal();
  contactForm.submitButton()?.removeAttribute("disabled");
  dialog.addEventListener("click", function (event) {
    const rect = dialog.getBoundingClientRect();
    const isInDialog =
      rect.top <= event.clientY &&
      event.clientY <= rect.top + rect.height &&
      rect.left <= event.clientX &&
      event.clientX <= rect.left + rect.width;
    if (!isInDialog) {
      dialog.close();
    }
  });

  return resetResendButton(selectors, resendButtonInterval);
}

type Result = {
  resendButtonInterval: NodeJS.Timeout | undefined;
};
