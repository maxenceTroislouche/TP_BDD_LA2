DELIMITER $$

CREATE PROCEDURE Create_CM_IMMO_DB()
BEGIN
    CREATE TABLE TIERS (
        id_tiers INT NOT NULL AUTO_INCREMENT,
        type_tiers INT NOT NULL,
        nom VARCHAR(200) NOT NULL,
        prenom VARCHAR(200) NOT NULL,
        date_de_naissance DATE NOT NULL,

        PRIMARY KEY (id_tiers)
    );

    CREATE TABLE TYPE_TIERS (
        id_type_tiers INT NOT NULL AUTO_INCREMENT COMMENT '1: GARANT, 2: PROPRIETAIRE, 3: LOCATAIRE, 4: AGENT',
        libelle VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_tiers)
    );

    ALTER TABLE TIERS ADD FOREIGN KEY (type_tiers) REFERENCES TYPE_TIERS(id_type_tiers);

    CREATE TABLE TYPE_BIEN (
        id_type_bien INT NOT NULL AUTO_INCREMENT,
        lib_type_bien VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_bien)
    );

    CREATE TABLE CLASSE_BIEN (
        id_classe_bien INT NOT NULL AUTO_INCREMENT,
        lib_classe_bien VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_classe_bien)
    );

    CREATE TABLE CHAUFFAGE (
        id_type_chauffage INT NOT NULL AUTO_INCREMENT,
        lib_type_chauffage VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_chauffage)
    );

    CREATE TABLE EAU_CHAUDE (
        id_type_eau_chaude INT NOT NULL AUTO_INCREMENT,
        lib_type_eau_chaude VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_eau_chaude)
    );

    CREATE TABLE BIEN (
        id_bien INT NOT NULL AUTO_INCREMENT,
        num_rue INT NOT NULL,
        nom_rue VARCHAR(200) NOT NULL,
        ville VARCHAR(200) NOT NULL,
        code_postal INT NOT NULL,
        etage INT,
        num_appartement INT,
        date_creation DATE NOT NULL,
        surface_habitable INT NOT NULL,
        id_type_eau_chaude INT NOT NULL,
        id_type_chauffage INT NOT NULL,
        id_classe_bien INT NOT NULL,
        id_type_bien INT NOT NULL,
        nb_pieces INT NOT NULL,

        PRIMARY KEY (id_bien)
    );

    ALTER TABLE BIEN ADD FOREIGN KEY (id_type_eau_chaude) REFERENCES EAU_CHAUDE(id_type_eau_chaude);
    ALTER TABLE BIEN ADD FOREIGN KEY (id_type_chauffage) REFERENCES CHAUFFAGE(id_type_chauffage);
    ALTER TABLE BIEN ADD FOREIGN KEY (id_classe_bien) REFERENCES CLASSE_BIEN(id_classe_bien);
    ALTER TABLE BIEN ADD FOREIGN KEY (id_type_bien) REFERENCES TYPE_BIEN(id_type_bien);

    CREATE TABLE PROPRIETE (
        id_tiers INT NOT NULL,
        id_bien INT NOT NULL,
        part FLOAT NOT NULL,

        PRIMARY KEY (id_tiers, id_bien)
    );

    ALTER TABLE PROPRIETE ADD FOREIGN KEY (id_bien) REFERENCES BIEN(id_bien);
    ALTER TABLE PROPRIETE ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);

    CREATE TABLE DESTINATION (
        id_destination INT NOT NULL AUTO_INCREMENT,
        lib_destination VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_destination)
    );

    CREATE TABLE BAIL (
        id_tiers_agent INT NOT NULL,
        id_bail INT NOT NULL AUTO_INCREMENT,
        code_bien INT NOT NULL,
        etat INT DEFAULT 1 COMMENT '1: en cours, 2: complet, 3: signé, 4: reglé, 5: terminé',
        montant_loyer FLOAT,
        montant_depot FLOAT,
        irl FLOAT,

        PRIMARY KEY (id_bail)
    );

    ALTER TABLE BAIL ADD FOREIGN KEY (code_bien) REFERENCES BIEN(id_bien);
    ALTER TABLE BAIL ADD FOREIGN KEY (id_tiers_agent) REFERENCES TIERS(id_tiers);

    CREATE TABLE TYPE_SIGNATURE (
        id_type_signature INT NOT NULL COMMENT '1: GARANT, 2: PROPRIETAIRE, 3: LOCATAIRE, 4: AGENT',
        lib_type_signature VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_signature)
    );

    CREATE TABLE SIGNATURE (
        id_tiers INT NOT NULL,
        id_bail INT NOT NULL,
        id_type_signature INT NOT NULL,
        date_signature DATE,

        PRIMARY KEY (id_tiers, id_bail, id_type_signature)
    );

    ALTER TABLE SIGNATURE ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);
    ALTER TABLE SIGNATURE ADD FOREIGN KEY (id_bail) REFERENCES BAIL(id_bail);
    ALTER TABLE SIGNATURE ADD FOREIGN KEY (id_type_signature) REFERENCES TYPE_SIGNATURE(id_type_signature);

    CREATE TABLE TYPE_HONORAIRE (
        id_type_honoraire INT NOT NULL,
        lib_type_honoraire VARCHAR(200) NOT NULL,

        PRIMARY KEY (id_type_honoraire)
    );

    CREATE TABLE HONORAIRE (
        montant FLOAT,
        date_reglement DATE,
        id_type_honoraire INT NOT NULL,
        id_bail INT NOT NULL,
        id_tiers INT NOT NULL,

        PRIMARY KEY (id_type_honoraire, id_bail, id_tiers)
    );

    ALTER TABLE HONORAIRE ADD FOREIGN KEY (id_type_honoraire) REFERENCES TYPE_HONORAIRE(id_type_honoraire);
    ALTER TABLE HONORAIRE ADD FOREIGN KEY (id_bail) REFERENCES BAIL(id_bail);
    ALTER TABLE HONORAIRE ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);

    CREATE TABLE AUTH (
        id_tiers INT AUTO_INCREMENT,
        nom_utilisateur VARCHAR(500),
        mot_de_passe VARCHAR(500),

        PRIMARY KEY (id_tiers)
    );

    ALTER TABLE AUTH ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);

    CREATE TABLE TYPE_LOCATION (
        id INT NOT NULL AUTO_INCREMENT,
        lib VARCHAR(500),

        PRIMARY KEY (id)
    );

    CREATE TABLE PHOTO (
        id INT NOT NULL AUTO_INCREMENT,
        url VARCHAR(500),

        PRIMARY KEY (id)
    );

    /* Location longue durée */
    CREATE TABLE LCD (
        id INT NOT NULL AUTO_INCREMENT,
        code_bien INT NOT NULL,
        id_locataire INT NOT NULL,
        date_debut DATE NOT NULL,
        date_fin DATE NOT NULL,
        montant FLOAT NOT NULL,

        PRIMARY KEY (id)
    );

    ALTER TABLE LCD ADD FOREIGN KEY (code_bien) REFERENCES BIEN(id_bien);
    ALTER TABLE LCD ADD FOREIGN KEY (id_locataire) REFERENCES TIERS(id_tiers);


    CREATE TABLE COMMENTAIRES (
        id INT NOT NULL,
        id_tiers INT NOT NULL,
        id_lcd INT NOT NULL,
        texte VARCHAR(500),
        id_commentaire_original INT,

        PRIMARY KEY (id)
    );

    ALTER TABLE COMMENTAIRES ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);
    ALTER TABLE COMMENTAIRES ADD FOREIGN KEY (id_lcd) REFERENCES LCD(id);
    ALTER TABLE COMMENTAIRES ADD FOREIGN KEY (id_commentaire_original) REFERENCES COMMENTAIRES(id);

    CREATE TABLE RETOUR_CLIENT (
        id INT NOT NULL,
        id_tiers INT NOT NULL,
        id_lcd INT NOT NULL UNIQUE,
        id_commentaire INT,

        PRIMARY KEY (id)
    );

    ALTER TABLE RETOUR_CLIENT ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);
    ALTER TABLE RETOUR_CLIENT ADD FOREIGN KEY (id_lcd) REFERENCES LCD(id);
    ALTER TABLE RETOUR_CLIENT ADD FOREIGN KEY (id_commentaire) REFERENCES COMMENTAIRES(id);

    CREATE TABLE TYPE_CRITERE (
        id INT NOT NULL,
        lib VARCHAR(200) NOT NULL,

        PRIMARY KEY (id)
    );

    CREATE TABLE NOTE_PAR_CRITERE (
        id_type_critere INT NOT NULL,
        id_retour INT NOT NULL,
        note INT NOT NULL,

        PRIMARY KEY (id_type_critere, id_retour)
    );

    ALTER TABLE NOTE_PAR_CRITERE ADD FOREIGN KEY (id_type_critere) REFERENCES TYPE_CRITERE(id);
    ALTER TABLE NOTE_PAR_CRITERE ADD FOREIGN KEY (id_retour) REFERENCES RETOUR_CLIENT(id);

    CREATE TABLE PHOTO_COMMENTAIRE (
        id_photo INT NOT NULL,
        id_commentaire INT NOT NULL,

        PRIMARY KEY (id_photo, id_commentaire)
    );

    ALTER TABLE PHOTO_COMMENTAIRE ADD FOREIGN KEY (id_photo) REFERENCES PHOTO(id);
    ALTER TABLE PHOTO_COMMENTAIRE ADD FOREIGN KEY (id_commentaire) REFERENCES COMMENTAIRES(id);

    CREATE TABLE QUESTIONS (
        id INT NOT NULL AUTO_INCREMENT,
        id_bien INT NOT NULL,
        id_tiers INT NOT NULL,
        texte VARCHAR(500),
        date_publication DATE NOT NULL,

        PRIMARY KEY (id)
    );

    ALTER TABLE QUESTIONS ADD FOREIGN KEY (id_bien) REFERENCES BIEN(id_bien);
    ALTER TABLE QUESTIONS ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);

    CREATE TABLE REPONSES (
        id INT NOT NULL AUTO_INCREMENT,
        id_tiers INT NOT NULL,
        id_question INT NOT NULL,
        date_publication DATE NOT NULL,
        texte VARCHAR(500),

        PRIMARY KEY (id)
    );

    ALTER TABLE REPONSES ADD FOREIGN KEY (id_tiers) REFERENCES TIERS(id_tiers);
    ALTER TABLE REPONSES ADD FOREIGN KEY (id_question) REFERENCES QUESTIONS(id);

    ALTER TABLE BIEN ADD id_type_location INT NOT NULL;
    ALTER TABLE BIEN ADD FOREIGN KEY (id_type_location) REFERENCES TYPE_LOCATION(id);
