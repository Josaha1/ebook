// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
const isVercel = !!process.env.VERCEL;

export default defineConfig({
  site: isVercel ? 'https://ebook-one-woad.vercel.app' : 'https://josaha1.github.io',
  base: isVercel ? '/' : '/ebook',
  output: 'static',
  vite: {
    plugins: [tailwindcss()]
  }
});
