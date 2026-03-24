/**
 * This file is edited from astro/loaders/glob.d.ts
 */

import type { glob, Loader } from "astro/loaders";
type GlobOptions = Parameters<typeof glob>[0];
/**
 * Loads multiple entries, using a glob pattern to match files.
 * @param pattern A glob pattern to match files, relative to the content directory.
 * @param ignore Glob patterns to exclude from the matched results.
 */
export declare function extendedGlob(
  globOptions: GlobOptions & {
    postprocessSlug?: (slug: string) => string;
    ignore?: string[];
  },
): Loader;
export {};
