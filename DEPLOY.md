# Deploying the Landing Page to GitHub Pages

Follow these steps to deploy the RideIL "Coming Soon" landing page using GitHub Pages.

## Prerequisites

- A GitHub account with access to the repository
- The `index.html` file committed to the repository (already included in this repo)

## Steps

### 1. Push the landing page to the repository

Make sure `index.html` is committed and pushed to the branch you want to deploy from (typically `main`):

```bash
git add index.html
git commit -m "Add coming soon landing page"
git push origin main
```

### 2. Enable GitHub Pages

1. Go to the repository on GitHub: https://github.com/zoharngo/ride-sharing-application
2. Click **Settings** (gear icon in the top navigation bar)
3. In the left sidebar, click **Pages** (under the "Code and automation" section)
4. Under **Source**, select **Deploy from a branch**
5. Under **Branch**, select `main` and set the folder to `/ (root)`
6. Click **Save**

### 3. Wait for deployment

GitHub will automatically build and deploy the site. This typically takes 1–2 minutes. You can monitor progress in the **Actions** tab of the repository.

### 4. Access the live site

Once deployed, the landing page will be available at:

```
https://zoharngo.github.io/ride-sharing-application/
```

A green checkmark and the URL will appear on the **Settings > Pages** page when the deployment is complete.

## Updating the Landing Page

Any changes pushed to `index.html` on the configured branch will automatically trigger a redeployment. Simply commit and push your changes:

```bash
git add index.html
git commit -m "Update landing page"
git push origin main
```

## Using a Custom Domain (Optional)

1. In **Settings > Pages**, enter your custom domain under **Custom domain**
2. Click **Save**
3. Configure your DNS provider to point to GitHub Pages:
   - For an apex domain (`example.com`): Add `A` records pointing to GitHub's IP addresses
   - For a subdomain (`www.example.com`): Add a `CNAME` record pointing to `zoharngo.github.io`
4. Optionally check **Enforce HTTPS** once DNS propagation is complete

Refer to the [GitHub Pages documentation](https://docs.github.com/en/pages) for more details.
