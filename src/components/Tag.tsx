import { getTagColor, getTextColor } from "../tagColors";
import "../styles/tags.css";
import { useMemo } from "react";
import type React from "react";

type TagProps = {
  tag: string;
  size?: "sm" | "md";
  selectable?: boolean;
  active?: boolean;
  onClick?: (event: React.MouseEvent<HTMLSpanElement>) => void;
};

const Tag = ({ tag, size = "md", selectable = true, active = false, onClick }: TagProps) => {
  const color = getTagColor(tag);
  const textColor = getTextColor(tag);

  const styles = useMemo(
    () => ({
      backgroundColor: color,
      border: active ? "3px solid rgb(0, 0, 0)" : "3px solid transparent",
      color: textColor,
      fontWeight: active ? "bold" : "normal",
      fontSize: size === "sm" ? "0.8rem" : "0.95rem",
      padding: size === "sm" ? "0.15rem 0.45rem" : "0.2rem 0.65rem",
    }),
    [color, textColor, active, size]
  );

  return (
    <span
      className="tag"
      style={styles}
      onClick={(event) => selectable && onClick?.(event)}
    >
      {tag}
    </span>
  );
};

export default Tag;