# 🎮 LogiGame & Cœur de Microcontrôleur VHDL 💻

Ce dépôt contient le code source complet d'un projet de conception de systèmes numériques sur FPGA (réalisé dans le cadre du module TE608). Le projet est divisé en deux parties principales : 
1. La conception et l'intégration d'un **Cœur de Microcontrôleur (MCU) personnalisé** depuis zéro.
2. La création d'un jeu interactif de réflexes, **LogiGame**, s'appuyant sur des modules matériels (LFSR, Timers) et synthétisé sur une carte **Digilent ARTY A7-35T**.

---

## 🛠️ Partie 1 : Le Cœur de Microcontrôleur

### Description de l'architecture
Le processeur conçu est une architecture séquentielle capable d'exécuter des programmes stockés en ROM. Il est composé des blocs suivants :
* **ALU (Unité Arithmétique et Logique)** : Unité combinatoire réalisant les opérations fondamentales (+, -, *, AND, OR, XOR, Décalages).
* **ALUBuffers** : Registres de mémorisation (mémoires caches et tampons d'entrée) synchronisés sur l'horloge.
* **ALUSELROUTE** : Matrice de routage combinatoire gérant le flux de données entre les entrées, l'ALU et les mémoires.
* **INSTRMemory (Séquenceur/ROM)** : Le "cerveau" du système. Il contient les instructions (10 bits) et un compteur ordinal (PC) intégrant des points d'arrêt matériels (HALT) pour exécuter des automates spécifiques à la demande.

### Comment tester le Microcontrôleur sur la carte ARTY
Le processeur attend vos instructions pour exécuter l'un des 3 automates matériels programmés :

* **Inputs (Données)** : Utilisez les interrupteurs **SW0 à SW3** pour définir la valeur des opérandes `A` et `B` (ici, A et B prennent la même valeur).
* **BTN0 (Reset)** : Remet le processeur à zéro (État d'attente).
* **BTN1 (Automate 1)** : Calcule la multiplication `A × B`.
* **BTN2 (Automate 2)** : Calcule l'équation logique `(A + B) XNOR A`.
* **BTN3 (Automate 3)** : Calcule l'équation combinatoire complexe `(A0 AND B1) OR (A1 AND B0)`.

**Lecture des résultats :**
* **LD0 à LD3 (Vertes)** : Affichent les 4 bits de poids faible du résultat.
* **LD0 à LD3 (Rouges - RGB)** : Affichent les 4 bits de poids fort du résultat.
* **LED Bleue (LD3 RGB)** : Signal `DONE`. Elle s'allume pour indiquer que le processeur a terminé son calcul et est en état de HALT.

---

## 🕹️ Partie 2 : LogiGame (Le Jeu Interactif)

### Description du jeu
LogiGame est un jeu de réflexe impitoyable géré par une machine à états finis (FSM) robuste. Le FPGA génère une couleur pseudo-aléatoire (via un module LFSR) et vous donne un temps limité pour appuyer sur le bouton correspondant à cette couleur. 

### Mapping des contrôles (Carte ARTY)
| Composant physique | Fonction dans le jeu |
| :--- | :--- |
| **LD3 (LED RGB)** | **Écran principal** : S'allume en Rouge, Vert ou Bleu. |
| **LD0 à LD3 (Vertes)** | **Score** : Affiche votre score en binaire (de 0 à 15). |
| **SW3 & SW2** | **Sélecteur de Difficulté** : Règle la vitesse du minuteur. |
| **BTN3** | **Start / Restart** : Lancer le jeu ou réinitialiser après une défaite. |
| **BTN2** | Bouton de réponse **ROUGE**. |
| **BTN1** | Bouton de réponse **VERT**. |
| **BTN0** | Bouton de réponse **BLEU**. |

### Comment jouer ?
1. **Réglez la difficulté** avec les interrupteurs `SW3` et `SW2` (vers le bas = mode facile, vers le haut = mode hardcore).
2. **Appuyez sur BTN3** pour démarrer une partie.
3. La LED RGB s'allume. **Appuyez immédiatement** sur le bouton correspondant à la couleur affichée.
4. **Si vous avez juste :** Le score augmente d'un point sur les LEDs vertes, et une nouvelle couleur apparaît.
5. **Victoire :** Atteignez un score de 15 (les 4 LEDs vertes allumées) pour gagner.
6. 💀 **Game Over :** Si vous vous trompez de bouton OU si vous êtes trop lent (Timeout), la LED RGB s'éteint instantanément. Votre score reste figé pour vous montrer votre performance. Appuyez sur `BTN3` pour recommencer !

---

## 📂 Structure du Répertoire

```text
📦 VHDL2-main
 ┣ 📂 coeur_microcontrôleur/   # Fichiers sources de la Partie 1 (ALU, Mem, Buffers)
 ┃ ┣ 📂 ALU/                   # Unité Arithmétique et Logique
 ┃ ┣ 📂 Buffers/               # Registres et Matrice de routage
 ┃ ┣ 📂 Memory/                # ROM d'instructions et Multiplexeur de sortie
 ┃ ┣ 📜 Top_Level.vhd          # Intégration globale du CPU
 ┃ ┗ 📜 ARTY_Wrapper.vhd       # Interface avec les broches physiques de la carte
 ┣ 📂 Game/                    # Fichiers sources de la Partie 2 (LogiGame)
 ┃ ┣ 📂 Controler/             # Machine à états (FSM) principale
 ┃ ┃ ┣ 📜 Controler.vhd        # Cœur du jeu
 ┃ ┃ ┣ 📜 DiviseurFreq.vhd     # Gestion de l'horloge
 ┃ ┃ ┣ 📜 InputHandler.vhd     # Anti-rebond et gestion stricte des inputs
 ┃ ┃ ┣ 📜 LFSR.vhd             # Générateur de nombres pseudo-aléatoires
 ┃ ┃ ┣ 📜 LogiGame.vhd         # Gestion du score et de la victoire
 ┃ ┃ ┗ 📜 Minuteur.vhd         # Timer dynamique couplé à la difficulté
 ┃ ┗ 📜 Top_Level_LogiGame.vhd # Top Level du jeu pour la carte
 ┣ 📂 Bitstream/               # Fichiers .bit prêts à être flashés
 ┗ 📜 Rapport_VHDL2.pdf        # Rapport technique détaillé du projet
