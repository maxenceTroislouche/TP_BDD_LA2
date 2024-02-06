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
  let users = [["Nom", "Prenom", "Date de naissance", "Email", "Mot de passe"]];

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

export default generateUsersCSV;