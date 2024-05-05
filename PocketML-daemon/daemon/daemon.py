# import requests
import asyncio
import time
import logging
import threading

def thread_function(name):
    logging.info("Thread %s: starting", name)
    time.sleep(5)
    logging.info("Thread %s: finishing", name)

def start(main):
    # requests.post() # post to api server that project is live and running
    # # on 
    # # expected params: PocketML username,

    format = "%(asctime)s: %(message)s"
    logging.basicConfig(format=format, level=logging.INFO, datefmt="%H:%M:%S")

    logging.info("Main    : before creating thread")
    x = threading.Thread(target=main, args=(1,), daemon=True)
    logging.info("Main    : before running thread")
    x.start()
    logging.info("Main    : wait for the thread to finish")
    # x.join()
    while True:
        time.sleep(1)
        print("hello")
    logging.info("Main    : all done")

start()