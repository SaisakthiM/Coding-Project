import torch
import torch.nn as nn
import torch.optim as optim
from torch.distributions import Categorical

RESOURCE = 100
VOCAB = 16

# ------------------------
# Agent A
# ------------------------

class AgentA(nn.Module):
    def __init__(self):
        super().__init__()

        self.msg_head = nn.Sequential(
            nn.Linear(1, 32),
            nn.ReLU(),
            nn.Linear(32, VOCAB)
        )

        self.offer_head = nn.Sequential(
            nn.Linear(VOCAB + VOCAB, 32),
            nn.ReLU(),
            nn.Linear(32, RESOURCE + 1)
        )

    def send(self):
        x = torch.tensor([[1.0]])

        logits = self.msg_head(x)

        dist = Categorical(logits=logits)

        token = dist.sample()

        return token, dist

    def make_offer(self, token_a, token_b):

        vec = torch.zeros(VOCAB * 2)

        vec[token_a] = 1
        vec[VOCAB + token_b] = 1

        logits = self.offer_head(vec)

        dist = Categorical(logits=logits)

        offer = dist.sample()

        return offer, dist


# ------------------------
# Agent B
# ------------------------

class AgentB(nn.Module):
    def __init__(self):
        super().__init__()

        self.reply_head = nn.Sequential(
            nn.Linear(VOCAB, 32),
            nn.ReLU(),
            nn.Linear(32, VOCAB)
        )

        self.accept_head = nn.Sequential(
            nn.Linear(RESOURCE + 1, 32),
            nn.ReLU(),
            nn.Linear(32, 2)
        )

    def reply(self, token_a):

        vec = torch.zeros(VOCAB)

        vec[token_a] = 1

        logits = self.reply_head(vec)

        dist = Categorical(logits=logits)

        token_b = dist.sample()

        return token_b, dist

    def decide(self, offer):

        vec = torch.zeros(RESOURCE + 1)

        vec[offer] = 1

        logits = self.accept_head(vec)

        dist = Categorical(logits=logits)

        decision = dist.sample()

        return decision, dist


agentA = AgentA()
agentB = AgentB()

optA = optim.Adam(agentA.parameters(), lr=1e-3)
optB = optim.Adam(agentB.parameters(), lr=1e-3)

for step in range(20000):

    # A speaks
    token_a, dist_msg_a = agentA.send()

    # B replies
    token_b, dist_msg_b = agentB.reply(token_a)

    # A proposes
    offer, dist_offer = agentA.make_offer(
        token_a.item(),
        token_b.item()
    )

    shareA = offer.item()
    shareB = RESOURCE - shareA

    # B decides
    decision, dist_decision = agentB.decide(shareA)

    accepted = decision.item()

    if accepted:
        rewardA = shareA
        rewardB = shareB - abs(shareA - shareB)
    else:
        rewardA = -10
        rewardB = -10

    lossA = (
        -dist_msg_a.log_prob(token_a) * rewardA
        -dist_offer.log_prob(offer) * rewardA
    )

    lossB = (
        -dist_msg_b.log_prob(token_b) * rewardB
        -dist_decision.log_prob(decision) * rewardB
    )

    optA.zero_grad()
    optB.zero_grad()

    lossA.backward()
    lossB.backward()

    optA.step()
    optB.step()

    if step % 5000 == 0:
        print(
            f"Step {step} | "
            f"A:{token_a.item()} "
            f"B:{token_b.item()} "
            f"Offer={shareA}/{shareB} "
            f"Accept={accepted}"
        )

print("\nLANGUAGE\n")

for t in range(VOCAB):

    with torch.no_grad():

        token_b = agentB.reply(torch.tensor(t))[0]

        offer = agentA.make_offer(
            t,
            token_b.item()
        )[0]

    print(
        f"A token {t:2d}"
        f" -> B token {token_b.item():2d}"
        f" -> Offer {offer.item():3d}"
    )
print("\nTOKEN TABLE\n")

for a in range(VOCAB):
    for b in range(VOCAB):

        with torch.no_grad():
            offer,_ = agentA.make_offer(a,b)

        print(
            f"A={a:2d} B={b:2d} "
            f"Offer={offer.item():3d}"
        )