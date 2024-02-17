db = connect("mongodb://localhost/CM_IMMO_MYSQL");

let json_users = require("/docker-entrypoint-initdb.d/data/users.json");
let json_auths = require("/docker-entrypoint-initdb.d/data/auth.json");
let json_locations = require("/docker-entrypoint-initdb.d/data/locations.json");
let json_qa = require("/docker-entrypoint-initdb.d/data/Q&A.json");
let json_comments = require("/docker-entrypoint-initdb.d/data/comments.json");
/* 
    TODO: 
        [X] AUTH : Renommé credentials
        [X] BAIL : VIDE
        [X] BIEN
        [X] CHAUFFAGE
        [X] CLASSE_BIEN
        [X] COMMENTAIRES
        [X] DESTINATION : VIDE
        [X] EAU_CHAUDE
        [X] HONORAIRE : VIDE
        [X] LCD
        [] NOTE_PAR_CRITERE
        [X] PHOTO : VIDE
        [X] PHOTO_COMMENTAIRE : VIDE
        [X] PROPRIETE
        [X] QUESTIONS
        [X] REPONSES
        [X] RETOUR_CLIENT
        [X] SIGNATURE : VIDE
        [X] TIERS
        [X] TYPE_BIEN
        [X] TYPE_CRITERE
        [X] TYPE_HONORAIRE : VIDE
        [X] TYPE_LOCATION
        [X] TYPE_SIGNATURE : VIDE
        [X] TYPE_TIERS
*/

function creerTypeTiers() {
    db.typetiers.insertMany([
        {lib: "GARANT"},
        {lib: "PROPRIETAIRE"},
        {lib: "LOCATAIRE"},
        {lib: "AGENT"},
        {lib: "CLIENT"}
    ]);
}

function creerTypeLocation() {
    db.typelocation.insertMany([
        {lib: "LOCATION_LONGUE"},
        {lib: "LOCATION_COURTE"}
    ]);
}

function creerTypeCritere() {
    db.typecritere.insertMany([
        {lib: "Logement conforme à l'annonce"},
        {lib: "Qualité de l'accueil"},
        {lib: "Propreté du logement"},
        {lib: "Qualité de l'environnement"}
    ]);
}

function creerTypeBien() {
    db.typebien.insertMany([
        {lib: "MAISON"},
        {lib: "APPARTEMENT"} 
    ]);
}

function creerEauChaude() {
    db.eauchaude.insertMany([
        {lib: "TEST"}
    ]);
}

function creerClasseBien() {
    db.classebien.insertMany([
        {lib: "TEST"}
    ]);
}

function creerChauffage() {
    db.chauffage.insertMany([
        {lib: "TEST"}
    ]);
}

async function creerTiers(nbTiers, libTypeTiers) {
    let usersData = [...json_users];

    if (nbTiers > usersData.length) {
        nbTiers = usersData.length;
    }

    let res = await db.typetiers.find({lib: libTypeTiers}).toArray();
    if (res.length === 0) {
        return;
    }

    let idTypeTiers = res[0]._id;

    let dataToInsert = [];

    for (let i = 0; i < nbTiers; i++) {
        let randomIdx = Math.floor(Math.random() * usersData.length);
        let user = usersData[randomIdx];

        usersData.splice(randomIdx, 1);
        
        dataToInsert.push({
            typetiers: idTypeTiers, 
            nom: user.nom, 
            prenom: user.prenom, 
            date_de_naissance: user.date_de_naissance
        });
    }

    await db.tiers.insertMany(dataToInsert);
}

async function creerAuths() {
    let authData = [...json_auths];

    let tiers = await db.tiers.find({}).toArray();
    let dataToInsert = [];
    
    for (let i = 0; i < tiers.length; i++) {
        // On vérifie si on a assez de data pour remplir la table auth
        if (authData.length === 0) {
            return;
        }
        let tiersConcerne = tiers[i];
        let randomIdx = Math.floor(Math.random() * authData.length);
        let auth = authData[randomIdx];
        authData.splice(randomIdx, 1);

        dataToInsert.push({
            idTiers: tiersConcerne._id,
            nomUtilisateur: auth.user,
            motDePasse: auth.password
        });
    }
    await db.credentials.insertMany(dataToInsert);

}

