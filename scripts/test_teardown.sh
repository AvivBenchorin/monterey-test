kill $(lsof -i -P -n | grep 127.0.0.1:5601 | awk '{if($1 == "node"){ print $2 }}' | uniq)
kill $(lsof -i -P -n | grep 127.0.0.1:9200 | awk '{if($1 == "java"){ print $2 }}' | uniq)
rm -r temp_test_targets