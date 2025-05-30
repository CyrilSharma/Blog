# Blog

The starter template for blogs, powered by [typst](https://github.com/typst/typst) and [Astro](https://astro.build/).

## Commands

All commands are run from the root of the project, from a terminal:

| Command                | Action                                           |
| :--------------------- | :----------------------------------------------- |
| `pnpm install`         | Installs dependencies                            |
| `pnpm dev`             | Starts local dev server at `localhost:4321`      |
| `pnpm build`           | Build your production site to `./dist/`          |
| `pnpm preview`         | Preview your build locally, before deploying     |
| `pnpm astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `pnpm astro -- --help` | Get help using the Astro CLI                     |

## Editor Setup

### VS Code

Open using the default setting:

```
code .vscode/blog.code-workspace
```

Or customize it:

```
cp .vscode/blog.code-workspace .vscode/blog.private.code-workspace
code .vscode/blog.private.code-workspace
```

Install suggseted extensions:

- `myriad-dreamin.tinymist`, for writing blog posts in typst.
- `astro-build.astro-vscode`, for developing astro components.

### Official Web App

(Untested) [Start from GitHub](https://typst.app/) and open your blog repository. You should be able to write articles like you do in local.

## Writing

Create a new blog post in `content/article`:

```typ
#import "/typ/templates/blog.typ": main
#show: main.with(
  title: "Title of the blog post",
  desc: [This is a test post.],
  date: "2025-04-25",
)
```

There is a sample blog post in [`content/article/personal-info.typ`](./content/article/personal-info.typ).

## Deploying to GitHub Pages

1. Search and change the `/blog-template` to name of your own repository.
2. Change Source's "Build and deployment" to "GitHub Actions" in [Page Settings](../../settings/pages).
3. Push your changes to the `main` branch and it will automatically deploy to GitHub Pages by [CI](.github/workflows/gh-pages.yml).

## Customization

- `src/consts.ts,src/components/BaseHead.astro`: global metadata and the head component.
- `src/styles/*`: CSS styles.

## Credit

- This theme is based off of the lovely [Bear Blog.](https://github.com/HermanMartinus/bearblog/)
- The astro integration is supported by [astro-typst.](https://github.com/overflowcat/astro-typst)
- And, the lovely [typst.](https://github.com/typst/typst)
