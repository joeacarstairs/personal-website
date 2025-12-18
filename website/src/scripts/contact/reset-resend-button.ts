import type { Selectors } from "./selectors";

export function resetResendButton(
  { otpDialog }: Selectors,
  resendButtonInterval: NodeJS.Timeout | undefined,
): Result {
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

type Result = {
  resendButtonInterval: NodeJS.Timeout | undefined;
};
