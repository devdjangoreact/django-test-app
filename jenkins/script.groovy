def buildJar() {
    echo "building the application..."
    sh 'pwd'
} 

def buildImage() {
    echo "building the docker image..."

    // withCredentials([
    //         file(credentialsId: 'env_file_cosmetic_django', variable: 'ENV_cosmetic_django'),
    //         file(credentialsId: 'env_file_cosmetic_postgres', variable: 'ENV_cosmetic_postgres')
    //     ]) {
    //         writeFile file: '.envs/.production/.django', text: readFile(ENV_cosmetic_django)
    //         writeFile file: '.envs/.production/.postgres', text: readFile(ENV_cosmetic_postgres)
    //     }
    // sh 'docker compose -f production.yml build cosmetic-api cosmetic-front cosmetic-dashboard'
    // withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {

    //     sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
    //     sh 'docker tag cosmetic-front:1.0 djangoreactdev/cosmetic-front:1.0'
    //     sh 'docker push djangoreactdev/cosmetic-front:1.0'
    //     sh 'docker tag cosmetic-api:1.0.2 djangoreactdev/cosmetic-api:1.0.2'
    //     sh 'docker push djangoreactdev/cosmetic-api:1.0.2'
    //     sh 'docker tag cosmetic-dashboard:1.0 djangoreactdev/cosmetic-dashboard:1.0'
    //     sh 'docker push djangoreactdev/cosmetic-dashboard:1.0'
    // }
} 

def deployApp() {
    echo 'deploying the application...'
    // sh 'docker stack rm cosmetic || true'
    // sh 'docker system prune -f'


    // // cosmetic
    // withCredentials([
    //         file(credentialsId: 'env_file_cosmetic_django', variable: 'ENV_cosmetic_django'),
    //         file(credentialsId: 'env_file_cosmetic_postgres', variable: 'ENV_cosmetic_postgres')
    //     ]) {
    //         writeFile file: 'cosmetic/.envs/.production/.django', text: readFile(ENV_cosmetic_django)
    //         writeFile file: 'cosmetic/.envs/.production/.postgres', text: readFile(ENV_cosmetic_postgres)
    //     }


    // withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {

    //     sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
    //     sh 'docker compose -f production.yml build'
    //     sh 'docker compose -f production.yml pull --ignore-pull-failures'
    
    // }

    // sh '''
    //     #!/bin/bash

    //     NETWORK_NAME="cosmetic_default"
    //     if ! docker network ls | grep -q "$NETWORK_NAME"; then
    //         # If the network doesn't exist, create it
    //         docker network create --driver overlay --scope swarm cosmetic_default
    //     fi
    //         echo "Network $NETWORK_NAME exists"
    //     '''

    // sh 'docker stack deploy -c production.yml cosmetic'
    sshagent(['ec2-jekins']) {
        sh '''
        #!/bin/bash

        ssh -o StrictHostKeyCheking=no ubuntu@ec2-35-173-231-122.compute-1.amazonaws.com

        docker run -p 80:80 -d nginx/nginx:latest
        
        '''

    }
} 

return this