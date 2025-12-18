import type { Selectors } from "./selectors";

export function postErrorMessageOnContactForm(
  { contactForm }: Selectors,
  errorMsg: string,
) {
  const errorElem = contactForm.errorElem();
  if (errorElem) {
    errorElem.textContent = errorMsg;
    errorElem.removeAttribute("hidden");
  } else {
    alert(errorMsg);
  }
}

export function postErrorMessageOnOtpForm(
  { otpDialog }: Selectors,
  errorMsg: string,
) {
  const errorElem = otpDialog.errorElem();
  if (errorElem) {
    errorElem.textContent = errorMsg;
    errorElem.removeAttribute("hidden");
  } else {
    alert(errorMsg);
  }
  for (const input of otpDialog.allOtpInputs()) {
    (input as HTMLInputElement).value = "";
  }
}
