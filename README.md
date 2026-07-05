# joeac.net

Joe Carstairs' public Internet presence

To install:

```sh
wget -O- https://git.joeac.net/joeac/joeac.net/raw/branch/main/install.sh | sh
```

## DNS setup

A/AAAA DNS records are added automatically by `make install`, but in order to
get `mox` working as an email server, you'll have to manually add the following
DNS records.

Deliver mail for mail.joeac.net to mail.joeac.net:

```
mail.joeac.net. MX 10 mail.joeac.net.
```

All emails from the email server will be signed with two DKIM keys. So that
clients can verify the authenticity of the messages, provide these keys as TXT
records:

```
2026a._domainkey.mail.joeac.net. TXT v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvYfjrzmYgBtYofzBwI80aiW98+M2g6z+gd1Iwz9g0y30rPFNTctFn9GwBNuYBgZiZxB+sqjEbPMbr3li/R7i0A9t/KbNNJhkNC+4IjKJjk+jw1CXm4vXOUa4YSYWwy7NVYTH/QwZGz6fwjVM7YvDnnE4gG2NwrVx+AXlONt2R1G+qgV6HAIIvVi8T0yCjjqEc5B5bKlqk0XU9vSyUFJhhKnR/KNRe79C+H9GWJzcU7HUCmIHX04Xi0JeB/wm3weF1xjtGTsWyy5BmHHsfWGqSr2Dbg5o6AI5W0h4VkQ4QzdEYGVQ9ZBDyqFQwQFXLn0oHZjCD/vFzPOPdM5pxF/OgwIDAQAB
2026b._domainkey.mail.joeac.net. TXT v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzcrk9FUt6AdrvnAP3KawuOTLw7uL5SJ+ZYmShuz41zwM6bPQteGSSwddFXIxcqVlJrdFahrK4KvHX/sw/hWVfZoPLDdwsGN5eI8cqQjNDE+JDu9BbPlTituva4Hkve0hbAKDqA8jmbcZg6aU7b44Kzq8UpWAlPO273Rq2tsbCBcITt8B3NFoeY9CSsZU1LqGl855GUtaNyhlPaAvfab3Q9/4wyusPhCHlBYaRK+ZzuSMs5KEOG6n4kbZfMVi2+4c/bPU5PdTuyvbSIEqjNH4TpfatE0I9ubGv0WbAzr5EZbv5+xtukZ/dIisPPMjn1AbjpSJYNYr2OYgey6+WvzRmQIDAQAB
```

Specify the MX host is allowed to send for our domain and for itself (for DSNs).
~all means softfail for anything else, which is done instead of -all to prevent
older mail servers from rejecting the message because they never get to looking
for a dkim/dmarc pass.

```
mail.joeac.net. TXT v=spf1 ip4:217.155.190.42 ip6:fdc9:6aec:7a18:0:2e0:4cff:fe61:9b17 mx ~all
```

Emails that fail the DMARC check (without aligned DKIM and without aligned SPF)
should be rejected, and request reports. If you email through mailing lists that
strip DKIM-Signature headers and don't rewrite the From header, you may want to
set the policy to p=none.

```
_dmarc.mail.joeac.net. TXT v=DMARC1;p=reject;rua=mailto:dmarcreports@mail.joeac.net!10m
```

Remote servers can use MTA-STS to verify our TLS certificate with the WebPKI
pool of CA's (certificate authorities) when delivering over SMTP with
STARTTLSTLS.

```
mta-sts.mail.joeac.net.  CNAME mail.joeac.net.
_mta-sts.mail.joeac.net. TXT v=STSv1; id=20260705T153220
```

Request reporting about TLS failures.

```
_smtp._tls.mail.joeac.net. TXT v=TLSRPTv1; rua=mailto:tlsreports@mail.joeac.net
```

Client settings will reference a subdomain of the hosted domain, making it
easier to migrate to a different server in the future by not requiring settings
in all clients to be updated.

```
clientsettings.mail.joeac.net. CNAME mail.joeac.net.
```

Autoconfig is used by Thunderbird. Autodiscover is (in theory) used by
Microsoft.

```
autoconfig.mail.joeac.net.         CNAME mail.joeac.net.
_autodiscover._tcp.mail.joeac.net. SRV 0 1 443 mail.joeac.net.
```

For secure IMAP and submission autoconfig, point to mail host.

```
_imaps._tcp.mail.joeac.net.        SRV 0 1 993 mail.joeac.net.
_submissions._tcp.mail.joeac.net.  SRV 0 1 465 mail.joeac.net.
```

Next records specify POP3 and non-TLS ports are not to be used. These are
optional and safe to leave out (e.g. if you have to click a lot in a DNS admin
web interface).

```
_imap._tcp.mail.joeac.net.         SRV 0 0 0 .
_submission._tcp.mail.joeac.net.   SRV 0 0 0 .
_pop3._tcp.mail.joeac.net.         SRV 0 0 0 .
_pop3s._tcp.mail.joeac.net.        SRV 0 0 0 .
```

Optional: You could mark Let's Encrypt as the only Certificate Authority allowed
to sign TLS certificates for your domain.

```
mail.joeac.net. CAA 0 issue "letsencrypt.org"
```
