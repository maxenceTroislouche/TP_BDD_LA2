import { writeFile } from "node:fs";
import writeArrayToCSV from "./csvparser.js";
import axios from 'axios';

const fetchRandomLocations = async () => {
    try {
        const response = await axios.get('https://randomuser.me/api/');
        // console.log(response.data);
        return response.data;
    } catch(error) {
        console.error(error);
        process.exit(1);
    }
}

const generateLocationsCSV = async (nbLocations, filepath) => {
    let locations = [["Num Rue","Nom Rue","Ville","Code Postal"]];

    for (let i = 0; i < nbLocations; i++) {
        const locationData = await fetchRandomLocations();
        const location = locationData.results[0];

        locations.push([
            location.location.street.number,
            location.location.street.name,
            location.location.city,
            location.location.postcode
        ]);
    }

    writeArrayToCSV(locations, filepath);
}

const generateLocationsJSON = async(nbLocations, filepath) => {
    let locations = [];

    for (let i = 0; i < nbLocations; i++) {
        const locationData = await fetchRandomLocations();
        const location = locationData.results[0];

        locations.push({
            num_rue: location.location.street.number,
            nom_rue: location.location.street.name,
            ville: location.location.city,
            code_postal: location.location.postcode
        });
    }

    writeFile(filepath, JSON.stringify(locations), { encoding: 'utf-8' }, err => {
        if (err) {
            console.error(`Erreur lors de l'écriture dans le fichier ${filepath}`);
            process.exit(1);
        } else {
            console.log(`Convertion JSON réussie pour ${filepath}`);
        }
    });
}

export { generateLocationsJSON, generateLocationsCSV };