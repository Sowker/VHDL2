Après une prise en main des différents outils liés à la programmation sur carte FPGA lors de la matière VHDL1, nous passons à VHDL2 afin de mettre en application notre compréhension de la programmation sur carte programmable et de ses contraintes. Pour cela, nous avons pu créer un microcontrôleur de zéro et un un jeu fonctionnant sur FPGA. Ce jeu sera un jeu de réflexe où l’utilisateur devra appuyer sur un bouton dans un temps imparti en fonction de la couleur de la LED allumée.


Ce projet se déroule en 3 étapes:

La première étant la création du microcontrôleur. Un composant complexe capable de réaliser plusieurs opérations grâce à son ALU et ses buffers, mais aussi de garder en mémoire ses résultats grâce à sa mémoire cache de 128 bits. Tous ses composants sont reliés par une table d’interconnexion et permettent le bon fonctionnement du microcontrôleur.

La deuxième partie se focalise sur la création du jeu. Pour ce faire, nous devons créer un composant capable de créer une séquence pseudo aléatoire, le LFSR qui va pouvoir allumer les LED de manière pseudo aléatoire. On va ensuite créer les différents composants permettant le bon déroulement du jeu comme le Minuteur, LogiGame ou bien encore l'Input Controler qui seront des composants pour le jeu. Celui-ci prendra la forme d’un automate dans le fichier Contrôler.

Enfin, la troisième et dernière partie permet la mise en commun des deux parties précédentes. Ainsi, à travers celle-ci, nous allons générer la séquence pseudo aléatoire par le micro-contrôleur, permettant de créer un jeu complet.

