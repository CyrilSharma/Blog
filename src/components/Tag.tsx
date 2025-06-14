import { getTagColor, getTextColor } from '../tagColors';
import { selectedTag } from '../tagStore';
import { useStore } from '@nanostores/react';
import '../styles/tags.css';

const Tag = ({ tag }: { tag: string }) => {
  // if tag is selected, make it look cool
  const $selectedTag = useStore(selectedTag);
  const isSelected = $selectedTag === tag;

  const color = getTagColor(tag);
  const textColor = getTextColor(tag);
  return <span className="tag"
    style={{ backgroundColor: isSelected ? 'var(--accent)' : color, color: isSelected ? 'var(--accent-foreground)' : textColor }}
    onClick={() => selectedTag.set(tag)}
  >{tag}</span>;
};

export default Tag;