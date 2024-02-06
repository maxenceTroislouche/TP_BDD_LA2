import generateUsersCSV from './users.js';
import generateLocationsCSV from './locations.js';
import generateAuthCSV from './auth.js';

console.log("Début du script !");

// Generate users csv
const nbUsers = 100;

generateUsersCSV(nbUsers);

// Generate Locations csv
const nbLocations = 100;
generateLocationsCSV(nbLocations);