DELIMITER $$
CREATE PROCEDURE InitTypeTiers()
BEGIN
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(1, 'GARANT');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(2, 'PROPRIETAIRE');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(3, 'LOCATAIRE');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(4, 'AGENT');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(5, 'CLIENT');
END $$

CREATE PROCEDURE InitTypeLocation()
BEGIN
    INSERT INTO CM_IMMO.TYPE_LOCATION(id, lib) VALUES (1, 'LOCATION_LONGUE');
    INSERT INTO CM_IMMO.TYPE_LOCATION(id, lib) VALUES (2, 'LOCATION_COURTE');
END $$

CREATE PROCEDURE InitTypeBien()
BEGIN
    INSERT INTO CM_IMMO.TYPE_BIEN(id_type_bien, lib_type_bien) VALUES (1, 'MAISON');
    INSERT INTO CM_IMMO.TYPE_BIEN(id_type_bien, lib_type_bien) VALUES (2, 'APPARTEMENT');
END $$

CREATE PROCEDURE InitClasseBien()
BEGIN
    INSERT INTO CM_IMMO.CLASSE_BIEN(id_classe_bien, lib_classe_bien) VALUES (1, 'TEST');
END $$

CREATE PROCEDURE InitChauffage()
BEGIN
    INSERT INTO CM_IMMO.CHAUFFAGE(id_type_chauffage, lib_type_chauffage) VALUES (1, 'TEST');
END $$

CREATE PROCEDURE InitEauChaude()
BEGIN
    INSERT INTO CM_IMMO.EAU_CHAUDE(id_type_eau_chaude, lib_type_eau_chaude) VALUES (1, 'TEST');
END $$

CREATE PROCEDURE InitTypeCritere()
BEGIN
    INSERT INTO CM_IMMO.TYPE_CRITERE(id, lib) VALUES (1, "Logement conforme à l'annonce");
    INSERT INTO CM_IMMO.TYPE_CRITERE(id, lib) VALUES (2, "Qualité de l'accueil");
    INSERT INTO CM_IMMO.TYPE_CRITERE(id, lib) VALUES (3, "Propreté du logement");
    INSERT INTO CM_IMMO.TYPE_CRITERE(id, lib) VALUES (4, "Qualité de l'environnement");
END $$