END $$

CREATE PROCEDURE Delete_Tables_CM_IMMO()
BEGIN
    DROP TABLE IF EXISTS CM_IMMO.AUTH;
    DROP TABLE IF EXISTS CM_IMMO.PROPRIETE;
    DROP TABLE IF EXISTS CM_IMMO.REPONSES;
    DROP TABLE IF EXISTS CM_IMMO.QUESTIONS;
    DROP TABLE IF EXISTS CM_IMMO.SIGNATURE;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_SIGNATURE;
    DROP TABLE IF EXISTS CM_IMMO.NOTE_PAR_CRITERE;
    DROP TABLE IF EXISTS CM_IMMO.RETOUR_CLIENT;
    DROP TABLE IF EXISTS CM_IMMO.PHOTO_COMMENTAIRE;
    DROP TABLE IF EXISTS CM_IMMO.COMMENTAIRES;
    DROP TABLE IF EXISTS CM_IMMO.PHOTO;
    DROP TABLE IF EXISTS CM_IMMO.HONORAIRE;
    DROP TABLE IF EXISTS CM_IMMO.LCD;
    DROP TABLE IF EXISTS CM_IMMO.BAIL;
    DROP TABLE IF EXISTS CM_IMMO.BIEN;
    DROP TABLE IF EXISTS CM_IMMO.DESTINATION;
    DROP TABLE IF EXISTS CM_IMMO.CHAUFFAGE;
    DROP TABLE IF EXISTS CM_IMMO.CLASSE_BIEN;
    DROP TABLE IF EXISTS CM_IMMO.TIERS;
    DROP TABLE IF EXISTS CM_IMMO.EAU_CHAUDE;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_BIEN;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_TIERS;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_LOCATION;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_HONORAIRE;
    DROP TABLE IF EXISTS CM_IMMO.TYPE_CRITERE;
END $$


CALL Create_CM_IMMO_DB();

CREATE PROCEDURE Reset_CM_IMMO_DB()
BEGIN
    CALL Delete_Tables_CM_IMMO();
    CALL Create_CM_IMMO_DB();
END $$

DELIMITER ;

