#!/bin/bash
ipfs pubsub sub imgur | while read line ; do

  echo "${line}"
  cid=$(echo "${line}" | awk -F' ' '{print $1}')
  filename=$(echo "${line}" | awk -F' ' '{print $2}')
  dirname=$(echo "${filename:0:2}")
  ipfs files mkdir -p "/imgur/${dirname}"
  ipfs files cp "/ipfs/${cid}/${filename}" "/imgur/${dirname}/"

done
