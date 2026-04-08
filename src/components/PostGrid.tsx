import React from "react";
import "../styles/post-grid.css";

type Post = {
  id: string;
  title: string;
  date: string | Date;
  dateMs?: number;
  tags?: string[];
  isNotes?: boolean;
};

type Props = {
  posts: Post[];
  basePath: string;
};


export default function PostGrid({ posts, basePath }: Props) {
  return (
    <div className="post-grid">
      <div className="pg-grid">
        {posts.map((post) => (
          <article className="pg-card" key={post.id}>
            <a href={`${basePath}/${post.id}/`}>
              <div className="pg-frame-wrapper">
                <iframe
                  src={`${basePath}/${post.id}/`}
                  scrolling="no"
                  tabIndex={-1}
                  aria-hidden="true"
                />
              </div>
            </a>
          </article>
        ))}
      </div>
    </div>
  );
}
