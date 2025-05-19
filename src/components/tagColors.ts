// Tag color palette and color functions for dark mode

export const tagColors: string[] = [
  '#3B82F6', // blue
  '#F59E42', // orange
  '#10B981', // green
  '#F43F5E', // red
  '#A78BFA', // purple
  '#FBBF24', // yellow
  '#6366F1', // indigo
  '#F472B6', // pink
  '#22D3EE', // cyan
  '#84CC16', // lime
  '#E11D48', // rose
  '#0EA5E9', // sky
];

export function getTagColor(tag: string): string {
  if (!tag || tag.toLowerCase() === 'all') return 'var(--accent, #a78bfa)';
  const index = tag.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
  return tagColors[index % tagColors.length];
}

export function getTextColor(bg: string): string {
  const hex = bg.replace('#', '');
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  const brightness = (r * 299 + g * 587 + b * 114) / 1000;
  return brightness > 140 ? '#222' : '#fff';
} 