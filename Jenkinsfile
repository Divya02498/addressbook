pipeline {
    agent none
    tools {
        maven 'my maven'
    }

    parameters{
    string(name: 'Env', defaultValue: 'Test', description: 'version to deploy')
    booleanParam(name: 'executeTests', defaultValue: true, description: 'decide to run tc')
    choice (name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }
    environment{
        BUILD_SERVER='ec2-user@18.212.163.110'
    }

   
    stages {
        stage('Compile') {
            agent {label 'slave-linux'}
            steps {
                echo "Compiling Hello World in ${params.env}"
                sh 'mvn compile'
            }
        }
        stage('Test') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                echo 'Testing Hello World'
                sh 'mvn test'
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Package') {
            agent any 
            steps {
                sshagent(['slave2']) {
             // some block
                echo "Packing Hello World app version ${params.APPVERSION}"
                sh "scp -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash server-config.sh'"
            }
            }
        }
    }
}
 