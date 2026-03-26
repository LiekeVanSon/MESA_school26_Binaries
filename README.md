# MESA Summer School Thursday Content

This repository is a minimal full Hugo site for one day of the MESA summer school.

## Structure

- `content/thursday/_index.md` is the Hugo landing page for the day.
- `content/thursday/morning-session.md` contains the opening session content.
- `content/thursday/lab-1.md`, `lab-2.md`, and `lab-3.md` are the main lab writeups.
- `content/thursday/lab1/`, `lab2/`, and `lab3/` contain starter MESA files for each lab.
- `themes/Hextra/` contains the Hugo theme used for rendering.
- `hugo.toml` contains the site configuration.

## Local Preview

1. Install Hugo Extended if it is not installed.

```bash
brew install hugo
```

2. Start the local Hugo server from the repository root.

```bash
hugo server -D
```

3. Open your browser at:

```text
http://localhost:1313/thursday/
```

## Notes

This repo is scoped to a single day and can still be merged into a larger multi-day Hugo site later if needed.
