# $1 = website domain name
# $2 = command to open text editor, e.g. `vim` or `code`
# $3 = theme name
rootswp_build(){
  echo "Building a fresh WordPress repo..."
  cd ~/workspace-wordpress
  mkdir $1 && cd $1
  git clone --depth=1 git@github.com:roots/trellis.git && rm -rf trellis/.git
  git clone --depth=1 git@github.com:roots/bedrock.git site && rm -rf site/.git
  git init
  git add .
  git commit -m "Initial commit"
  $3 trellis/group_vars/development
  echo "Done. Next step: configure wordpress_sites.yml and vault.yml"
  echo "Enter 'done' once you're finished configuring"
  
  while :
  do
    read input_1
    if [ $input_1 = "done" ]; then
      echo "Beginning provisioning with vagrant..."
      cd trellis && vagrant up
      echo "Provisioning complete. Create a new theme for this WordPress build? (yes/no)"
      while :
      do
        read input_2
        if [ $input_2 = "yes" ]; then
          rootswp_theme $1 $2
        elif [ $input_2 = "no" ]; then
          break
        fi
      done
      break
    fi
  done
}

# $1 = website domain name
# $2 = theme name
rootswp_theme(){
  cd ~/workspace-wordpress/$1/site/web/app/themes
  composer create-project roots/sage $2
  cd $2 && yarn && yarn build
}
