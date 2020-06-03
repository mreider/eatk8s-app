docker login
docker build -t eatk8s .
docker tag eatk8s mreider/eatk8s:$1
docker tag eatk8s mreider/eatk8s:latest
docker push mreider/eatk8s:latest
