import { generateUsersJSON, generateUsersCSV } from './users.js';
import { generateLocationsJSON, generateLocationsCSV } from './locations.js';
import generateAuthCSV from './auth.js';
import generateQuestionsAnswersCSV from './questions.js';
import generateCommentsCSV from './comments.js';

import { unlink } from 'node:fs';


console.log("Début du script !");

const nbUsers = 20;
const usersCSVFilepath = 'CSV/users.csv';
const usersJSONFilepath = 'JSON/users.json';

const nbLocations = 10;
const locationsCSVFilepath = 'CSV/locations.csv';
const locationsJSONFilepath = 'JSON/locations.json';

const authCSVFilepath = 'CSV/auth.csv';

const nbQuestions = 20;
const questionsCSVFilepath = 'CSV/questions.csv';
const answersCSVFilepath = 'CSV/answers.csv';

const nbPositiveComments = 20;
const nbNeutralComments = 20;
const nbNegativeComments = 20;
const commentsCSVFilepath = 'CSV/comments.csv';

if (process.argv.length === 3 && process.argv[2] === 'clean') {
    unlink(usersCSVFilepath, (err) => {throw err;});
    unlink(usersJSONFilepath, (err) => {throw err;});
    unlink(locationsCSVFilepath, (err) => {throw err;});
    unlink(locationsJSONFilepath, (err) => {throw err;});
    unlink(authCSVFilepath, (err) => {throw err;});
    unlink(questionsCSVFilepath, (err) => {throw err;});
    unlink(answersCSVFilepath, (err) => {throw err;});
    unlink(commentsCSVFilepath, (err) => {throw err;});
    console.log("Fichiers CSV nettoyés !");
    process.exit(0);
}

// Generate users csv
console.log("Génération des users ...");
generateUsersCSV(nbUsers, usersCSVFilepath);
generateUsersJSON(nbUsers, usersJSONFilepath);

// Generate Locations csv
console.log("Génération des adresses ...");
generateLocationsCSV(nbLocations, locationsCSVFilepath);
generateLocationsJSON(nbLocations, locationsJSONFilepath);

// Generate Auth csv
console.log("Génération des auth ...");
generateAuthCSV(nbUsers, authCSVFilepath);

// Generate Questions/Answers CSV files
console.log("Génération des questions/réponses ...");
generateQuestionsAnswersCSV(nbQuestions, questionsCSVFilepath, answersCSVFilepath);

// Generate comments CSV file
console.log("Génération des commentaires ...");
generateCommentsCSV(nbPositiveComments, nbNeutralComments, nbNegativeComments, commentsCSVFilepath);