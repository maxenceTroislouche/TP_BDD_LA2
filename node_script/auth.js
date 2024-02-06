import jsonData from './JSON/users_passwords_JSON_1000.json' with { type: "json" };
import writeArrayToCSV from './csvparser.js';


const generateAuthCSV = async (nbUsers, filepath) => {
    // Generates auth csv from the already generated JSON
    // => users_password_JSON_1000.csv

    let jsonDataCopy = [...jsonData];
    let csvData = [["username", "password"]];
    let randomIndex = 0;
    let data;

    console.log(jsonDataCopy);

    // Checks if we have enough data in the json file
    // If we don't, we provide everything we can
    if (jsonDataCopy.length < nbUsers) {
        nbUsers = jsonDataCopy.length;
    }

    while (csvData.length < nbUsers + 1) {
        // Pick username/password from jsonData
        randomIndex = Math.random() * jsonDataCopy.length;

        // Remove username/password from jsonData
        data = jsonDataCopy.splice(randomIndex, 1)[0];
        
        console.log(data);

        csvData.push([
            data.user,
            data.password
        ]);
    } 

    writeArrayToCSV(csvData, filepath);
}

export default generateAuthCSV;