# Use python 3.9 runtime as base image
FROM python:3.9

# Set the working directory in the container to the app folder
WORKDIR /app/

# Copy requirements file
COPY ../requirements.txt ./

# Bundle the app
COPY . .

# Download packages/dependencies
RUN pip install -r requirements.txt

# Run main
CMD ["uvicorn", "app.main:app", "--reload"]

