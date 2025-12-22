import fs from "node:fs";
import path from "node:path";
import { defineCollection, z } from "astro:content";
import { file } from "astro/loaders";

const blog = defineCollection({
  // Drive the collection from the generated meta.json instead of globbing Typst.
  // Each entry in meta.json is treated as one collection item keyed by slug.
  loader: file("meta.json"),
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
