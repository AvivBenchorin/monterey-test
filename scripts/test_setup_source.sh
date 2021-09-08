mkdir temp_test_targets
cd temp_test_targets
curl -X GET --output temp_os.tar.gz https://artifacts.opensearch.org/snapshots/core/opensearch/1.1.0-SNAPSHOT/opensearch-min-1.1.0-SNAPSHOT-linux-x64-latest.tar.gz
tar -xf temp_os.tar.gz
cd opensearch-1.1.0-SNAPSHOT/
bin/opensearch &
# timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9200)" != "200" ]]; do sleep 5; done'

cd ..
git clone https://github.com/opensearch-project/OpenSearch-Dashboards.git
cd OpenSearch-Dashboards
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 10.24.1
npm i -g yarn
yarn osd bootstrap
yarn start --no-base-path --no-watch &

# timeout 300 bash -c 'while [[ "$(curl -s localhost:5601/api/status | jq -r '.status.overall.state')" != "green" ]]; do sleep 5; done'
