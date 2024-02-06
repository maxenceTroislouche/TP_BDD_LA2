import writeArrayToCSV from "./csvparser.js";
import axios from 'axios';

const fetchRandomLocations = async () => {
    try {
        const response = await axios.get('https://randomuser.me/api/');
        console.log(response.data);
        return response.data;
    } catch(error) {
        console.error(error);
        exit(1);
    }
}

const generateLocationsCSV = async (nbLocations) => {
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

    writeArrayToCSV(locations, 'CSV/locations.csv');
}

export default generateLocationsCSV;