# Workforce Analysis Unit Away Day - 9th May 2018

## Welcome

Welcome to our unit away day! This folder contains all the information and data required for the exercise:

/data: useful datasets for the exercise
/projects: analysis folder templates for each problem set  
/problems: a description of each problem
README.md: this file 

Please clone this repository and branch under a suitable name, and do your work in the relevant /projects/project-# subfolder.
The projects folder is a template for the way the Data Insights team lay out their work - blame Adam if you don't like it :p

Push your code back at the end of the day, merge it and then everyone will be able to see what we've all worked on.

Have fun!
 
Peter, Eugene, Amy and Isi



## Git Proxy

In the Department the command line and most programming based tools are blocked from interacting with web pages. To get around this when using git you will need to open up a git bash terminal and run the following code with your username and password in the place holders. 

```sh 
git config --global http.proxy http://username:password@lonbloxx01:8080
git config --global https.proxy  https://username:password@lonbloxx01:8080
```

This creates a file called .gitconfig at the route of your F drive that git will use to bypass the proxy whenever an external request is made.

Note the following:

1. Whenever your password is changed you will need to re-run the code.
2. If you are having issues with OneDrive this will switch git from F directory to C. In this case just re-run the above code and you will then have files in both places.  