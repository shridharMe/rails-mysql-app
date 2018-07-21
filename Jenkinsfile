#!/usr/bin/env groovy
pipeline {
    agent {
        node { label 'ADOP' }
    }
      
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '14'))
        timestamps()
    }
    environment {         
        DOCKER_REPO_URL          = "shridharpatil01"
    }
    parameters {
        booleanParam(name: 'REFRESH',defaultValue: true,description: 'Refresh Jenkinsfile and exit.')        
    }
    stages {
        stage('docker build') {
            when {
                expression { params.REFRESH == false }
            }
            parallel {
                stage("app-code") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'docker build -t rails-app app-code/.'
					}
				}
                stage("nginx") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'docker build -t rails-app nginx/.'
					}
				}
            }
           
        }
        stage('Tag') {
            when {
                expression { params.REFRESH == false }
            }
             parallel {
                stage("app-code") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'docker tag rails-app:latest ${DOCKER_REPO_URL}/rails-app:latest'
					}
				}
                stage("nginx") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'docker tag nginx:latest ${DOCKER_REPO_URL}/nginx:latest'
					}
				}
            }            
        }
        stage('Scanning') {
            when {
                expression { params.REFRESH == false }                           
            }
            parallel {
                stage("app-code") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'echo "scanning complete" '
					}
				}
                stage("nginx") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'echo "scanning complete" '
					}
				}
            } 
            
        }   
        stage('Push') {
            when {
                expression { params.REFRESH == false }                           
            }
            parallel {
                stage("app-code") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						 sh '''             
                            docker push ${DOCKER_REPO_URL}/rails-app:latest
                     '''
					}
				}
                stage("nginx") {
					//agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						 sh '''             
                            docker push ${DOCKER_REPO_URL}/nginx:latest
                     '''
					}
				}
            }            
            
        }  
        stage('Deploy') {
            when {
                expression { params.REFRESH == false }                                    
            }
            steps {

                sh '''
                    echo "Hello world"
                    '''
                
            }
            
        }       
    }
    post { 
        success {   
              script {
                      if ("${env.REFRESH}" == "false"){
                          sh '''    
                            echo "some post build acitivity after successful build"                       
                            //bitbucketStatusNotify ( buildState: 'SUCCESSFUL', buildDescription: 'Jenkins Salve' )                            
                            '''   
                      }  
                }
        }
        failure {
            script {  
                    if ("${env.REFRESH}" == "false"){
                        sh '''
                        echo "some post build acitivity after failed build"       
                        '''    
                        //bitbucketStatusNotify(buildState: 'FAILED')
                    } 
             }
        }
    }
}

def loadsquad(){
  def squadlist = new File('/tmp/squads')
  print "---> getting list of squads\n" + squadlist.text
  return squadlist.text
}