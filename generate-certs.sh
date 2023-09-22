# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# generate key for CA certificate
openssl genrsa -out ca.key 2048

# generate CA certificate
openssl req -new -x509 -days 1826 -key ca.key -subj /CN=ca.example.com \
    -addext 'keyUsage=critical,keyCertSign,cRLSign,digitalSignature' \
    -addext 'basicConstraints=critical,CA:TRUE' -out ca.crt 

#generate key for leaf certificate
openssl genrsa -out private.key 2048

#request leaf certificate
cat > extensions.cnf <<EOF
[v3_ca]
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
EOF

openssl req -new -key private.key -subj /CN=cicd-agent.example.com -out iamra-cert.csr

#sign leaf certificate with CA
openssl x509 -req -days 7 -in iamra-cert.csr -CA ca.crt -CAkey ca.key -set_serial 01 -extfile extensions.cnf -extensions v3_ca -out certificate.crt


