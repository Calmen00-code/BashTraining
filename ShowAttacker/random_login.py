import random

# IPs for USA, China, India, Malaysia
ips = [
    "8.8.8.8",           # USA
    "61.135.169.125",    # China
    "49.205.64.1",       # India
    "175.136.244.1"      # Malaysia
]

# Some sample usernames
usernames = [
    "admin", "root", "guest", "test", "john",
    "mary", "oracle", "sysadmin", "demo", "user"
]

# Generate 500 lines
lines = []
for _ in range(500):
    ip = random.choice(ips)
    user = random.choice(usernames)
    lines.append(f"Failed password for invalid user {user} from {ip} port 22 ssh2")

for _ in range(500):
    ip = random.choice(ips)
    user = random.choice(usernames)
    lines.append(f"Accepted password for {user} from {ip} port 22 ssh2")

# Save to file
with open("sample_auth.log", "w") as f:
    f.write("\n".join(lines))

print("sample_auth.log created with 500 entries.")
