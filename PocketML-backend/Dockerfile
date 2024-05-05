# Use python 3.9 runtime as base image
FROM python:3.9

ARG FIREBASE_PRIVATE_KEY_ID
ARG FIREBASE_PRIVATE_KEY

ENV FIREBASE_PRIVATE_KEY_ID=$FIREBASE_PRIVATE_KEY_ID
ENV FIREBASE_PRIVATE_KEY=$FIREBASE_PRIVATE_KEY

# Set the working directory in the container to the app folder
WORKDIR /app

# Copy requirements file
COPY ../requirements.txt ./

# Download packages/dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Bundle the app
COPY . .

# add current directory to python path
ENV PYTHONPATH ./app

CMD ["uvicorn", "--port", "80", "--log-level", "trace", "app.main:app"]