/** Strip the file extension from an Astro content collection ID to get a clean slug. */
export function toSlug(id: string): string {
  return id.replace(/\.md$/, '');
}
