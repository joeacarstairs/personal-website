# mox

There are three secrets required for mox. One is the admin password, which
should be stored in config/adminpasswd. The other two are DKIM private keys,
which should be stored in the config/dkim directory. The public parts of these
keys should be exposed in DNS TXT records.
