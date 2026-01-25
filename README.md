# TP R202 - Incus et LXConsole

## BUT 1ère année Réseaux & Télécommunications

Support pédagogique pour l'installation et la configuration d'Incus et LXConsole sur Debian 13 (Trixie).

---

## Structure du dépôt

```
TP-R202/
├── README.md
├── Docs Etud/                              # Documents de référence
│   ├── Installation-LXConsole.md
│   ├── Glossaire commandes Incus.pdf
│   ├── Bash Glossaire commandes Linux cat fonct.pdf
│   ├── Bash Op et caract spe.pdf
│   └── Note config profil et cloud init v2.pdf
├── TD/                                     # Travaux Dirigés
│   └── TD Admin Sys et Virt v1.pdf
├── TP/                                     # Travaux Pratiques
│   └── TP Virt Incus v1.pdf
└── scripts/                                # Scripts d'installation
```

---

## Travaux Pratiques et Dirigés

- [TP Virt Incus v1.pdf](TP/TP%20Virt%20Incus%20v1.pdf) - TP Virtualisation avec Incus
- [TD Admin Sys et Virt v1.pdf](TD/TD%20Admin%20Sys%20et%20Virt%20v1.pdf) - TD Administration Système et Virtualisation

---

## Documentation

### Guide d'installation

- [Installation-LXConsole.md](Docs%20Etud/Installation-LXConsole.md) - Installation et configuration de LXConsole

### Glossaires de référence

- [Glossaire commandes Incus.pdf](Docs%20Etud/Glossaire%20commandes%20Incus.pdf) - Référence des commandes Incus
- [Bash Glossaire commandes Linux.pdf](Docs%20Etud/Bash%20Glossaire%20commandes%20Linux%20cat%20fonct.pdf) - Commandes Linux par catégorie/fonction
- [Bash Opérateurs et caractères spéciaux.pdf](Docs%20Etud/Bash%20Op%20et%20caract%20spe.pdf) - Syntaxe Bash

### Configuration avancée

- [Note config profil et cloud init v2.pdf](Docs%20Etud/Note%20config%20profil%20et%20cloud%20init%20v2.pdf) - Configuration des profils et cloud-init

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

**Version** : 1.3
**Date** : Janvier 2026
