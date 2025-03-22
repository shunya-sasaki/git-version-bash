# Git version with bash

## Detect version flow

```mermaid
flowchart TD

processStart@{label: "Start", shape: circle}
conditionCommitCount@{label: "commit count==0?", shape: diam}
conditionHasChanges@{label: "has changes?", shape: diam}
stopAsTag@{label: "{major}.{minor}.{patch}", shape: dbl-circ}
stopPatchInc@{label: "{major}.{minor}.{patch+1}.dev{commit_count}+d{hash}", shape: dbl-circ}

processStart --> conditionCommitCount
conditionCommitCount -->|y| conditionHasChanges
conditionHasChanges -->|n| stopAsTag
conditionHasChanges -->|y| stopPatchInc
conditionCommitCount -->|n| stopPatchInc
```
