# Repository Rename Instructions

## How to Rename on GitHub

The repository name can only be changed through GitHub's web interface. Follow these steps:

### Step 1: Rename on GitHub

1. Go to https://github.com/sfloess/Galaxy-J7-02
2. Click **Settings** (top right)
3. Under "Repository name", change:
   - From: `Galaxy-J7-02`
   - To: `Samsung-Galaxy-J7`
4. Click **Rename**

GitHub will automatically:
- Redirect old URLs to new name
- Update clone/fetch URLs
- Preserve all issues, PRs, and history

### Step 2: Update Local Remote URL

After renaming on GitHub, update your local repository:

```bash
cd ~/tmp/adb
git remote set-url origin git@github.com:sfloess/Samsung-Galaxy-J7.git
git remote -v  # Verify the change
```

### Step 3: Verify

```bash
git pull  # Should work with new URL
git push  # Should work with new URL
```

## What I've Already Done

✅ Updated all documentation references:
- `scripts/install_debian_with_ssh.sh`
- `scripts/setup_termux_sdcard.sh`  
- `README.md` (2 locations)

These changes are committed and ready to push after you rename on GitHub.

## Timeline

1. **You do:** Rename on GitHub (2 minutes)
2. **You do:** Update local remote URL (30 seconds)
3. **I'll do:** Push the updated documentation

---

**Note:** GitHub maintains redirects from the old name, so existing clones and links will continue to work, but it's best practice to update your local remote URL.
