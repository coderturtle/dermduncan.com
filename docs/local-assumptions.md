# Local Assumptions

## Expected Paths

- Hekton root: `~/hekton`
- Development root: `~/Development/hekton`
- Project root: `~/Development/hekton/factory-output/dermduncan.com`
- Vault root: `~/vaults/hekton-mind-palace`
- Proposed vault control plane: `20-projects/factory-output/dermduncan.com`

## Required Tools

- `git`
- `bash`
- `hugo` (extended edition, `0.123.7` to match CI; not installed on this machine as of adoption)

## GitHub Account

Use the `coderturtle` GitHub account for this repo.

The local remote should use:

```text
git@github.com-coderturtle:coderturtle/dermduncan.com.git
```

That host alias routes SSH to the coderturtle key according to the Hekton command reference.

## Theme

`themes/hugo-resume` is vendored directly in the tree, not a Git submodule (the CI workflow requests `submodules: recursive`, which is a no-op here since there is no `.gitmodules`). No upstream version is currently recorded.
