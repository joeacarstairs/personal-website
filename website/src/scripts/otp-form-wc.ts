class OtpForm extends HTMLElement {
  observer?: MutationObserver;

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
    const inputs = this.querySelectorAll(
      'input:not([type="submit"])',
    ) as NodeListOf<HTMLInputElement>;
    for (const input of inputs) {
      input.value = "";
    }
  }

  configureInputs() {
    this.observer?.disconnect();
    const inputs = this.querySelectorAll(
      'input:not([type="submit"])',
    ) as NodeListOf<HTMLInputElement>;
    const form = this.querySelector("form") as HTMLFormElement;

    for (const input of inputs) {
      input.addEventListener("focus", () => {
        input.select();
      });

      input.addEventListener("input", () => {
        if (input.value.length > 0) {
          input.value = input.value.slice(0, 1).toLocaleUpperCase();
          const nextInput = input.nextElementSibling as HTMLInputElement;
          if (nextInput) {
            nextInput.focus();
            return;
          }

          const submitButton = form.querySelector(
            'input[type="submit"]',
          ) as HTMLInputElement;
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
