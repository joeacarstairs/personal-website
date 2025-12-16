import { defineConfig, envField } from "astro/config";
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
      SENDMAIL_BIN: envField.string({ context: "server", access: "secret" }),
    },
  },
  site: "https://joeac.net",
  integrations: [mdx(), sitemap()],
});
