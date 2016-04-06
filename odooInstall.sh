#!/bin/sh
#Este shell script foi criado com intuito de auxiliar
# a instalacao do Odoo 8.0 e a localizacao brasileira.

#Instalando o Open SSH. Permitindo acesso remoto via
#Putty.
echo "==========================="
echo "Installing OpenSSh"
echo "==========================="
apt-get install openssh-server -y

#Definir configuracoes locais.
echo "==========================="
echo "Local Settings"
echo "==========================="
export LANGUAGE=pt_BR.UTF-8
export LANG=pt_BR.UTF-8
locale-gen pt_BR pt_BR.UTF-8
dpkg-reconfigure locales

#Atualiando Repositorio.
echo "==========================="
echo "Update Repository"
echo "==========================="
sudo apt-get update

#Criando Usuario Odoo.
#Este usuario sera responsavel pela aplicacao.
echo "==========================="
echo "Creating user Odoo"
echo "==========================="
adduser --system --home=/opt/odoo --group odoo

#Instalando Postgres.
#Sera necessario cria o usuario odoo apos
#instalacao.
echo "==========================="
echo "Installing postgres"
echo "==========================="
apt-get install postgresql -y

#Instalando versionador git.
echo "==========================="
echo "Installing Git"
echo "==========================="
apt-get install git -y

#Instalando Python e as libs necessarias para o odoo.
echo "==========================="
echo "Installing Python and Libs"
echo "==========================="
apt-get install python-dev python-yaml python-feedparser python-geoip python-imaging python-pybabel python-unicodecsv wkhtmltopdf libxml2-dev libxmlsec1-dev python-argparse python-Babel python-cups python-dateutil python-decorator python-docutils python-feedparser python-gdata python-gevent python-greenlet python-Jinja2 python-libxslt1 python-lxml python-Mako python-MarkupSafe python-mock python-openid python-passlib python-psutil python-psycopg2 python-pychart python-pydot python-pyparsing python-pyPdf python-ldap python-yaml python-reportlab python-requests python-simplejson python-six python-tz python-unittest2 python-vatnumber python-vobject python-webdav python-Werkzeug python-wsgiref python-xlwt python-zsi python-dev libpq-dev poppler-utils python-pdftools antiword -y
apt-get install python-pip  -y
apt-get install python-setuptools -y
pip install pyserial==2.7
pip install psycogreen==1.0
pip install pyusb==1.0.0b1
pip install qrcode==5.0.1
pip install Pillow==2.5.1
pip install boto==2.38.0
pip install oerplib==0.8.4
pip install jcconv==0.2.3
pip install pytz==2014.4

#Instalando WKHTMLtoPDF, responsavel por geracao de 
# arquivos PDF.
echo "==========================="
echo "Installing WKHTMLtoPDF"
echo "==========================="
cd /tmp
wget http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
cp /usr/local/bin/wkhtmltopdf /usr/bin
cp /usr/local/bin/wkhtmltoimage /usr/bin

#Realizando o clone do odoo 8.0
echo "==========================="
echo "Clonning odoo 8.0"
echo "==========================="
cd /opt/odoo/
git clone https://www.github.com/odoo/odoo --depth 1 --branch 8.0 --single-branch .

#Realizando o clone do arquivo de configuracao,
#esta com as configuracoes padroes.
echo "==========================="
echo "Config odoo File"
echo "==========================="
cd /etc/
wget https://raw.github.com/gabrielbr17/Others/master/odoo-server.conf -O odoo-server.conf
chown odoo: /etc/odoo-server.conf
chmod 640 /etc/odoo-server.conf

#Criando diretorio para Log da aplicacao.
echo "==========================="
echo "Log odoo File"
echo "==========================="
mkdir /var/log/odoo
chown odoo:root /var/log/odoo

#Criando arquivo para inicializacao do odoo.
echo "==========================="
echo "Init odoo File"
echo "==========================="
cd /etc/init.d/
wget https://raw.github.com/gabrielbr17/Others/master/odoo-server -O odoo-server
chmod 755 /etc/init.d/odoo-server
chown root: /etc/init.d/odoo-server

#Clonando repositorias da localizacao brasileira e as dependencias necessarias.
echo "==========================="
echo "Clonning Brazilian Repository"
echo "==========================="
cd /opt/odoo
mkdir localizacao
cd localizacao
git clone https://github.com/odoo-brazil/l10n-brazil.git --branch 8.0 --depth 1
git clone https://github.com/odoo-brazil/account-fiscal-rule.git --branch 8.0 --depth 1
git clone https://github.com/odoo-brazil/odoo-brazil-eletronic-documents.git --branch 8.0 --depth 1
git clone https://github.com/OCA/server-tools --branch 8.0 --depth 1

#Instalando Geraldo reports, utilizado para relatorios.
echo "==========================="
echo "Installing Geraldo Reports"
echo "==========================="
cd /tmp
git clone https://github.com/aricaldeira/geraldo --branch master
cd geraldo
python setup.py install

#Instalando PySped para poder utilizar NFe
echo "==========================="
echo "Installing PySped"
echo "==========================="
cd /tmp
wget http://labs.libre-entreprise.org/download.php/430/pyxmlsec-0.3.0.tar.gz
tar xvzf pyxmlsec-0.3.0.tar.gz
cd pyxmlsec-0.3.0
python setup.py install
cd /tmp
git clone https://github.com/odoo-brazil/PySPED.git --branch 8.0
cd PySPED
python setup.py install

#Instalando pyxmlsec, necessario para o PySped
echo "==========================="
echo "Installing pyxmlsec"
echo "==========================="
cd /tmp
git clone https://github.com/aricaldeira/pyxmlsec --branch master
cd pyxmlsec
python setup.py install

#Alterando owner da pasta odoo.
echo "==========================="
echo "Change owner"
echo "==========================="
cd /opt/
chown odoo: odoo -R

echo "==========================="
echo "Finished"
echo "==========================="