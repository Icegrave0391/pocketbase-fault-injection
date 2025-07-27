#!/bin/bash

# 获取所有包含file字段的collection及其file字段名
curl -s http://localhost:8090/api/collections \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2xsZWN0aW9uSWQiOiJwYmNfMzE0MjYzNTgyMyIsImV4cCI6MTc1MzY4MjIzMywiaWQiOiJ4b2FnOWkxYWlvOGlvNHgiLCJyZWZyZXNoYWJsZSI6dHJ1ZSwidHlwZSI6ImF1dGgifQ.xKIV2SjxKYoCfe4jiwWuGIC5EN97K0L5zNzybB-svJs" \
  | jq -r '
    .items[]
    | select(.fields[]?.type=="file")
    | .name as $c
    | .fields[] | select(.type=="file") | "\($c)\t\(.name)"
  '