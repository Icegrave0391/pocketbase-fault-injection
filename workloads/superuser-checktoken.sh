#!/bin/bash

curl -X POST http://localhost:8090/api/collections/_superusers/auth-with-password \
  -H "Content-Type: application/json" \
  -d '{"identity":"test@gmail.com","password":"1234567890"}'