INSERT INTO acme.client(prenom, nom, numero_tel, mail, num_addr, mod_num_addr, rue_addr, code_postal_addr, ville_addr) VALUES
('john', 'doe', '01.02.03.04.05', 'john.doe@mail.com', 123, 'BIS', 'rue de la république', '69001', 'Lyon'),
('jane', 'doe', '01.02.03.04.05', 'jane.doe@mail.com', 456, 'TER', 'avenue des étoiles', '75001', 'Paris'),
('them', 'doe', '01.02.03.04.05', 'them.doe@mail.com', 789, NULL, 'rue da la canebière', '13001', 'Marseille');

INSERT INTO acme.produit(libelle, sku, prix) VALUES
('produit1', '00000001', 12.3),
('produit2', '00000002', 45.6),
('produit3', '00000003', 78.9),
('produit4', '00000004', 98.7),
('produit5', '00000005', 65.4);

INSERT INTO acme.commande(id_client, date_creation, date_validation) VALUES
(1, '2021-01-01', '2021-01-12'),
(1, '2021-12-31', '2022-01-07'),
(1, '2023-06-21', '2023-07-03'),
(1, '2025-01-23', '2025-01-31'),
(2, '2021-03-07', '2021-03-25'),
(2, '2021-06-23', '2022-06-24'),
(3, '2023-08-21', '2023-08-29');

INSERT INTO acme.produit_commande(id_produit, id_commande, quantite) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(4, 3, 4),
(3, 4, 3),
(2, 4, 2),
(1, 5, 12),
(3, 6, 1),
(4, 7, 23);
