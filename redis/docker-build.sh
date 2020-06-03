docker login
docker build -t eatk8s-redis .
docker tag eatk8s-redis mreider/eatk8s-redis:$1
docker tag eatk8s-redis mreider/eatk8s-redis:latest
docker push mreider/eatk8s-redis:latest
