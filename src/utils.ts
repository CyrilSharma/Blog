import { readFileSync } from "fs";
import { resolve } from "path";
import * as cheerio from "cheerio";

export const formatDate = (date: Date) =>
  date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });

const lenTags = ["p", "div", "ul", "ol", "dl", "blockquote", "pre", "table", "button"]; 
const blockTags = [...lenTags, "style", "script"];

export function extractPreview(id: string): string {
  try {
    const raw = readFileSync(resolve("html", id, "index.html"), "utf-8");
    const $ = cheerio.load(raw);
    $("script, nav, img").remove();

    const blocks: string[] = [];
    let textLen = 0;
    for (const el of $("body").children().toArray()) {
      let tagName = el.tagName?.toLowerCase();
      if (!blockTags.includes(tagName)) continue;
      const html = $.html(el);
      blocks.push(html);
      if (!lenTags.includes(tagName)) continue;
      textLen += $(el).text().length;
      if (textLen >= 800) break;
    }

    return `<div class="prose">${blocks.join("\n")}</div>`;
  } catch {
    return "";
  }
}