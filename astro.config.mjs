// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import { typst } from "astro-typst";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
  // Deploys to GitHub Pages
  site: "https://cyrilsharma.github.io",
  base: "/Blog",

  integrations: [
    sitemap(),
    typst({
      // Always builds HTML files
      mode: {
        default: "html",
        detect: () => "html",
      },
    }),
    icon({
      include: ["mdi"],
    }),
  ],
});
