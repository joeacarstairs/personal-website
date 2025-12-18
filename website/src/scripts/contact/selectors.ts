export type Selectors = {
  contactForm: {
    emailElem: () => HTMLInputElement;
    errorElem: () => Element | null;
    nameElem: () => HTMLInputElement;
    messageElem: () => HTMLTextAreaElement;
    self: () => HTMLFormElement | null;
    submitButton: () => HTMLInputElement | null;
  };
  otpDialog: {
    allOtpInputs: () => NodeListOf<HTMLInputElement>;
    errorElem: () => Element | null;
    firstOtpInput: () => HTMLInputElement | null;
    otpForm: () => HTMLFormElement | null;
    otpRecipient: () => Element | null;
    otpValidUntil: () => Element | null;
    resendButton: () => HTMLButtonElement | null;
    self: () => HTMLDialogElement;
    submitButton: () => HTMLInputElement | null;
  };
  successSection: {
    email: () => Element | null;
    message: () => Element | null;
    name: () => Element | null;
    self: () => Element | null;
  };
};
