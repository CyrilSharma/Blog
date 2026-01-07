// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import icon from "astro-icon";
import react from "@astrojs/react";
import path from "node:path";

// https://astro.build/config
export default defineConfig({
  // Deploys to GitHub Pages
  site: "https://cyrilsharma.github.io",
  base: "/Blog",

  integrations: [
    sitemap(),
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
