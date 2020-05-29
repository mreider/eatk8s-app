docker login
docker build -t eatk8s .
docker tag eatk8s mreider/eatk8s:$1
docker push mreider/eatk8s:$1