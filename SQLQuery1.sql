USE master;
GO

-- Création de la base de données
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_Ventes')
    DROP DATABASE DW_Ventes;
GO

CREATE DATABASE DW_Ventes;
GO

USE DW_Ventes;
GO

-- =============================================
-- TABLES DE DIMENSIONS
-- =============================================

-- Dimension Calendrier
CREATE TABLE Dim_Calendrier (
    Clef_Date INT PRIMARY KEY,
    Date_Complete DATE NOT NULL,
    Jour INT NOT NULL,
    Semaine INT NOT NULL,
    Semaine_Annee INT NOT NULL,
    Mois INT NOT NULL,
    Mois_Annee INT NOT NULL,
    Trimestre INT NOT NULL,
    Trimestre_Annee INT NOT NULL,
    Annee INT NOT NULL,
    Ferie BIT DEFAULT 0,
    Nom_Mois VARCHAR(20),
    Nom_Jour VARCHAR(20)
);

-- Dimension Temps
CREATE TABLE Dim_Temps (
    Clef_Temps INT PRIMARY KEY,
    Temps TIME NOT NULL,
    Heure INT NOT NULL,
    Minute INT NOT NULL,
    AM_PM VARCHAR(2),
    Jour_Nuit VARCHAR(10),
    Heure_Creuse BIT DEFAULT 0
);

-- Dimension Caisse
CREATE TABLE Dim_Caisse (
    Clef_Caisse INT PRIMARY KEY,
    Numero_Caisse VARCHAR(20) NOT NULL,
    Type_Caisse VARCHAR(50)
);

-- Dimension Magasin
CREATE TABLE Dim_Magasin (
    Clef_Magasin INT PRIMARY KEY,
    Nom_Magasin VARCHAR(100) NOT NULL,
    Numero_Magasin VARCHAR(20),
    Rue VARCHAR(200),
    Ville VARCHAR(100),
    Departement VARCHAR(50),
    Pays VARCHAR(50),
    Code_Postal VARCHAR(10),
    Directeur VARCHAR(100),
    Zone VARCHAR(50),
    Zone_Precedente VARCHAR(50),
    Region VARCHAR(50),
    Region_Precedente VARCHAR(50),
    Date_Premiere_Ouverture DATE,
    Date_Derniere_Renovation DATE
);

-- Dimension Mode de Paiement
CREATE TABLE Dim_Mode_Paiement (
    Clef_Mode_Paiement INT PRIMARY KEY,
    Code_Paiement VARCHAR(20) NOT NULL,
    Description VARCHAR(100),
    Type_Paiement VARCHAR(50)
);

-- Dimension Client
CREATE TABLE Dim_Client (
    Clef_Client INT PRIMARY KEY,
    Nom_Client VARCHAR(100),
    Prenom_Client VARCHAR(100),
    Numero_Carte_Client VARCHAR(50),
    Code_Postal_Client VARCHAR(10),
    Ville_Client VARCHAR(100),
    Adresse_Client VARCHAR(200),
    Date_Carte_Fidelite DATE,
    Date_Naissance DATE,
    Sexe_Client VARCHAR(10),
    Age INT,
    Statut_Marital VARCHAR(20),
    Nombre_Enfants INT,
    Revenus_Foyer DECIMAL(15,2)
);

-- Dimension Produit
CREATE TABLE Dim_Produit (
    Clef_Produit INT PRIMARY KEY,
    Code_Produit VARCHAR(50) NOT NULL,
    Description_Produit VARCHAR(200),
    Marque_Produit VARCHAR(100),
    Sous_Sous_Categorie VARCHAR(100),
    Sous_Categorie VARCHAR(100),
    Categorie_Produit VARCHAR(100),
    Rayon VARCHAR(100),
    Prix_Produit_Recommande DECIMAL(10,2),
    Rangee VARCHAR(50),
    Secteur VARCHAR(50),
    Etagere VARCHAR(50)
);

-- Dimension Promotion
CREATE TABLE Dim_Promotion (
    Clef_Promotion INT PRIMARY KEY,
    Code_Promotion VARCHAR(50) NOT NULL,
    Nom_Promotion VARCHAR(200),
    Type_Promotion VARCHAR(50),
    Date_Debut DATE,
    Date_Fin DATE,
    Taux_Remise DECIMAL(5,2)
);

-- =============================================
-- TABLE DE FAITS
-- =============================================

CREATE TABLE Fait_Vente_Produits (
    -- Clés étrangères (FK vers dimensions)
    Clef_Date_Paiement INT NOT NULL,
    Clef_Heure_Paiement INT NOT NULL,
    Clef_Caisse INT NOT NULL,
    Clef_Magasin INT NOT NULL,
    Clef_Client INT NOT NULL,
    Clef_Mode_Paiement INT NOT NULL,
    Clef_Produit INT NOT NULL,
    Clef_Promotion INT,
    
    -- Identifiants de transaction
    ID_Paiement VARCHAR(50) NOT NULL,
    
    -- Mesures (Faits)
    Quantite INT NOT NULL,
    Montant_Unitaire DECIMAL(10,2) NOT NULL,
    Cout_Achat DECIMAL(10,2),
    Montant DECIMAL(10,2) NOT NULL,
    Reduction DECIMAL(10,2) DEFAULT 0,
    Montant_Final DECIMAL(10,2) NOT NULL,
    
    -- Mesures calculées
    Marge_Brute DECIMAL(10,2),
    Taux_Marge DECIMAL(5,2),
    
    -- Contraintes
    CONSTRAINT FK_Vente_Date FOREIGN KEY (Clef_Date_Paiement) 
        REFERENCES Dim_Calendrier(Clef_Date),
    CONSTRAINT FK_Vente_Temps FOREIGN KEY (Clef_Heure_Paiement) 
        REFERENCES Dim_Temps(Clef_Temps),
    CONSTRAINT FK_Vente_Caisse FOREIGN KEY (Clef_Caisse) 
        REFERENCES Dim_Caisse(Clef_Caisse),
    CONSTRAINT FK_Vente_Magasin FOREIGN KEY (Clef_Magasin) 
        REFERENCES Dim_Magasin(Clef_Magasin),
    CONSTRAINT FK_Vente_Client FOREIGN KEY (Clef_Client) 
        REFERENCES Dim_Client(Clef_Client),
    CONSTRAINT FK_Vente_Mode_Paiement FOREIGN KEY (Clef_Mode_Paiement) 
        REFERENCES Dim_Mode_Paiement(Clef_Mode_Paiement),
    CONSTRAINT FK_Vente_Produit FOREIGN KEY (Clef_Produit) 
        REFERENCES Dim_Produit(Clef_Produit),
    CONSTRAINT FK_Vente_Promotion FOREIGN KEY (Clef_Promotion) 
        REFERENCES Dim_Promotion(Clef_Promotion)
);

-- Index pour optimiser les requêtes
CREATE INDEX IDX_Vente_Date ON Fait_Vente_Produits(Clef_Date_Paiement);
CREATE INDEX IDX_Vente_Magasin ON Fait_Vente_Produits(Clef_Magasin);
CREATE INDEX IDX_Vente_Produit ON Fait_Vente_Produits(Clef_Produit);
CREATE INDEX IDX_Vente_Client ON Fait_Vente_Produits(Clef_Client);

PRINT 'Data Warehouse créé avec succès!';
GO