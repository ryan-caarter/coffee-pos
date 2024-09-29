#!/usr/bin/env python

import asyncio
from websockets.sync.client import connect

def hello():
    with connect("wss://2xfeq3ok1b.execute-api.ap-southeast-2.amazonaws.com/production/") as websocket:
        websocket.send("Hello world!")
        message = websocket.recv()
        print(f"Received: {message}")

hello()
