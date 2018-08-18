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
        HOSTED_ZONE_NAME         = credentials('HOSTED_ZONE_NAME')
        TERRAFORM_USER_ARN       = credentials('TERRAFORM_USER_ARN')
        AWS_ACCESS_KEY_ID        = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY    = credentials('AWS_SECRET_KEY')  
        ENV_NAME                 = "dev" 
        SQUAD_NAME               = "devops"
    }
    parameters {
        booleanParam(name: 'REFRESH',defaultValue: true,description: 'Refresh Jenkinsfile and exit.')
        choice(choices: 'eks\nfargate', description: 'Select the platform to deploy', name: 'PLATFORM')  
        choice(choices: 'deploy\nteardown', description: 'Select option to create or teardown infro', name: 'TERRAFORM_ACTION')
    }
    stages {
        stage ('prerequisite') {
            when {
                expression { params.REFRESH == false }                
            }
            steps {
                dir('infra/prerequisite') {
                  sh '''
                      cp ../provision.sh .
                     chmod +x ./provision.sh                     
                    ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                    ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r validate
                    ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                    ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                    '''

                }}
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
        stage('infra provision & code deploment') {
            when {
                expression { params.REFRESH == false }                                    
            }
            parallel {
                stage("eks") {	
                    when {
                        expression { params.PLATFORM == "eks" }                                    
                     }				
					steps {
                        dir('infra/core/eks') {

						 sh '''
                            cp ../../provision.sh .
                            chmod +x provision.sh
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r validate
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                            #./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply                            
                            #./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r kubeconfig
                            # kubectl kubectl create -f kube/.

                         '''

                        }
					}
				}
                stage("fargate") {		
                     when {
                        expression { params.PLATFORM == "fargate" }                                    
                     }		
					steps {
                         dir('infra/core/fargate') {
						sh '''
                            cp ../../provision.sh .
                            chmod +x provision.sh
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r init
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r validate
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r plan
                            ./provision.sh -s ${SQUAD_NAME} -e ${ENV_NAME} -r apply
                             
                        '''
                         }
					}
				}
            }            
        }       
    }
    post { 
        always {
            script{
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
        success { 
              script {
                      sh '''

                       echo " build successfull "
                      '''
                }
        }
        failure {
            script {  
                    
                      sh '''

                       echo " build failed "
                      '''
             }
        }
    }
}

