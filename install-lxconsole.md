# Installation de LXConsole sur Debian 13 (Trixie)

LXConsole est une interface web pour gérer des serveurs Incus/LXD.

**GitHub** : https://github.com/PenningLabs/lxconsole

## Prérequis

- Debian 13 (Trixie)
- Incus installé et configuré
- Accès root ou sudo

---

## Procédure d'installation

### Nettoyage (si réinstallation)

```bash
# Arrêter le service s'il existe
sudo systemctl stop lxconsole 2>/dev/null

# Arrêter tout processus LXConsole en cours
pkill -f "python3 run.py" 2>/dev/null

# Supprimer l'ancienne installation
sudo rm -rf /opt/lxconsole
```

### Prérequis système

```bash
# Mettre à jour les paquets
sudo apt update

# Installer Python, pip, venv et git
sudo apt install -y python3 python3-pip python3-venv git
```

### Création de l'utilisateur système

```bash
# Créer un utilisateur système dédié pour LXConsole (sans shell, sans home)
sudo useradd -r -s /bin/false lxconsole 2>/dev/null || true

# Ajouter l'utilisateur lxconsole au groupe incus-admin pour accéder à l'API Incus
sudo usermod -aG incus-admin lxconsole
```

### Installation de LXConsole

```bash
# Cloner le dépôt LXConsole dans /opt
sudo git clone https://github.com/PenningLabs/lxconsole.git /opt/lxconsole

# Créer l'environnement virtuel Python
sudo python3 -m venv /opt/lxconsole/venv

# Installer les dépendances Python
sudo /opt/lxconsole/venv/bin/pip install -r /opt/lxconsole/requirements.txt

# Attribuer les permissions à l'utilisateur lxconsole
sudo chown -R lxconsole:lxconsole /opt/lxconsole
```

### Configuration d'Incus

```bash
# Activer l'écoute réseau de l'API Incus sur le port 8443
incus config set core.https_address :8443
```

### Création du service systemd

```bash
# Créer le fichier de service systemd
sudo tee /etc/systemd/system/lxconsole.service > /dev/null << 'EOF'
[Unit]
Description=LXConsole - Web interface for Incus/LXD
After=network.target incus.service

[Service]
Type=simple
User=lxconsole
WorkingDirectory=/opt/lxconsole
Environment=PATH=/opt/lxconsole/venv/bin
ExecStart=/opt/lxconsole/venv/bin/python run.py --host 0.0.0.0 --port 5000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Recharger la configuration systemd
sudo systemctl daemon-reload

# Activer le démarrage automatique au boot
sudo systemctl enable lxconsole
```

### Démarrage du service

```bash
# Démarrer LXConsole
sudo systemctl start lxconsole

# Vérifier le statut
sudo systemctl status lxconsole
```

---

## Accès

| Service | URL |
|---------|-----|
| Interface web LXConsole | `http://<IP>:5000` |
| API Incus | `https://<IP>:8443` |

---

## Commandes utiles

```bash
# Statut du service
sudo systemctl status lxconsole

# Redémarrer le service
sudo systemctl restart lxconsole

# Arrêter le service
sudo systemctl stop lxconsole

# Logs en temps réel
sudo journalctl -u lxconsole -f
```

---

## Première utilisation

1. Ouvrir `http://<IP>:5000` dans un navigateur
2. Créer un compte administrateur (page /register)
3. Se connecter
4. Ajouter un serveur Incus avec l'adresse `https://<IP>:8443`
5. Configurer le certificat client pour l'authentification

---

## Structure des fichiers

```
/opt/lxconsole/
├── venv/                 # Environnement virtuel Python
├── lxconsole/            # Code source
├── instance/             # Base de données SQLite
├── requirements.txt      # Dépendances Python
└── run.py                # Point d'entrée
```
