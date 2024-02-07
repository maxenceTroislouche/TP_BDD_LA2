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
    INSERT INTO CM_IMMO.TYPE_LOCATION(id, lib) VALUES (1, "Location longue durée");
    INSERT INTO CM_IMMO.TYPE_LOCATION(id, lib) VALUES (2, "Location courte durée");
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

CREATE PROCEDURE InitTempsAuths()
BEGIN
    CREATE TABLE TEMP_AUTHS (
        id INT AUTO_INCREMENT,
        nom_utilisateur VARCHAR(500),
        mot_de_passe VARCHAR(500),
        PRIMARY KEY (id)
    );
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
END $$

CREATE PROCEDURE fillAllTablesFromTempTables()
BEGIN
    CALL FillTiers(350, 'CLIENT');
    CALL FillTiers(30, 'PROPRIETAIRE');
    CALL FillAuths();
END $$

CREATE PROCEDURE deleteAllTempTables()
BEGIN
    CALL DeleteTempAuths();
    CALL DeleteTempTiers();
END $$

DELIMITER ;
