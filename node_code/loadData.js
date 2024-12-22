const mysql = require('mysql2');
const fs = require('fs');
const csv = require('csv-parser');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'D4t@Science!',
  database: 'pizzeria_project'
});

connection.connect(err => {
  if (err) {
    console.error('Error connecting: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

function escapeQuotes(value) {
  return value.replace(/'/g, "''");  // Replace all ' with ''
}

function loadCSVToMySQL(tableName, filePath) {
  fs.createReadStream(filePath)
    .pipe(csv())
    .on('data', (row) => {
      const escapedRow = Object.fromEntries(
        Object.entries(row).map(([key, value]) => [key.trim(), escapeQuotes(value)])
      );

      const columns = Object.keys(escapedRow).join(', ');
      const values = Object.values(escapedRow).map(value => `'${value}'`).join(', ');

      const query = `INSERT INTO ${tableName} (${columns}) VALUES (${values})`;

      connection.query(query, (err, results) => {
        if (err) {
          console.error('Error inserting data: ', err.sqlMessage);
        } else {
          console.log('Inserted row: ', results);
        }
      });
    })
    .on('end', () => {
      console.log('File processed successfully.');
      connection.end();
    });
}

const tableName = process.argv[2];
const filePath = process.argv[3];
loadCSVToMySQL(tableName, filePath);
