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
      SENDMAIL_BIN: envField.string({ context: "server", access: "secret" }),
    },
  },
  site: "https://joeac.net",
  integrations: [db(), mdx(), sitemap()],
});
