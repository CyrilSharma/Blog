import React, { useMemo, useState } from "react";
import "../styles/post-grid.css";
import Tag from "./Tag";

type Post = {
  id: string;
  title: string;
  date: string | Date;
  dateMs?: number;
  modifiedDate?: string | Date;
  tags?: string[];
  desc?: string;
};

type Props = {
  posts: Post[];
  basePath: string;
};

const formatDate = (value: string | Date) => {
  const d = value instanceof Date ? value : new Date(value);
  return isNaN(d.valueOf()) ? "" : d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" });
};

const normalize = (s: string) => s.toLowerCase();

export default function PostGrid({ posts, basePath }: Props) {
  const [query, setQuery] = useState("");
  const [tag, setTag] = useState<string>("All");

  const tags = useMemo(() => {
    const set = new Set<string>();
    for (const p of posts) {
      (p.tags ?? []).forEach((t) => set.add(t));
    }
    return ["All", ...Array.from(set).sort()];
  }, [posts]);

  const filtered = useMemo(() => {
    const q = normalize(query.trim());
    return posts.filter((p) => {
      const matchesTag = tag === "All" || (p.tags ?? []).includes(tag);
      const matchesQuery =
        !q ||
        normalize(p.title).includes(q) ||
        (p.desc ? normalize(String(p.desc)).includes(q) : false);
      return matchesTag && matchesQuery;
    });
  }, [posts, query, tag]);

  return (
    <div className="post-grid">
      <div className="pg-header">
        <input
          className="pg-search"
          type="search"
          placeholder="Search posts"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <div className="pg-tags">
          {tags.map((t) => (
            <span key={t} style={{ cursor: "pointer" }}>
              <Tag
                tag={t}
                size="sm"
                selectable
                active={t === tag}
                onClick={() => setTag(t)}
              />
            </span>
          ))}
        </div>
      </div>

      <div className="pg-grid">
        {filtered.map((post) => (
          <article className="pg-card" key={post.id}>
            <a href={`${basePath}/${post.id}/`}>
              <h2 className="pg-title">{post.title}</h2>
              <div className="pg-date">{formatDate(post.date)}</div>
              {post.tags && post.tags.length > 0 && (
                <div className="pg-pill-row">
                  {post.tags.map((t) => (
                    <Tag key={t} tag={t} size="sm" selectable={false} />
                  ))}
                </div>
              )}
              {post.desc && <p className="pg-desc">{String(post.desc)}</p>}
            </a>
          </article>
        ))}
      </div>
    </div>
  );
}

