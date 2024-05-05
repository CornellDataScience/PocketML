import asyncio
import time
import logging
import multiprocessing
import requests

from enum import Enum

class Status(Enum):
    RUNNING = 0
    STOPPED = 1
    PAUSED = 2

def authenticate(token):
    session = requests.Session()
    session.headers.update({'Authorization': f'Bearer {token}'})
    response = requests.get(f'{api_url}/api/v1/users/get_me')

class Daemon:
    def __init__(self, train):
        # basic logging configurations
        format = "%(asctime)s: %(message)s"
        logging.basicConfig(format=format, level=logging.INFO, datefmt="%H:%M:%S")
        
        self.train_process = None  # process for training loop
        self.train_function = train  # target training function
        self.train_config = {
            'batch_size': 32,
            'epochs': 1,
            'lr': 1.0,
            'log_interval': 10
        }
        self.train_status = Status.RUNNING

        event_loop = asyncio.get_event_loop()

        try:
            if self.train_status == Status.RUNNING:
                self.start_training()
            # asyncio.ensure_future(self.stop_training())
            event_loop.run_forever()
        finally:
            print("Closing Loop")
            event_loop.close()

    def start_training(self):
        # puts the training function into a process
        logging.info("Creating training process")
        self.train_process = multiprocessing.Process(
            target=self.train_function, 
            args=(self.train_config,),
            daemon=True
        )

        # payload = {
        #     "name": "thailand", 
        #     "wandb": False,
        #     "wandb_link": "",
        #     "start_time": 1,
        #     "config": self.train_config,
        #     "cluster_name": "local",
        #     "total_epoch": 14,
        # }

        # res = requests.post('http://10.48.85.83:8000/api/v1/jobs/new_job', json=payload)
        # print(res.text)

        # start training process
        logging.info("Starting training")
        self.train_process.start()

    async def stop_training(self):
        while True:
            await asyncio.sleep(5)
            if self.train_process:
                self.train_process.terminate()

    async def get_change(self):
        while True:
            # res = await requests.get('http://10.48.85.83:8000/api/v1/jobs/<job_id>/get_change')
            self.train_process.terminate()