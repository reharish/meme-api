#!/bin/sh

set -e
mkdir -p /var/www/meme-api
cp -r . /var/www/meme-api
cp -a scripts/gunicorn.service /etc/systemd/system/gunicorn.service

systemctl enable gunicorn.service
systemctl start gunicorn.service

read -ep "Have a Domain Name [y/n] " domain

if [ "$domain" == "y" ];
then
    printf "Enter your Domain name\n"
    read -ep "[meme.example.com]: " domain_name
    echo ${domain_name}
    apt update && apt install apache2 -y
    echo "<VirtualHost *:80>
        ServerAdmin youremail_id@domain
        ServerName ${domain_name}
        ServerAlias ${domain_name}
        ProxyRequests Off
        <Location />
                ProxyPreserveHost On
                ProxyPass http://127.0.0.1:8080/
                ProxyPassReverse http://127.0.0.1:8080/
        </Location>
</VirtualHost> " | tee /etc/apache2/sites-enabled/${domain_name}.conf

    a2enmod proxy
    a2enmod proxy_http
    a2ensite ${domain_name}.conf
    service apache2 restart
    printf "      %${#domain_name}s     \n" | tr " " "#"
    printf "# visit: ${domain_name} #\n"
    printf "      %${#domain_name}s     \n" | tr " " "#"

else
    echo "Meme Page : http://127.0.0.1:8080"
fi

exit 0