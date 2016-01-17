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


var player = []

var io = require('socket.io').listen(server);
io.sockets.on('connection', function(socket) {
    console.log('SERVER::WE ARE USING SOCKETS!');
    console.log(socket.id);

    // Receieves names from a user that logs in from the iOS Client
    socket.on("addPlayer", function (data) {
        if (!player[0]) {
            player[0] = data
        } else if (!player[1]) {
            player[1] = data
        }
        console.log("Player1:", player[0]);
        console.log("Player2:", player[1]);
    });

    socket.on("retrievePlayers", function (data) {
        console.log("retrieved Players");
        // using both broadcast and emit to ensure that both players are able to log
        // in on their client side
        socket.emit("sendPlayers", player);
        socket.broadcast.emit("sendPlayers", player);
    });    
});
