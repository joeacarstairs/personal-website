import { defineConfig, envField } from "astro/config";
import db from "@astrojs/db";
import mdx from "@astrojs/mdx";
import node from "@astrojs/node";

import sitemap from "@astrojs/sitemap";

// https://astro.build/config
export default defineConfig({
  adapter: node({
    mode: "standalone",
  }),
  env: {
    schema: {
      MAX_DAILY_EMAILS: envField.number({
        context: "server",
        access: "secret",
      }),
      LOCAL_SMTP_ENVELOPE_FROM: envField.string({
        context: "server",
        access: "secret",
      }),
      LOCAL_SMTP_HOST: envField.string({ context: "server", access: "secret" }),
      LOCAL_SMTP_PORT: envField.number({ context: "server", access: "secret" }),
      LOCAL_SMTP_USER: envField.string({ context: "server", access: "secret" }),
      LOCAL_SMTP_PASSWORD: envField.string({
        context: "server",
        access: "secret",
      }),
      CONTACT_MAILBOX: envField.string({ context: "server", access: "secret" }),
    },
  },
  site: "https://joeac.net",
  integrations: [db(), mdx(), sitemap()],
});
