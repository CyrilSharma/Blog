import React, { useState } from 'react';
import '../styles/sidebar.css'; // Regular CSS import
import { getTagColor, getTextColor } from '../tagColors';
import { BASE_PATH } from '$consts';
import { useStore } from '@nanostores/react';
import { selectedTag } from '../tagStore';

interface Post {
  id: string;
  title: string;
  date: Date;
  tags?: string[];
}

interface SidebarProps {
  title: string;
  posts: Post[];
  allTags: string[];
}

interface TagListProps {
  allTags: string[];
  selectedTag: string;
  setSelectedTag: (tag: string) => void;
}

const formatDate = (date: Date) =>
  date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });

const TagList = ({ allTags, selectedTag, setSelectedTag }: TagListProps) => {
  return (
    <div className="tag-list">
    <button
      className={`tag ${selectedTag === '' ? 'active' : ''}`}
      onClick={() => setSelectedTag('')}
      style={{
        backgroundColor: getTagColor('all'),
        color: getTextColor(getTagColor('all')),
        borderColor: getTagColor('all'),
      }}
    >
      All
    </button>
    {allTags.map((tag) => {
      const bg = getTagColor(tag);
      const fg = getTextColor(bg.replace('var(--accent, ', '').replace(')', '') || bg);
      return (
        <button
          key={tag}
          className={`tag ${selectedTag === tag ? 'active' : ''}`}
          onClick={() => setSelectedTag(tag)}
          style={{
            backgroundColor: bg,
            color: fg,
            borderColor: bg,
          }}
        >
          {tag}
        </button>
      );
    })}
    </div>
  )
}

export const Sidebar = ({ title, posts, allTags }: SidebarProps) => {
  const $selectedTag = useStore(selectedTag);
  const [showTags, setShowTags] = useState(false);
  const [isOpen, setIsOpen] = useState(true);

  const filteredPosts = $selectedTag
    ? posts.filter((post) => post.tags?.includes($selectedTag))
    : posts;

  return (
    <>
      <aside className={`sidebar ${isOpen ? 'open' : 'closed'}`}>
        <div className="sidebar-header">
          <h2>{title}</h2>
          <button 
            className="close-button"
            onClick={() => setIsOpen(false)}
            aria-label="Close sidebar"
          >
            ×
          </button>
        </div>

        <div className="tags">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontWeight: 'bold' }}>Tags</span>
            <button style={{ background: 'none', border: 'none', padding: '0', color: 'inherit', cursor: 'pointer', marginRight: '1rem' }} onClick={() => setShowTags(prev => !prev)} className="toggle-button">
              {showTags ? '▲' : '▼'}
            </button>
          </div>

          {showTags && (
            <TagList allTags={allTags} selectedTag={$selectedTag} setSelectedTag={selectedTag.set}/>
          )}
        </div>

        <ul>
          {filteredPosts.map((post) => (
            <li key={post.id}>
              <a href={`${BASE_PATH}/${post.id}/`}>
                <div style={{ wordBreak: 'break-word' }}>{post.title}</div>
                <small>{formatDate(post.date)}</small>
              </a>
            </li>
          ))}
        </ul>
      </aside>
      {!isOpen && (
        <button 
          className="hamburger-button"
          onClick={() => setIsOpen(true)}
          aria-label="Open sidebar"
          style={{ fontSize: '2.5rem' }}
        >
          ☰
        </button>
      )}
    </>
  );
};
