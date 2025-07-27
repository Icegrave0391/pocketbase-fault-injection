#!/bin/bash

# 获取所有collections名称
curl -s http://localhost:8090/api/collections \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2xsZWN0aW9uSWQiOiJwYmNfMzE0MjYzNTgyMyIsImV4cCI6MTc1MzY4MjIzMywiaWQiOiJ4b2FnOWkxYWlvOGlvNHgiLCJyZWZyZXNoYWJsZSI6dHJ1ZSwidHlwZSI6ImF1dGgifQ.xKIV2SjxKYoCfe4jiwWuGIC5EN97K0L5zNzybB-svJs" \
  | jq -r '.items[].name'