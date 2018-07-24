# Reset .bashrc to default, in case this script gets run more than once in future

/bin/cp /etc/skel/.bashrc ~/
exec bash

# Add our new shortcut commands

printf "zen-cli() {
  %s \"\$@\"
}
export -f zen-cli\n" "sudo docker exec zen-node gosu user zen-cli " >> ~/.bashrc

printf "sc() {
  %s \"\$@\"
}
export -f sc\n" "sudo systemctl " >> ~/.bashrc

printf "logs() {
   %s \"\$@\"
}
export -f logs\n" "sudo docker logs " >> ~/.bashrc

exec bash

echo "Shortcuts Added"
