import path from 'node:path';
import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { getCollection } from 'astro:content';
import MarkdownIt from 'markdown-it';

const mdParser = new MarkdownIt({
	html: true
});

export async function GET(context: APIContext) {
	// `site` is guaranteed to exist because we define it in our Astro config
	const site = context.site!;
	const posts = await getCollection('blog');

	return rss({
		title: 'Joe Carstairs’ blog',
		description: 'Short posts on random topics I find interesting',
		customData: `
			<image>/images/headshot.webp</image>
		  <language>en-GB</language>
		`,
		site: path.join(site.toString(), 'blog'),
		trailingSlash: false,
		items: posts.map((post) => ({
		  link: `/blog/${post.slug}`,
			title: post.data.title,
	    content: mdParser.render(post.body),
	    pubDate: post.data.pubDate,
	    description: post.data.description,
	    author: 'Joe Carstairs',

			// A page for displaying comments related to the item
	    /* commentsUrl: `${post.slug}/comments`, */
		})),
	})
}
