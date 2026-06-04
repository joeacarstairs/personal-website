/** @typedef {import("./selectors.js").Selectors} Selectors */

/** @typedef {{ resendButtonInterval: NodeJS.Timeout | undefined }} Result */

/**
 * @param {Selectors} selectors
 * @param {NodeJS.Timeout | undefined} resetButtonInterval
 * @returns {Result}
 */
export function resetResendButton({ otpDialog }, resendButtonInterval) {
  clearInterval(resendButtonInterval);

  const resendButton = otpDialog.resendButton();
  if (resendButton) {
    resendButton.setAttribute("data-countdown", "60");
    resendButton.setAttribute("disabled", "");

    resendButtonInterval = setInterval(() => {
      const countdown = +(resendButton.getAttribute("data-countdown") ?? 1) - 1;
      resendButton.setAttribute("data-countdown", countdown.toString());
      resendButton.textContent = `Resend (${countdown}s)`;
    }, 1000);

    setTimeout(() => {
      clearInterval(resendButtonInterval);
      resendButton.textContent = "Resend";
      resendButton.removeAttribute("disabled");
    }, 1000 * 60);
  }

  return { resendButtonInterval };
}
