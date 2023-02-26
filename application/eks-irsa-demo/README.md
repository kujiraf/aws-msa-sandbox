```
#起動確認
java -jar target/eks-irsa-demo-0.0.1-SNAPSHOT.jar
curl localhost:8080/backend/api/v1/debug
```

```
# docker hub push
./mvnw clean package -Dmaven.test.skip=true
docker build -t kujira1234/eks-irsa-demo:latest -f Dockerfile .
# docker run xxx -d -p 8080:8080
docker push kujira1234/eks-irsa-demo:latest
```
