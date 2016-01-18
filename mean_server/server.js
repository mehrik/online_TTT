var express = require('express');
var path = require('path');
var app = express();
// Points to client folder
app.use(express.static(path.join(__dirname, './client')));
// require to connect to database
require('./server/config/mongoose.js');
// require routes.js config
require('./server/config/routes.js')(app);

// player dictionary
var player = [];
var gameStart = false;
var TGame = require("./server/TTTGame.js");
var game = new TGame();
game.init();


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

    // Receieves names from a user that logs in from the iOS Client
    socket.on("addPlayer", function (data) {
        var turn;
        if (!player[0]) {
            player[0] = data
            game.player1 = player[0];
            console.log("player1 is added! ", player[0]);
            io.emit("showPlayer1", player[0]);
        } else if (!player[1]) {
            gameStart = true;
            player[1] = data;
            game.player2 = player[1];
            io.emit("showPlayer2", player[1]);
        }
        game.currentTurn="Red";
        
        if(gameStart) {
            io.emit("gameStart");
             if(game.currentTurn == "Red"){
                turn = game.player1;
            }else{
                turn = game.player2;
            }
            
            io.emit("takeTurn", turn);
        }
    });
    var col = "";
    socket.on("played", function(data){
        if(data.name == game.player1){
            col = 'Red';
        }else{
            col = 'Blue';
        }
        console.log("button pressed from player!!!", data.name, data.place);
        console.log("color? ", col);
        game.updateGameBoardAt(data.place, col);
        io.emit("changeBoard", {color: col, place: data.place+1});
        
        // game.currentTurn = data.name;
      
        game.checkGame()
        
        if(game.gameOver){
            var winner;
            if(game.winner == "Red"){
                winner = game.player1;
            }else{
                winner = game.player2;
            }
            io.emit("gameOver", winner);
        }else{
            var turn;
            if(game.currentTurn == "Red"){
                game.currentTurn = "Blue";
                turn = game.player2;
            }else{
                game.currentTurn = "Red";
                turn = game.player1;
            }
            
            io.emit("takeTurn", turn);
        }

    }); //{name: player name, place: int}
    
    socket.on('playAgain', function(){
        game.resetGame();
        io.emit('resetGame');
        io.emit("takeTurn", game.player1);
    });

    socket.on("exitGame", function(exitPlayer){
        console.log("exit player name: ", exitPlayer);
        // socket.emit("endGame");
        io.emit("exitPlayer", exitPlayer);
    });
});



// SOCKET STUFF HERE