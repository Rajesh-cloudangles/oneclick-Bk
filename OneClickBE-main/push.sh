#!/bin/bash

REPO_PATH="/home/saicharanthatavarthi/Documents/CA-Git/Automation-Webapp"

cd "$REPO_PATH" || { echo "Directory not found: $REPO_PATH"; exit 1; }

# Pull latest changes
echo "Pulling latest changes from origin/main..."
git pull origin main || { echo "Git pull failed"; exit 1; }

# Show current changes
echo ""
echo "Current status of the repository:"
git status

# Ask for confirmation to add changes
read -p "Do you want to stage all changes (git add .)? (y/n): " add_confirm

if [[ "$add_confirm" =~ ^[Yy]$ ]]; then
    # Stage all changes
    git add .

    # Show staged changes
    echo ""
    echo "Staged changes:"
    git status

    # Ask for commit message confirmation
    read -p "Proceed to commit with current date-time tag? (y/n): " commit_confirm

    if [[ "$commit_confirm" =~ ^[Yy]$ ]]; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        git commit -m "Auto-commit on $TIMESTAMP"
        
        # Ask for confirmation to push to origin/main
        read -p "Do you want to push the changes to origin/main? (y/n): " push_confirm

        if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
            git push origin main
            echo "✅ Changes committed and pushed to origin/main."
        else
            echo "❌ Push cancelled."
        fi
    else
        echo "❌ Commit cancelled."
    fi
else
    echo "❌ Staging changes cancelled."
fi
