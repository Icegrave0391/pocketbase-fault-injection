
#!/bin/bash

# 请求一次并输出HTTP状态码和结果说明
code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8090/api/files/collection_files/777777777777777/file_10_kb_kxmoykcs4p.txt")
echo "HTTP code: $code"
if [[ "$code" =~ ^2 ]]; then
  echo "Success!"
else
  echo "Failed!"
fi