#!/bin/bash
#Have 'ipfs daemon --enable-pubsub-experiment' running.

#export IPFS_PATH=~/.ipfs-imgur #Uncomment this line if you ran 'export IPFS_PATH=~/.ipfs-imgur' 'ipfs init' to init a different ipfs path just for imgur.
randchar(){
  head /dev/urandom | tr -dc A-Za-z0-9 | head -c1
}

while : ; do
  rand=$(echo "$(randchar)$(randchar)$(randchar)$(randchar)$(randchar)$(randchar)$(randchar)")
  if curl -I "https://i.imgur.com/${rand}.jpg" 2>&1 | grep "HTTP" | head -n 1 | grep -q "200" ; then
    ext=$(curl -I "https://i.imgur.com/${rand}.jpg" 2>&1 | grep content-type | head -n 1 | sed -e 's/.*\///g' | tr -dc '[:alnum:]')
    cid=$(wget -q -O - "https://i.imgur.com/${rand}.${ext}" | ipfs add -w -Q --stdin-name "${rand}.${ext}" - )
    ipfs files mkdir -p "/imgur/${rand:0:2}"
    ipfs files cp "/ipfs/${cid}/${filename}" "/imgur/${rand:0:2}/"
    echo "${cid} ${rand}.${ext}"
    echo "${cid} ${rand}.${ext}" | ipfs pubsub pub imgur -
  fi
done
