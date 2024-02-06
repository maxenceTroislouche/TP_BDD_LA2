import generateUsersCSV from './users.js';
import generateLocationsCSV from './locations.js';
import generateAuthCSV from './auth.js';
import generateQuestionsAnswersCSV from './questions.js';

import { unlink } from 'node:fs';


console.log("Début du script !");

const nbUsers = 20;
const usersCSVFilepath = 'CSV/users.csv';

const nbLocations = 20;
const locationsCSVFilepath = 'CSV/locations.csv';

const authCSVFilepath = 'CSV/auth.csv';

const nbQuestions = 20;
const questionsCSVFilepath = 'CSV/questions.csv';
const answersCSVFilepath = 'CSV/answers.csv';

if (process.argv.length === 3 && process.argv[2] === 'clean') {
    unlink(usersCSVFilepath, (err) => {throw err;});
    unlink(locationsCSVFilepath, (err) => {throw err;});
    unlink(authCSVFilepath, (err) => {throw err;});
    unlink(questionsCSVFilepath, (err) => {throw err;});
    unlink(answersCSVFilepath, (err) => {throw err;});
    console.log("Fichiers CSV nettoyés !");
    process.exit(0);
}

// Generate users csv
generateUsersCSV(nbUsers, usersCSVFilepath);

// Generate Locations csv
generateLocationsCSV(nbLocations, locationsCSVFilepath);

// Generate Auth csv
generateAuthCSV(nbUsers, authCSVFilepath);

// Generate Questions/Answers CSV files
generateQuestionsAnswersCSV(nbQuestions, questionsCSVFilepath, answersCSVFilepath);