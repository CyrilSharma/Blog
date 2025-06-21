import { getTagColor, getTextColor } from '../tagColors';
import { selectedTag } from '../tagStore';
import '../styles/tags.css';
import { useEffect, useState } from 'react';

const Tag = ({ tag }: { tag: string }) => {
  const [isSelected, setIsSelected] = useState(false);
  
  useEffect(() => {
    const unsubscribe = selectedTag.subscribe(value => {
      setIsSelected(value === tag);
    });
    
    return unsubscribe;
  }, [tag]);

  const color = getTagColor(tag);
  const textColor = getTextColor(tag);
  // make tag bold
  return <span className="tag"
    style={{
      // make background color intense when selected
      // backgroundColor: isSelected ? 'var(--accent)' : color,
      backgroundColor: color, // isSelected ? 'var(--accent)' : color,
      border: isSelected ? '4px solid rgb(0, 0, 0)' : '4px solid transparent',
      // background: isSelected ? `linear-gradient(rgb(255, 255, 255), ${color})` : color,
      color: textColor, // isSelected ? 'var(--accent-foreground)' : textColor,
      fontWeight: isSelected ? 'bold' : 'normal' }}
    onClick={() => selectedTag.set(tag)}
  >{tag}</span>;
};

export default Tag;