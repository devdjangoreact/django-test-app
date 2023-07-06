def buildJar() {
    echo "building the application..."
    sh 'pwd'
} 

def buildImage() {
    echo "building the docker image..."

    withCredentials([
            file(credentialsId: 'env_test_aws', variable: 'env_test_aws'),
        ]) {
            writeFile file: '.env', text: readFile(env_test_aws)
        }

    sh 'docker compose -f docker-compose.prod-build.yml build web nginx-proxy'

    def IMAGE_django_web = env.IMAGE_django_web
    def IMAGE_nginx_proxy = env.IMAGE_nginx_proxy
    withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {

        sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
        sh "docker push ${IMAGE_nginx_proxy}"
        sh "docker push ${IMAGE_django_web}"
    }
} 

def deployApp() {
    echo 'deploying the application...'

    def IMAGE_django_web = env.IMAGE_django_web
    def IMAGE_nginx_proxy = env.IMAGE_nginx_proxy

    // cosmetic
    withCredentials([
            file(credentialsId: 'env_test_aws', variable: 'env_test_aws'),
        ]) {
            writeFile file: '.env', text: readFile(env_test_aws)
        }


    def shellCmd = "chmod +r -R app && cd app && export IMAGE_django_web=${IMAGE_django_web} \
    && export IMAGE_nginx_proxy=${IMAGE_nginx_proxy} \
    && docker compose -f docker-compose.prod-deploy.yml build \
    && docker compose -f docker-compose.prod-deploy.yml up -d"
    def ec2instans = 'ubuntu@35.173.231.122'
    sshagent(['ec2-jekins']) {
        sh "scp -o StrictHostKeyChecking=no .env ${ec2instans}:/home/ubuntu/app/.env"
        sh "scp -o StrictHostKeyChecking=no docker-compose.prod-deploy.yml ${ec2instans}:/home/ubuntu/app/docker-compose.prod-deploy.yml"
        sh "cd jenkins && scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2instans}:/home/ubuntu/app/server-cmds.sh"
        sh "ssh -o StrictHostKeyChecking=no ${ec2instans} ${shellCmd}"
    }
} 

return this