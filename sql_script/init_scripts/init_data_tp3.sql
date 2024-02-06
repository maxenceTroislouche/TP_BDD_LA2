DELIMITER $$
CREATE PROCEDURE InitTypeTiers()
BEGIN
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(1, 'GARANT');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(2, 'PROPRIETAIRE');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(3, 'LOCATAIRE');
    INSERT INTO CM_IMMO.TYPE_TIERS(id_type_tiers, libelle) VALUES(4, 'AGENT');
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
        id INT NOT NULL,
        nom_utilisateur VARCHAR(500),
        mot_de_passe VARCHAR(500),
        PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE FillAndDeleteTempAuths()
BEGIN
    DROP TABLE AUTH;
END $$

CREATE PROCEDURE InitTempTiers()
BEGIN
    CREATE TABLE TEMP_TIERS (
           id INT NOT NULL AUTO_INCREMENT,
           nom VARCHAR(200) NOT NULL,
           prenom VARCHAR(200) NOT NULL,
           date_de_naissance DATE NOT NULL,
           PRIMARY KEY (id)
    );
END $$

CREATE PROCEDURE FillAndDeleteTempTiers()
BEGIN
    DROP TABLE TEMP_TIER;
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

CREATE PROCEDURE fillTablesAndDeleteAllTempTable()
BEGIN
    CALL FillAndDeleteTempTiers();
    CALL FillAndDeleteTempAuths();
END $$
DELIMITER ;
