# New Dawn iOS Repo
iOS repository for project New Dawn

# Prep
Take a look at these videos to get familiar with iOS/Swift development:
1. First App: https://www.youtube.com/watch?v=xsohzfdeDng. This covers basics about Xcode, ViewController and UI Elements. **You should download Xcode and try it out on yourself to make sure you can rock with Xcode before going to next tutorials**.
2. UI Views & Constraint: https://www.youtube.com/watch?v=aiXvvL1wNUc. This tutorial covers basics aruond Constraints and StackView. Our app also has extensive constraints and more complex views such as ImageView, TableView, CollectionView, etc. But you don't need to know them until you are going to work on one of them.
3. Segue Basics (Connect and pass data between two views): https://www.youtube.com/watch?v=uKQjJb-KSwU. This teaches you how one view passes data to another.
4. Install Cocoapods: https://www.youtube.com/watch?v=MuMZZtQpB6Y. Cocoapods contains all extension library we use within the app. You should install it and run 'pod install' frequently in our repository to update the libraries we use (see below for details).

## Repository Setup
1. Clone the repo to your local machine by running `git clone https://github.com/new-dawn/new_dawn_ios_playground.git` in your terminal. You should run `git pull --rebase origin master` frequently so you can keep your local repo in sync with Github master branch. After the first time you clone the repo, you should go to `new_dawn_ios/NewDawn` directory, and run `pod install` to install required depencency.
2. In your local repo, run `git branch <feature_name>` and `git checkout <feature_name>` to create your own branch whenever you are starting a new feature.
3. Open `new_dawn_ios_playground/NewDawn/NewDawn.xcworkspace` in Xcode to start development within your branch.  
4. If you want to push your change, you can run `git add -A` in the terminal (from `new_dawn_ios_playground` folder) to include all your local changes. Then run `git commit -m "<some message>"` to commit your changes locally.
4. Run `git push origin <feature_name>` to push your local changes to your own branch on Github.
5. Go to Github page, create Pull Request when you are ready to merge your branch with master by clicking on "New pull request" on Github page.
6. After your pull request is accepted by any code reviewer, you can click on "Merge pull request" to merge your branch with master. Then in your command line, you can run `git checkout master` to go to master branch, and run `git pull --rebase origin master` to update your local repository to the latest master branch. Then you can create a new branch to develop new features.
