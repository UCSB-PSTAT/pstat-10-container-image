pipeline {
    agent none
    triggers{
        upstream(upstreamProjects: 'UCSB-PSTAT GitHub/base-rstudio/main', threshold: hudson.model.Result.SUCCESS)
    }
    environment {
        IMAGE_NAME = 'pstat-10'
        CONTAINER_REGISTRY  = 'registry.cloud.college.ucsb.edu'
    }
    stages {
        stage('Build Test Deploy') {
            agent {
                label 'jupyter'
            }
            stages{
                stage('Build') {
                    steps {
                        script {
                            if (currentBuild.getBuildCauses('com.cloudbees.jenkins.GitHubPushCause').size() || currentBuild.getBuildCauses('jenkins.branch.BranchIndexingCause').size()) {
                               scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                            }
                        }
                        echo "NODE_NAME = ${env.NODE_NAME}"
                        sh 'podman build -t localhost/$IMAGE_NAME --pull --force-rm --no-cache .'
                     }
                    post {
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Test') {
                    steps {
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME which rstudio'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME R -q -e "getRversion() >= \\"4.5.2\\"" | tee /dev/stderr | grep -q "TRUE"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME find /usr/share -type f -name lmodern.sty'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"kableExtra\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"stats\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"datasets\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"graphics\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"tidyverse\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"mosaic\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"mosaicCore\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"mosaicData\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"openintro\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"palmerpenguins\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"RColorBrewer\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"knitr\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"markdown\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"rmarkdown\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"car\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"carData\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"cherryblossom\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"datasets\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"DBI\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"dbplyr\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"network\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"DT\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"emo\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"fivethirtyeight\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"GGally\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"gargle\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"Lock5Data\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"MASS\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"RSQLite\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"leaflet\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"learnr\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"skimr\")"'
                        sh 'podman run -it --pull=never --rm localhost/$IMAGE_NAME Rscript -e "library(\"tutorial.helpers\")"'
                        sh 'podman run -d --pull=never --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                        retry(6) { sh 'sleep 10 && curl -v http://localhost:8888/rstudio?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s[1-3][0-9][0-9]\\s+[\\w\\s]+\\s*$"' }
                        sh 'curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                        sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                    }
                    post {
                        always {
                            sh 'podman rm -ifv $IMAGE_NAME'
                        }
                        unsuccessful {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }
                stage('Deploy') {
                    when { branch 'main' }
                    environment {
                        DOCKER_HUB_CREDS = credentials('harbor-registry-token')
                    }
                    steps {
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://$CONTAINER_REGISTRY/ucsb/$IMAGE_NAME:latest --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                        sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://$CONTAINER_REGISTRY/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d") --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                    }
                    post {
                        always {
                            sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                        }
                    }
                }                
            }
            post {
                always {
                    sh 'podman rmi -i localhost/$IMAGE_NAME || true'
                }
            }
        }
    }
    post {
        success {
            slackSend(username: 'jenkins', color: 'good', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(username: 'jenkins', color: 'danger', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
