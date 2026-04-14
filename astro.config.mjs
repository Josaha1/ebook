// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://josaha1.github.io',
  base: '/ebook',
  output: 'static',
  vite: {
    plugins: [tailwindcss()]
  }
});
