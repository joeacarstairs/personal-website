import * as Gemtext from "gemtext";

export function renderGemtextToHtml(gemtext: string, title?: string): string {
  gemtext = title ? gemtext.replace(`# ${title}`, "") : gemtext;
  return postProcessGemtextToHtml(
    Gemtext.parse(gemtext).generate(GemtextHTMLRenderer),
  );
}

const GemtextHTMLRenderer: Gemtext.Renderer<string> = {
  preamble: function (): string {
    return "";
  },

  postamble: function (): string {
    return "";
  },

  text: function (content: string): string {
    content = content.trim();
    if (content === "") {
      return "";
    }
    return `<p>${htmlEscape(content)}</p>`;
  },

  link: function (url: string, alt: string): string {
    const imgExtensions: (string | undefined)[] = [
      "webp",
      "png",
      "svg",
      "gif",
      "jpg",
      "jpeg",
      "apng",
    ];
    if (imgExtensions.includes(url.split(".").at(-1)?.toLowerCase())) {
      return `<img src="${url}" alt="${alt}" />`;
    }
    return `<p>=> <a href="${url}">${alt}</a></p>`;
  },

  preformatted: function (content: string[], alt: string): string {
    return `<pre alt="${alt}">${htmlEscape(content.join("\n"))}</pre>`;
  },

  heading: function (level: number, text: string): string {
    return `<h${level}>${htmlEscape(text)}</h${level}>`;
  },

  unorderedList: function (content: string[]): string {
    return `<ul>${content.map((li) => `<li>${htmlEscape(li)}</li>`).join("")}</ul>`;
  },

  quote: function (content: string): string {
    return `<blockquote>${htmlEscape(content)}</blockquote>`;
  },
};

function htmlEscape(str: string) {
  return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function postProcessGemtextToHtml(html: string): string {
  html = mergeAdjacentBlockquotes(html);
  return html;
}

function mergeAdjacentBlockquotes(html: string): string {
  return html.replaceAll(/\<\/blockquote\>\<blockquote\>/gm, "<br>");
}
