// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import icon from "astro-icon";
import react from "@astrojs/react";
import path from "node:path";
import fs from "node:fs";

const meta = JSON.parse(fs.readFileSync("./meta.json", "utf8"));
const rawPages = Object.keys(meta).map(
  (slug) => `https://cyrilsharma.github.io/Blog/${slug}/raw.txt`
);

// https://astro.build/config
export default defineConfig({
  // Deploys to GitHub Pages
  site: "https://cyrilsharma.github.io",
  base: "/Blog",

  integrations: [
    sitemap({ customPages: rawPages }),
    icon({
      include: ["mdi"],
    }),
    react(),
  ],
  vite: {
    plugins: [
      {
        name: "watch-html-content",
        configureServer(server) {
          server.watcher.add(`./html/**/*.html`);
          server.watcher.on("change", (file) => {
            server.ws.send({ type: "full-reload" });
          });
        },
      },
    ],
  },
});
