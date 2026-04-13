import { defineCollection } from "astro:content";
import { z } from "astro/zod";

import { extendedGlob } from "./loaders/extended-glob";

const blog = defineCollection({
  loader: extendedGlob({
    pattern: "**/*.(md|mdx|gmi|html)",
    base: "./src/content/blog",
    postprocessSlug: (slug: string) => slug.replaceAll(/^capsule-longlog\//g, ""),
    ignore: [
      "capsule-longlog/index.gmi",
      /* Some blog posts were ported to gemtext. Don't port them back again:
       * that would lead to duplicates! The originals are likely to be better
       * anyway, as MD/MDX are richer languages. */
      "**/2024-01-14.gmi",
      "**/2024-01-29.gmi",
      "**/2024-03-30.gmi",
      "**/2024-04-10.gmi",
      "**/2024-04-11.gmi",
      "**/2024-04-14.gmi",
      "**/2024-05-02.gmi",
      "**/2024-06-13.gmi",
      "**/2024-07-08.gmi",
      "**/2024-07-16.gmi",
      "**/2024-12-17.gmi",
      "**/2025-01-19.gmi",
      "**/2025-01-24.gmi",
      "**/2025-01-28.gmi",
      "**/2025-05-02.gmi",
      "**/2025-05-04.gmi",
      "**/2025-06-23.gmi",
      "**/2025-07-03.gmi",
      "**/2025-09-18.gmi",
      "**/2025-09-24.gmi",
      "**/2025-10-05.gmi",
      "**/2025-10-09.gmi",
      "**/2025-12-11.gmi",
      "**/2026-02-16.gmi",
      "**/2026-03-04.gmi",
    ],
  }),
  schema: z.object({
    title: z.string(),
    hidden: z.optional(z.boolean()),
    description: z.optional(z.string()),
    pubDate: z.date(),
    updatedDate: z.optional(z.date()),
  }),
});

export const collections = { blog };
