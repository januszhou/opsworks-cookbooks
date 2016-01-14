###Adding a new repository
- Adding new entry at `deploy_setup/recipes/deploy.rb::fullLists` and `deploy_setup/recipes/setup.rb::fullLists`, the format will be ` $folderName => {'url' => $github_repo_url, 'branch' => '$branch_you_need'}`
- Once you commit and pushed to `release-chef-11.10` branch, you need go to opswork->deployments at aws, click `Run command`, and select `update custom cookbooks` from command list.
- Next, once it's done, at same page, select `Execute Recipe`, then type `deploy_setup::deploy` at "Recipes to execute", it will run our deploy.rb recipe.
- It should be good now.