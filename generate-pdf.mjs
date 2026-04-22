import puppeteer from 'puppeteer';
import { readFileSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const htmlPath = resolve(__dirname, 'index.html');
const outPath = resolve(__dirname, 'Patrick_Schueller_Resume.pdf');

const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
const page = await browser.newPage();

await page.goto(`file://${htmlPath}`, { waitUntil: 'networkidle0' });

// Give fonts a moment to load
await new Promise(r => setTimeout(r, 1500));

await page.pdf({
  path: outPath,
  format: 'A4',
  printBackground: true,
  margin: { top: '16mm', bottom: '16mm', left: '14mm', right: '14mm' },
});

await browser.close();
console.log('PDF saved to:', outPath);
