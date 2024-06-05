import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import LINKS from '../../data/links.ts';

export async function GET(context: APIContext) {
	// `site` is guaranteed to exist because we define it in our Astro config
	const site = context.site!;

	return rss({
		title: 'Joe Carstairs’ links',
		description: 'An assortment of links I’m accumulating.',
		customData: `
			<image>/images/headshot.webp</image>
		  <language>en-GB</language>
		`,
		site,
		trailingSlash: false,
		items: LINKS.map((link) => ({
		  link: link.href,
			title: link.title,
	    content: link.description,
	    pubDate: new Date(link.isoDateAdded),
	    description: link.description,
	    author: 'Joe Carstairs',
		})),
	})
}
