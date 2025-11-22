FROM cgr.dev/chainguard/wolfi-base:latest

RUN echo "https://wolfi.duyne.me" > /etc/apk/repositories && \
    echo "https://packages.wolfi.dev/os" >> /etc/apk/repositories && \
    cat <<EOF > /etc/apk/keys/melange.rsa.pub
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5AqGblXA57jN4PbrDgVl
OpTCOlRdT+LVzVBlYiYCRYk6pFCQ2yNXx1f9nmT02mv9G82tMSC3pjc/pij/mdCB
eBCukBMSzgT7LAFejrATnKhGgwzSk38xdRhpKUuQcxrzxSu9pWjasn3Hkkz0AsCz
FM9K9vrNWgX7C0juUqH0IkdpvtMj2AoERbu08h3qSHN5XN0GurhCQM9yyNULwGbS
2CPeIPGpsTwsR5iqR0LrEr8771X3AIdxJVCZro2qwhV7X3+RubZpMtmAdVhoQj5T
IHW1+sq4sgVmn5bJ6MfNDc/zvilFaXyNaTK7vLD7UUU1F3JkHQlGVSPKX9LcBoQ0
aJDJn47L156zc1NmMnb8yFhQ/JE3KwuSbwP5gsKTMTsedmTHmjEj87UIrxcpqhW7
EgknlWanim8lq6JHEn9JY9Y7sjy/KOEEz1l9TUN/tAoTjsesfTS/PXF7mDa9jqVv
sZC1cKLIi+N1orXRiyj4K11qkqHNCnGfSMhvU/OzMry3vc9FMdpw1nEAzONtzQkS
Fxbl8FPwyUal61TdTlTasrmHw+HUIbw3Nmxhz5GmSmp3yssdEJ5BnQV5k9OxIXYP
D1o8paH76f3ieCLfEus0vZwAMsiy2Y6J58cgSbat+MIzlp6coTCX1uGYt5SoSZMa
aPWJdfQ1lfLFRtlQEeZHtPkCAwEAAQ==
-----END PUBLIC KEY-----
EOF