#!/usr/bin/env groovy
pipeline {
    agent {
        node { label 'docker' }
    }
      
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '14'))
        timestamps()
    }
    environment { 
        DOCKER_REPO_URL          = credentials('DOCKER_REPO_URL')        
        DOCKER_REPO_PWD          = credentials('DOCKER_REPO_PWD')  
    }
    parameters {
        booleanParam(name: 'REFRESH',defaultValue: true,description: 'Refresh Jenkinsfile and exit.')
        booleanParam(name: 'SSL',defaultValue: false,description: 'Create nginx SSL certificate.')        
    }
    stages {
        stage("testing") {
            when {
                expression { params.REFRESH == false }                                    
            }	
             parallel {
                  stage("sonar testing") {	
                       steps {
                                sh '''             
                                echo sonar testing
                                '''
                        }
                  }
                  stage("static security testing") {	
                       steps {
                                sh '''             
                                echo static security testing
                                '''
                        }
                  }
                  stage("unit testing") {	
                       steps {
                                sh '''             
                                echo unit testing
                                '''
                        }
                  }
           
             }				
            
		}
        stage('docker build') {
            when {
                expression { params.REFRESH == false }
            }
            parallel {
                stage("app-code") {				
					steps {
                        sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} build-rails-app
                        '''
					}
				}
                stage("nginx") {					
					steps {
						 sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} build-nginx
                        '''
					}
				}
            }
           
        }
        stage('Tag') {
            when {
                expression { params.REFRESH == false }
            }
             parallel {
                stage("rails-app") {
					 
					steps {
						 sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} tag-rails-app
                        '''
					}
				}
                stage("nginx") {					
					steps {
						 sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} tag-nginx
                        '''
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
					steps {
						sh 'echo scanning complete '
					}
				}
                stage("nginx") {				
					steps {
						sh 'echo scanning complete '
					}
				}
            } 
            
        } 
        stage("docker login") {
            when {
                expression { params.REFRESH == false }                                    
            }					
            steps {
                sh '''             
                   make DOCKER_REPO_URL=${DOCKER_REPO_URL} DOCKER_REPO_PWD=${DOCKER_REPO_PWD} docker-login
                '''
            }
		}
        stage('Push') {
            when {
                expression { params.REFRESH == false }                           
            }
            parallel {
                stage("rails-app") {					
					steps {
						 sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} push-rails-app
                        '''
					}
				}
                stage("nginx") {
					steps {
						  sh '''                       
						  make DOCKER_REPO_URL=${DOCKER_REPO_URL} push-nginx
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
                            make DOCKER_REPO_URL=${DOCKER_REPO_URL} clean-up                            
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

