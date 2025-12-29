import fs from "node:fs";
import path from "node:path";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import { SITE_TITLE, SITE_DESCRIPTION, BASE_PATH } from "$consts";

const readPostHtml = (slug) => {
  const filePath = path.join("html", slug, "index.html");
  try {
    const html = fs.readFileSync(filePath, "utf8");
    const body = html.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
    return body ? body[1] : html;
  } catch (err) {
    console.warn(`[rss] Unable to read HTML for ${slug}:`, err);
    return "";
  }
};

export async function GET(context) {
  const posts = await getCollection("blog");
  return rss({
    title: SITE_TITLE,
    description: SITE_DESCRIPTION,
    site: context.site,
    items: posts.map((post) => ({
      title: post.data.title,
      description:
        typeof post.data.desc === "string" ? post.data.desc : "",
      pubDate: post.data.updatedDate ?? post.data.date,
      categories: post.data.tags ?? [],
      link: `${BASE_PATH}/${post.id}/`,
      content: readPostHtml(post.id),
    })),
  });
}
