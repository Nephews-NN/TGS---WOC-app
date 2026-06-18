# Bean Catch — World of Coffee (Bean Voyage)

Phone-friendly catch game to draw people to the booth. Catch falling coffee beans with a cup; miss 3 and it's over. Women earn 30% fewer points for the same catch — the point of the event.

## Files
- `index.html` — the whole game (HTML + CSS + JS, single file)
- `supabase_setup.sql` — run once to create the `scores` table
- `README.md` — this file

## 1. Set up the database (one time)
1. Open Supabase → **SQL Editor**.
2. Paste the contents of `supabase_setup.sql` and **Run**.
   This creates a `scores` table and lets the public key insert (but not read) scores.

The URL and anon key are already wired into `index.html` (top of the `<script>`, CONFIG block).

## 2. Add your story
Open `index.html`, find `STORY_HTML` near the top of the `<script>` block, and replace the placeholder text. It accepts plain HTML.

## 3. Deploy to Vercel
**Option A — GitHub (recommended):**
1. Push this folder to `https://github.com/Nephews-NN/TGS---WOC-app.git`
   ```
   git init
   git add .
   git commit -m "Bean Catch game"
   git branch -M main
   git remote add origin https://github.com/Nephews-NN/TGS---WOC-app.git
   git push -u origin main
   ```
2. In Vercel → **Add New Project** → import that repo → **Deploy** (no build settings needed, it's static).

**Option B — drag & drop:** vercel.com → new project → upload this folder.

## 4. QR code
After deploy you'll get a URL like `https://tgs-woc-app.vercel.app`. Generate a QR pointing to it (e.g. qr-code-generator.com or `https://api.qrserver.com/v1/create-qr-code/?data=YOUR_URL&size=600x600`) and print it for the entrance queue.

## Tweaks (all near the top of the script in index.html)
- `POINTS_PER_BEAN` — points per caught bean
- `FEMALE_MULTIPLIER` — 0.7 = 30% less (the message)
- `MAX_MISSES` — beans you can drop before game over (3)
- Bean speed: `fallSpeed = H * 0.30` in `startGame()` (already 40% slower)
- Bean colour: `--bean` CSS variable (single brown)
