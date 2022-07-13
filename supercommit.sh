#!/bin/bash -e
msg="'$*'"
if [ -z "$msg" ]; then
    echo "You need to provide a commit message"
    exit
fi

while true; do
	git submodule foreach "
   		git add -A .
   	 	git update-index --refresh
   	 	commits=\$(git diff-index HEAD)
   	 	if [ ! -z \"\$commits\" ]; then
       			git commit -am \"$msg\"
    		fi"

	git add .
	if ! git diff-index --quiet HEAD; then
		git commit -am "$msg"
	fi
        read -p "Do you wish to push your commit? " yn
        case $yn in
                [Yy]* ) git submodule foreach '
			if ! [[ `git diff-index --quiet HEAD` ]]; then
                                git push origin master || :
                        else
                                echo "No changes" # no changes
                        fi'; git push; break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
        esac
done
