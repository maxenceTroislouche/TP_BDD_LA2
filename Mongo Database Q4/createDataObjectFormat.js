import jsonLocations from "./init_scripts/data/locations.json" with { type: "json" };
import jsonUser from "./init_scripts/data/users.json" with { type: "json" };
import jsonComments from "./init_scripts/data/comments.json" with { type: "json" };
import jsonQuestions from "./init_scripts/data/Q&A.json" with { type: "json" };
import { writeFile } from "node:fs";

const getRandomInt = (max) => {
    return Math.floor(Math.random() * max);
}

const generateJS = (nbBiens, filepath) => {

    // Read location file
    // For each document, add : etage, num_appartement, date_creation, surface, type eau chaude, type chauffage, classe bien, type bien, nb_pieces, type_location

    let jsonBiens=[];
    //let jsonLocationsParsed = JSON.parse(jsonLocations);

    jsonLocations.forEach(location => {

        location.etage = getRandomInt(10);

        location.numAppartement = getRandomInt(10);

        let creationDate = getRandomInt(1708168084);
        location.dateCreation = new Date(creationDate);

        location.surface = getRandomInt(150);

        const typesEnergie = ["Électricité","Gaz","Fioul","Énergie solaire"];
        location.typeEauChaude = typesEnergie[getRandomInt(4)];
        location.typeChauffage = typesEnergie[getRandomInt(4)];
        
        const classesBien = ["T1","T2","T3","T4","T5","T6","Duplex","Triplex","Souplex","Loft"];
        location.classeBien = classesBien[getRandomInt(10)];

        const typesBien = ["Appartement", "Maison", "Local commercial"];
        location.typeBien = typesBien[getRandomInt(3)];

        location.nbPieces = getRandomInt(10);

        const typesLocation = ["Location longue", "Location courte"];
        location.typeLocation = typesLocation[getRandomInt(2)];

        // Add questions
        location.questions = [];
        for (let i = 0; i < getRandomInt(6); i++) {
            location.questions.push(jsonQuestions[getRandomInt(jsonQuestions.length)]);
        }

        // Add reservation
        if (location.typeLocation == "Location courte") {
            location.reservations = [];
            for (let i = 0; i < getRandomInt(10); i++) {
                let reservation={locataire:{}};

                // Add third
                reservation.locataire.nom = jsonUser[getRandomInt(jsonUser.length)].nom;
                reservation.locataire.prenom = jsonUser[getRandomInt(jsonUser.length)].prenom;
                reservation.locataire.dateDeNaissance = new Date(jsonUser[getRandomInt(jsonUser.length)].date_de_naissance );
                reservation.locataire.typeTier = "Locataire";

                // Add arrival date and departure date
                const arrivalDate = creationDate + getRandomInt(1708168084);
                const departureDate = arrivalDate + getRandomInt(2629743);  // One month max

                reservation.dateDebut = new Date( arrivalDate);
                reservation.dateFin = new Date( departureDate );

                // Add amount
                reservation.montant = getRandomInt(2000);

                // Add comments
                if(getRandomInt(2)){
                    reservation.commentaire = jsonComments[getRandomInt(jsonComments.length)];
                }

                // Add noteParHashtag
                let hashtagsPossible = ["accueil", "environnement", "proprete", "localisation"];
                
                let notesParHashtag = [];
                for (let i = 0; i < getRandomInt(hashtagsPossible.length); i++) {
                    let idxHashtag = getRandomInt(hashtagsPossible.length - 1);
                    let hashtag = hashtagsPossible[idxHashtag];
                    hashtagsPossible.splice(idxHashtag, 1); // On retire le hashtag choisi de la liste
                    let noteparhashtag = {
                        note: getRandomInt(5),
                        hashtag: hashtag
                    }
                    notesParHashtag.push(noteparhashtag);
                }

                reservation.notesParHashtag = notesParHashtag

                location.reservations.push(reservation);           
            }
        }

        
        jsonBiens.push(location);
        //console.log(jsonBiens);
    });

    writeFile("./init_scripts/data/bien_Mongo.json", JSON.stringify(jsonBiens), { encoding: 'utf-8' }, err => {
        if (err) {
            console.error(`Erreur lors de l'écriture dans le fichier ${filepath}`);
            process.exit(1);
        } else {
            console.log(`Création du JSON réussie`);
        }
    });
    
}

generateJS();