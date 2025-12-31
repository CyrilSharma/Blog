import { defineCollection, z } from "astro:content";
import { file } from "astro/loaders";

const parseDateInput = (val: unknown): Date => {
  if (val instanceof Date) return val;
  const str = String(val);
  // If no timezone is provided, treat it as date-only in US Eastern to avoid day rollbacks.
  const dateOnlyMatch = /^(\d{4})-(\d{2})-(\d{2})$/.exec(str);
  if (dateOnlyMatch) {
    const [, y, m, d] = dateOnlyMatch;
    // US Eastern: UTC-5 standard, UTC-4 daylight. Use -5h as a stable offset anchor.
    const utcMs = Date.UTC(Number(y), Number(m) - 1, Number(d), 17, 0, 0); // 12:00 ET == 17:00 UTC
    return new Date(utcMs);
  }
  return new Date(str);
};

const blog = defineCollection({
  // Drive the collection from the generated meta.json instead of globbing Typst.
  // Each entry in meta.json is treated as one collection item keyed by slug.
  loader: file("meta.json"),
  schema: z.object({
    title: z.string(),
    author: z.string().optional(),
    desc: z.any().optional(),
    date: z.union([z.string(), z.date()]).transform(parseDateInput),
    updatedDate: z
      .union([z.string(), z.date()])
      .optional()
      .transform((val) => (val ? parseDateInput(val) : undefined)),
    tags: z.array(z.string()).default([]),
  }),
});

export const collections = { blog };
