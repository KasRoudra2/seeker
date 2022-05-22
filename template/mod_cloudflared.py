#!/usr/bin/env python3

from os import system, popen
from time import sleep

R = '\033[31m' # red
G = '\033[32m' # green
C = '\033[36m' # cyan
W = '\033[0m'  # white


port = 8080

local_url = f'http://127.0.0.1:{port}'

system("rm -rf $HOME/.cffolder/log.txt")
system(f"cd $HOME/.cffolder && ./cloudflared tunnel -url {local_url} --logfile log.txt > /dev/null 2>&1 &")
sleep(9)
cloudflared_url = popen("cat $HOME/.cffolder/log.txt | grep -o 'https://[-0-9a-z]*\.trycloudflare.com'").read().strip()
if cloudflared_url is not None:
    print(f'\n{G}[+] {C}Your Cloudflared url is: {G}{cloudflared_url}{W}\n', flush=True)
else:
    print(f'{R}[-] {C}Cloudflared failed to start! Try again later{W}')