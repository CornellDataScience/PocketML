# Use python 3.9 runtime as base image
FROM python:3.9

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