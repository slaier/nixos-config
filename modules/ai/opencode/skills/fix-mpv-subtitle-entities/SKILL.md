---
name: fix-mpv-subtitle-entities
description: Fix mpv showing literal "&lrm;"/"&rlm;" HTML entities in subtitles. Trigger whenever the user reports stray HTML entities like &lrm;, &rlm;, &amp; appearing in mpv/VLC subtitle text, or Netflix WEB-DL mkv subs looking wrong.
---

# fix-mpv-subtitle-entities

Netflix WEB-DL mkvs often embed SubRip (SRT) tracks whose text contains raw HTML entities (`&lrm;`, `&rlm;`, `&amp;`, `&#x200E;`...). mpv treats SRT as plain text and does not decode HTML entities, so they render literally.

## Diagnosis first (facts are yours, don't ask)

1. Find subtitle files: `ls <dir>/*.srt` — if none, entities are likely **inside the mkv**.
2. Check tracks: `nix shell nixpkgs#mkvtoolnix -c mkvmerge -J <file.mkv>` — look for `SubRip/SRT` tracks and their `properties.language` / `track_name`.
3. Extract and confirm: `mkvextract tracks <f.mkv> <id>:out.srt` then `grep -o "&[a-z#0-9]*;" out.srt | sort | uniq -c`.

## Fix

Prefer external subtitles over remuxing (source mkv stays untouched and checksum-verifiable):

```bash
for f in *.mkv; do
  b="${f%.mkv}"
  mkvextract tracks "$f" 2:"$b.zh-Hans.srt" 3:"$b.zh-Hant.srt" 5:"$b.ja.srt"   # map track ids to language names from diagnosis
  sed -i 's/&[a-z]*;//g; s/&#x\?[0-9a-fA-F]*;//g' "$b".*.srt
done
```

Rules:
- Name files `<mkv-basename>.<lang>.srt` next to the mkv — mpv auto-loads and picks the right language track (e.g. `.zh-Hans.srt`, `.en.srt`, `.ja.srt`).
- Strip entities with sed (`&lrm;` is U+200E, meaningless in zh/ja/en subtitles — safe to delete).
- Skip tracks that have no entities (usually the English track) — don't re-extract clean data.
- If mpv still shows the old text, the embedded track is selected: press `j` to cycle, or delete the embedded track with `mkvpropedit` if the user wants it gone permanently.

See `scripts/fix-entities.sh` for a ready script: `fix-entities.sh <dir>` walks all mkvs, extracts every SubRip track, strips entities, writes `<basename>.<lang>.srt`. Track→lang mapping keys off `track_name` ("Simplified/Traditional Chinese", "Japanese", ...), not the bare `language` code (both zh tracks are `chi`). The script already strips entities on extraction — do not re-sed its outputs; only re-sed files you extract yourself.
