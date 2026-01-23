#!/bin/bash
# Installation LXConsole pour Incus
# Utilisation: sudo ./install-lxconsole.sh
# Testé sur: Ubuntu 22.04+, Debian 13

set -e

echo "🚀 INSTALLATION LXCONSOLE"
echo "========================="

if [[ $EUID -ne 0 ]]; then
    echo "❌ Ce script doit être exécuté en root (sudo)"
    exit 1
fi

# 1. Nettoyage
echo "1️⃣  Nettoyage d'une installation précédente..."
systemctl stop lxconsole 2>/dev/null || true
rm -rf /opt/lxconsole /etc/systemd/system/lxconsole.service
pkill -f lxconsole 2>/dev/null || true

# 2. Dépendances
echo "2️⃣  Installation des dépendances..."
apt update
apt install -y python3 python3-pip python3-venv git curl

# 3. Utilisateur
echo "3️⃣  Création utilisateur lxconsole..."
useradd -r -d /opt/lxconsole -s /bin/bash lxconsole 2>/dev/null || true

# 4. Téléchargement
echo "4️⃣  Téléchargement LXConsole..."
mkdir -p /opt/lxconsole
cd /opt/lxconsole
git clone https://github.com/PenningLabs/lxconsole.git . 2>/dev/null || git -C . pull

# 5. Python venv
echo "5️⃣  Installation Python..."
sudo -u lxconsole python3 -m venv venv
sudo -u lxconsole bash -c "source venv/bin/activate && pip install -r requirements.txt"

# 6. Permissions
echo "6️⃣  Configuration des permissions..."
chown -R lxconsole:lxconsole /opt/lxconsole

# 7. Groupe Incus
echo "7️⃣  Ajout au groupe Incus..."
usermod -a -G incus-admin lxconsole 2>/dev/null || true

# 8. Service systemd
echo "8️⃣  Création du service..."
cat > /etc/systemd/system/lxconsole.service << 'EOF'
[Unit]
Description=LXConsole - Web UI for Incus
After=network.target incus.service
Wants=incus.service

[Service]
Type=simple
User=lxconsole
WorkingDirectory=/opt/lxconsole
Environment=PATH=/opt/lxconsole/venv/bin
ExecStart=/opt/lxconsole/venv/bin/python run.py --host 0.0.0.0 --port 5000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 9. Démarrage
echo "9️⃣  Activation et démarrage..."
systemctl daemon-reload
systemctl enable lxconsole
systemctl start lxconsole

# 10. Vérification
echo "🔟 Vérification..."
sleep 2
if systemctl is-active --quiet lxconsole; then
    echo ""
    echo "✅ INSTALLATION RÉUSSIE!"
    echo ""
    echo "Accès: http://localhost:5000"
    echo "ou:    http://$(hostname -I | awk '{print $1}'):5000"
else
    echo "❌ LXConsole n'a pas démarré!"
    systemctl status lxconsole
    exit 1
fi