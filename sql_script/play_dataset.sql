
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
LOAD DATA INFILE '/var/lib/mysql-files/auth.csv' INTO TABLE TEMP_AUTHS FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY ';\n' IGNORE 1 ROWS (nom_utilisateur, mot_de_passe);

LOAD DATA INFILE '/var/lib/mysql-files/users.csv' INTO TABLE TEMP_TIERS FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY ';\n' IGNORE 1 ROWS (nom, prenom, date_de_naissance);
CALL fillTablesAndDeleteAllTempTable();
