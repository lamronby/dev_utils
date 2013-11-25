#!/bin/sh
#
# Export a Mercurial patch to git.
#


if [ $# -lt 1 ]
then
	echo "No changesets specified"
	exit 1
fi

wd=`pwd`
HG_DIR="/c/dev/mercurial/DIVAdirector"
GIT_DIR="/c/dev/divadirector_web"

while (( "$#" ))
do
	changeset=$1
	
	# Mercurial
	echo "Exporting patch $changeset from Mercurial"
	cd $HG_DIR
	hg export --git -r $changeset > ../$changeset.diff
	
	# Git
	echo "Testing patch apply in git repo"
	cd $GIT_DIR
	git apply --ignore-whitespace --check /c/dev/mercurial/$changeset.diff
	rc=$?
	echo "Return code for apply check is $rc"
	if [ $rc -eq 0 ]
	then
		# echo "Check was succesful!"
		echo "Check was succesful, applying patch for reals this time!"
		git apply --ignore-whitespace /c/dev/mercurial/$changeset.diff
	else
		#echo "Check failed."
		echo "Check failed, you must patch manually."
	fi
	
	shift
done

cd $wd


