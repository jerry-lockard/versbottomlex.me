# Professional Git Commit Message Generation

Create a perfectly structured git commit message for the VersBottomLex.me project that follows industry best practices and enables efficient project history tracking.

## Commit Details
- **Change Type**: {{feature|bugfix|refactor|docs|style|test|chore|perf}}
- **Scope**: {{frontend|backend|infrastructure|docs|tests}}
- **Changes Made**: {{description_of_changes}}
- **Issue References**: {{issue_numbers}}
- **Breaking Change**: {{yes|no}}

## Commit Message Requirements

### 1. Subject Line
- [ ] Use conventional commits format (`type(scope): summary`)
- [ ] Keep under 50 characters
- [ ] Begin with lowercase verb in imperative mood (add, fix, update)
- [ ] No period at the end
- [ ] Clear and descriptive of what was changed
- [ ] Prefix with `BREAKING CHANGE:` if applicable
- [ ] Include component/scope in parentheses when relevant

### 2. Message Body
- [ ] Separate from subject with blank line
- [ ] Wrap at 72 characters per line
- [ ] Explain the motivation behind the change
- [ ] Describe why this approach was taken
- [ ] Compare with previous behavior if relevant
- [ ] Use present tense ("change" not "changed" or "changes")
- [ ] Include performance implications if relevant
- [ ] Explain non-obvious technical decisions
- [ ] Reference dependent changes if applicable

### 3. Issue References
- [ ] Include "Fixes #123" or "Resolves #123" syntax for auto-closing issues
- [ ] Reference related issues with "Refs #123"
- [ ] Place issue references at the end of the commit message
- [ ] Properly format multiple issue references
- [ ] Include external ticket references if applicable

### 4. Co-authors (if applicable)
- [ ] Include "Co-authored-by: Name <email>" for pair/mob programming
- [ ] Place co-author tags at the end after a blank line
- [ ] Format consistently for multiple co-authors

### 5. Formatting
- [ ] Use Markdown formatting in body when helpful
- [ ] Separate logical sections with blank lines
- [ ] Use bullet points for lists of changes
- [ ] Highlight important information using emphasis

## Message Structure Template
```
type(scope): concise description of the change

Detailed explanation of why this change was necessary and how it
addresses the problem. Include context that future developers would
find helpful when reviewing this commit.

Additional paragraphs for complex changes, separated by blank lines.

- Bullet points for multiple discrete changes
- Another change detail

Performance implications: [if relevant]
Migration notes: [if relevant]

Fixes #123, Refs #456
```

## Auto-Push Feature
- [ ] Generate properly formatted commit message
- [ ] If approved, automatically stage modified files
- [ ] Commit changes with the generated message
- [ ] Push to the current branch

Generate a professional commit message based on the provided changes, then offer to execute the commit and push if the message is approved.
