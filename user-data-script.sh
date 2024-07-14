#!/bin/bash
set -ex

sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
# Update package lists
sudo apt-get update

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# Install CodeDeploy Agent
sudo apt update
sudo apt install ruby-full -y
sudo apt install wget -y
cd /home/ubuntu
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Install PM2
sudo npm install -g pm2

# Install Nginx
sudo apt-get install -y nginx

# Install Express.js dependencies
cd /var/www/html
npm install express aws-sdk

# sudo rm /var/www/html/index.nginx-debian.html
# Configure Nginx as a reverse proxy for your Node.js app
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Restart Nginx to apply the changes
sudo systemctl restart nginx

# Create the Express.js app file
# sudo wget -O /var/www/html/app.js https://raw.githubusercontent.com/fredritchie/hypha-3-tier/main/app.js

# Install Express.js dependencies
npm install express
npm install aws-sdk 
# Run the Express.js app using PM2
# pm2 start /var/www/html/app.js

# # Save PM2 process list to automatically start at boot
# pm2 save

# # Display server status
# sudo systemctl status nginx
# pm2 status