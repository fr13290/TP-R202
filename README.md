# TP R202 - Incus et LXConsole

## BUT 1ère année Réseaux & Télécommunications

Support pédagogique pour l'installation et la configuration d'Incus et LXConsole sur Debian 13 (Trixie).

---

## Structure du dépôt

```
TP-R202/
├── README.md                   # Ce fichier
└── Docs Etud/                  # Documents de référence pour les étudiants
    ├── Installation-LXConsole.md
    ├── Glossaire commandes Incus.pdf
    ├── Bash Glossaire commandes Linux cat fonct.pdf
    └── Bash Op et caract spe.pdf
```

---

## Documentation

### Guide d'installation

- [Installation-LXConsole.md](Docs%20Etud/Installation-LXConsole.md) - Installation et configuration de LXConsole

### Glossaires de référence

- [Glossaire commandes Incus.pdf](Docs%20Etud/Glossaire%20commandes%20Incus.pdf) - Référence des commandes Incus
- [Bash Glossaire commandes Linux.pdf](Docs%20Etud/Bash%20Glossaire%20commandes%20Linux%20cat%20fonct.pdf) - Commandes Linux par catégorie/fonction
- [Bash Opérateurs et caractères spéciaux.pdf](Docs%20Etud/Bash%20Op%20et%20caract%20spe.pdf) - Syntaxe Bash

---

## Quick Start

### 1. Configuration d'Incus

```bash
# Activer l'écoute réseau de l'API Incus
sudo incus config set core.https_address "[::]:8443"
```

### 2. Accès aux services

| Service | URL |
|---------|-----|
| LXConsole (interface web) | `http://<IP>:5000` |
| API Incus | `https://<IP>:8443` |

---

## Prérequis

- Debian 13 (Trixie) ou Ubuntu 22.04+
- Incus installé et fonctionnel
- Accès root ou sudo

---

## Commandes utiles

```bash
# Statut du service LXConsole
sudo systemctl status lxconsole

# Logs en temps réel
sudo journalctl -u lxconsole -f

# Redémarrer LXConsole
sudo systemctl restart lxconsole

# Vérifier que Incus écoute sur le port 8443
sudo ss -tlnp | grep 8443

# Liste des conteneurs Incus
incus list
```

---

**Version** : 1.2
**Date** : Janvier 2026
