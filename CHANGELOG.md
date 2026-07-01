# Changelog
All notable changes to this project will be documented in this file.



## [v26.06.30] - 2026-07-01
### :sparkles: New Features
- [`c131f88`](https://github.com/StellarTeams/claude-plugins/commit/c131f883bc47034a6631644678198187ca4f91b0) - add coding guidelines skill *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`1ef4a82`](https://github.com/StellarTeams/claude-plugins/commit/1ef4a824499f07d013174eaf468b2ad0c1a5534f) - github ci files *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`12049ab`](https://github.com/StellarTeams/claude-plugins/commit/12049abab4a23fdd02ab680fbbfc11ec7df0dfbe) - inject commit convention via SessionStart hook *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`aace0c1`](https://github.com/StellarTeams/claude-plugins/commit/aace0c11e72774ed5a07c0918967924f44ecc022) - update spec skill to use git worktree and bump version to 1.0.6 *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`0ae749f`](https://github.com/StellarTeams/claude-plugins/commit/0ae749f2cb9797d2a8fbcd49beb2fb0d67bac33a) - open worktree in IDE after /spec creates it *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`ccd601f`](https://github.com/StellarTeams/claude-plugins/commit/ccd601f1438d0daba6f973430b1fe288bc788ba2) - prompt for editor choice instead of auto-launching WebStorm *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`f0b4077`](https://github.com/StellarTeams/claude-plugins/commit/f0b40771cfe056733110151f6e5418dc256ed5f0) - block automatic git commit and push via PreToolUse guard *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`f9bce03`](https://github.com/StellarTeams/claude-plugins/commit/f9bce03a959083ef41f74925e6dddaaef27a8c5b) - auto-approve OpenSpec CLI calls so the spec flow runs uninterrupted *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`d5d56b6`](https://github.com/StellarTeams/claude-plugins/commit/d5d56b6b64af1f7272d3a4ccc7671aacb24b815c) - reorder worktree editor prompt so "Don't open" is the default *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`650ee5f`](https://github.com/StellarTeams/claude-plugins/commit/650ee5f969d45e5467b5a782e3d24a3841c0f5f3) - require interactive editor selection in /spec worktree prompt *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`7a81c84`](https://github.com/StellarTeams/claude-plugins/commit/7a81c8490290b7954b5c7d66f6e05f1591452ede) - ask to open worktree in editor as the final /spec step *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`776e2e5`](https://github.com/StellarTeams/claude-plugins/commit/776e2e5eddca0249c973881926ac4a3faa3bd609) - add plan-mode research step to /spec before opsx:propose *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`23f4fb1`](https://github.com/StellarTeams/claude-plugins/commit/23f4fb132dde3a2c662c40420caba866afd3993f) - scope git guard to push only, let commits run freely *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`10fe9be`](https://github.com/StellarTeams/claude-plugins/commit/10fe9bef39ee98777286cc51aa17208447eb7616) - auto-approve pnpm/bun and in-project file access *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`9e7efc9`](https://github.com/StellarTeams/claude-plugins/commit/9e7efc97f858d752a67c8d9e13367f7ce85c90b7) - auto-approve project-local node_modules binaries *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`618c57d`](https://github.com/StellarTeams/claude-plugins/commit/618c57dae116ceae38fa67807d429097e9372291) - add notify plugin for cross-platform attention notifications *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`e4ac66c`](https://github.com/StellarTeams/claude-plugins/commit/e4ac66cd178900585b34150f992bfd3c4f1c79ac) - auto-approve shellcheck calls in base-skills *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`5b2dbdb`](https://github.com/StellarTeams/claude-plugins/commit/5b2dbdb30c63f835df1ea744b110fe0b2001a292) - add branch and recent-commit context to commit-message skill *(commit by [@creativearmenia](https://github.com/creativearmenia))*

### :bug: Bug Fixes
- [`495e319`](https://github.com/StellarTeams/claude-plugins/commit/495e319c57bebd793edda3fa40daebdcf0d247d0) - trigger commit-message skill via explicit description *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`615aadd`](https://github.com/StellarTeams/claude-plugins/commit/615aadd501a7641fbad4450251c99719c4859e16) - use npx as default for openspec-init, skip global install *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`48a3145`](https://github.com/StellarTeams/claude-plugins/commit/48a31451c9b1a535e2a781ace4f783c622ab03c6) - tighten allowed-tools and improve worktree setup in spec skills *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`a5a5772`](https://github.com/StellarTeams/claude-plugins/commit/a5a57724dbd9368f9e5a74f4327abb119612e3e8) - repair spec skill OpenSpec handoff and worktree init *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`1b6f640`](https://github.com/StellarTeams/claude-plugins/commit/1b6f6401bde750c918bf5fd2f1fb914ea777bf68) - ensure openspec CLI is on PATH so /opsx commands don't exit 127 *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`0814531`](https://github.com/StellarTeams/claude-plugins/commit/0814531e01ddbec9c5d58d75e07f0209f82ed3f4) - stop /spec from skipping the editor prompt under zsh *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`1fabbe9`](https://github.com/StellarTeams/claude-plugins/commit/1fabbe971e6f75b5d14c5c0dd53cfe91f06d0dee) - keep /spec editor prompt as the last step *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`0e756ea`](https://github.com/StellarTeams/claude-plugins/commit/0e756eacb05b878f8316d9b38ac4d286578a1cb9) - make /spec enter plan mode before researching *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`e71d9bc`](https://github.com/StellarTeams/claude-plugins/commit/e71d9bc6f0421cea7805b07b30893d3598a4ea56) - correct marketplace org name and install identifiers *(commit by [@creativearmenia](https://github.com/creativearmenia))*

### :construction_worker: Build System
- [`322d8b5`](https://github.com/StellarTeams/claude-plugins/commit/322d8b505f1a7f56460be23d9c77a6c716c46cca) - make release workflow self-contained *(commit by [@creativearmenia](https://github.com/creativearmenia))*

### :memo: Documentation Changes
- [`532a85c`](https://github.com/StellarTeams/claude-plugins/commit/532a85c7d16c91b12c16ad040878e2ab23b72e32) - add CLAUDE.md and fix post-install hook activation *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`d801781`](https://github.com/StellarTeams/claude-plugins/commit/d8017815162668c91c63cab921dc7485dd86d227) - update READMEs to reflect spec skill worktree change *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`8f0b8ab`](https://github.com/StellarTeams/claude-plugins/commit/8f0b8abbc6150b5296fde91086f9004c40e328ca) - document /spec plan-mode research step in READMEs *(commit by [@creativearmenia](https://github.com/creativearmenia))*

### :wrench: Chores
- [`f9442da`](https://github.com/StellarTeams/claude-plugins/commit/f9442da44628e052a8007e3c19bd6af3e617ff6e) - do not allow claude to add Co-Authored-By during commit *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`6fca333`](https://github.com/StellarTeams/claude-plugins/commit/6fca333de450b32fbc3d66f8d2dd2bcbbe896775) - move CLAUDE.md into .claude/ and add project settings *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`475e99d`](https://github.com/StellarTeams/claude-plugins/commit/475e99da6bf58437dc4af13c8c0b059eedb2a017) - bump base-skills to 1.1.0 *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`009d9f3`](https://github.com/StellarTeams/claude-plugins/commit/009d9f3c309de51a0036eb612bd8e2a43234662b) - bump base-skills to 1.2.0 *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`710936d`](https://github.com/StellarTeams/claude-plugins/commit/710936df2cc7d7f17c3131eff486be6ecb5d5504) - bump base-skills to 1.2.3 and document version-bump convention *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`92ab3d8`](https://github.com/StellarTeams/claude-plugins/commit/92ab3d8f750b6ede365714f63bcba257d9812747) - align base-skills docs/hooks and add validation CI *(commit by [@creativearmenia](https://github.com/creativearmenia))*
- [`09eb6a9`](https://github.com/StellarTeams/claude-plugins/commit/09eb6a9d7e3359ca2697f689d0a3a0ed6a2369c3) - allow git and openspec commands without permission prompts *(commit by [@creativearmenia](https://github.com/creativearmenia))*

[v26.06.30]: https://github.com/StellarTeams/claude-plugins/compare/bc32bfec27e92d9081f970d3bf4decd63b8740e9...v26.06.30
