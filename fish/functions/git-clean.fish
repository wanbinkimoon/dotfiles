function git-clean
    git pull
    git fetch -p

    # Check if --force is passed as an argument
    set force_delete false
    if test "$argv[1]" = "--force"
        set force_delete true
    end

    # Delete local branches whose upstream has been deleted
    for branch in (git branch -vv | grep ': gone]' | awk '{print $1}')
        if test "$force_delete" = "true"
            # Try to delete the branch with force
            if not git branch -d "$branch"
                # If it fails, it means the branch is not fully merged
                echo "The branch '$branch' is not fully merged. Do you want to delete it? (y/n)"
                read -P "" response
                if test "$response" = "y"
                    git branch -D "$branch"
                end
            end
        else
            git branch -d "$branch"
        end
    end
end
