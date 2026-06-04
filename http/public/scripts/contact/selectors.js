/**
 * @typedef {Object} Selectors
 * @property {Object} contactForm
 * @property {() => HTMLInputElement} contactForm.emailElem
 * @property {() => Element | null} contactForm.errorElem
 * @property {() => HTMLInputElement} contactForm.nameElem
 * @property {() => HTMLTextAreaElement} contactForm.messageElem
 * @property {() => HTMLFormElement | null} contactForm.self
 * @property {() => HTMLInputElement | null} contactForm.submitButton
 * @property {Object} otpDialog
 * @property {() => NodeListOf<HTMLInputElement>} otpDialog.allOtpInputs
 * @property {() => Element | null} otpDialog.errorElem
 * @property {() => HTMLInputElement | null} otpDialog.firstOtpInput
 * @property {() => HTMLFormElement | null} otpDialog.otpForm
 * @property {() => Element | null} otpDialog.otpRecipient
 * @property {() => Element | null} otpDialog.otpValidUntil
 * @property {() => HTMLButtonElement | null} otpDialog.resendButton
 * @property {() => HTMLDialogElement} otpDialog.self
 * @property {() => HTMLInputElement | null} otpDialog.submitButton
 * @property {Object} successSection
 * @property {() => Element | null} successSection.email
 * @property {() => Element | null} successSection.message
 * @property {() => Element | null} successSection.name
 * @property {() => Element | null} successSection.self
 */
