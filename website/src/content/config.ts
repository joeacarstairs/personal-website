import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
	type: 'content',
	schema: z.object({
		title: z.string(),
		hidden: z.optional(z.boolean()),
		description: z.string(),
		pubDate: z.date(),
		updatedDate: z.optional(z.date()),
	}),
});

export const collections = { blog };
