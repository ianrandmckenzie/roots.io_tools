# $1 = website domain name
# $2 = command to open text editor, e.g. `vim` or `code`
rootswp_build(){
  echo "Building a fresh WordPress repo..."
  mkdir $1 && cd $1
  git clone --depth=1 git@github.com:roots/trellis.git && rm -rf trellis/.git
  git clone --depth=1 git@github.com:roots/bedrock.git site && rm -rf site/.git
  git init
  git add .
  git commit -m "Initial commit"
  $2 trellis/group_vars/development
  echo "Done. Next step: configure wordpress_sites.yml and vault.yml"
  echo "Enter 'done' once you're finished configuring"
  
  while :
  do
    read input_1
    if [ $input_1 = "done" ]; then
      echo "Beginning provisioning with vagrant..."
      cd trellis && vagrant up
      echo "Provisioning complete."
    fi
  done
}
