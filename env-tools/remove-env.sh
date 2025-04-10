#!/bin/bash
# Script to remove environment files from Git history

echo "⚠️ WARNING: This script will rewrite Git history to remove sensitive files."
echo "            Make sure you have a backup of your repository first."
echo "            This could cause issues for collaborators."
echo ""
read -p "Are you sure you want to continue? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Operation cancelled."
  exit 0
fi

# List of files to remove from history
FILES_TO_REMOVE=(
  "*/.env"
  "*/.env.*"
  "backend/.env"
  "env-tools/.env*"
  ".env*"
)

# Join the array with spaces
FILES_STRING=$(printf " %s" "${FILES_TO_REMOVE[@]}")
FILES_STRING=${FILES_STRING:1}

echo ""
echo "🔄 Removing sensitive files from Git history..."
echo ""

# Use BFG Repo-Cleaner if available (much faster than filter-branch)
if command -v bfg &> /dev/null; then
  echo "Using BFG Repo-Cleaner to clean history"
  
  for file in "${FILES_TO_REMOVE[@]}"; do
    echo "Removing $file"
    bfg --delete-files "$file" --no-blob-protection
  done
  
  # After BFG completes, you need to run garbage collection and push forcefully
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive
  
  echo ""
  echo "✅ Files removed from Git history."
  echo "To push these changes, use: git push origin --force"
else
  # Fall back to git filter-branch (slower but built-in)
  echo "Using git filter-branch to clean history (this may take a while)"
  
  # Use filter-branch to remove files from history
  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch $FILES_STRING" \
    --prune-empty --tag-name-filter cat -- --all
    
  # Clean up refs
  git for-each-ref --format="delete %(refname)" refs/original/ | git update-ref --stdin
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive
  
  echo ""
  echo "✅ Files removed from Git history."
  echo "To push these changes, use: git push origin --force"
fi

echo ""
echo "🔒 Ensuring environment files are properly ignored..."

# Check if the files are properly ignored now
for file in "${FILES_TO_REMOVE[@]}"; do
  if git check-ignore $file &>/dev/null; then
    echo "✅ $file is properly ignored by Git"
  else
    echo "⚠️ $file might not be properly ignored. Check your .gitignore file."
  fi
done

echo ""
echo "🔒 IMPORTANT SECURITY STEPS:"
echo "1. Change any exposed secrets, passwords or tokens immediately!"
echo "2. Rotate JWT secrets, database passwords, and API keys"
echo "3. Check for any other sensitive files not covered by this script"
echo ""
echo "Remember: NEVER commit sensitive information to Git repositories."