"""import torch
import torch.nn as nn
import torch.optim as optim
import random

# Vocabulary
VOCAB = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
VOCAB_SIZE = len(VOCAB)

char_to_idx = {c: i for i, c in enumerate(VOCAB)}
idx_to_char = {i: c for i, c in enumerate(VOCAB)}

# ---------------------
# Teacher
# ---------------------
class AgentA(nn.Module):
    def __init__(self):
        super().__init__()
        self.embed = nn.Embedding(VOCAB_SIZE, 16)
        self.fc = nn.Linear(16, 16)  # communication bottleneck

    def forward(self, x):
        x = self.embed(x)
        return self.fc(x)

# ---------------------
# Student
# ---------------------
class AgentB(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(16, 16)
        self.fc2 = nn.Linear(16, VOCAB_SIZE)

    def forward(self, msg):
        x = torch.relu(self.fc1(msg))
        return self.fc2(x)

agentA = AgentA()
agentB = AgentB()

optimizer = optim.Adam(
    list(agentA.parameters()) +
    list(agentB.parameters()),
    lr=0.01
)

loss_fn = nn.CrossEntropyLoss()

for step in range(5000):

    char = random.choice(VOCAB)

    target = torch.tensor(
        [char_to_idx[char]],
        dtype=torch.long
    )

    msg = agentA(target)
    prediction = agentB(msg)

    loss = loss_fn(prediction, target)

    optimizer.zero_grad()
    loss.backward()
    optimizer.step()

    if step % 500 == 0:
        pred_idx = prediction.argmax(dim=1).item()

        print(
            f"Step {step} | "
            f"Target={char} | "
            f"Pred={idx_to_char[pred_idx]} | "
            f"Loss={loss.item():.4f}"
        )"""

"""import random
import torch
import torch.nn as nn
import torch.optim as optim

# -----------------
# Agent A
# -----------------
class AgentA(nn.Module):
    def __init__(self):
        super().__init__()

        self.net = nn.Sequential(
            nn.Linear(1, 16),
            nn.ReLU(),
            nn.Linear(16, 1)  # ONE FLOAT MESSAGE
        )

    def forward(self, x):
        return self.net(x)


# -----------------
# Agent B
# -----------------
class AgentB(nn.Module):
    def __init__(self):
        super().__init__()

        self.net = nn.Sequential(
            nn.Linear(2, 32),
            nn.ReLU(),
            nn.Linear(32, 32),
            nn.ReLU(),
            nn.Linear(32, 1)
        )

    def forward(self, message, number_b):
        x = torch.cat([message, number_b], dim=1)
        return self.net(x)


agentA = AgentA()
agentB = AgentB()

optimizer = optim.Adam(
    list(agentA.parameters()) +
    list(agentB.parameters()),
    lr=0.001
)

loss_fn = nn.MSELoss()


# -----------------
# TRAIN
# -----------------
for step in range(10000):

    a = random.randint(0, 20)
    b = random.randint(0, 20)

    target = a + b

    a_tensor = torch.tensor([[float(a)]])
    b_tensor = torch.tensor([[float(b)]])
    target_tensor = torch.tensor([[float(target)]])

    message = agentA(a_tensor)

    prediction = agentB(message, b_tensor)

    loss = loss_fn(prediction, target_tensor)

    optimizer.zero_grad()
    loss.backward()
    optimizer.step()

    if step % 1000 == 0:
        print(
            f"Step {step} | "
            f"{a}+{b}={target} | "
            f"Pred={prediction.item():.2f} | "
            f"Loss={loss.item():.4f}"
        )


# -----------------
# TEST
# -----------------

print("\nTESTING\n")

for _ in range(10):

    a = random.randint(0, 20)
    b = random.randint(0, 20)

    a_tensor = torch.tensor([[float(a)]])
    b_tensor = torch.tensor([[float(b)]])

    with torch.no_grad():
        msg = agentA(a_tensor)
        pred = agentB(msg, b_tensor)

    print(
        f"{a} + {b} = "
        f"{pred.item():.2f} "
        f"(expected {a+b})"
    )

print("\nMESSAGES")

for i in range(21):
    x = torch.tensor([[float(i)]])

    with torch.no_grad():
        msg = agentA(x)

    print(i, msg.item())"""