async function creerBien(nbBiens, libTypeLocation) {
    let adresses = [...json_locations];

    let typeBiens = await db.typebien.find({}).toArray();
    let classeBiens = await db.classebien.find({}).toArray();
    let chauffages = await db.chauffage.find({}).toArray();
    let eauchaudes = await db.eauchaude.find({}).toArray();

    let idTypeLocation = await db.typelocation.find({lib: libTypeLocation}).toArray()[0]._id;
    let dataToInsert = [];

    for (let i = 0; i < nbBiens; i++) {
        let idRandomTypeBien = typeBiens[Math.floor(Math.random() * typeBiens.length)]._id;
        let idRandomClasseBien = classeBiens[Math.floor(Math.random() * classeBiens.length)]._id;
        let idRandomChauffage = chauffages[Math.floor(Math.random() * chauffages.length)]._id;
        let idRandomEauChaude = eauchaudes[Math.floor(Math.random() * eauchaudes.length)]._id;
        let randomAdresse = adresses[Math.floor(Math.random() * adresses.length)];

        let numEtage = Math.floor(Math.random() * 10);
        let numAppart = Math.floor(Math.random() * 50);
        let dateCreation = (new Date()).toLocaleDateString();
        let surfaceHabitable = Math.floor(Math.random() * 200);
        let nbPieces = Math.floor(Math.random() * 10);

        dataToInsert.push({
            idTypeBien: idRandomTypeBien,
            idClasseBien: idRandomClasseBien,
            idChauffage: idRandomChauffage,
            idEauChaude: idRandomEauChaude,
            idTypeLocation: idTypeLocation,
            numRue: randomAdresse.num_rue,
            nomRue: randomAdresse.nom_rue,
            ville: randomAdresse.ville,
            codePostal: randomAdresse.code_postal,
            numEtage: numEtage,
            numAppartement: numAppart,
            dateCreation: dateCreation,
            surfaceHabitable: surfaceHabitable,
            nbPieces: nbPieces
        });
    }

    await db.bien.insertMany(dataToInsert);
}

async function creerProprietes() {
    let biens = await db.bien.find({}).toArray();
    let idProprietaire = await db.typetiers.find({lib: "PROPRIETAIRE"}).toArray()[0]._id;
    let proprietaires = await db.tiers.find({typetiers: idProprietaire}).toArray();

    let dataToInsert = [];
    for (let i = 0; i < biens.length; i++) {
        let randomIdx = Math.floor(Math.random() * proprietaires.length);
        let idProprio = proprietaires[randomIdx]._id;

        dataToInsert.push({
            idBien: biens[i]._id,
            idProprietaire: idProprio,
            part: 100
        })
    }

    await db.propriete.insertMany(dataToInsert);
}

async function creerLCD() {
    // On crée entre 1 et 3 lcd par bien
    const startDate = new Date('2024-01-01');
    const endDate = new Date('2024-12-31');

    const timeDiff = endDate.getTime() - startDate.getTime();

    let biens = db.bien.find({}).toArray();
    let idClient = db.typetiers.find({lib: "CLIENT"}).toArray()[0]._id;
    let clients = db.tiers.find({typetiers: idClient}).toArray();

    let dataToInsert = [];

    for (let bien of biens) {
        let nbLCD = 1 + Math.floor(Math.random() * 2);
        for (let i = 0; i < nbLCD; i++) {
            const randomTime = Math.random() * timeDiff;
            const randomDate = new Date(startDate.getTime() + randomTime);
            const randomEndDate = new Date(randomDate.getTime());
            randomEndDate.setDate(randomEndDate.getDate() + 1 + Math.floor(Math.random() * 10));
            let idClientRandom = clients[Math.floor(Math.random() * clients.length)]._id;
            let montant = Math.floor(Math.random() * 2000);
            let dateDebut = randomDate.toLocaleDateString();
            let dateFin = randomEndDate.toLocaleDateString();
            dataToInsert.push({
                montant: montant,
                codeBien: bien._id,
                idLocataire: idClientRandom,
                dateDebut: dateDebut,
                dateFin: dateFin
            });
        }
    }

    await db.lcd.insertMany(dataToInsert);
}

