import writeArrayToCSV from './csvparser.js';
import axios from 'axios';

const fetchRandomUser = async () => {
  try {
    const response = await axios.get('https://randomuser.me/api/');
    console.log(response.data);
    return response.data;
  } catch(error) {
    console.error(error);
  }
};

const generateUsersCSV = async (nbUsers) => {
  let users = [["Nom", "Prenom", "Date de naissance", "Email", "Mot de passe"]];

  for (let i = 0; i < nbUsers; i++) {
    const userData = await fetchRandomUser();
    const user = userData.results[0];
    console.log([
      user.name.last,
      user.name.first,
      user.dob.date.substring(0, 10),
    ]);

    console.log(user.name.last);
    users.push([
      user.name.last,
      user.name.first,
      user.dob.date.substring(0, 10),
    ]);
  }

  writeArrayToCSV(users, 'CSV/users.csv');
};

export default generateUsersCSV;