CREATE DATABASE IF NOT EXISTS acme;

USE acme;

-----------------------------------

CREATE TABLE IF NOT EXISTS acme.user(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    login VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL
);

GRANT SELECT ON acme.user TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE TABLE IF NOT EXISTS acme.client(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    numero_tel VARCHAR(14) NOT NULL, -- 14 pour format 06.06.06.06.06 ou 06 06 06 06 06 (ou 0606060606 car plus court)
    mail VARCHAR(255) NOT NULL,
    num_addr SMALLINT NOT NULL,
    mod_num_addr VARCHAR(5), -- modificateur type TER, BIS...
    rue_addr VARCHAR(255) NOT NULL,
    code_postal_addr VARCHAR(5) NOT NULL,
    ville_addr VARCHAR(255) NOT NULL
);

GRANT INSERT ON acme.client TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT SELECT ON acme.client TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT UPDATE ON acme.client TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT DELETE ON acme.client TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE TABLE IF NOT EXISTS acme.produit(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL,
    sku VARCHAR(8) NOT NULL,
    prix DOUBLE(10,2) NOT NULL
);

GRANT INSERT ON acme.produit TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT SELECT ON acme.produit TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT UPDATE ON acme.produit TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT DELETE ON acme.produit TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE TABLE IF NOT EXISTS acme.commande(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    date_creation DATE NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id)
);

GRANT INSERT ON acme.commande TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT SELECT ON acme.commande TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE TABLE IF NOT EXISTS acme.produit_commande(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_produit INT NOT NULL,
    id_commande INT NOT NULL,
    quantite INT NOT NULL,
    FOREIGN KEY (id_produit) REFERENCES produit(id),
    FOREIGN KEY (id_commande) REFERENCES commande(id)
);

GRANT INSERT ON acme.produit_commande TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
GRANT SELECT ON acme.produit_commande TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.produits_populaires AS
SELECT
    prd.libelle AS libelle,
    prd.sku AS sku,
    SUM(pivot.quantite) AS quantite
FROM produit_commande AS pivot
INNER JOIN produit AS prd ON prd.id = pivot.id_produit
GROUP BY prd.id
ORDER BY quantite DESC;

GRANT SELECT ON acme.produits_populaires TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.produits_non_populaires AS
SELECT
    prd.libelle AS libelle,
    prd.sku AS sku,
    SUM(pivot.quantite) AS quantite
FROM produit_commande AS pivot
INNER JOIN produit AS prd ON prd.id = pivot.id_produit
GROUP BY prd.id
ORDER BY quantite ASC;

GRANT SELECT ON acme.produits_non_populaires TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.chiffre_affaires_total AS
SELECT
    SUM(pivot.quantite * prd.prix) AS chiffre_affaire 
FROM acme.commande AS cmd
INNER JOIN acme.produit_commande AS pivot ON pivot.id_commande = cmd.id
INNER JOIN acme.produit AS prd ON prd.id = pivot.id_produit;

GRANT SELECT ON acme.chiffre_affaires_total TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.chiffre_affaires_annee AS
SELECT
    year(cmd.date_creation) AS annee,
    SUM(pivot.quantite * prd.prix) AS chiffre_affaire 
FROM acme.commande AS cmd
INNER JOIN acme.produit_commande AS pivot ON pivot.id_commande = cmd.id
INNER JOIN acme.produit AS prd ON prd.id = pivot.id_produit
GROUP BY year(cmd.date_creation);

GRANT SELECT ON acme.chiffre_affaires_annee TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.chiffre_affaires_mois AS
SELECT
    DATE_FORMAT(cmd.date_creation, '%m') AS mois,
    SUM(pivot.quantite * prd.prix) AS chiffre_affaire 
FROM acme.commande AS cmd
INNER JOIN acme.produit_commande AS pivot ON pivot.id_commande = cmd.id
INNER JOIN acme.produit AS prd ON prd.id = pivot.id_produit
GROUP BY DATE_FORMAT(cmd.date_creation, '%m');

GRANT SELECT ON acme.chiffre_affaires_mois TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------

CREATE VIEW IF NOT EXISTS acme.chiffre_affaires_client AS
SELECT
    CONCAT(cl.prenom, ' ', cl.nom) AS client,
    SUM(pivot.quantite * prd.prix) AS chiffre_affaire 
FROM acme.commande AS cmd
INNER JOIN acme.produit_commande AS pivot ON pivot.id_commande = cmd.id
INNER JOIN acme.produit AS prd ON prd.id = pivot.id_produit
INNER JOIN acme.client AS cl ON cl.id = cmd.id_client
GROUP BY cl.id;

GRANT SELECT ON acme.chiffre_affaires_client TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

-----------------------------------
