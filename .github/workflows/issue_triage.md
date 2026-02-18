---
on:
  issues: 
    types: [opened, reopened]
permissions:
  contents: read
  issues: read
  pull-requests: read
safe-outputs:
  add-comment:
    max: 1
---

## Issues Greeting

When a new issue is created comment it greeting the issue and add a label based on the request the user is making

## Labels

You are allowed to create labels
