#Add shortcuts to common commands, run as your main user

printf "zc() {
  %s \"\$@\"
}
export -f zc\n" "sudo docker exec zen-node gosu user zen-cli " >> ~/.bashrc

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

printf "lt() {
  %s \"\$@\"
}
export -f lt\n" "sudo docker logs zen-secnodetracker" >> ~/.bashrc

printf "lz() {
  %s \"\$@\"
}
export -f lz\n" "sudo docker logs zen-node" >> ~/.bashrc

source ~/.bashrc
echo "source ~/.bashrc"
