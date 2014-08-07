#!/bin/bash
#
# Export a Mercurial patch to git.
#


function usage {
    echo "Usage: export_patch <hg_repo_dir> <git_repo_dir> <changeset>"
}

if [ $# -lt 1 ]
then
    echo "No changesets specified"
    usage
    exit 1
fi

hg_dir=$1
shift
git_dir=$1
shift
do_git_apply=0
wd=`pwd`

for changeset in $*
do
    # Mercurial
    cd $hg_dir
    summary=$(hg log -r $changeset | grep "^summary:" | sed 's/^summary: *//')
    echo -e "\nExporting patch $changeset from Hg, summary: $summary"
    hg export --git -r $changeset > $changeset.diff
    
    # Git
    echo "Testing patch apply in git repo"
    cd $git_dir
    git apply --ignore-whitespace --check $hg_dir/$changeset.diff
    rc=$?
    echo "Return code for apply check is $rc"
    if [ $rc -eq 0 ]
    then
        if [ $do_git_apply -eq 1 ]
        then
            echo "Check was successful, applying patch for reals this time!"
            git apply --ignore-whitespace $hg_dir/$changeset.diff
            rc=$?
            echo "Return code for apply is $rc"
        else
            echo "Check was successful!"
        fi
    else
        echo "Check failed."
    fi
    
    summaries="$summaries\n$changeset: $summary"
   
done

echo -e "\nChangeset summaries:\n$summaries"

cd $wd
