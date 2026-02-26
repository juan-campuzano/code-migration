---
on:
  workflow_dispatch:
  schedule: daily
permissions:
  id-token: write 
  contents: read
  issues: read
  pull-requests: read
safe-outputs:
  create-pull-request:
    title-prefix: "[ai modernization]: "
engine: copilot
imports:
  - ../agents/AppModernization-Flutter.agent.md
---

Perform code modernization on the repository. This workflow will run daily and can also be triggered manually. It will read the contents of the repository and create pull requests with the necessary changes for modernization.