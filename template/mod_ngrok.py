#!/usr/bin/env python3

from os import system, popen
from time import sleep
from requests import get

R = '\033[31m' # red
G = '\033[32m' # green
C = '\033[36m' # cyan
W = '\033[0m'  # white

port = 8080

local_url = f'http://127.0.0.1:{port}'


system(f"cd $HOME/.ngrokfolder && ./ngrok http {local_url} > /dev/null 2>&1 &")
sleep(9)
ngrok_data = get('http://127.0.0.1:4040/api/tunnels').text.strip()
ngrok_url = popen(f"echo {ngrok_data} | grep -o 'https://[-0-9a-z]*\.ngrok.io'").read()
if ngrok_url is not None:
    print(f'\n{G}[+] {C}Your Ngrok url is: {G}{ngrok_url}{W}\n', flush=True)
else:
    print(f'{R}[-] {C}Ngrok failed to start! Try again later{W}')