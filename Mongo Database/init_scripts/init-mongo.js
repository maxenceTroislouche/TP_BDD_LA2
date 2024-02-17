db = connect("mongodb://localhost/CM_IMMO");

// let json_auth = require("/docker-entrypoint-initdb.d/data/auth.json");
let json_comments = require("/docker-entrypoint-initdb.d/data/comments.json");
// let json_locations = require("/docker-entrypoint-initdb.d/data/locations.json");
let json_q_a = require("/docker-entrypoint-initdb.d/data/Q&A.json");
// let json_users = require("/docker-entrypoint-initdb.d/data/users.json");

// db.credentials.insertMany(json_auth);
db.comments.insertMany(json_comments.positif);
db.comments.insertMany(json_comments.negatif);
// db.bien.insertMany(json_locations);
db.question.insertMany(json_q_a);
// db.user.insertMany(json_users);
