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

// player dictionary
var player1, player2;

var io = require('socket.io').listen(server);
io.sockets.on('connection', function(socket) {
    console.log('SERVER::WE ARE USING SOCKETS!');
    console.log(socket.id);

    // Receieves names from a user that logs in from the iOS Client
    socket.on("addPlayer", function (data) {
        if (!player1) {
            player1 = data
        } else if (!player2) {
            player2 = data
        }
        console.log("Player1:", player1);
        console.log("Player2:", player2);
    });
});



// SOCKET STUFF HERE