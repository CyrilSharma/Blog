import { getTagColor, getTextColor } from '../tagColors';
import { selectedTag } from '../tagStore';

const Tag = ({ tag }: { tag: string }) => {
  const color = getTagColor(tag);
  const textColor = getTextColor(tag);
  return <span className="tag"
    style={{ backgroundColor: color, color: textColor }}
    onClick={() => selectedTag.set(tag)}
  >{tag}</span>;
};

export default Tag;