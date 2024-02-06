import { exit } from 'node:process';
import { writeFile } from 'fs';

function writeArrayToCSV(array, filepath) {
    let csvString = "";
    let lineString = "";
    for (let line of array) {
        lineString = "";
        for (let item of line) {
            if (typeof item === 'string') {
                lineString += `"${item}",`;
            } else {
                lineString += `${item},`;
            }
        }
        console.log("<<" + lineString + ">>");
        if (lineString.length != 0 && lineString[lineString.length - 1] == ",") {
            lineString = lineString.slice(0, -1);
            lineString += ";\n";
        }
        csvString += lineString;
    }

    writeFile(filepath, csvString, err => {
        if (err) {
            console.error(`Erreur lors de l'écriture dans le fichier ${filepath}`);
            exit(1);
        } else {
            console.log(`Convertion CSV réussie pour ${filepath}`);
        }
    });
}

export default writeArrayToCSV;