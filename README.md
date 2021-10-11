
# An Easy Guide: Learn, Test and Deploy API Gateway with NGINX

Many times good technologies are beyond your reach, you heard about it but you can't play with it due to lack of resources. It doesn't have to be this way.

NGINX/NGINX Plus is a lightweight, high performance, advanced API Gateway. Yet you can easily spin up even in your local machine for learning and testing. The objective of this repo is to use the least installed components/resources to learn and test NGINX API Gateway. Eventually you will learn to deploy it into production.

Components:
- NGINX Plus [You may request for a NGINX Plus [Trial License](https://www.nginx.com/free-trial-request/) and build the [NGINX Plus Docker Image](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/)]
- 2 httpbin as backend servers [For load balancing demo purpose]

Note: You may use NGINX OSS instead of NGINX Plus container. However, some of the features used are only available in NGINX Plus. I have put comments next to directives inside the conf files.

## Prerequisite: 
- Install docker and docker-compose in your machine
- Build NGINX Plus docker image and have it in your machine (You do not need to push to external repo)

## Getting Started
To start this demo:
```
#Clone the repo
git clone https://github.com/mcheo-nginx/apigateway

#To step up the stack
docker-compose -f docker-compose.yml up -d 

#To delete the demo stack after testing
docker-compose -f docker-compose.yml down

#Every time you modify nginx.conf config file, you need to reload NGINX process
docker exec apigateway_nginx_1 nginx -s reload

#To monitor the logs
docker exec apigateway_nginx_1 tail -f -n 10 /var/log/nginx/nginx_access.log
```

## API Gateway Essential Functions Demo:
These are the essential functions of an API Gateway, we will demonstrate each of these
- TLS Termination
- Request routing
- Rate limiting
- Load balancing
- Client Authentication
    - Basic API Key
    - JWT Validation
    - Dynamic API Key (Leverage NGINX Plus Key-Value Store)
- Fine-grained access control


This repo contains sample self-signed cert. In case you want to generate your own self-signed cert.
```
openssl req -newkey rsa:2048 -nodes -keyout apigwdemo.com.key -x509 -days 3650 -out apigwdemo.com.crt
```

Sample commands to generate random hex string to be used as API Key
```
openssl rand -hex 10
```

Sample commands to update NGINX Plus Key-Value store, I have defined apikeyzone in the conf file
```
#To list table
curl  http://localhost:8080/api/7/http/keyvals/apikeyzone

#To add record into the table
curl -X POST -d '{"user1":"1"}'  http://localhost:8080/api/7/http/keyvals/apikeyzone 

#To remove record from the table
curl -X PATCH -d '{"user1":null}' -s 'http://localhost:8080/api/7/http/keyvals/apikeyzone'
```

You may also use tool such as [Postman](https://www.postman.com/) for API testing. However, we are using curl commands below as we aspire to minimize prerequisites for this learning.
Sample testing commands:
```
curl -v http://localhost/get #This will fail and redirect you to HTTPS

curl -k https://localhost/get

curl -k https://localhost/delay/1

curl -k https://localhost/delay/11 #This will fail the regex match

#The API Gateway is expecting API Key in HTTP Header "x-api-key" for basic authentication
curl -k -H "x-api-key:2j1PM5rwgt" -X POST https://localhost/post

#Visit [jwt.io](https://jwt.io/) to generate JWT token. The secret key used in this demo is "apigwdemosecret".
#You must supply a valid token
TOKEN=xxxxx
curl -k -H "Authorization: Bearer $TOKEN" https://localhost/headers

#You must update the key-value store bofore hand
curl -k -H "x-kv-apikey:<valid_key>" https://localhost/anything
```


## References:
- [NGINX Official Docs](https://docs.nginx.com/)
- [NGINX Modules Documentation](http://nginx.org/en/docs/)
