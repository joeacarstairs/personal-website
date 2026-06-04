/** @typedef {import("./selectors.js").Selectors} Selectors */

import { actions } from "./actions.js";
import { resetResendButton } from "./reset-resend-button.js";
import { postErrorMessageOnOtpForm } from "./post-error-message.js";

/** @typedef {{ resendButtonInterval: NodeJS.Timeout | undefined }} Result */

const fallbackErrorMsg =
  "No can do. I'm afraid joeac.net is a bit broken right now - sorry about that.";

/**
 * @param {Selectors} selectors
 * @param {NodeJS.Timeout | undefined} resetButtonInterval
 * @returns {Promise<Result>}
 */
export async function resendOtp(selectors, resetButtonInterval) {
  const result = resetResendButton(selectors, resetButtonInterval);
  const name = selectors.contactForm.nameElem()?.value;
  const email = selectors.contactForm.emailElem().value;

  try {
    await actions.sendOtp({ type: "email", name, email });
  } catch (sendOtpError) {
    const errorMsg = sendOtpError?.toString() ?? fallbackErrorMsg;
    postErrorMessageOnOtpForm(selectors, errorMsg);
    throw sendOtpError;
  }

  return result;
}
