
#!/bin/bash

# 请求一次并输出HTTP状态码和结果说明
code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8090/api/files/collection_files/444444444444444/file_128_b_j2n6qbmjn8.txt")
echo "HTTP code: $code"
if [[ "$code" =~ ^2 ]]; then
  echo "Success!"
else
  echo "Failed!"
fi