"""import random
import torch
import torch.nn as nn
import torch.optim as optim

MESSAGE_VOCAB = 8

# -----------------
# Agent A
# -----------------

class AgentA(nn.Module):
    def __init__(self):
        super().__init__()

        self.net = nn.Sequential(
            nn.Linear(1, 32),
            nn.ReLU(),
            nn.Linear(32, MESSAGE_VOCAB)
        )

    def forward(self, x):
        logits = self.net(x)

        # choose symbol
        probs = torch.softmax(logits, dim=-1)

        symbol = torch.argmax(probs, dim=-1)

        return symbol


# -----------------
# Agent B
# -----------------

class AgentB(nn.Module):
    def __init__(self):
        super().__init__()

        self.embed = nn.Embedding(MESSAGE_VOCAB, 8)

        self.net = nn.Sequential(
            nn.Linear(9, 32),
            nn.ReLU(),
            nn.Linear(32, 1)
        )

    def forward(self, symbol, b):

        msg = self.embed(symbol)

        x = torch.cat([msg, b], dim=1)

        return self.net(x)


agentA = AgentA()
agentB = AgentB()

optimizer = optim.Adam(
    list(agentA.parameters()) +
    list(agentB.parameters()),
    lr=0.001
)

loss_fn = nn.MSELoss()

# -----------------
# TRAIN
# -----------------

for step in range(10000):

    a = random.randint(0, 20)
    b = random.randint(0, 20)

    target = a + b

    a_tensor = torch.tensor([[float(a)]])
    b_tensor = torch.tensor([[float(b)]])
    target_tensor = torch.tensor([[float(target)]])

    symbol = agentA(a_tensor)

    pred = agentB(symbol, b_tensor)

    loss = loss_fn(pred, target_tensor)

    optimizer.zero_grad()
    loss.backward()
    optimizer.step()

    if step % 1000 == 0:
        print(
            f"Step {step} | "
            f"{a}+{b}={target} | "
            f"Symbol={symbol.item()} | "
            f"Pred={pred.item():.2f}"
        )

print("\nMAPPING\n")

for i in range(21):
    x = torch.tensor([[float(i)]])
    symbol = agentA(x)

    print(i, "->", symbol.item())"""

import random
import torch
import torch.nn as nn
import torch.optim as optim

# --------------------------
# Hyperparameters
# --------------------------

NUM_SYMBOLS = 32

# --------------------------
# Speaker
# --------------------------

class AgentA(nn.Module):
    def __init__(self):
        super().__init__()

        self.embed = nn.Embedding(21,16)

        self.net = nn.Sequential(
            nn.Linear(32,64),
            nn.ReLU(),
            nn.Linear(64,4)  # 4-number message
        )

    def forward(self,a,b):
        ea=self.embed(a)
        eb=self.embed(b)

        x=torch.cat([ea,eb],dim=-1)

        return self.net(x)

# --------------------------
# Listener
# --------------------------

class AgentB(nn.Module):
    def __init__(self):
        super().__init__()

        self.net=nn.Sequential(
            nn.Linear(4,64),
            nn.ReLU(),
            nn.Linear(64,1)
        )

    def forward(self,msg):
        return self.net(msg)

# --------------------------
# Models
# --------------------------

agentA = AgentA()
agentB = AgentB()

opt = optim.Adam(
    list(agentA.parameters()) +
    list(agentB.parameters()),
    lr=0.003
)

# --------------------------
# Training
# --------------------------

for step in range(10000):

    a = random.randint(0, 20)
    b = random.randint(0, 20)

    target = a + b

    a_t = torch.tensor([a])
    b_t = torch.tensor([b])

    logits = agentA(a_t, b_t)

    # Straight-through estimator
    probs = torch.softmax(logits, dim=-1)

    symbol = torch.multinomial(probs, 1).squeeze()

    pred = agentB(symbol)

    loss = (pred.squeeze() - target) ** 2

    opt.zero_grad()
    loss.backward()
    opt.step()

    if step % 1000 == 0:
        print(
            f"Step {step} | "
            f"{a}+{b}={target} | "
            f"Symbol={symbol.item()} | "
            f"Pred={pred.item():.2f}"
        )

# --------------------------
# Inspect language
# --------------------------

print("\nLANGUAGE\n")

for a in range(5):
    for b in range(5):
        a_t = torch.tensor([a])
        b_t = torch.tensor([b])

        logits = agentA(a_t, b_t)
        symbol = torch.argmax(logits).item()

        print(f"{a}+{b} -> symbol {symbol}")