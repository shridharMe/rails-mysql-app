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
        stage("ssl generation") {
            when {
                expression { params.REFRESH == false }
                expression { params.SSL == true }                                    
            }					
            steps {
                sh '''           
                  
                   make generate-ssl-certificates
                 '''
            }
		}
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
                  stage("dependency check nexus lifecycle") {	
                       steps {
                                sh '''             
                                echo dependency check nexus lifecycle
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
                stage("rails-app") {				
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
        stage('docker tagging') {
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
        stage('docker scanning') {
            when {
                expression { params.REFRESH == false }                           
            }
            parallel {
                stage("rails-app") {					
					steps {
						sh 'make docker-scanning'
					}
				}
                stage("nginx") {				
					steps {
						sh 'make docker-scanning'
					}
				}
            } 
            
        } 
        stage("run app") {
            when {
                expression { params.REFRESH == false }                                    
            }					
            steps {
                sh '''             
                   make run-docker-compose
                '''
            }
		}
        stage("owasp testing") {
            when {
                expression { params.REFRESH == false }                                    
            }					
            steps {
                sh '''             
                  make owsap-testing
                '''
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
        stage('docker push') {
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
        stage('deploy') {
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
                            
                            if [ -z "$(docker ps -qa)" ]; then
                              echo "nothin to clean"
                            else
                                docker stop $(docker ps -qa)
                                docker rm  $(docker ps -qa)
                                docker rmi ${DOCKER_REPO_URL}/nginx
                                docker rmi ${DOCKER_REPO_URL}/rails-app
                                docker  network rm local_network

                            fi                           
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

