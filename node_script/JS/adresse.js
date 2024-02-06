import fetch from 'node-fetch';
import fs from 'fs';

if (process.argv.length < 4 ) {
    console.error('Please specify the number of users to get, the csv name file to generate, and the delay in milliseconds (optional).');
    process.exit(1);
}
if (isNaN(process.argv[2])) {
    console.error('Please specify a valid number of users to get.');
    process.exit(1);
}
if (process.argv[3].length < 1) {
    console.error('Please specify a valid csv name file to generate.');
    process.exit(1);
}

const numLocations = parseInt(process.argv[2]);
const fileNameToCreate = process.argv[3];
const delay = process.argv[4] ? parseInt(process.argv[4]) : 50; // Delay in milliseconds, default to 50ms if not provided

const getLocations = async (numLocations) => {
    const locations = [];
    for (let i = 0; i < numLocations; i++) {
        await new Promise(resolve => setTimeout(resolve, delay)); // Wait for the specified delay
        try {
            const response = await fetch('https://randomuser.me/api/');
            const data = await response.json();
            locations.push({"num_rue": data.results[0].location.street.number, "nom_rue": data.results[0].location.street.name, "ville": data.results[0].location.city, "code_postal": data.results[0].location.postcode });
        } catch (error) {
            console.error('Error fetching data:', error);
            return;
        }
    }
    return locations;
};

const saveCSV = (locationsData) => {
    const headers = "Num Rue,Nom Rue,Ville,Code Postal\n";
    const rows = locationsData.map(loc => `${loc.num_rue},"${loc.nom_rue}",${loc.ville},${loc.code_postal}`).join('\n');
    const csvContent = headers + rows;
    fs.writeFileSync(`${fileNameToCreate}.csv`, csvContent);
    console.log('CSV file has been saved.');
};

getLocations(numLocations).then((jsonData) => {
    saveCSV(jsonData);
});
