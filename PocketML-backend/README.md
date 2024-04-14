# PocketML-backend

This repository contains the backend code for PocketML.

## Preparation

To run the server, you need to have Python 3.9 or later installed on your machine. You can download Python from
the [official website](https://www.python.org/downloads/).

To install the required packages, run the following command:

```bash
pip3 install -r requirements.txt
```

You would also need a separate `.env` file in this directory that contains the following variables:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

For CDS PocketML Team internal usage, please refer to the `.env` file in the `Technical` documents in our Google Drive.

## Usage

To start the server in a development manner, run the following command:

```bash
uvicorn app.main:app --reload
```
