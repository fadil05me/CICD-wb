def secret = 'k2-appserver'
def server = 'k2@103.127.134.73'
def directory = '/home/k2/wayshub-backend'
def branch = 'master'
def namebuild = 'wayshub-backend:1.0'

pipeline{
    agent any
    stages{
        stage ('pull new code'){
            steps{
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    git pull origin ${branch}
                    echo "Selesai Pulling!"
                    exit
                    EOF"""
                }
            }
        }

        stage ('build the code'){
            steps{
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker build -t ${namebuild} .
                    echo "Selesai Building!"
                    exit
                    EOF"""
                }
            }
        }

        stage ('test the code'){
            steps{
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${directory}
                        docker run -d --name testcode -p 5009:5000 ${namebuild}
                        if wget --spider -q --server-response http://127.0.0.1:5009/ 2>&1 | grep '404 Not Found'; then
                            echo "Webserver is up and returning 404 as expected!"
                        else
                            echo "Webserver is not responding with expected 404, stopping the process."
                            docker rm -f testcode
                            exit 1
                        fi
                        docker rm -f testcode
                        echo "Selesai Testing!"
                        exit
                    EOF"""
                }
            }
        }

        stage ('deploy'){
            steps {
                sshagent([secret]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker compose down
                    docker compose up -d
                    echo "Selesai Men-Deploy!"
                    exit
                    EOF"""
                }
            }
        }
    }
}
