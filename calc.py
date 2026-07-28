#!/usr/bin/env python

alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

ch = b"\xCD\x80\xCD\x80"
li = list(bytes(ch))
print(li)

res = [[], [], [], []]
for i, a in enumerate(alphabet):
    a = ord(a)
    for j, b in enumerate(alphabet[i:]):
        b = ord(b)
        for k in range(4):
            if 0xff ^ a ^ b != li[k]:
                continue
            # res[k].append((chr(a), chr(b), hex(a), hex(b)))
            res[k].append((chr(a), chr(b)))

print(*res, sep="\n")
