---
title: Pushing Status Messages to GitHub
classes: image-with-border
---
{::options parse_block_html="true" /}

# Pushing Status Messages to GitHub

Cider-CI can push status messages of Cider-CI jobs to GitHub.


## Configuration

1. Create an Authentication Token on GitHub.
<div class="row"> <div class="col-md-6">
Visit your [Personal access tokens](https://github.com/settings/tokens)
page on GitHub and create a new token.

</div> <div class="col-md-6">
![Create Token](github_create-token.png)
</div> </div>

2. Copy the Token.
<div class="row"> <div class="col-md-6">
</div> <div class="col-md-6">
![Copy Token](github_copy-token.png)
</div> </div>

3. Configure the Repository on Cider-CI with the Token.
<div class="row"> <div class="col-md-6">
Visit your instance of Cider-CI. Set the **GitHub Authentication Token**
for your Repository (Administration → Repositories → Repository → Edit).

</div> <div class="col-md-6">
![Repository Configuration](github_configure-repo-with-token.png)
</div> </div>


## Verification

4. Run a Job.
<div class="row"> <div class="col-md-6">
</div> <div class="col-md-6">
![Run Job](github_run-job.png)
</div> </div>

5. Watch Status Message on GitHub
<div class="row"> <div class="col-md-6">
Statuses are shown with pull requests or
on the branches overview page of your GitHub project:
`https://github.com/YOUR-ORGANIZATION/YOUR-PROJECT/branches`.

</div> <div class="col-md-6">
![Watch Status Message](github_watch-status-on-github.png)
</div> </div>

