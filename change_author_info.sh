#!/bin/sh

#if [ -z "$1" -o -z "$2" ]
#then
#    echo "Usage: $0 <old_author_email> <new_author_email> <new_author_name>"
#    exit 1
#fi

#echo "Looking for old email '$1', change to '$2', author name '$3'"

git filter-branch --force --env-filter '

an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"

if [ "$GIT_AUTHOR_EMAIL" = "someotheruser@fake.com" ]
then
    an="Lam"
    am="lamronby@fake.com"
fi

if [ "$GIT_COMMITTER_EMAIL" = "someotheruser@fake.com" ]
then
    cn="Lam"
    cm="lamronby@fake.com"
fi

export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'
