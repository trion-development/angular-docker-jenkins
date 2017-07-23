#!groovy

properties(
    [
        [$class: 'BuildDiscarderProperty', strategy:
          [$class: 'LogRotator', artifactDaysToKeepStr: '14', artifactNumToKeepStr: '5', daysToKeepStr: '30', numToKeepStr: '60']],
        pipelineTriggers(
          [
              pollSCM('H/15 * * * *'),
              cron('@daily'),
          ]
        )
    ]
)
node {
    docker.image('trion/ng-cli-karma:1.2.1').inside {
      stage('Checkout') {
          //disable to recycle workspace data to save time/bandwidth
          deleteDir()
          checkout scm
      }

      stage('NPM Install') {
          withEnv(["NPM_CONFIG_LOGLEVEL=warn"]) {
              sh 'npm install'
          }
      }

      stage('Build') {
          milestone()
          sh 'ng build --prod --aot --sm --progress=false'
      }

      stage('Test') {
          withEnv(["CHROME_BIN=/usr/bin/chromium-browser"]) {
            sh 'ng test --progress=false --watch false'
          }
          junit '**/test-results.xml'
      }

      stage('Lint') {
          sh 'ng lint'
      }
    }
    //end docker

    stage('Archive') {
        sh 'tar -cvzf dist.tar.gz --strip-components=1 dist'
        archive 'dist.tar.gz'
    }

    stage('Deploy') {
        milestone()
        echo "Deploying..."
    }
}
