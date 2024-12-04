Berikut adalah contoh **README.md** untuk repository GitHub Anda di https://github.com/Sincan2, berdasarkan skrip yang telah Anda buat (`qe3.sh`) dan fungsinya.

```markdown
# Automate SSL Certificate with Certbot and DigitalOcean API

This repository contains a shell script (`qe3.sh`) that automates the process of obtaining and renewing SSL certificates for wildcard domains using Let's Encrypt, DigitalOcean DNS API, and Certbot. The script also configures Nginx to use the generated certificates and sets up a cron job for automatic SSL renewal.

## Features
- **Obtain SSL Certificates**: Automatically obtain SSL certificates for wildcard domains using Let's Encrypt and DigitalOcean's DNS-01 challenge.
- **Nginx Configuration**: Automatically configures Nginx for your domain and applies the SSL certificate.
- **Automated SSL Renewal**: Adds a cron job to automatically renew the SSL certificates every 12 hours.
- **DigitalOcean API Integration**: Uses DigitalOcean's API to manage DNS records for DNS-01 challenge.

## Requirements

Before running the script, make sure you have the following:
1. **Certbot**: You must have `certbot` installed on your server. If not, the script will attempt to install it automatically.
2. **DigitalOcean API Token**: A DigitalOcean API token to manage DNS records for the DNS challenge.
3. **Nginx**: Nginx should be installed and running on your server.
4. **Linux Server**: The script is designed to run on a Linux server (Ubuntu preferred).

## Setup Instructions

### 1. Clone the Repository
Clone this repository to your server:
```bash
git clone https://github.com/Sincan2/Automate-SSL-Certificate.git
cd Automate-SSL-Certificate
```

### 2. Configure DigitalOcean API Token
The script requires a DigitalOcean API token to perform DNS challenge verification. 

- **API Token**: Obtain your API token from DigitalOcean.
- Run the script, and when prompted, enter your DigitalOcean API token. The token will be saved in a `.env` file.

```bash
./qe3.sh
```

This will prompt you to enter the API token for DigitalOcean.

### 3. Enter Domain and Email
After the API token is configured, the script will ask for the domain name and your email address:
```bash
./qe3.sh
```

This will create SSL certificates for your wildcard domain (`*.example.com`) and apply the certificates to Nginx.

### 4. SSL Configuration and Nginx Setup
The script will automatically:
- Create the necessary Nginx configuration to use the newly generated SSL certificate.
- Test the Nginx configuration using `nginx -t`.
- Restart Nginx to apply the new SSL certificate.

### 5. Adding Cron Job for Automatic SSL Renewal
The script adds a cron job to automatically renew the SSL certificate every 12 hours. The cron job will also reload Nginx after the renewal to apply the new certificate.

The cron job is added automatically when you run the script.

### 6. Verifying the Cron Job
To verify that the cron job has been added, you can check the crontab:
```bash
sudo crontab -l
```

This should show a cron job for `certbot renew` every 12 hours.

## Usage

1. **First Run (API Token Setup)**:
   - When running the script for the first time, you will be prompted to input your DigitalOcean API token. This token will be saved in a `.env` file.

2. **Second Run (Domain and Email Setup)**:
   - After the token is saved, run the script again to enter your domain and email for the SSL certificate generation.

```bash
./qe3.sh
```

3. **Cron Job**:
   - The script will automatically add a cron job for SSL certificate renewal every 12 hours.

4. **Nginx Configuration**:
   - The script configures Nginx to use the generated SSL certificates.

## Example

```bash
$ ./qe3.sh
Masukkan API token DigitalOcean:
DIGITALOCEAN_TOKEN=your_token_here
API token telah disimpan.

Masukkan domain dan email untuk SSL wildcard:
Domain (misalnya example.com): example.com
Email (misalnya email@example.com): email@example.com

Mengambil sertifikat SSL untuk wildcard domain example.com...
Sertifikat SSL untuk wildcard domain example.com berhasil dibuat.

Memeriksa konfigurasi Nginx...
Konfigurasi Nginx valid. Melakukan restart Nginx...
Menambahkan cron job untuk pembaruan SSL secara otomatis...
Cron job berhasil ditambahkan untuk pembaruan SSL.

Proses selesai. Sertifikat SSL telah diterapkan, Nginx telah direstart, dan cron job pembaruan SSL telah ditambahkan.
```

## Troubleshooting

- **Certbot Installation Issues**: If Certbot is not installed, the script will attempt to install it for you. Make sure your server has an internet connection to install packages.
- **Nginx Configuration Errors**: If `nginx -t` fails, check your Nginx configuration for any syntax errors. The script will stop at this step if there is an error.
- **API Token Issues**: Make sure you have provided a valid DigitalOcean API token with sufficient permissions to manage DNS records.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please create an issue in this repository, and I will assist you as soon as possible.

---

Enjoy automated SSL certificate management with Certbot and DigitalOcean DNS! 🎉
```

### Penjelasan:

- **Setup Instructions**: Memberikan instruksi langkah demi langkah untuk menyiapkan skrip di server.
- **Usage**: Menjelaskan bagaimana cara menjalankan skrip, termasuk interaksi pengguna (memasukkan API token, domain, dan email).
- **Example**: Menyediakan contoh output dari menjalankan skrip, sehingga pengguna bisa memahami apa yang diharapkan.
- **Troubleshooting**: Memberikan solusi jika terjadi masalah yang umum.
- **License**: Menyebutkan lisensi, dalam hal ini, lisensi MIT, tetapi Anda bisa menyesuaikannya sesuai kebutuhan.
  
Anda dapat menambahkan README ini ke repository GitHub Anda agar pengguna lain dapat mengikuti instruksi dengan mudah.