async function creerQuestionsReponses() {
    let dataQA = [...json_qa];

    let idClient = await db.typetiers.find({lib: "CLIENT"}).toArray()[0]._id;
    let clients = await db.tiers.find({typetiers: idClient}).toArray();

    let biens = await db.bien.find({}).toArray();

    for (let dataQuestion of dataQA) {
        let idRandomBien = biens[Math.floor(Math.random() * biens.length)]._id;
        let idRandomClient = clients[Math.floor(Math.random() * clients.length)]._id;

        let idProprietaire = await db.propriete.find({idBien: idRandomBien}).toArray()[0].idProprietaire;

        let res = await db.question.insertOne({
            idBien: idRandomBien,
            idTiers: idRandomClient,
            texte: dataQuestion.question,
            datePublication: dataQuestion.date
        });

        let idQuestion = res.insertedId;

        let reponsesToInsert = [];
        for (let reponse of dataQuestion.reponses) {
            reponsesToInsert.push({
                idQuestion: idQuestion,
                idTiers: idProprietaire,
                datePublication: dataQuestion.date,
                texte: reponse
            });
        }

        await db.reponse.insertMany(reponsesToInsert);
    }
}

function _addComment(dataComment, idCommentairePrecedent, idLCD, idTiers, idProprio, tourProprio) {
    let id = idTiers;
    if (tourProprio) {
        id = idProprio;
    }

    let res = db.commentaire.insertOne({
        idTiers: id,
        idLCD: idLCD,
        texte: dataComment.commentaire,
        idCommentaireOriginal: idCommentairePrecedent
    });

    let idCom = res.insertedId;

    for (let reponse of dataComment.reponses) {
        _addComment(reponse, idCom, idLCD, idTiers, idProprio, !tourProprio);
    }
}

async function creerCommentaires() {
    let dataComments = [...json_comments];
    let tousLesLCD = await db.lcd.find({}).toArray();
    for (let commentaire of dataComments) {
        let lcd = tousLesLCD[Math.floor(Math.random() * tousLesLCD.length)];
        let idProprio = await db.propriete.find({idBien: lcd.codeBien}).toArray()[0].idTiers;

        _addComment(commentaire, null, lcd._id, lcd.idLocataire, idProprio, false);
    }
}

async function creerRetourClient() {
    let comments = await db.commentaire.find({idCommentaireOriginal: null}).toArray();
    let dataToInsert = [];

    for (let comment of comments) {
        dataToInsert.push({
            idTiers: comment.idTiers,
            idLCD: comment.idLCD,
            idCommentaire: comment._id
        });
    }

    await db.retourclient.insertMany(dataToInsert);
}

async function creerNotesParCritere() {
    let retours = await db.retourclient.find({}).toArray();
    let criteres = await db.typecritere.find({}).toArray();
    
    let dataToInsert = [];
    
    for (let retour of retours) {
        for (let critere of criteres) {
            dataToInsert.push({
                idTypeCritere: critere._id,
                idRetour: retour._id,
                note: Math.floor(Math.random() * 5)
            });
        }
    }
    await db.noteparcritere.insertMany(dataToInsert);
}

async function ajouterData() {
    creerTypeTiers();
    creerTypeLocation();
    creerTypeCritere();
    creerTypeBien();
    creerEauChaude();
    creerClasseBien();
    creerChauffage();

    await creerTiers(350, "CLIENT");
    await creerTiers(30, "PROPRIETAIRE");
    await creerTiers(30, "AGENT");
    
    await creerAuths();

    await creerBien(10, "LOCATION_LONGUE");
    await creerBien(10, "LOCATION_COURTE");

    await creerProprietes();
    await creerLCD();
    await creerQuestionsReponses();
    await creerCommentaires();
    await creerRetourClient();
    await creerNotesParCritere();
}

// Attention seulement 20 users dans users.json
ajouterData().then(() => {
    console.log("Terminé")
})
