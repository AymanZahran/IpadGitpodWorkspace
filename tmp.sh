if [[ $K8S_PROVIDER == "AWS" ]]
then
  cat << EOF > ~/.aws/config
  [gitpod]
  region = $AWS_DEFAULT_REGION
  cli_auto_prompt = on-partial
  EOF
  cat << EOF > ~/.aws/credentials
  [gitpod]
  aws_access_key_id = $AWS_ACCESS_KEY_ID
  aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
  EOF
elif [[ $K8S_PROVIDER == "AZURE" ]]
then
  echo "Pending.."
elif [[ $K8S_PROVIDER == "GCP" ]]
then
  echo "Pending.."
elif [[ $K8S_PROVIDER == "DIGITAL_OCEAN" ]]
then
  mkdir -p ~/.config/doctl
  echo "access-token: $DIGITAL_OCEAN_TOKEN" > ~/.config/doctl/config.yaml
elif [[ $K8S_PROVIDER == "LINODE" ]]
then
  cat << EOF > ~/.config/linode-cli
  [DEFAULT]
  default-user = AymanZahran

  [AymanZahran]
  token = $LINODE_TOKEN
  EOF
else
  echo "No Provider to Authenticate"
fi