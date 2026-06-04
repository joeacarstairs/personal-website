export const actions = {
  /**
   * @param {{type: 'email', name: string, email: string}}
   * @returns {Promise<void>}
   */
  sendOtp: async ({ type, name, email }) => {
    const url = "/do/send_otp.php";
    const req = new Request(url, {
      method: "POST",
      body: JSON.stringify({ type, name, email }),
    });
    const res = await fetch(req);
    if (!res.ok) {
      throw new Error(
        `Request to ${url} failed: ${res.status} ${res.statusText} ${await res.text()}`,
      );
    }
  },

  /**
   * @param {{guess: string, lenient?: bool, userId: string}}
   * @returns {Promise<string | false>}
   */
  verifyOtp: async ({ guess, lenient, userId }) => {
    const url = "/do/verify_otp.php";
    const req = new Request(url, {
      method: "POST",
      body: JSON.stringify({ guess, lenient, userId }),
    });
    const res = await fetch(req);

    if (res.status === 400) {
      return false;
    } else if (!res.ok) {
      throw new Error(
        `Request to ${url} failed: ${res.status} ${res.statusText} ${await res.text()}`,
      );
    }

    return res.text();
  },

  /**
   * @param {{email: string, message: string, name: string, userId: string, token: string}}
   * @returns {Promise<void>}
   */
  sendEmail: async ({ email, message, name, userId, token }) => {
    const url = "/do/send_email.php";
    const req = new Request(url, {
      method: "POST",
      body: JSON.stringify({ email, message, name, userId, token }),
    });
    const res = await fetch(req);
    if (!res.ok) {
      throw new Error(
        `Request to ${url} failed: ${res.status} ${res.statusText} ${await res.text()}`,
      );
    }
  },
};
