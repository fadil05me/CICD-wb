def secret = "k2-appserver"
def server = "k2@103.127.134.73"
def directory = "/home/k2/wayshub-backend"
def branch = "master"
def namebuild = "wayshub-backend:1.0"

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
                    cd "${directory}"
                    docker run -d testcode -p 5009:5000 "${namebuild}"
                    SERVER_URL="http://127.0.0.1:5009"
                    OUTPUT=$(wget --quiet --spider --server-response "$SERVER_URL" 2>&1)
                    docker rm -f testcode

                    if grep -i "404 Not Found" <<< "$OUTPUT" >/dev/null 2>&1; then
                    echo "Website is up."
                    else
                    echo "Website is down."
                    exit 1
                    fi

                    echo "Selesai Building!"  # Moved outside the if block
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
