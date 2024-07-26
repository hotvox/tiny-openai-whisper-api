FROM auguryan/nvidia:latest

# Copy the model
# Source: wget https://huggingface.co/distil-whisper/distil-large-v3-openai/resolve/main/model.bin?download=true
COPY ./model.bin /model.bin

# Run updates and install ffmpeg
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy and install the requirements
COPY ./requirements.txt /requirements.txt

# Pip install the dependencies
RUN pip3 install --upgrade pip 
RUN pip3 install --no-cache-dir -r /requirements.txt

# Copy the current directory contents into the container at /app
COPY main.py /app/main.py

# Set the working directory to /app
WORKDIR /app

ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/lib64:/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH

# Expose port 27606
EXPOSE 27606

# Run the app
CMD uvicorn main:app --host 0.0.0.0 --port 27606
