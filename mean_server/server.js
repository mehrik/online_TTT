var express = require('express');
var path = require('path');
var app = express();
// Points to client folder
app.use(express.static(path.join(__dirname, './client')));
// require to connect to database
require('./server/config/mongoose.js');
// require routes.js config
require('./server/config/routes.js')(app);

var server = app.listen(5000, function() {
    console.log("    //////////////");
    console.log("   ////      ////");
    console.log("  //// 5000 ////");
    console.log(" ////      ////");
    console.log("//////////////");
});

var io = require('socket.io').listen(server);
io.sockets.on('connection', function(socket) {
    console.log('SERVER::WE ARE USING SOCKETS!');
    console.log(socket.id);

    socket.on("addPlayer", function (data) {
        console.log(data);
    });
});



// SOCKET STUFF HERE