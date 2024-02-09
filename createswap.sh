# $1 is the size of swap memory ex: 16G
# ./createswap.sh 16G
sudo fallocate -l $1 /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo sysctl vm.swappiness=70
sudo sysctl vm.vfs_cache_pressure=50

# File path
file_path="/etc/sysctl.conf"

# Properties to add or modify
property1="vm.swappiness=70"
property2="vm.vfs_cache_pressure=50"

# Function to check if a property exists in the file
property_exists() {
    grep -q "^$1=" "$file_path"
}

# Check if the file exists
if [ -e "$file_path" ]; then
    # Check and modify or add property1
    if property_exists "$property1"; then
        sudo nano "$file_path"
        echo "Modified $property1 in $file_path"
    else
        sudo bash -c "echo '$property1' >> $file_path"
        echo "Added $property1 to $file_path"
    fi

    # Check and modify or add property2
    if property_exists "$property2"; then
        sudo nano "$file_path"
        echo "Modified $property2 in $file_path"
    else
        sudo bash -c "echo '$property2' >> $file_path"
        echo "Added $property2 to $file_path"
    fi
else
    echo "File not found: $file_path"
fi
