sudo apt update 
sudo apt install gcc make curl -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked