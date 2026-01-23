# Installation et Configuration de LXConsole

**LXConsole** est une interface web pour gérer Incus.

## Prérequis

- Incus installé et fonctionnel
- Ubuntu 22.04+ ou Debian 13+
- Accès root/sudo
- Connexion Internet

## Installation Automatique

```bash
sudo bash scripts/install-lxconsole.sh
```

## Configuration d'Incus

```bash
sudo incus config set core.https_address "[::]:8443"
```

## Accès à LXConsole

Ouvrir: `http://192.168.X.X:5000`

## Ajouter un Serveur Incus

1. Settings → Servers → Add Server
2. Address: `localhost` ou IP du serveur
3. Port: `8443`
4. Protocol: `https`

## Dépannage

### LXConsole ne démarre pas
```bash
sudo journalctl -u lxconsole -n 50
sudo systemctl restart lxconsole
```

### Impossible de se connecter à Incus
```bash
sudo ss -tlnp | grep 8443
```

### Port 5000 déjà utilisé
```bash
sudo lsof -i :5000
```

## Désinstallation

```bash
sudo systemctl stop lxconsole
sudo systemctl disable lxconsole
sudo rm /etc/systemd/system/lxconsole.service
sudo rm -rf /opt/lxconsole
sudo userdel lxconsole
```