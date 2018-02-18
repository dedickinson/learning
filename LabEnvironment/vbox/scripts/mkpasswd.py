#!/usr/bin/env python3
import sys
from passlib.hash import sha512_crypt

pw = sys.argv[1]

print(sha512_crypt.hash(pw))
