# New Dawn iOS Repo
iOS repository for project New Dawn

# Prep
Take a look at this video to get familiar with iOS/Swift development

## Repository Setup
1. Clone the repo to your local machine by running `git clone https://github.com/new-dawn/new_dawn_ios.git` in your terminal/command line. You can then add your changes in `new_dawn_ios/`. Run `git pull --rebase origin master` frequently so you can rebase your code to master branch.
2. In your local repo, run `git branch <feature_name>` and `git checkout <feature_name>` to create your own branch.
3. Write code in your branch. 
4. If you want to push your change, run `git add -A` to include all your local changes. Then run `git commit -m "<some message>"` to commit your changes locally.
4. Run `git push origin <feature_name>` to push your local changes to your own branch on Github.
5. Go to Github page, create Pull Request when you are ready to merge your branch with master by clicking on "new pull request" on Github page.
6. After your pull request is accepted by any code reviewer, you can click on "Merge pull request" to merge your branch with master. Then in your command line, you can run `git checkout master` to go to master branch, and run `git pull --rebase origin master` to update your local repository to the latest master branch.

## First thing to do after
1. In `new_dawn_ios/NewDawn` directory, run `pod install` to install required depencency.
2. Made changes in NewDawn.xcworkspace instead of NewDawn.xcodeproj

# Try your First Pull Request
1. To quickly ramp up how UI dev works, please follow the below steps to build a small ViewController 
