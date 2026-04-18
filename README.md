# codein.ca

Landing page for Code In Canada Recruiting — a Canadian startup matching Brazilian engineers with North American companies.

Live at: **https://codein.ca**

## Project structure

```
codein/
├── index.html          # Entire site — HTML, CSS, and React JSX in one file
└── assets/
    ├── 1.jpg … 6.jpg
    ├── logo-codein-recruiting.png
    ├── favicon.ico
    ├── favicon-16x16.png
    ├── favicon-32x32.png
    ├── apple-touch-icon.png
    ├── android-chrome-192x192.png
    ├── android-chrome-512x512.png
    └── site.webmanifest
```

## Technology

`index.html` is a self-contained prototype with no build step:

- **React 18** loaded from unpkg CDN
- **Babel standalone** transpiles JSX in the browser at runtime
- **Google Fonts** — Instrument Serif + Geist + Geist Mono
- All component logic is inline `<script type="text/babel">` blocks, organized with `// === src/filename.jsx ===` comments
- CSS uses custom properties (`--primary`, `--accent`, `--bg`, etc.) on `:root`; `data-accent` and `data-density` attributes on `<body>` switch themes

There is no `package.json`, no bundler, no build command. Edit `index.html` directly.

## Sections (in render order)

| Component | Section ID | Description |
|-----------|-----------|-------------|
| `Nav` | — | Sticky nav with section-spy scroll highlighting |
| `Hero` | `#top` / `#program` | Headline (3 variants), cohort card, CTAs |
| `Ticker` | — | Scrolling city-pair marquee |
| `Stats` | — | 4 key metrics (toggleable via tweaks panel) |
| `LogoRow` | — | Partner wordmarks |
| Editorial strip | — | Full-bleed `1.jpg` between logos and how-it-works |
| `How` | `#how` | 6-step process accordion |
| `Talent` | `#talent` | Company ↔ engineer tab toggle, 6 cards each |
| `Roadmap` | `#roadmap` | 5-phase interactive timeline |
| `Stories` | `#stories` | 3 testimonial cards |
| `FAQ` | `#faq` | Accordion, 7 questions |
| `CTABand` | — | Dark full-width CTA |
| `Footer` | — | 4-column footer |
| `ApplyModal` | — | 4-step application flow, persists via `localStorage` |
| `Tweaks` | — | Dev panel: accent color, hero variant, density, stats toggle |

## Tweakable defaults

Defined in a `<script>` block near the bottom of `<head>`:

```js
window.TWEAK_DEFAULTS = {
  "accent": "coral",       // "coral" | "maple" | "sun" | "sky"
  "heroVariant": "editorial", // "editorial" | "direct" | "bold"
  "showStats": true,
  "density": "comfortable" // "compact" | "comfortable" | "spacious"
};
```

## Deployment

**Target server:** `xps15` (Ubuntu 24.04, accessible via `ssh xps15`)

**How it's served:** A Docker container named `static-sites` runs `nginx:alpine` and binds port 8083. A reverse proxy (also Docker) routes `codein.ca` → port 8083. SSL is terminated upstream.

**Document root on server:** `/home/ds/home-server-setup/data/nginx/html/codein/`

**Nginx vhost config:** `/home/ds/home-server-setup/data/nginx/conf.d/` (shared with all static sites on this host)

### Deploy command

Run from the repo root on your local machine:

```bash
rsync -av --delete --exclude='.DS_Store' \
  index.html \
  assets/ \
  xps15:/home/ds/home-server-setup/data/nginx/html/codein/
```

This command is idempotent and safe to re-run. No container restart needed — nginx serves files directly from the bind-mounted directory.

### Verify after deploy

```bash
curl -sI http://codein.ca | head -3
# Expect: HTTP/1.1 200 OK
```

### Asset path convention

`index.html` references assets as `assets/<filename>` (relative). The server mirrors this exactly:

```
/home/ds/.../codein/index.html
/home/ds/.../codein/assets/logo-codein-recruiting.png
/home/ds/.../codein/assets/1.jpg
# etc.
```

Do not flatten assets into the root — paths will break.

## Other static sites on the same host

The `static-sites` container serves multiple domains from sibling directories under `/home/ds/home-server-setup/data/nginx/html/`. Editing the nginx config or other site directories is out of scope for this repo.
