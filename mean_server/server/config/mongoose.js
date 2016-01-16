var mongoose = require('mongoose');
// fs module for loading files
var fs = require('fs');
var path = require('path');
// connect to database
mongoose.connect('mongodb://localhost/online_TTT');
// variable that points to folder where models live
var models_path = path.join(__dirname, './../models');
// read all of the files in the models folder
fs.readdirSync(models_path).forEach(function(file) {
    if(file.indexOf('.js') >= 0) {
        require(path.join(models_path, file));
    }
});