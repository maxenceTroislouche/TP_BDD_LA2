db = connect("mongodb://localhost/immoDB");

// let json_auth = require("/docker-entrypoint-initdb.d/data/auth.json");
let json_comments = require("/docker-entrypoint-initdb.d/data/comments.json");
let json_biens = require("/docker-entrypoint-initdb.d/data/bien_Mongo.json");
let json_q_a = require("/docker-entrypoint-initdb.d/data/Q&A.json");
// let json_users = require("/docker-entrypoint-initdb.d/data/users.json");

// db.credentials.insertMany(json_auth);
db.comments.insertMany(json_comments);
db.biens.insertMany(json_biens);
db.question.insertMany(json_q_a);
// db.user.insertMany(json_users);
