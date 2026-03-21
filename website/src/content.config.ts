import { glob } from "astro/loaders";
import { defineCollection } from "astro:content";
import { z } from "astro/zod";

const blog = defineCollection({
  loader: glob({
    pattern: "**/*.(md|mdx|gmi|html)",
    base: "./src/content/blog",
  }),
  schema: z.object({
    title: z.string(),
    hidden: z.optional(z.boolean()),
    description: z.string(),
    pubDate: z.date(),
    updatedDate: z.optional(z.date()),
  }),
});

export const collections = { blog };
