import path from 'node:path';
import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import LINKS from '../../data/links.ts';
import MarkdownIt from 'markdown-it';

const mdParser = new MarkdownIt({
	html: true
});

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
		site: path.join(site.toString(), 'links'),
		trailingSlash: false,
		items: LINKS.map((link) => ({
		  link: link.href,
			title: link.title,
	    content: mdParser.render(link.description),
	    pubDate: new Date(link.isoDateAdded),
	    description: mdParser.render(link.description),
	    author: 'Joe Carstairs',
		})),
	})
}
