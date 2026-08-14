import { toSentenceCase, kebabToTitleCase, snakeToTitleCase } from './change-casing';
export * from './array';
export { toSentenceCase, kebabToTitleCase, snakeToTitleCase };
export const getColor = (name, fallback) => {
  if (typeof window === 'undefined') return fallback;
  return getComputedStyle(document.documentElement).getPropertyValue(name).trim() || fallback || '#5143d9';
};