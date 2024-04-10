import { defineCollection, z } from 'astro:content';

const dateSchema = z.object({
	year: z.number(),
	month: z.number(),
	day: z.number(),
});

const blog = defineCollection({
	type: 'content',
	schema: z.object({
		title: z.string(),
		description: z.string(),
		pubDate: dateSchema,
		updatedDate: z.optional(dateSchema),
	}),
});

export const collections = { blog };
