vault_creds_path = /v1/secret/data/credentials
vault_login_token = secret

build-backend:
	sudo docker build -t backend-application:latest backend-app/

build-creds-gen:
	sudo docker build -t create-creds:latest create-creds/

build-authaproxy:
	sudo docker build -t lua-haproxy:latest auth-haproxy/

generate-configs:
	./script.sh ${vault_login_token} ${vault_creds_path}

run-vault:
	sudo docker run -itd --name creds-vault --cap-add=IPC_LOCK -e "VAULT_DEV_ROOT_TOKEN_ID=${vault_login_token}" -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200' vault

run-backend:
	sudo docker run -itd --name backend-app backend-application:latest
	
run-creds-gen:
	sudo docker run --rm --link creds-vault:vault create-creds:latest curl --header "X-Vault-Token: ${vault_login_token}" --request POST --data @payload.json -s http://vault:8200${vault_creds_path}

run-authaproxy:
	sudo docker run -itd --link backend-app:application --link creds-vault:vault --name authaproxy lua-haproxy:latest

build-dependencies:
	make build-backend
	make build-creds-gen
	make generate-configs
	make build-authaproxy

create-stack:
	make build-dependencies
	make run-vault
	make run-backend
	make run-authaproxy
	make run-creds-gen
