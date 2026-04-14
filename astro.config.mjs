// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import icon from "astro-icon";
import react from "@astrojs/react";
import path from "node:path";
import fs from "node:fs";
import { spawn } from "node:child_process";

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
          server.watcher.add(`./content/article`);
          server.watcher.on("add", (file) => {
            if (!file.endsWith(".typ") || !file.includes("content/article")) return;
            console.log(`[make] new file detected: ${file}, running make...`);
            const proc = spawn("make", [], { stdio: "inherit" });
            proc.on("exit", (code) => {
              if (code === 0) console.log("[make] done");
              else console.error(`[make] exited with code ${code}`);
            });
          });
          server.watcher.on("change", (file) => {
            if (!file.endsWith(".typ") || !file.includes("content/article")) return;
            const slug = path.basename(file, ".typ");
            console.log(`[typst] navigating to ${slug}`);
            server.ws.send({ type: "custom", event: "typst-navigate", data: { slug } });
          });
          const typstWatchers = new Map();
          server.middlewares.use((req, _res, next) => {
            const match = req.url?.match(/^\/([^/?@]+)\//);
            const slug = match?.[1];
            if (slug && !typstWatchers.has(slug)) {
              const typFile = `content/article/${slug}.typ`;
              if (fs.existsSync(typFile)) {
                fs.mkdirSync(`html/${slug}`, { recursive: true });
                console.log(`[typst] starting watch for ${slug}`);
                const proc = spawn(
                  "typst",
                  ["watch", typFile, `html/${slug}/index.html`,
                   "--format", "html", "--features", "html", "--root", "."],
                  { stdio: "inherit" }
                );
                proc.on("exit", (code) => {
                  console.log(`[typst] watch for ${slug} exited with code ${code}`);
                  typstWatchers.delete(slug);
                });
                typstWatchers.set(slug, proc);
              }
            }
            next();
          });
          const pending = new Map();
          server.watcher.on("change", (file) => {
            if (!file.includes("/html/")) return;
            if (pending.has(file)) clearTimeout(pending.get(file));
            pending.set(
              file,
              setTimeout(() => {
                pending.delete(file);
                const full = fs.readFileSync(file, "utf8");
                const match = full.match(/<body[^>]*>([\s\S]*?)<\/body>/is);
                const content = match ? match[1] : full;
                server.ws.send({
                  type: "custom",
                  event: "typst-update",
                  data: { content },
                });
              }, 150)
            );
          });
        },
      },
    ],
  },
});
