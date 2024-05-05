import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from torch.utils.data import Dataset, DataLoader
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

import daemon

# Define the dataset class
class WeatherDataset(Dataset):
    def __init__(self, data, seq_length):
        self.data = data
        self.seq_length = seq_length

    def __len__(self):
        return len(self.data) - self.seq_length

    def __getitem__(self, index):
        return (
            self.data[index:index+self.seq_length],
            self.data[index+self.seq_length]
        )

# Define the RNN model
class RNN(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim, num_layers):
        super().__init__()
        self.rnn = nn.RNN(input_dim, hidden_dim, num_layers, batch_first=True, nonlinearity="tanh")
        self.fc = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        rnn_out, _ = self.rnn(x)
        out = self.fc(rnn_out[:, -1, :])
        return out

def train(config, model, device, train_loader, optimizer, criterion, epoch):
    model.train()
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()
        optimizer.step()

        if batch_idx % config['log_interval'] == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader), loss.item()))

def test(model, device, test_loader, criterion):
    model.eval()

    print(len(test_loader))

    test_loss = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += criterion(output, target)

    test_loss /= len(test_loader.dataset)

    print('\nTest set: Average loss: {:.4f}\n'.format(test_loss))

def main(config):
    torch.manual_seed(1)

    # configure devices
    if torch.cuda.is_available():
        device = torch.device("cuda")
    elif torch.backends.mps.is_available():
        device = torch.device("mps")
    else:
        device = torch.device("cpu")
    
    # Load data

    # Convert to DataFrame
    df = pd.read_csv('preprocessed.csv').iloc[:, 1:] # Loads ~100K datapoints

    # Normalize the data
    scaler = MinMaxScaler()
    df_normalized = scaler.fit_transform(df)

    # Convert DataFrame to PyTorch tensor
    data_tensor = torch.tensor(df.values, dtype=torch.float32)

    # Hyperparameters
    input_dim = 3  # temperature, humidity, pressure
    output_dim = 3  # temperature, humidity, pressure

    hidden_dim = 16
    num_layers = 100

    seq_length = 10  # number of time steps to look back
    test_size = 0.2

    train_kwargs = {"batch_size": config["batch_size"]}
    test_kwargs = {"batch_size": 1}

    if device == 'cuda':
        cuda_kwargs = {'num_workers': 1,
                        'pin_memory': True,
                        'shuffle': True}
        train_kwargs.update(cuda_kwargs)
        test_kwargs.update(cuda_kwargs)

    # Perform train-test split
    train_data, test_data = train_test_split(data_tensor, test_size=test_size, shuffle=False)

    # Prepare the data loaders
    train_dataset = WeatherDataset(train_data, seq_length)

    test_dataset = WeatherDataset(test_data, seq_length)
    train_loader = DataLoader(train_dataset, **train_kwargs, shuffle=False)
    test_loader = DataLoader(test_dataset, **test_kwargs, shuffle=False)

    # Define the model
    model = RNN(input_dim, hidden_dim, output_dim, num_layers).to(device)

    # Define the loss function and optimizer
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=1)

    # Train and Test
    for epoch in range(1, config['epochs'] + 1):
        train(config, model, device, train_loader, optimizer, criterion, epoch)
        print("done")
        test(model, device, test_loader, criterion)

if __name__ == '__main__':
    a = daemon.Daemon(main)