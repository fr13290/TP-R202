# TP R202 - Incus et LXConsole

## BUT 1ère année Réseaux & Télécommunications

Support pédagogique pour l'installation et la configuration d'Incus et LXConsole sur Debian 13 (Trixie).

---

## Structure du dépôt

```
TP-R202/
├── README.md                  # Ce fichier
├── install-lxconsole.md       # Documentation installation LXConsole
├── Docs Etud/                 # Documents de référence pour les étudiants
│   ├── Installation-LXConsole.md
│   ├── Glossaire commandes Incus.pdf
│   ├── Bash Glossaire commandes Linux cat fonct.pdf
│   └── Bash Op et caract spe.pdf
└── scripts/
    ├── README.md
    └── install-lxconsole.sh   # Script d'installation automatique
```

---

## Quick Start

### Installation rapide

```bash
# Cloner le dépôt
git clone https://github.com/fr13290/TP-R202.git
cd TP-R202

# Exécuter le script d'installation
sudo bash scripts/install-lxconsole.sh
```

### Accès aux services

| Service | URL |
|---------|-----|
| LXConsole (interface web) | `http://<IP>:5000` |
| API Incus | `https://<IP>:8443` |

---

## Documentation

### Installation

- [install-lxconsole.md](install-lxconsole.md) - Procédure complète d'installation de LXConsole sur Debian 13

### Documents étudiants

- [Installation-LXConsole.md](Docs%20Etud/Installation-LXConsole.md) - Guide pas à pas
- [Glossaire commandes Incus.pdf](Docs%20Etud/Glossaire%20commandes%20Incus.pdf) - Référence des commandes Incus
- [Bash Glossaire commandes Linux.pdf](Docs%20Etud/Bash%20Glossaire%20commandes%20Linux%20cat%20fonct.pdf) - Commandes Linux par catégorie
- [Bash Opérateurs et caractères spéciaux.pdf](Docs%20Etud/Bash%20Op%20et%20caract%20spe.pdf) - Syntaxe Bash

---

## Prérequis

- Debian 13 (Trixie)
- Incus installé
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

# Liste des conteneurs Incus
incus list
```

---

**Version** : 1.1
**Date** : Janvier 2026
