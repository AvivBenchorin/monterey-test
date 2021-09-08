mkdir temp_test_targets
cd temp_test_targets
curl -X GET --output temp_os.tar.gz https://artifacts.opensearch.org/snapshots/core/opensearch/1.0.0-SNAPSHOT/opensearch-min-1.0.0-SNAPSHOT-linux-x64-latest.tar.gz
tar -xf temp_os.tar.gz
cd opensearch-1.0.0-SNAPSHOT/
bin/opensearch &
# timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9200)" != "200" ]]; do sleep 5; done'

cd ..
curl -X GET --output temp_osd.tar.gz https://artifacts.opensearch.org/snapshots/core/opensearch-dashboards/1.0.0-SNAPSHOT/opensearch-dashboards-min-1.0.0-SNAPSHOT-linux-x64-latest.tar.gz
tar -xf temp_osd.tar.gz

cd opensearch-dashboards-1.0.0-SNAPSHOT-linux-x64
bin/opensearch-dashboards serve &
# timeout 300 bash -c 'while [[ "$(curl -s localhost:5601/api/status | jq -r '.status.overall.state')" != "green" ]]; do sleep 5; done'
