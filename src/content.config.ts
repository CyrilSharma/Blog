import fs from "node:fs";
import path from "node:path";
import { defineCollection, z } from "astro:content";

const blog = defineCollection({
  // Drive the collection from the generated meta.json instead of globbing Typst.
  // Each entry in meta.json is treated as one collection item keyed by slug.
  loader: async () => {
    const metaPath = path.join(process.cwd(), "meta.json");
    const raw = fs.readFileSync(metaPath, "utf8");
    const meta = JSON.parse(raw) as Record<string, object>;
    const entries = Object.entries(meta).map(([id, data]) => ({
      id,
      ...data,
    }));
    console.log(entries);
    return entries;
  },
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    desc: z.any().optional(),
    date: z.coerce.date(),
    // Transform string to Date object
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).default([]),
  }),
});

export const collections = { blog };
