import path from "node:path";
import rss from "@astrojs/rss";
import type { APIContext } from "astro";
import { getCollection } from "astro:content";
import { renderGemtextToHtml } from "../../renderGemtextToHtml";

export async function GET(context: APIContext) {
  // `site` is guaranteed to exist because we define it in our Astro config
  const site = context.site!;
  const posts = await getCollection("microlog");

  return rss({
    title: "Joe Carstairs’ microlog",
    description: "My private X feed I guess?",
    customData: `
			<image>/images/headshot.webp</image>
		  <language>en-GB</language>
		`,
    site: path.join(site.toString(), "microlog"),
    trailingSlash: false,
    items: posts.map((post) => ({
      link: `/microlog/${post.id}`,
      title: post.id,
      content: renderGemtextToHtml(post.body ?? ""),
      pubDate: new Date(post.id.replace(/\.[0-9]+$/g, "")),
      author: "Joe Carstairs",
    })),
  });
}
