#!/bin/bash
################################################################################
# DÉSINSTALLATION COMPLÈTE D'INCUS - VERSION SÉCURISÉE
# Supprime tous les conteneurs, VMs, réseaux et données Incus
# 
# Usage: sudo bash ./remove_incus.sh
# 
# Ce script nettoie complètement une installation Incus cassée
# Utile pour réinstaller clean quand tout est en pagaille
#
# CHANGELOG v2:
# - FIX CRITIQUE: Protection des paquets réseau avant autoremove
# - apt-transport-https et ca-certificates ne sont plus supprimés
################################################################################

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérification sudo
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}ERREUR: Ce script doit être exécuté avec sudo${NC}"
    exit 1
fi

# Avertissement
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${RED}⚠ ATTENTION CRITIQUE ⚠${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Ce script va:${NC}"
echo "  • ARRÊTER le service Incus"
echo "  • SUPPRIMER TOUS les conteneurs et VMs"
echo "  • SUPPRIMER TOUS les réseaux Incus"
echo "  • DÉSINSTALLER complètement Incus"
echo "  • EFFACER TOUTES les données (/var/lib/incus, /etc/incus, etc.)"
echo ""
echo -e "${RED}⚠ AUCUN DE CES CHANGEMENTS NE PEUT ÊTRE ANNULÉ${NC}"
echo ""

# Confirmation
read -p "Êtes-vous SÛR de vouloir continuer ? (tapez 'oui' pour confirmer): " response
if [[ "$response" != "oui" ]]; then
    echo -e "${GREEN}Annulé.${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Démarrage de la désinstallation complète...${NC}"
echo ""

# 1. Arrêter le service
echo -e "${BLUE}[1/7]${NC} Arrêt du service Incus..."
systemctl stop incus incus-user 2>/dev/null || true
systemctl disable incus incus-user 2>/dev/null || true
echo -e "${GREEN}  ✓${NC} Service arrêté"

# 2. Supprimer tous les conteneurs et VMs
echo -e "${BLUE}[2/7]${NC} Suppression des conteneurs et VMs..."
INSTANCE_COUNT=0
for instance in $(incus list -cn 2>/dev/null); do
    echo "  → Suppression de $instance"
    incus delete "$instance" -f 2>/dev/null || true
    INSTANCE_COUNT=$((INSTANCE_COUNT+1))
done
if [ "$INSTANCE_COUNT" -eq 0 ]; then
    echo "  (aucun conteneur/VM trouvé)"
else
    echo -e "${GREEN}  ✓${NC} $INSTANCE_COUNT instance(s) supprimée(s)"
fi

# 3. Supprimer tous les réseaux personnalisés
echo -e "${BLUE}[3/7]${NC} Suppression des réseaux personnalisés..."
NETWORK_COUNT=0
for network in $(incus network list -cn 2>/dev/null | grep -v "^lo$\|^incusbr0$" || true); do
    echo "  → Suppression du réseau $network"
    incus network delete "$network" 2>/dev/null || true
    NETWORK_COUNT=$((NETWORK_COUNT+1))
done
if [ "$NETWORK_COUNT" -eq 0 ]; then
    echo "  (aucun réseau personnalisé trouvé)"
else
    echo -e "${GREEN}  ✓${NC} $NETWORK_COUNT réseau(x) supprimé(s)"
fi

# 4. Supprimer le réseau par défaut incusbr0
echo -e "${BLUE}[4/7]${NC} Suppression du réseau incusbr0..."
incus network delete incusbr0 2>/dev/null || true
echo -e "${GREEN}  ✓${NC} incusbr0 supprimé"

# 5. NOUVEAU: Protéger les paquets critiques
echo -e "${BLUE}[5/7]${NC} Protection des paquets réseau critiques..."
# Marquer comme manuellement installés pour éviter leur suppression
apt-mark manual apt-transport-https ca-certificates curl wget 2>/dev/null || true
echo -e "${GREEN}  ✓${NC} Paquets protégés"

# 6. Désinstaller les paquets Incus
echo -e "${BLUE}[6/7]${NC} Désinstallation des paquets Incus..."
apt-get purge -y incus incus-client incus-extra incus-base 2>/dev/null || true

# MODIFIÉ: Autoremove avec vérification
echo "  Vérification des paquets à supprimer..."
PACKAGES_TO_REMOVE=$(apt-get --dry-run autoremove 2>/dev/null | grep "^Remv" | awk '{print $2}')
if echo "$PACKAGES_TO_REMOVE" | grep -qE "apt-transport-https|ca-certificates|curl|wget"; then
    echo -e "${YELLOW}  ⚠ ATTENTION: autoremove tenterait de supprimer des paquets critiques${NC}"
    echo -e "${YELLOW}  → Saut de l'autoremove pour sécurité${NC}"
else
    apt-get autoremove -y 2>/dev/null || true
    echo -e "${GREEN}  ✓${NC} Autoremove effectué"
fi

apt-get autoclean 2>/dev/null || true
echo -e "${GREEN}  ✓${NC} Paquets nettoyés"

# 7. Supprimer toutes les données Incus
echo -e "${BLUE}[7/7]${NC} Suppression des données Incus..."
rm -rf /var/lib/incus
rm -rf /var/log/incus
rm -rf /var/cache/incus
rm -rf /etc/incus
rm -rf ~/.config/incus
rm -rf ~/.local/share/incus
echo -e "${GREEN}  ✓${NC} Données supprimées"

# Résumé final
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ SUCCÈS: Incus complètement supprimé${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Pour réinstaller Incus proprement:${NC}"
echo ""
echo "  sudo apt update"
echo "  sudo apt install incus incus-extra"
echo "  sudo incus admin init"
echo ""
