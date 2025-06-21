import React, { useState, useEffect, useRef, useLayoutEffect } from 'react';
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
  const sidebarRef = useRef<HTMLElement>(null);

  const filteredPosts = $selectedTag
    ? posts.filter((post) => post.tags?.includes($selectedTag) || $selectedTag === 'All')
    : posts;

  useEffect(() => {
    const checkMobile = () => {
      setIsMobile(window.innerWidth <= 768);
    };
    
    checkMobile();
    window.addEventListener('resize', checkMobile);
    
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  // This runs before the screen is repainted
  // Hence, the scroll position is restored immediately
  useLayoutEffect(() => {
    const sidebar = sidebarRef.current;
    if (!sidebar) return;

    const key = 'sidebar-scroll-position';
    
    const handleNavigation = () => {
      const data = sessionStorage.getItem(key);
      if (data) {
        try {
          const obj = JSON.parse(data);
          sidebar.scrollTop = obj.scrollTop || 0;
        } catch (err) {
          console.warn('Failed to restore sidebar scroll position on navigation:', err);
        }
      }
    };

    let position = { scrollTop: 0 };
    let timeout: number | undefined;

    const handleScroll = () => {
      position.scrollTop = sidebar.scrollTop;
      if (!timeout) {
        timeout = window.setTimeout(() => {
          sessionStorage.setItem(key, JSON.stringify(position));
          timeout = 0;
        }, 100);
      }
    };

    sidebar.addEventListener('scroll', handleScroll);

    // Listen for Astro navigation events
    document.addEventListener('astro:page-load', handleNavigation);
    document.addEventListener('astro:after-swap', handleNavigation);

    return () => {
      document.removeEventListener('astro:page-load', handleNavigation);
      document.removeEventListener('astro:after-swap', handleNavigation);
      sidebar.removeEventListener('scroll', handleScroll);
      if (timeout) {
        clearTimeout(timeout);
      }
    };
  }, []); // Empty dependency array - only set up listeners once

  const handleLinkClick = () => {
    if (isMobile) {
      setIsOpen(false);
    }
  };

  return (
    <>
      <aside ref={sidebarRef} className={`sidebar ${isOpen ? 'open' : 'closed'}`}>
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
