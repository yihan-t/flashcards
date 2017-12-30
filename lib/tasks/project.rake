namespace :project do
  desc "Attempt to update project, if there are no conflicts"
  task :update do
    if `git config remote.upstream.url`.blank?
      `git remote add upstream git@github.com:appdevsummer17/final_project.git`
    end

    `git checkout -b project-update-#{Time.now.to_i}`
    `git add -A`
    `git commit -m "Changes before project update"`
    `git fetch upstream`
    `git checkout master`
    `git reset --hard upstream/master`
    `git checkout -`
    `git rebase upstream/master`
    `rails db:drop`
    `bin/setup`
    `git add -A`
    `git commit -m "Updated project from upstream"`
  end
end
