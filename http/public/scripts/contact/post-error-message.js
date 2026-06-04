/** @typedef {import("./selectors.js").Selectors} Selectors */

/**
 * @param {{contactForm: Selectors}} contactForm
 * @param {string} errorMsg
 */
export function postErrorMessageOnContactForm({ contactForm }, errorMsg) {
  const errorElem = contactForm.errorElem();
  if (errorElem) {
    errorElem.textContent = errorMsg;
    errorElem.removeAttribute("hidden");
  } else {
    alert(errorMsg);
  }
}

/**
 * @param {{otpDialog: Selectors}} otpDialog
 * @param {string} errorMsg
 */
export function postErrorMessageOnOtpForm({ otpDialog }, errorMsg) {
  const errorElem = otpDialog.errorElem();
  if (errorElem) {
    errorElem.textContent = errorMsg;
    errorElem.removeAttribute("hidden");
  } else {
    alert(errorMsg);
  }
  /** @type NodeListOf<HTMLInputElement> */
  const inputs = otpDialog.allOtpInputs();
  for (const input of inputs) {
    input.value = "";
  }
}
