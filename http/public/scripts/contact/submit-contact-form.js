import { actions } from "./actions.js";
import { postErrorMessageOnContactForm } from "./post-error-message.js";
import { resetResendButton } from "./reset-resend-button.js";

/** @typedef {import("./selectors.js").Selectors} Selectors */

const fallbackErrorMsg =
  "No can do. I'm afraid joeac.net is a bit broken right now - sorry about that.";

/**
 * @param {Selectors} selectors
 * @param {NodeJS.Timeout | undefined} resetButtonInterval
 * @returns {Promise<Result>}
 */
export async function submitContactForm(selectors, resendButtonInterval) {
  const { contactForm, otpDialog } = selectors;

  const name = contactForm.nameElem()?.value;
  const email = contactForm.emailElem().value;

  contactForm.submitButton()?.setAttribute("disabled", "");
  try {
    await actions.sendOtp({ type: "email", name, email });
  } catch (sendOtpError) {
    const errorMsg = sendOtpError?.toString() ?? fallbackErrorMsg;
    postErrorMessageOnContactForm(selectors, errorMsg);
    throw sendOtpError;
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
