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

    sh 'docker compose -f docker-compose.prod.yml build web nginx-proxy'

    def IMAGE_django_web = env.IMAGE_django_web
    def IMAGE_nginx_proxy = env.IMAGE_nginx_proxy
    withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {

        sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
        sh "docker tag nginx-proxy ${IMAGE_nginx_proxy}"
        sh "docker push ${IMAGE_nginx_proxy}"
        sh "docker tag nginx-proxy ${IMAGE_nginx_proxy}"
        sh "docker push ${IMAGE_nginx_proxy}"
    }
} 

def deployApp() {
    echo 'deploying the application...'

    def IMAGE_django_web = System.getenv('IMAGE_django_web')
    def IMAGE_nginx_proxy = System.getenv('IMAGE_nginx_proxy')

    // cosmetic
    withCredentials([
            file(credentialsId: 'env_test_aws', variable: 'env_test_aws'),
        ]) {
            writeFile file: '.env', text: readFile(env_test_aws)
        }

    def dockerimage='docker compose -f docker-compose.prod.yml up -d --build'
    def ec2instans = 'ubuntu@ec2-35-173-231-122.compute-1.amazonaws.com'
    sshagent(['ec2-jekins']) {
        sh "source .env"
        sh "scp docker-compose.prod.yml ${ec2instans}/home/ubuntu"
        sh "ssh -o StrictHostKeyChecking=no ${ec2instans} ${dockerimage}"
    }
} 

return this