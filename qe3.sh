#!/bin/bash

# Fungsi untuk membaca API token DigitalOcean
read_api_token() {
    echo "Masukkan API token DigitalOcean:"
    read -r DIGITALOCEAN_TOKEN

    # Simpan token ke dalam file .env
    echo "DIGITALOCEAN_TOKEN=$DIGITALOCEAN_TOKEN" > .env

    echo "API token telah disimpan."
}

# Fungsi untuk memasukkan domain dan email
read_domain_and_email() {
    # Cek jika jumlah argumen sudah benar
    if [ "$#" -ne 2 ]; then
        echo "Penggunaan: $0 domain wildcard-domain email-email"
        exit 1
    fi

    # Variabel input
    DOMAIN=$1
    EMAIL=$2
}

# Langkah pertama: Memasukkan API token DigitalOcean
if [ ! -f .env ]; then
    read_api_token
else
    echo ".env file sudah ada, menggunakan API token yang sudah disimpan."
    source .env
fi

# Cek apakah API token ada di file .env
if [ -z "$DIGITALOCEAN_TOKEN" ]; then
    echo "API token DigitalOcean belum diatur!"
    exit 1
fi

# Langkah kedua: Memasukkan domain dan email
echo "Masukkan domain dan email untuk SSL wildcard:"
read -p "Domain (misalnya example.com): " DOMAIN
read -p "Email (misalnya email@example.com): " EMAIL

# Set environment variable untuk API token DigitalOcean
export DIGITALOCEAN_TOKEN=$DIGITALOCEAN_TOKEN

# Periksa apakah Certbot sudah terinstal
if ! command -v certbot &> /dev/null
then
    echo "Certbot tidak ditemukan. Menginstal Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-dns-digitalocean
fi

# Menjalankan Certbot dengan DNS-01 Challenge untuk wildcard domain
echo "Mengambil sertifikat SSL untuk wildcard domain $DOMAIN..."
certbot certonly --dns-digitalocean \
    --dns-digitalocean-credentials ~/.digitalocean_api_token \
    --dns-digitalocean-propagation-seconds 60 \
    -d "*.$DOMAIN" -d "$DOMAIN" \
    --email "$EMAIL" --agree-tos --no-eff-email

# Memeriksa jika sertifikat berhasil dibuat
if [ $? -eq 0 ]; then
    echo "Sertifikat SSL untuk wildcard domain $DOMAIN berhasil dibuat."
else
    echo "Gagal membuat sertifikat SSL."
    exit 1
fi

# Mengecek konfigurasi Nginx
echo "Memeriksa konfigurasi Nginx..."
sudo nginx -t

# Jika ada error, beri tahu pengguna dan hentikan proses
if [ $? -ne 0 ]; then
    echo "Ada kesalahan dalam konfigurasi Nginx. Silakan perbaiki sebelum melanjutkan."
    exit 1
fi

# Jika tidak ada error, restart Nginx
echo "Konfigurasi Nginx valid. Melakukan restart Nginx..."
sudo /etc/init.d/nginx restart

# Menambahkan cron job untuk pembaruan sertifikat SSL
echo "Menambahkan cron job untuk pembaruan sertifikat SSL secara otomatis..."

# Cek jika cron job sudah ada
if ! sudo crontab -l | grep -q 'certbot renew'; then
    # Menambahkan cron job untuk memperbarui sertifikat SSL setiap 12 jam
    (sudo crontab -l 2>/dev/null; echo "0 0,12 * * * certbot renew --quiet && systemctl reload nginx") | sudo crontab -
    echo "Cron job berhasil ditambahkan untuk pembaruan SSL."
else
    echo "Cron job untuk pembaruan SSL sudah ada."
fi

echo "Proses selesai. Sertifikat SSL telah diterapkan, Nginx telah direstart, dan cron job pembaruan SSL telah ditambahkan."
