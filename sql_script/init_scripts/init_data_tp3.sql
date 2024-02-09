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
    CREATE TABLE TEMP_QUESTIONS (
        id INT AUTO_INCREMENT,
        texte VARCHAR(500),
        date_publication DATE,
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempReponses()
BEGIN
    CREATE TABLE TEMP_REPONSES (
        id INT AUTO_INCREMENT,
        id_question INT,
        texte VARCHAR(500),
        date_publication DATE,
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE InitTempComments()
BEGIN
    CREATE TABLE TEMP_COMMENTS (
        id INT AUTO_INCREMENT,
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

CREATE PROCEDURE GenerateLCDReservations(IN typeTiers VARCHAR(200))
BEGIN
    DECLARE currentBien INT;
    DECLARE lastDateFin DATE;
    DECLARE nbReservations, i, randomLocataire, randomMontant INT;
    DECLARE dateDebut, dateFin DATE;
    DECLARE idTypeTiers INT;
    DECLARE finished INT DEFAULT FALSE;

    DECLARE bienCursor CURSOR FOR SELECT id_bien FROM BIEN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;
    
    OPEN bienCursor;

    SELECT id_type_tiers INTO idTypeTiers FROM TYPE_TIERS WHERE libelle = typeTiers;
    
    bien_loop: LOOP
        FETCH bienCursor INTO currentBien;
        IF finished THEN
            LEAVE bien_loop;
        END IF;
        
        SET lastDateFin = '2022-12-31';
        SET nbReservations = FLOOR(5 + (RAND() * 5));
        
        SET i = 0;
        WHILE i < nbReservations DO
            SELECT id_tiers INTO randomLocataire FROM TIERS WHERE type_tiers = idTypeTiers ORDER BY RAND() LIMIT 1;

            SET dateDebut = DATE_ADD(lastDateFin, INTERVAL FLOOR(1 + (RAND() * 30)) DAY);
            SET dateFin = DATE_ADD(dateDebut, INTERVAL FLOOR(15 + (RAND() * 30)) DAY);

            SET randomMontant = FLOOR(300 + (RAND() * 1200));

            INSERT INTO LCD (code_bien, id_locataire, date_debut, date_fin, montant) VALUES (currentBien, randomLocataire, dateDebut, dateFin, randomMontant);
            
            SET lastDateFin = dateFin;
            SET i = i + 1;
        END WHILE;
    END LOOP;
    
    CLOSE bienCursor;
END $$

CREATE PROCEDURE FillCommentsWithRandomLCD()
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE curIdTiers INT;
    DECLARE codeBien INT;
    DECLARE curTexte VARCHAR(500);
    DECLARE curIdCommentaireOriginal INT;
    DECLARE randomIdLCD INT;
    DECLARE idTypeAgent INT;

    DECLARE commentCursor CURSOR FOR 
        SELECT texte, id_commentaire_original FROM TEMP_COMMENTS;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

    OPEN commentCursor;

    SELECT id_type_tiers INTO idTypeAgent FROM TYPE_TIERS WHERE libelle = 'AGENT';

    fetch_loop: LOOP
        FETCH commentCursor INTO curTexte, curIdCommentaireOriginal;
        IF finished THEN
            LEAVE fetch_loop;
        END IF;

        SELECT id, id_locataire, code_bien INTO randomIdLCD, curIdTiers, codeBien FROM LCD ORDER BY RAND() LIMIT 1;

        IF curIdCommentaireOriginal != 0 THEN
            IF curIdCommentaireOriginal % 2 = 0 THEN
                SELECT id_tiers INTO curIdTiers FROM TIERS WHERE type_tiers = idTypeAgent ORDER BY RAND() LIMIT 1;
            ELSE
                SELECT id_tiers INTO curIdTiers FROM PROPRIETE WHERE id_bien = codeBien ORDER BY RAND() LIMIT 1;
            END IF;
        ELSE
            SET curIdCommentaireOriginal = NULL;
        END IF;

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
           (SELECT id_tiers FROM TIERS JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers WHERE TYPE_TIERS.libelle = 'LOCATAIRE' ORDER BY RAND() LIMIT 1)
    FROM TEMP_QUESTIONS t;
END $$


CREATE PROCEDURE FillReponses()
BEGIN
    INSERT INTO REPONSES (id_question, texte, date_publication, id_tiers)
    SELECT t.id_question, t.texte, t.date_publication,
           CASE WHEN RAND() < 0.5 THEN 
               (SELECT id_tiers FROM TIERS JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers WHERE TYPE_TIERS.libelle = 'LOCATAIRE' ORDER BY RAND() LIMIT 1)
           ELSE
               (SELECT id_tiers FROM TIERS JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers WHERE TYPE_TIERS.libelle = 'PROPRIETAIRE' ORDER BY RAND() LIMIT 1)
           END
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

CREATE PROCEDURE FillProprietes(IN libelleTiersType VARCHAR(200))
BEGIN
    DECLARE fin INT DEFAULT FALSE;
    DECLARE currentIdTiers INT;
    DECLARE currentIdBien INT;
    DECLARE compteurBiens INT DEFAULT 0;
    DECLARE nombreDeTiers INT;
    DECLARE nombreDeBiens INT;
    DECLARE idProprietaire INT;
    DECLARE biensNonAttribues INT;

    DECLARE cursTiers CURSOR FOR SELECT id_tiers FROM TIERS
        INNER JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers
        WHERE TYPE_TIERS.libelle = libelleTiersType;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    OPEN cursTiers;

    SELECT COUNT(*) INTO nombreDeTiers
    FROM TIERS
    INNER JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers
    WHERE TYPE_TIERS.libelle = libelleTiersType;

    SELECT COUNT(*) INTO nombreDeBiens FROM BIEN;

    boucleTiers: LOOP
        FETCH cursTiers INTO currentIdTiers;
        IF fin THEN
            LEAVE boucleTiers;
        END IF;

        SELECT id_bien INTO currentIdBien FROM BIEN
        WHERE id_bien NOT IN (SELECT id_bien FROM PROPRIETE)
        ORDER BY id_bien
        LIMIT 1;

        IF currentIdBien IS NOT NULL THEN
            INSERT INTO PROPRIETE (id_tiers, id_bien, part) VALUES (currentIdTiers, currentIdBien, 1);
            SET compteurBiens = compteurBiens + 1;
            SET currentIdBien = NULL;
        ELSE
            LEAVE boucleTiers;
        END IF;
    END LOOP;

    SET biensNonAttribues = compteurBiens + 1;
    WHILE biensNonAttribues <= nombreDeBiens DO
        SELECT id_bien INTO currentIdBien FROM BIEN
        WHERE id_bien NOT IN (SELECT id_bien FROM PROPRIETE)
        ORDER BY id_bien
        LIMIT 1;

        IF currentIdBien IS NOT NULL THEN
            SELECT id_tiers INTO idProprietaire FROM TIERS
            INNER JOIN TYPE_TIERS ON TIERS.type_tiers = TYPE_TIERS.id_type_tiers
            WHERE TYPE_TIERS.libelle = libelleTiersType
            ORDER BY RAND()
            LIMIT 1;

            INSERT INTO PROPRIETE (id_tiers, id_bien, part) VALUES (idProprietaire, currentIdBien, 1);
        END IF;
        SET biensNonAttribues = biensNonAttribues + 1;
    END WHILE;

    CLOSE cursTiers;
END $$

CREATE PROCEDURE DeleteProprietes()
BEGIN
    DELETE FROM PROPRIETE;
END $$

CREATE PROCEDURE FillRetourClients()
BEGIN
    DECLARE fin INT DEFAULT FALSE;
    DECLARE currentLCD INT;
    DECLARE currentClient INT;
    DECLARE currentComment INT;

    DECLARE cursLCD CURSOR FOR SELECT id, id_locataire FROM LCD WHERE date_fin < CURRENT_DATE();

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    OPEN cursLCD;

    boucleLCD: LOOP
        FETCH cursLCD INTO currentLCD, currentClient;
        IF fin THEN
            LEAVE boucleLCD;
        END IF;

        SELECT id INTO currentComment FROM COMMENTAIRES WHERE id NOT IN (SELECT id_commentaire FROM RETOUR_CLIENT) ORDER BY RAND() LIMIT 1;

        IF currentComment IS NOT NULL THEN
            INSERT INTO RETOUR_CLIENT (id_commentaire, id_lcd, id_tiers) VALUES (currentComment, currentLCD, currentClient);

        END IF;

    END LOOP;

    CLOSE cursLCD;
END $$

CREATE PROCEDURE DeleteRetourClients()
BEGIN
    DELETE FROM RETOUR_CLIENT;
END $$

CREATE PROCEDURE FillNoteParCritere()
BEGIN
    DECLARE fin INT DEFAULT FALSE;
    DECLARE currentRetourClient INT;
    DECLARE currentCritere INT;
    DECLARE nbCritere INT;

    DECLARE cursRetourClient CURSOR FOR SELECT id FROM RETOUR_CLIENT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    OPEN cursRetourClient;

    SELECT COUNT(*) INTO nbCritere FROM TYPE_CRITERE;

    bloucleRetourClient: LOOP
        FETCH cursRetourClient INTO currentRetourClient;
        IF fin THEN
            LEAVE bloucleRetourClient;
        END IF;

        SET currentCritere = 1;
        WHILE currentCritere <= nbCritere DO
            INSERT INTO NOTE_PAR_CRITERE (id_retour, id_type_critere, note) VALUES (currentRetourClient, currentCritere, FLOOR(RAND() * 5) + 1);
            SET currentCritere = currentCritere + 1;
        END WHILE;
    END LOOP;

END $$

CREATE PROCEDURE DeleteNoteParCritere()
BEGIN
    DELETE FROM NOTE_PAR_CRITERE;
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
    CALL InitTempComments();
    CALL InitTempReponses();
    CALL InitTempQuestions();
END $$

CREATE PROCEDURE fillAllTablesFromTempTables()
BEGIN
    CALL FillTiers(350, 'CLIENT');
    CALL FillTiers(30, 'PROPRIETAIRE');
    CALL FillTiers(30, 'AGENT');
    CALL FillAuths();
    CALL FillBiens(50, 'LOCATION_COURTE');
    CALL FillBiens(10, 'LOCATION_LONGUE');
    CALL FillProprietes('PROPRIETAIRE');
    CALL GenerateLCDReservations('CLIENT');
    CALL FillCommentsWithRandomLCD();
#     CALL FillRetourClients();
#     CALL FillNoteParCritere();
    CALL FillQuestions();
    CALL FillReponses();
END $$

CREATE PROCEDURE deleteAllTempTables()
BEGIN
    CALL DeleteTempComments();
    CALL DeleteTempReponses();
    CALL DeleteTempQuestions();
    CALL DeleteProprietes();
    CALL DeleteTempAuths();
    CALL DeleteTempTiers();
    CALL DeleteTempBiens();
END $$

DELIMITER ;
