# Push this repo to your GitHub

## 1. Create a new repo on GitHub

- Go to https://github.com/new
- Repository name: e.g. `move-stylus-samples`
- Visibility: Public (or Private)
- Do **not** initialize with README (we already have one)

## 2. Add remote and push

From this directory (`move-stylus-samples`), run (replace `YOUR_USERNAME` with your GitHub username):

```bash
git remote add origin https://github.com/YOUR_USERNAME/move-stylus-samples.git
git branch -M main
git push -u origin main
```

If you use SSH:

```bash
git remote add origin git@github.com:YOUR_USERNAME/move-stylus-samples.git
git branch -M main
git push -u origin main
```

## 3. Or use GitHub CLI

If you have `gh` installed:

```bash
gh repo create move-stylus-samples --public --source=. --remote=origin --push
```
