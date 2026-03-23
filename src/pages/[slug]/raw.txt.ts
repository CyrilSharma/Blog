import fs from "node:fs";
import path from "node:path";
import { getCollection } from "astro:content";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.id },
  }));
}

export async function GET({ params }: { params: { slug: string } }) {
  const file = path.join("content/article", `${params.slug}.typ`);
  const content = fs.readFileSync(file, "utf8");
  return new Response(content, {
    headers: { "Content-Type": "text/plain; charset=utf-8" },
  });
}
