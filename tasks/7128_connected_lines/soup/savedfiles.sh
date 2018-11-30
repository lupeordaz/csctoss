inotifywait -m /opt/sdm/savefiles -e create -e moved_to |
    while read path action file; do
        #echo "The file '$file' appeared in directory '$path' via '$action'"
        # do something with the file
        cp /opt/sdm/savefiles/$file /opt/t
        cd /opt/t
        ./test.sh $file  >> /opt/sdm/config.log 
	mv /opt/sdm/savefiles/$file /opt/sdm/processed
    done
