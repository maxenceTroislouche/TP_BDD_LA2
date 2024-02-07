
#Delete all tables
CALL Delete_Tables_CM_IMMO();

#Create all tables
CALL Create_CM_IMMO_DB();

#Reset database/all tables
CALL Reset_CM_IMMO_DB();

#Fill in types table with default value
CALL InitAllDefaultTypesTables();

#Create all temp tables
CALL createALlTempTables();

#Fill all tables and delete all temp tables
LOAD DATA INFILE '/var/lib/mysql-files/users_dataset.csv' INTO TABLE TEMP_TIERS FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (nom, prenom, date_de_naissance);
LOAD DATA INFILE '/var/lib/mysql-files/users_passwords_modified.csv' INTO TABLE TEMP_AUTHS FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (nom_utilisateur, mot_de_passe);
LOAD DATA INFILE '/var/lib/mysql-files/locations.csv' INTO TABLE TEMP_LOCATIONS FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (num_rue, nom_rue, ville, code_postal);
LOAD DATA INFILE '/var/lib/mysql-files/questions.csv' INTO TABLE TEMP_QUESTIONS FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (id, texte, datePublication);
LOAD DATA INFILE '/var/lib/mysql-files/answers.csv' INTO TABLE TEMP_AUTHS FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (idQuestion, texte, datePublication);
CALL fillAllTablesFromTempTables();

CALL deleteAllTempTables();

DROP TABLE TEMP_AUTHS;
DROP TABLE TEMP_TIERS;
