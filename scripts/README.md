# Script d'Installation LXConsole

## Utilisation Rapide

```bash
sudo bash install-lxconsole.sh
```

## Prérequis

- Ubuntu 22.04+ ou Debian 13+
- Incus installé (depuis le TP)
- Accès root/sudo
- Connexion Internet

## Que fait le script?

1. ✅ Nettoie les installations précédentes
2. ✅ Installe les dépendances Python
3. ✅ Crée l'utilisateur `lxconsole`
4. ✅ Télécharge LXConsole depuis GitHub
5. ✅ Configure l'environnement Python
6. ✅ Crée le service systemd
7. ✅ Démarre LXConsole automatiquement

## Après l'Installation

```bash
sudo incus config set core.https_address "[::]:8443"
# Ouvrir: http://votre-serveur:5000
# Créer un compte admin et vous connecter
```

## Vérification

```bash
sudo systemctl status lxconsole
sudo ss -tlnp | grep 5000
sudo journalctl -u lxconsole -n 20
```

## Dépannage

### Le script échoue
```bash
sudo bash -x install-lxconsole.sh
```

### Port 5000 déjà utilisé
```bash
sudo lsof -i :5000
sudo kill -9 <PID>
sudo systemctl restart lxconsole
```

### Problème de dépendances
```bash
cd /opt/lxconsole
sudo -u lxconsole bash -c "source venv/bin/activate && pip install -r requirements.txt"
sudo systemctl restart lxconsole
```