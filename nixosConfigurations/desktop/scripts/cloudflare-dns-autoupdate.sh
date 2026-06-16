
ADDR=$(curl ipinfo.io/ip)
RECORD_ID="48a852ad9199e63372e81814b3a7e08c" # for root A-record of jafner.net zone
curl \
  -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/6b206a70012d3d5487c39bdcd8c06a59/dns_records/48a852ad9199e63372e81814b3a7e08c" \
  -H "Authorization: Bearer " \
  -H "Content-Type: application/json" \
  --data '{"content": ""}'
