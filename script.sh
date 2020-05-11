#!/bin/bash


update_haproxy_conf()
{
  vault_address=${1}
  vault_creds_path=${2}
  application=${3}
  conf_file_template=${4}
  conf_file=${5}

  sed  "s|VAULT_ADDRESS|${vault_address}|" ${conf_file_template} | \
  sed  "s|VAULT_CREDS_PATH|${vault_creds_path}|"  | \
  sed  "s|FLASK_APP|${application}|"  > ${conf_file}
}

update_vault_lua()
{
  version=${1}   # v1/v2
  token=${2}
  conf_file_template=${3}
  lua_script_file=${4}

  if [ ${version} == 'v2' ]
  then
      sed  "s|VAULT_CRED_JSON|data['data']['data'][creds['user']]|" ${conf_file_template} | \
      sed  "s|VAULT_TOKEN|\'${token}\'|" > ${lua_script_file}
  else
      sed  "s|VAULT_CRED_JSON|data['data'][creds['user']]|" ${conf_file_template} | \
      sed  "s|VAULT_TOKEN|\'${token}\'|" > ${lua_script_file}
  fi

}

#update_haproxy_conf 'vault:8200' '/v1/secret/data/credentials' 'application:5000' 'templates/haproxy.cfg.template' 'auth-haproxy/haproxy.cfg'
update_haproxy_conf 'vault:8200' ${2} 'application:5000' 'templates/haproxy.cfg.template' 'auth-haproxy/haproxy.cfg'

#update_vault_lua 'v2' 'myroot' 'templates/auth-request.lua.template' 'auth-haproxy/auth-request.lua'
update_vault_lua 'v2' ${1} 'templates/auth-request.lua.template' 'auth-haproxy/auth-request.lua'
