#!/bin/bash

# 请求一次并输出HTTP状态码和结果说明
code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8090/api/files/collection_files/000000000000000/file_20_mb_ok77l01l2a.txt")
echo "HTTP code: $code"
if [[ "$code" =~ ^2 ]]; then
  echo "Success!"
else
  echo "Failed!"
fi