const https = require('https')
const zlib = require('zlib')
const fs = require('fs')
// const tar = require('tar')
const { pipeline } = require('stream')
const { exec, spawn } = require('child_process')

bootOpenSearch('https://artifacts.opensearch.org/snapshots/core/opensearch/1.0.0-SNAPSHOT/opensearch-min-1.0.0-SNAPSHOT-linux-x64-latest.tar.gz', 'opensearch-1.0.0-SNAPSHOT.tar.gz')
bootOpenSearchDashboards('https://artifacts.opensearch.org/snapshots/core/opensearch-dashboards/1.0.0-SNAPSHOT/opensearch-dashboards-min-1.0.0-SNAPSHOT-linux-x64-latest.tar.gz', 'OSD.tar.gz')

async function bootOpenSearch(snapshotPath, snapshotName) {
  const OpenSearchFile = fs.createWriteStream(snapshotName)
  https.get(snapshotPath, (res) => {
    pipeline(res, OpenSearchFile)

  })
  await spawn('tar', ['-xf', snapshotName])
  exec(`./${snapshotName}/bin/opensearch`)
  // & timeout 300 bash -c \'while [[ "$(curl -s -o /dev/null -w \'\'%{http_code}\'\' localhost:9200)" != "200" ]]; do sleep 5; done\'`)
}


async function bootOpenSearchDashboards(snapshotPath, snapshotName) {
  const OpenSearchDashboardsFile = fs.createWriteStream(snapshotName)
  https.get(snapshotPath, (res) => {
    pipeline(res, OpenSearchDashboardsFile)

  })
  await spawn('tar', ['-xf', snapshotName])
  exec(`./${snapshotName}/bin/opensearch-dashboards serve`)
  // & timeout 300 bash -c \'while [[ "$(curl -s localhost:5601/api/status \| jq -r \'.status.overall.state\')" != "green" ]]; do sleep 5; done\'`)
}
// const OpenSearchDashboardsFile = fs.createWriteStream('./OpenSearchDashboards.tgz')
// https.get('https://artifacts.opensearch.org/snapshots/core/opensearch-dashboards/1.0.0-SNAPSHOT/opensearch-dashboards-min-1.0.0-SNAPSHOT-linux-x64-latest.tar.gz', (res) => {
//   pipeline(res, OpenSearchDashboardsFile)
// })
// spawn('tar', ['-xf', 'OpenSearchDashboards.tgz'])
// // const OpenSearchDashboardsProcess = spawn('opensearch-1.0.0-SNAPSHOT/bin/opensearch');