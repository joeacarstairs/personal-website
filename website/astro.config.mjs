import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import node from "@astrojs/node";

import sitemap from "@astrojs/sitemap";

// https://astro.build/config
export default defineConfig({
  adapter: node({
    mode: "standalone",
  }),
  site: "https://joeac.net",
  integrations: [mdx(), sitemap()],
});
