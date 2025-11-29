# RPI_SignalK_Install_Fr

Ce dépot vous permet de trouver les commandes et services utilisés pour installer un Raspberry Pi avec SignalK et une carte Waveshare 2CH Hat.

Après une première vidéo Youtube https://www.youtube.com/watch?v=LtRXSjpMPuI qui explique comment jz suis arrivé à ce choix, J'ai ajouté une seconde vidéo qui explique l'installation en faisant référence à ce dépôt. Elle est disponible ici: 

*You have an English version in this repo https://github.com/Merange/RPI_Signalk_Install*

# Installation de la carte CANopen Waveshare 2CH Hat
Récupération et compilation de la bibliothèque 
```
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.60.tar.gz
tar zxvf bcm2835-1.60.tar.gz 
cd bcm2835-1.60/
sudo ./configure
sudo make
sudo make check
sudo make install
```

Ajout de la bibliothèque d'accès à la carte
```
wget https://files.waveshare.com/upload/8/8c/WiringPi-master.zip
sudo apt-get install unzip
unzip WiringPi-master.zip
cd WiringPi-master/
sudo ./build 
```

Ajout de l'accès à la carte dans la configuration du Raspberry Pi dans le fichier __*/boot/firmware/config.txt*__  (utiliser une éditeur de texte en mode Super Utilisateur e.g. *sudo nano*) des lignes suivantes
L'accès aux 2 ports se fera par __*can0*__ et __*can1*__
```
dtparam=spi=on
dtoverlay=mcp2515-can1,oscillator=16000000,interrupt=25
dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=23
dtoverlay=spi-bcm2835-overlay
```

Après le redémarrage, vous pouvez créer les 2 réseaux et configurer les ports CAN à 250kbit/s la vitesse du bus NMEA2000
```
sudo ip link set can0 up type can bitrate 250000
sudo ip link set can1 up type can bitrate 250000
sudo ifconfig can0 txqueuelen 65536
sudo ifconfig can1 txqueuelen 65536
```

Installation des outils Can, can-utils, pour tester la configuration
```
sudo apt-get install can-utils -y
```

Ouvrir les 2 commandes suivantes dans 2 terminaux séparés
```
candump can0
cansend can1 000#11.22.33.44
```

# Installation de SignalK 
J’ai suivi la procédure proposée sur le site de SignalK
Installation de NodeJS, NPM, des bibliothèques nécessaires à SignalK et enfin SignalK depuis NodeJS via NPM
```
sudo apt install nodejs
sudo apt install libnss-mdns avahi-utils libavahi-compat-libdnssd-dev
sudo npm install -g signalk-server
```

Afin de s’assurer que le service SignalK démarre bien *après* service le service CanOpen, il faut modifier  *__signalK service__*
```
sudo systemctl edit signalk.service
```
En ajoutant à la fin du fichier
```
After=socketcan-interface.service
```

