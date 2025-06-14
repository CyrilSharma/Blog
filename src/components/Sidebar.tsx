import React, { useState, useEffect } from 'react';
import '../styles/sidebar.css'; // Regular CSS import
import { getTagColor, getTextColor } from '../tagColors';
import { BASE_PATH } from '$consts';
import { useStore } from '@nanostores/react';
import { selectedTag } from '../tagStore';
import Tag from './Tag';

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
}

const formatDate = (date: Date) =>
  date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });

const TagList = ({ allTags }: TagListProps) => {
  return (
    <div className="tag-list">
    <Tag tag="All" />
    {allTags.map((tag) => {
      return <Tag tag={tag} />
    })}
    </div>
  )
}

export const Sidebar = ({ title, posts, allTags }: SidebarProps) => {
  const $selectedTag = useStore(selectedTag);
  const [showTags, setShowTags] = useState(false);
  const [isOpen, setIsOpen] = useState(true);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    const checkMobile = () => {
      setIsMobile(window.innerWidth <= 768);
    };
    
    checkMobile();
    window.addEventListener('resize', checkMobile);
    
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  const handleLinkClick = () => {
    if (isMobile) {
      setIsOpen(false);
    }
  };

  const filteredPosts = $selectedTag
    ? posts.filter((post) => post.tags?.includes($selectedTag) || $selectedTag === 'All')
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
            <TagList allTags={allTags} />
          )}
        </div>

        <ul>
          {filteredPosts.map((post) => (
            <li key={post.id}>
              <a href={`${BASE_PATH}/${post.id}/`} onClick={handleLinkClick}>
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
