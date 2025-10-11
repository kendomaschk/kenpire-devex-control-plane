import sys
import os

print("Orchestrator started...")
print("Working directory:", os.getcwd())
print("Arguments:", sys.argv)
print("Config path: ./config/kenpire-agent-mode.yaml")

config_path = os.path.join(os.getcwd(), "config", "kenpire-agent-mode.yaml")
if os.path.exists(config_path):
    print("✅ Found configuration file.")
else:
    print("❌ Config file not found.")

print("Simulated sync complete.")
