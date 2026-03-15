# Updating Your Project Template

This project supports one-click template updates through GitHub Actions.

## For Students (GitHub + GitHub Desktop)

1. Open your repository on GitHub.
2. Go to **Actions**.
3. Select **Template Sync**.
4. Click **Run workflow** (keep defaults unless your instructor says otherwise).
5. Wait for the workflow to finish.

If a pull request is created:

6. Open the pull request.
7. Review changed files.
8. Click **Merge pull request**.
9. Open GitHub Desktop and click **Pull origin**.

If an issue is created instead of a pull request:

- The update had merge conflicts.
- Ask a TA/mentor to help resolve the conflict.

## What the Action Does

- Fetches the latest template updates.
- Tries to merge them into a sync branch in your repo.
- Creates a pull request when merge succeeds.
- Creates an issue when manual conflict resolution is needed.

## Notes

- Your design work is not automatically overwritten.
- Always review pull requests before merging.
- Run template sync regularly (for example, once per week during the chipathon).

## Troubleshooting

- **Action not visible:** Make sure your repo contains `.github/workflows/template-sync.yml` in the default branch.
- **Permission error:** Ensure Actions are enabled for the repository.
- **No pull request created:** The repository may already be up to date; check the workflow summary.
