const fs = require('fs');
const https = require('https');
const { parse } = require('json2csv');

const args = process.argv.slice(2);

if (args.length === 0) {
  console.log("Usage: node script.js <nombre d'utilisateurs>");
  process.exit(1);
}

const number_of_users = parseInt(args[0], 10);
const output_file = 'users.csv';
const users = [];

const fetchRandomUser = () => {
  return new Promise((resolve, reject) => {
    https.get('https://randomuser.me/api/', (resp) => {
      let data = '';

      // Un morceau de données a été reçu.
      resp.on('data', (chunk) => {
        data += chunk;
      });

      // Toute la réponse a été reçue.
      resp.on('end', () => {
        resolve(JSON.parse(data));
      });
    }).on("error", (err) => {
      reject(err);
    });
  });
};

const generateUsers = async () => {
  for (let i = 0; i < number_of_users; i++) {
    const userData = await fetchRandomUser();
    const user = userData.results[0];
    users.push({
      Nom: user.name.last,
      Prénom: user.name.first,
      "Date de Naissance": user.dob.date.substring(0, 10),
      Email: user.email,
      "Mot de Passe": user.login.password,
    });
  }

  const csv = parse(users, {
    fields: ["Nom", "Prénom", "Date de Naissance", "Email", "Mot de Passe"]
  });

  fs.writeFileSync(output_file, csv);
  console.log(`Fichier CSV généré : ${output_file}`);
};

generateUsers();
