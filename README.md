# authaproxy

Added capability to use Vault for BasicAuth in HaProxy. No more need to put passwords in the haproxy configuration. Keep your credentials in Vault and HaProxy will work with vault to validate a user.

## Getting Started

authaproxy uses lua to communicate with Vault at runtime. Follow the README to run it on your development machine or on your laptop. 


### Prerequisites

To run the authaproxy, you require the following:

```
1. Docker
2. make ulitily 

```

### Installing

Once you got the requisites on your machine, execute the following command:


```
$ make create-stack
```

This will automcatically run the containers of haproxy, vault and a simple hello-world application on the machine. 


![Stats Success](/images/docker-ps.png)


Execute the following command to get IP of authaproxy:

```
$ sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' authaproxy

```

authaproxy exposes the following endpoints:

```
http://<IP>/stats   # Haproxy stats page

http://<IP>/hello   # proxy to simple hello-world application and returns Hello World!

```

## Running the following tests


```
$ curl -u 'dev:changeit' http://<IP>/stats   ## returns 200

```

I ran the following tests:

![Stats Success](/images/success-stats.png)


![Stats Success](/images/wrong-stats.png)


![Stats Success](/images/401-stats.png)


![Stats Success](/images/hello-success.png)

When you don't pass credentials, it will give 401. Incase of wrong credentials, it will give 403. Give it a try from your browser as well.


You can update/create credentials in the 'create-creds/payload.json' file and execute the following command at runtime:

```
$ make run-creds-gen

```

##### Note: 

You can modify the vault-token or credentials path in the Makefile as per your requirement. To update the changes destroy containers and recreate them with make.


## Built With

* [Haproxy](http://www.haproxy.org/) - TCP/HTTP Load Balancer
* [Vault](https://www.vaultproject.io/) - Manages Secret data
* [Lua](https://www.lua.org/) - Injected in Haproxy to fetch and validate credentials from Vault
* [Flask](https://www.fullstackpython.com/flask.html) - hello-world application


