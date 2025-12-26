-- ============================================================
-- SCRIPT 3 : ANALYSE & KPIs – DATA WAREHOUSE
-- ============================================================
-- Objectifs :
-- 1. Analyse ABC des produits
-- 2. Cohort analysis des clients
-- 3. Prévisions de ventes (tendance)
-- 4. Score de performance par magasin
-- 5. Analyse de panier (Market Basket Analysis)
-- 6. KPI supplémentaires (matière DW)
-- ============================================================

USE DW_Ventes;
GO

PRINT '============================================';
PRINT 'DEBUT SCRIPT 3 : ANALYSE & KPIs';
PRINT '============================================';
PRINT '';

/* ============================================================
   KPI 1 : ANALYSE ABC DES PRODUITS
   ============================================================ */
PRINT 'KPI 1 : ANALYSE ABC DES PRODUITS';

WITH CA_Produit AS (
    SELECT
        p.Clef_Produit,
        p.Description_Produit,
        SUM(f.Montant_Final) AS CA_Produit
    FROM Fait_Vente_Produits f
    JOIN Dim_Produit p ON f.Clef_Produit = p.Clef_Produit
    GROUP BY p.Clef_Produit, p.Description_Produit
),
CA_Cumule AS (
    SELECT *,
        SUM(CA_Produit) OVER () AS CA_Total,
        SUM(CA_Produit) OVER (ORDER BY CA_Produit DESC) AS CA_Cumule
    FROM CA_Produit
)
SELECT
    Clef_Produit,
    Description_Produit,
    CA_Produit,
    CAST(CA_Cumule * 100.0 / CA_Total AS DECIMAL(5,2)) AS Pourcentage_Cumule,
    CASE
        WHEN CA_Cumule / CA_Total <= 0.80 THEN 'A'
        WHEN CA_Cumule / CA_Total <= 0.95 THEN 'B'
        ELSE 'C'
    END AS Classe_ABC
FROM CA_Cumule
ORDER BY CA_Produit DESC;

PRINT '';

/* ============================================================
   KPI 2 : COHORT ANALYSIS DES CLIENTS
   ============================================================ */
PRINT 'KPI 2 : COHORT ANALYSIS DES CLIENTS';

WITH FirstPurchase AS (
    SELECT
        Clef_Client,
        MIN(c.Annee * 100 + c.Mois) AS Cohort_Mois
    FROM Fait_Vente_Produits f
    JOIN Dim_Calendrier c ON f.Clef_Date_Paiement = c.Clef_Date
    GROUP BY Clef_Client
),
ClientActivity AS (
    SELECT
        f.Clef_Client,
        fp.Cohort_Mois,
        (c.Annee * 100 + c.Mois) AS Mois_Activite
    FROM Fait_Vente_Produits f
    JOIN Dim_Calendrier c ON f.Clef_Date_Paiement = c.Clef_Date
    JOIN FirstPurchase fp ON f.Clef_Client = fp.Clef_Client
)
SELECT
    Cohort_Mois,
    Mois_Activite,
    COUNT(DISTINCT Clef_Client) AS Nombre_Clients
FROM ClientActivity
GROUP BY Cohort_Mois, Mois_Activite
ORDER BY Cohort_Mois, Mois_Activite;

PRINT '';

/* ============================================================
   KPI 3 : PREVISION DES VENTES (TENDANCE MENSUELLE)
   ============================================================ */
PRINT 'KPI 3 : PREVISION DES VENTES (TENDANCE)';

SELECT
    c.Annee,
    c.Mois,
    SUM(f.Montant_Final) AS CA_Mensuel
FROM Fait_Vente_Produits f
JOIN Dim_Calendrier c ON f.Clef_Date_Paiement = c.Clef_Date
GROUP BY c.Annee, c.Mois
ORDER BY c.Annee, c.Mois;

PRINT '';

/* ============================================================
   KPI 4 : SCORE DE PERFORMANCE PAR MAGASIN
   ============================================================ */
PRINT 'KPI 4 : SCORE DE PERFORMANCE PAR MAGASIN';

SELECT
    m.Nom_Magasin,
    SUM(f.Montant_Final) AS CA_Total,
    SUM(f.Marge_Brute) AS Marge_Totale,
    COUNT(DISTINCT f.ID_Paiement) AS Nombre_Ventes,
    CAST(SUM(f.Montant_Final) / COUNT(DISTINCT f.ID_Paiement) AS DECIMAL(10,2)) AS Panier_Moyen
FROM Fait_Vente_Produits f
JOIN Dim_Magasin m ON f.Clef_Magasin = m.Clef_Magasin
GROUP BY m.Nom_Magasin
ORDER BY CA_Total DESC;

PRINT '';


/* ============================================================
   KPI 6 : TOP PRODUITS PAR MARGE
   ============================================================ */
PRINT 'KPI 6 : TOP PRODUITS PAR MARGE';

SELECT
    p.Description_Produit,
    SUM(f.Marge_Brute) AS Marge_Totale
FROM Fait_Vente_Produits f
JOIN Dim_Produit p ON f.Clef_Produit = p.Clef_Produit
GROUP BY p.Description_Produit
ORDER BY Marge_Totale DESC;

PRINT '';

/* ============================================================
   KPI 7 : TAUX D UTILISATION DES PROMOTIONS
   ============================================================ */
PRINT 'KPI 7 : TAUX D UTILISATION DES PROMOTIONS';

SELECT
    COUNT(*) AS Ventes_Totales,
    SUM(CASE WHEN Clef_Promotion IS NOT NULL THEN 1 ELSE 0 END) AS Ventes_Avec_Promo,
    CAST(
        100.0 * SUM(CASE WHEN Clef_Promotion IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Taux_Promotion_Pct
FROM Fait_Vente_Produits;

PRINT '';

/* ============================================================
   KPI 8 : PANIER MOYEN PAR CLIENT
   ============================================================ */
PRINT 'KPI 8 : PANIER MOYEN PAR CLIENT';

SELECT
    cl.Nom_Client,
    cl.Prenom_Client,
    CAST(SUM(f.Montant_Final) / COUNT(DISTINCT f.ID_Paiement) AS DECIMAL(10,2)) AS Panier_Moyen
FROM Fait_Vente_Produits f
JOIN Dim_Client cl ON f.Clef_Client = cl.Clef_Client
GROUP BY cl.Nom_Client, cl.Prenom_Client
ORDER BY Panier_Moyen DESC;

PRINT '';

PRINT '============================================';
PRINT 'FIN SCRIPT 3 : TOUS LES KPIs ONT ETE EXECUTES';
PRINT '============================================';
GO
