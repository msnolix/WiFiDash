<p align="center">
  <img src=".github/misc/logo.png" alt="WiFiDash Logo">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge">
  <img src="https://img.shields.io/github/license/msnolix/WiFiDash?style=for-the-badge">
  <img src="https://img.shields.io/github/stars/msnolix/WiFiDash?style=for-the-badge">
  <img src="https://img.shields.io/github/issues/msnolix/WiFiDash?color=red&style=for-the-badge">
  <img src="https://img.shields.io/github/forks/msnolix/WiFiDash?color=teal&style=for-the-badge">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Author-msnolix-blue?style=flat-square">
  <img src="https://img.shields.io/badge/Open%20Source-Yes-darkgreen?style=flat-square">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-lightblue?style=flat-square">
  <img src="https://img.shields.io/badge/Written%20In-Bash-darkcyan?style=flat-square">
</p>


A **fully-featured professional terminal Wi-Fi dashboard** for monitoring and testing your own networks.

⚠️ **Important:** Only test networks you own. Unauthorized access is illegal.

## Table of Contents

1. Features
2. Requirements
3. Installation
4. Usage
5. Configuration
6. Directory Structure
7. Contributing
8. License

---

## Features

- Detect nearby Wi-Fi networks and display signal strength, channel, ESSID.
- Automatically select the strongest network for monitoring.
- Capture WPA/WPA2 handshakes automatically.
- Brute-force handshakes with a custom wordlist.
- Real-time dashboard showing capture and brute-force progress.
- Logs all activity for review.
- Written entirely in bash, easy to read and modify.

## Requirements

- Linux OS (Kali, Ubuntu recommended)
- Root privileges
- aircrack-ng suite
- Wi-Fi adapter with monitor mode support

Install dependencies:

```bash
sudo apt update
sudo apt install aircrack-ng
```

## Installation

1. Clone the repository:

```bash
git clone https://github.com/msnolix/WiFiDash.git
cd WiFiDash
```

2. Make the script executable:

```bash
chmod +x wifi_dash.sh
```

## Usage

Run the script:

```bash
sudo ./wifi_dash.sh
```

Follow prompts to select adapter, scan networks, capture handshakes, and brute-force with wordlist.

## Configuration

- Captures folder: captures/ – stores .cap files
- Logs folder: logs/ – stores aircrack logs
- Temp scans: tmp/ – stores temporary CSV files

## Directory Structure

```
WiFiDash/
├── wifi_dash.sh
├── captures/
├── logs/
├── tmp/
├── docs/
└── README.md
```

## Contributing

Contributions are welcome! Fork the repository, create a branch, commit, push, and submit a PR.

## License

MIT License – free to use for educational and personal purposes.
