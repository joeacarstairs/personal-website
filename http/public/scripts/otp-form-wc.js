class OtpForm extends HTMLElement {
  /** @type MutationObserver? */
  observer;

  constructor() {
    super();
  }

  connectedCallback() {
    this.observer = new MutationObserver(() => {
      this.clearInputs();
      this.configureInputs();
    });
    this.observer.observe(this, { childList: true, subtree: true });
  }

  disconnectedCallback() {
    this.observer?.disconnect();
  }

  clearInputs() {
    console.log("clearing all inputs");
    /** @type NodeListOf<HTMLInputElement> */
    const inputs = this.querySelectorAll('input:not([type="submit"])');
    for (const input of inputs) {
      input.value = "";
    }
  }

  configureInputs() {
    this.observer?.disconnect();
    /** @type NodeListOf<HTMLInputElement> */
    const inputs = this.querySelectorAll('input:not([type="submit"])');
    /** @type NodeListOf<HTMLFormElement> */
    const form = this.querySelector("form");

    for (const input of inputs) {
      input.addEventListener("focus", () => {
        input.select();
      });

      input.addEventListener("input", () => {
        if (input.value.length > 0) {
          input.value = input.value.slice(0, 1).toLocaleUpperCase();
          /** @type HTMLInputElement */
          const nextInput = input.nextElementSibling;
          if (nextInput) {
            nextInput.focus();
            return;
          }

          /** @type HTMLInputElement */
          const submitButton = form.querySelector('input[type="submit"]');
          submitButton.focus();
          let areAllInputsEntered = true;
          inputs.forEach((input) => {
            areAllInputsEntered = areAllInputsEntered && input.value.length > 0;
          });
          if (areAllInputsEntered) {
            form.requestSubmit(submitButton);
          }
        }
      });
    }
  }
}

customElements.define("otp-form", OtpForm);