CREATE PROCEDURE InitTempTiers()
BEGIN
    CREATE TABLE TEMP_TIERS (
           id INT AUTO_INCREMENT,
           nom VARCHAR(200) NOT NULL,
           prenom VARCHAR(200) NOT NULL,
           date_de_naissance DATE NOT NULL,
           PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempQuestions()
BEGIN
    CREATE TEMPORARY TABLE TEMP_QUESTIONS (
        id INT AUTO_INCREMENT,
        texte VARCHAR(500),
        date_publication DATE,
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempReponses()
BEGIN
    CREATE TEMPORARY TABLE TEMP_REPONSES (
        id INT AUTO_INCREMENT,
        id_question INT,
        texte VARCHAR(500),
        date_publication DATE,
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempComments()
BEGIN
    CREATE TEMPORARY TABLE TEMP_COMMENTS (
        id INT AUTO_INCREMENT,
        id_tiers INT,
        id_lcd INT,
        texte VARCHAR(500),
        id_commentaire_original INT,
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE FillTiers(IN nbAuthToCreate INT, IN libelleTiersType VARCHAR(200))
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE randomNom VARCHAR(200);
    DECLARE randomPrenom VARCHAR(200);
    DECLARE randomDateNaissance DATE;
    DECLARE tiersType INT;

    SELECT id_type_tiers INTO tiersType FROM TYPE_TIERS WHERE libelle = libelleTiersType;

    WHILE i < nbAuthToCreate DO
        SELECT nom, prenom, date_de_naissance INTO randomNom, randomPrenom, randomDateNaissance FROM TEMP_TIERS
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO TIERS (type_tiers, nom, prenom, date_de_naissance) VALUES (tiersType, randomNom, randomPrenom, randomDateNaissance);

        SET i = i + 1;
    END WHILE;

END $$
CREATE PROCEDURE GenerateLCDReservations()
BEGIN
    DECLARE currentBien INT;
    DECLARE lastDateFin DATE;
    DECLARE nbReservations, i, randomLocataire, randomMontant INT;
    DECLARE dateDebut, dateFin DATE;
    
    DECLARE bienCursor CURSOR FOR SELECT id_bien FROM BIEN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;
    
    OPEN bienCursor;
    
    bien_loop: LOOP
        FETCH bienCursor INTO currentBien;
        IF finished THEN
            LEAVE bien_loop;
        END IF;
        
        SET lastDateFin = '2022-12-31'; -- Date de départ pour les réservations passées
        SET nbReservations = FLOOR(5 + (RAND() * 5)); -- Générer entre 5 et 10 réservations par bien
        
        bien_reservations: FOR i IN 1..nbReservations DO
            -- Sélection aléatoire d'un locataire
            SELECT id_tiers INTO randomLocataire FROM TIERS WHERE id_type_tiers = 3 ORDER BY RAND() LIMIT 1;
            
            -- Définir les dates de début et fin de réservation sans chevauchement
            SET dateDebut = DATE_ADD(lastDateFin, INTERVAL FLOOR(1 + (RAND() * 30)) DAY);
            SET dateFin = DATE_ADD(dateDebut, INTERVAL FLOOR(15 + (RAND() * 30)) DAY); -- Durée entre 15 et 45 jours
            
            -- Montant aléatoire
            SET randomMontant = FLOOR(300 + (RAND() * 1200));
            
            -- Insertion de la réservation
            INSERT INTO LCD (code_bien, id_locataire, date_debut, date_fin, montant) VALUES (currentBien, randomLocataire, dateDebut, dateFin, randomMontant);
            
            SET lastDateFin = dateFin;
        END FOR;
        
    END LOOP;
    
    CLOSE bienCursor;
END $$

CREATE PROCEDURE FillCommentsWithRandomLCD()
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE curIdTiers INT;
    DECLARE curTexte VARCHAR(500);
    DECLARE curIdCommentaireOriginal INT;
    DECLARE randomIdLCD INT;

    DECLARE commentCursor CURSOR FOR 
        SELECT id_tiers, texte, id_commentaire_original FROM TEMP_COMMENTS;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

    OPEN commentCursor;

    fetch_loop: LOOP
        FETCH commentCursor INTO curIdTiers, curTexte, curIdCommentaireOriginal;
        IF finished THEN
            LEAVE fetch_loop;
        END IF;

        -- Sélection aléatoire d'un id_lcd de la table LCD
        SELECT id INTO randomIdLCD FROM LCD ORDER BY RAND() LIMIT 1;

        -- Insertion du commentaire dans la table COMMENTAIRES
        INSERT INTO COMMENTAIRES (id_tiers, id_lcd, texte, id_commentaire_original)
        VALUES (curIdTiers, randomIdLCD, curTexte, curIdCommentaireOriginal);

    END LOOP;

    CLOSE commentCursor;
END $$


CREATE PROCEDURE FillQuestions()
BEGIN
    INSERT INTO QUESTIONS (texte, date_publication, id_bien, id_tiers)
    SELECT t.texte, t.date_publication,
           (SELECT id_bien FROM BIEN ORDER BY RAND() LIMIT 1),
           (SELECT id_tiers FROM TIERS ORDER BY RAND() LIMIT 1)
    FROM TEMP_QUESTIONS t;
END $$

CREATE PROCEDURE FillReponses()
BEGIN
    INSERT INTO REPONSES (id_question, texte, date_publication, id_tiers)
    SELECT t.id_question, t.texte, t.date_publication,
           (SELECT id_tiers FROM TIERS ORDER BY RAND() LIMIT 1)
    FROM TEMP_REPONSES t;
END $$


CREATE PROCEDURE DeleteTempQuestions()
BEGIN
    DROP TABLE TEMP_QUESTIONS;
END $$

CREATE PROCEDURE DeleteTempReponses()
BEGIN
    DROP TABLE TEMP_REPONSES;
END $$

CREATE PROCEDURE DeleteTempComments()
BEGIN
    DROP TABLE TEMP_COMMENTS;
END $$


CREATE PROCEDURE DeleteTempTiers()
BEGIN
    DROP TABLE TEMP_TIERS;
END $$

CREATE PROCEDURE FillAuths()
BEGIN
     DECLARE fin INT DEFAULT FALSE;
    DECLARE currentIdTiers INT;
    DECLARE randomNomUtilisateur VARCHAR(200);
    DECLARE randomMotDePasse VARCHAR(200);

    DECLARE cursTiers CURSOR FOR SELECT id_tiers FROM TIERS;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    OPEN cursTiers;

    boucleTiers: LOOP
        FETCH cursTiers INTO currentIdTiers;
        IF fin THEN
            LEAVE boucleTiers;
        END IF;

        SELECT nom_utilisateur, mot_de_passe INTO randomNomUtilisateur, randomMotDePasse FROM TEMP_AUTHS
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO AUTH (id_tiers, nom_utilisateur, mot_de_passe) VALUES (currentIdTiers, randomNomUtilisateur, randomMotDePasse);
    END LOOP;

    CLOSE cursTiers;
END $$


CREATE PROCEDURE DeleteTempAuths()
BEGIN
    DROP TABLE TEMP_AUTHS;
END $$

CREATE PROCEDURE InitTempsAuths()
BEGIN
    CREATE TABLE TEMP_AUTHS (
        id INT AUTO_INCREMENT,
        nom_utilisateur VARCHAR(500),
        mot_de_passe VARCHAR(500),
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempBiens()
BEGIN
    CREATE TABLE TEMP_LOCATIONS (
        id_bien INT NOT NULL AUTO_INCREMENT,
        num_rue INT NOT NULL,
        nom_rue VARCHAR(200) NOT NULL,
        ville VARCHAR(200) NOT NULL,
        code_postal VARCHAR(200) NOT NULL,
        PRIMARY KEY (id_bien)
    );
END $$

CREATE PROCEDURE FillBiens(IN nbBiensToCreate INT, IN typeLocationBien VARCHAR(200))
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE randomNumRue INT;
    DECLARE randomNomRue VARCHAR(200);
    DECLARE randomVille VARCHAR(200);
    DECLARE randomCodePostal VARCHAR(200);
    DECLARE idTypeEauChaude INT;
    DECLARE idTypeChauffage INT;
    DECLARE idClasseBien INT;
    DECLARE idTypeBien INT;
    DECLARE idTypeLocation INT;
    DECLARE etage INT;
    DECLARE numAppartement INT;
    DECLARE dateCreation DATE;
    DECLARE surfaceHabitable INT;
    DECLARE nbPieces INT;

    WHILE i < nbBiensToCreate DO
        SELECT num_rue, nom_rue, ville, code_postal INTO randomNumRue, randomNomRue, randomVille, randomCodePostal FROM TEMP_LOCATIONS
        ORDER BY RAND()
        LIMIT 1;

        SELECT id_type_eau_chaude INTO idTypeEauChaude FROM EAU_CHAUDE ORDER BY RAND() LIMIT 1;
        SELECT id_type_chauffage INTO idTypeChauffage FROM CHAUFFAGE ORDER BY RAND() LIMIT 1;
        SELECT id_classe_bien INTO idClasseBien FROM CLASSE_BIEN ORDER BY RAND() LIMIT 1;
        SELECT id_type_bien INTO idTypeBien FROM TYPE_BIEN ORDER BY RAND() LIMIT 1;
        SELECT id INTO idTypeLocation FROM TYPE_LOCATION WHERE lib = typeLocationBien;

        SET etage = FLOOR(RAND() * 10);
        SET numAppartement = FLOOR(RAND() * 50);
        SET dateCreation = CURRENT_DATE();
        SET surfaceHabitable = FLOOR(RAND() * 200);
        SET nbPieces = FLOOR(RAND() * 10);

        INSERT INTO BIEN (id_type_bien, id_classe_bien, id_type_chauffage, id_type_eau_chaude, num_rue, nom_rue, ville, code_postal, etage, num_appartement, date_creation, surface_habitable, nb_pieces, id_type_location) VALUES (idTypeBien, idClasseBien, idTypeChauffage, idTypeEauChaude, randomNumRue, randomNomRue, randomVille, randomCodePostal, etage, numAppartement, dateCreation, surfaceHabitable, nbPieces, idTypeLocation);

        SET i = i + 1;
    END WHILE;


END $$

CREATE PROCEDURE DeleteTempBiens()
BEGIN
    DROP TABLE TEMP_LOCATIONS;
END $$

CREATE PROCEDURE InitAllDefaultTypesTables()
BEGIN
    CALL InitTypeTiers();
    CALL InitTypeLocation();
    CALL InitTypeBien();
    CALL InitClasseBien();
    CALL InitChauffage();
    CALL InitEauChaude();
    CALL InitTypeCritere();
END $$

CREATE PROCEDURE createALlTempTables()
BEGIN
    CALL InitTempsAuths();
    CALL InitTempTiers();
    CALL InitTempBiens();
END $$

CREATE PROCEDURE fillAllTablesFromTempTables()
BEGIN
    CALL FillTiers(350, 'CLIENT');
    CALL FillTiers(30, 'PROPRIETAIRE');
    CALL FillAuths();
    CALL FillBiens(50, 'LOCATION_COURTE');
    CALL FillBiens(10, 'LOCATION_LONGUE');
END $$

CREATE PROCEDURE deleteAllTempTables()
BEGIN
    CALL DeleteTempAuths();
    CALL DeleteTempTiers();
    CALL DeleteTempBiens();
END $$

DELIMITER ;
