import { writeFile } from "node:fs";
import writeArrayToCSV from './csvparser.js';
import axios from 'axios';

const fetchRandomUser = async () => {
  try {
    const response = await axios.get('https://randomuser.me/api/');
    return response.data;
  } catch(error) {
    console.error(error);
    process.exit(1);
  }
}

const generateUsersCSV = async (nbUsers, filepath) => {
  let users = [["Nom", "Prenom", "Date de naissance"]];

  for (let i = 0; i < nbUsers; i++) {
    const userData = await fetchRandomUser();
    const user = userData.results[0];
    users.push([
      user.name.last,
      user.name.first,
      user.dob.date.substring(0, 10),
    ]);
  }

  writeArrayToCSV(users, filepath);
}

const generateUsersJSON = async (nbUsers, filepath) => {
  let users = [];

  for (let i = 0; i < nbUsers; i++) {
    const userData = await fetchRandomUser();
    const user = userData.results[0];
    users.push({
      nom: user.name.last,
      prenom: user.name.first,
      date_de_naissance: user.dob.date.substring(0, 10)
    });
  }

  writeFile(filepath, JSON.stringify(users), { encoding: 'utf-8' }, err => {
    if (err) {
        console.error(`Erreur lors de l'écriture dans le fichier ${filepath}`);
        process.exit(1);
    } else {
        console.log(`Convertion JSON réussie pour ${filepath}`);
    }
  });
}

export { generateUsersCSV, generateUsersJSON };