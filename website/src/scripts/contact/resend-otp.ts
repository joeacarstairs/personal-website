import { actions } from "astro:actions";
import { resetResendButton } from "./reset-resend-button";
import { postErrorMessageOnOtpForm } from "./post-error-message";
import type { Selectors } from "./selectors";

const fallbackErrorMsg =
  "No can do. I'm afraid joeac.net is a bit broken right now - sorry about that.";

export async function resendOtp(
  selectors: Selectors,
  resetButtonInterval: NodeJS.Timeout | undefined,
): Promise<Result> {
  const result = resetResendButton(selectors, resetButtonInterval);
  const name = selectors.contactForm.nameElem()?.value;
  const email = selectors.contactForm.emailElem().value;

  const sendOtpResult = await actions.otp.send({ type: "email", name, email });
  if (sendOtpResult.error) {
    const errorMsg = sendOtpResult.error?.toString() ?? fallbackErrorMsg;
    postErrorMessageOnOtpForm(selectors, errorMsg);
    throw sendOtpResult.error;
  }

  return result;
}

type Result = {
  resendButtonInterval: NodeJS.Timeout | undefined;
};
