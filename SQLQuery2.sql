-- =============================================
-- SCRIPT 2: IMPORT DES DONNEES DEPUIS CSV
-- VERSION FINALE CORRIGEE
-- =============================================

USE DW_Ventes;
GO

PRINT '========================================';
PRINT 'DEBUT DE L IMPORT DES FICHIERS CSV';
PRINT '========================================';
PRINT '';

-- IMPORTANT : adapter le chemin si nécessaire
DECLARE @CheminCSV VARCHAR(200) = 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data';

-- =============================================
-- 1. IMPORT DIM_CALENDRIER
-- =============================================
PRINT 'Import Dim_Calendrier...';

BULK INSERT Dim_Calendrier
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Calendrier.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountCal INT;
SELECT @CountCal = COUNT(*) FROM Dim_Calendrier;
PRINT 'Dim_Calendrier: ' + CAST(@CountCal AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 2. IMPORT DIM_TEMPS
-- =============================================
PRINT 'Import Dim_Temps...';

BULK INSERT Dim_Temps
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Temps.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountTemps INT;
SELECT @CountTemps = COUNT(*) FROM Dim_Temps;
PRINT 'Dim_Temps: ' + CAST(@CountTemps AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 3. IMPORT DIM_MAGASIN
-- =============================================
PRINT 'Import Dim_Magasin...';

BULK INSERT Dim_Magasin
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Magasin.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountMag INT;
SELECT @CountMag = COUNT(*) FROM Dim_Magasin;
PRINT 'Dim_Magasin: ' + CAST(@CountMag AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 4. IMPORT DIM_CAISSE
-- =============================================
PRINT 'Import Dim_Caisse...';

BULK INSERT Dim_Caisse
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Caisse.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountCaisse INT;
SELECT @CountCaisse = COUNT(*) FROM Dim_Caisse;
PRINT 'Dim_Caisse: ' + CAST(@CountCaisse AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 5. IMPORT DIM_MODE_PAIEMENT
-- =============================================
PRINT 'Import Dim_Mode_Paiement...';

BULK INSERT Dim_Mode_Paiement
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Mode_Paiement.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountMP INT;
SELECT @CountMP = COUNT(*) FROM Dim_Mode_Paiement;
PRINT 'Dim_Mode_Paiement: ' + CAST(@CountMP AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 6. IMPORT DIM_CLIENT
-- =============================================
PRINT 'Import Dim_Client...';

BULK INSERT Dim_Client
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Client.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountClient INT;
SELECT @CountClient = COUNT(*) FROM Dim_Client;
PRINT 'Dim_Client: ' + CAST(@CountClient AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 7. IMPORT DIM_PRODUIT
-- =============================================
PRINT 'Import Dim_Produit...';

BULK INSERT Dim_Produit
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Produit.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountProd INT;
SELECT @CountProd = COUNT(*) FROM Dim_Produit;
PRINT 'Dim_Produit: ' + CAST(@CountProd AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 8. IMPORT DIM_PROMOTION
-- =============================================
PRINT 'Import Dim_Promotion...';

BULK INSERT Dim_Promotion
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Dim_Promotion.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountPromo INT;
SELECT @CountPromo = COUNT(*) FROM Dim_Promotion;
PRINT 'Dim_Promotion: ' + CAST(@CountPromo AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- 9. IMPORT FAIT_VENTE_PRODUITS
-- =============================================
PRINT 'Import Fait_Vente_Produits...';

BULK INSERT Fait_Vente_Produits
FROM 'C:\Users\DELL\Desktop\PFE_BD\data_ware_house\data\Fait_Vente_Produits.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DECLARE @CountFait INT;
SELECT @CountFait = COUNT(*) FROM Fait_Vente_Produits;
PRINT 'Fait_Vente_Produits: ' + CAST(@CountFait AS VARCHAR) + ' lignes importees';
PRINT '';

-- =============================================
-- RESUME DES IMPORTS (CORRIGE)
-- =============================================
DECLARE 
    @cCal INT,
    @cTemps INT,
    @cMag INT,
    @cCaisse INT,
    @cMP INT,
    @cClient INT,
    @cProd INT,
    @cPromo INT,
    @cFaitTotal INT;

SELECT @cCal        = COUNT(*) FROM Dim_Calendrier;
SELECT @cTemps      = COUNT(*) FROM Dim_Temps;
SELECT @cMag        = COUNT(*) FROM Dim_Magasin;
SELECT @cCaisse     = COUNT(*) FROM Dim_Caisse;
SELECT @cMP         = COUNT(*) FROM Dim_Mode_Paiement;
SELECT @cClient     = COUNT(*) FROM Dim_Client;
SELECT @cProd       = COUNT(*) FROM Dim_Produit;
SELECT @cPromo      = COUNT(*) FROM Dim_Promotion;
SELECT @cFaitTotal  = COUNT(*) FROM Fait_Vente_Produits;

PRINT '';
PRINT '========================================';
PRINT 'RESUME DES IMPORTS';
PRINT '========================================';
PRINT 'Dim_Calendrier:       ' + CAST(@cCal AS VARCHAR)       + ' lignes';
PRINT 'Dim_Temps:            ' + CAST(@cTemps AS VARCHAR)     + ' lignes';
PRINT 'Dim_Magasin:          ' + CAST(@cMag AS VARCHAR)       + ' lignes';
PRINT 'Dim_Caisse:           ' + CAST(@cCaisse AS VARCHAR)    + ' lignes';
PRINT 'Dim_Mode_Paiement:    ' + CAST(@cMP AS VARCHAR)        + ' lignes';
PRINT 'Dim_Client:           ' + CAST(@cClient AS VARCHAR)    + ' lignes';
PRINT 'Dim_Produit:          ' + CAST(@cProd AS VARCHAR)      + ' lignes';
PRINT 'Dim_Promotion:        ' + CAST(@cPromo AS VARCHAR)     + ' lignes';
PRINT 'Fait_Vente_Produits:  ' + CAST(@cFaitTotal AS VARCHAR) + ' lignes';
PRINT '========================================';
PRINT '';

-- =============================================
-- VERIFICATION DE L INTEGRITE
-- =============================================
PRINT 'Verification de l integrite...';
PRINT '';

IF EXISTS (
    SELECT 1 FROM Fait_Vente_Produits f
    LEFT JOIN Dim_Calendrier c ON f.Clef_Date_Paiement = c.Clef_Date
    WHERE c.Clef_Date IS NULL
)
    PRINT 'ERREUR: Dates invalides detectees';
ELSE
    PRINT 'OK: Toutes les dates sont valides';

IF EXISTS (
    SELECT 1 FROM Fait_Vente_Produits f
    LEFT JOIN Dim_Client c ON f.Clef_Client = c.Clef_Client
    WHERE c.Clef_Client IS NULL
)
    PRINT 'ERREUR: Clients invalides detectes';
ELSE
    PRINT 'OK: Tous les clients sont valides';

IF EXISTS (
    SELECT 1 FROM Fait_Vente_Produits f
    LEFT JOIN Dim_Produit p ON f.Clef_Produit = p.Clef_Produit
    WHERE p.Clef_Produit IS NULL
)
    PRINT 'ERREUR: Produits invalides detectes';
ELSE
    PRINT 'OK: Tous les produits sont valides';

PRINT '';
PRINT '========================================';
PRINT 'IMPORT TERMINE AVEC SUCCES!';
PRINT '========================================';
PRINT '';

-- =============================================
-- ECHANTILLON DE DONNEES
-- =============================================
SELECT TOP 10
    c.Date_Complete AS Date_Vente,
    t.Temps AS Heure,
    m.Nom_Magasin,
    cl.Nom_Client + ' ' + cl.Prenom_Client AS Client,
    p.Description_Produit AS Produit,
    f.Quantite,
    f.Montant_Unitaire,
    f.Montant_Final,
    ISNULL(pr.Nom_Promotion, 'Sans promo') AS Promotion
FROM Fait_Vente_Produits f
INNER JOIN Dim_Calendrier c ON f.Clef_Date_Paiement = c.Clef_Date
INNER JOIN Dim_Temps t ON f.Clef_Heure_Paiement = t.Clef_Temps
INNER JOIN Dim_Magasin m ON f.Clef_Magasin = m.Clef_Magasin
INNER JOIN Dim_Client cl ON f.Clef_Client = cl.Clef_Client
INNER JOIN Dim_Produit p ON f.Clef_Produit = p.Clef_Produit
LEFT JOIN Dim_Promotion pr ON f.Clef_Promotion = pr.Clef_Promotion
ORDER BY c.Date_Complete DESC, t.Temps DESC;
GO

-- =============================================
-- DIM_CALENDRIER
-- =============================================
PRINT 'Dim_Calendrier (5 lignes)';
SELECT TOP 5 * FROM Dim_Calendrier ORDER BY Clef_Date;
PRINT '';

-- =============================================
-- DIM_TEMPS
-- =============================================
PRINT 'Dim_Temps (5 lignes)';
SELECT TOP 5 * FROM Dim_Temps ORDER BY Clef_Temps;
PRINT '';

-- =============================================
-- DIM_MAGASIN
-- =============================================
PRINT 'Dim_Magasin (5 lignes)';
SELECT TOP 5 * FROM Dim_Magasin ORDER BY Clef_Magasin;
PRINT '';

-- =============================================
-- DIM_CAISSE
-- =============================================
PRINT 'Dim_Caisse (5 lignes)';
SELECT TOP 5 * FROM Dim_Caisse ORDER BY Clef_Caisse;
PRINT '';

-- =============================================
-- DIM_MODE_PAIEMENT
-- =============================================
PRINT 'Dim_Mode_Paiement (5 lignes)';
SELECT TOP 5 * FROM Dim_Mode_Paiement ORDER BY Clef_Mode_Paiement;
PRINT '';

-- =============================================
-- DIM_CLIENT
-- =============================================
PRINT 'Dim_Client (5 lignes)';
SELECT TOP 5 * FROM Dim_Client ORDER BY Clef_Client;
PRINT '';

-- =============================================
-- DIM_PRODUIT
-- =============================================
PRINT 'Dim_Produit (5 lignes)';
SELECT TOP 5 * FROM Dim_Produit ORDER BY Clef_Produit;
PRINT '';

-- =============================================
-- DIM_PROMOTION
-- =============================================
PRINT 'Dim_Promotion (5 lignes)';
SELECT TOP 5 * FROM Dim_Promotion ORDER BY Clef_Promotion;
PRINT '';

-- =============================================
-- FAIT_VENTE_PRODUITS
-- =============================================
PRINT 'Fait_Vente_Produits (5 lignes)';
SELECT TOP 5 * FROM Fait_Vente_Produits ORDER BY Clef_Date_Paiement, Clef_Heure_Paiement;
PRINT '';

PRINT '========================================';
PRINT 'FIN DES ECHANTILLONS';
PRINT '========================================';
