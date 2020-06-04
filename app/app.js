const express = require('express');
const app = express();
const bull = require('bull');
const path = require('path');
const axios = require('axios');
const router = express.Router();
const fs = require('fs');
const util = require('util');
const redis = require('redis');
const favicon = require('serve-favicon')

/*

These routes run in three different node microservices
but I kept all the routes on the same page and in the same codebase
for simplicity and so I could test in localhost as if it's all one app
on my laptop.

You can see in the /kubernetes folder how the host / port variables
change based on what you're deploying. But it's all the same app,
it just takes on different identities :)

The /, /shop, and /whois routes are for the frontend.
The /purchase route is for the shopper microservice
The /deliver route is for the grocer microservice

Peace be with you.

- Matt

*/


if (typeof process.env.REDIS_HOST !== 'undefined'){
    var redis_host = process.env.REDIS_HOST;
    var redis_port = process.env.REDIS_PORT;
    var shopper_host = process.env.SHOPPER_HOST;
    var shopper_port = process.env.SHOPPER_PORT;
    var grocer_host = process.env.GROCER_HOST;
    var grocer_port = process.env.GROCER_PORT;
}else{
    var redis_host = 'localhost';
    var redis_port = '6379';
    var shopper_host = 'localhost';
    var shopper_port = '8080';
    var grocer_host = 'localhost';
    var grocer_port = '8080';
}
var return_shopping_list = {};
var client = redis.createClient(redis_port,redis_host, {no_ready_check: true});
var queue = new bull('default',{redis: {port: redis_port, host: redis_host}});
app.use(favicon(path.join(`${__dirname}/favicon.ico`)))
app.use(express.json())
router.get('/',function(req,res){
    res.sendFile(path.join(__dirname+'/index.html'));
});

router.get('/shop',function(req,res){
    if (typeof req.query.indecision !== 'undefined'){
        indecision = 2000;
    }else{
        indecision = req.query.indecision;    
    }
    if (typeof req.query.complexity !== 'undefined'){
        complexity = 1;
    }else{
        complexity = req.query.complexity;    
    }
    axios.post('http://' + shopper_host + ':' + shopper_port + '/purchase', {
        indecision: indecision,
        complexity: complexity
        }).then((res) => {
        console.log("purchased")
        })
        
    var myObj = {status: "ok"};
    res.send(JSON.stringify(myObj));     
});

router.get('/whois',function(req,res){
       var key_array = [];

        client.multi()
        .keys("bull:default:*", function (err, replies) {
        //console.log("MULTI got " + replies.length + " replies");
        replies.forEach(function (reply, index) {
            //console.log("Reply " + index + ": " + reply.toString());
            key_array.push(reply.toString())
        });

    })
    .exec(function (err, replies) {
        for (var i in key_array){
            client.hgetall(key_array[i], function(err, obj) {
                if (typeof obj != "undefined") {
                    data = JSON.parse(obj.data);
                    console.log(util.inspect(obj));
                    if (!('finishedOn' in obj)){
                        return_shopping_list[data.shopping_list] = data.shopper_name;
                    }else{
                        delete return_shopping_list[data.shopping_list]; 
                    }
                    //console.log(util.inspect(shopping_list));
            }
            //console.log(util.inspect(shopping_list));
        });
        }
        console.log(util.inspect(return_shopping_list));
        res.send(JSON.stringify(return_shopping_list))
    });


        //console.log(util.inspect(key_array));    //res.send(JSON.stringify(shopping_lists));
})

router.post('/deliver',function(req,res){
    queue.add({shopping_list: req.body.shopping_list, shopper_name: req.body.shopper_name, complexity: parseInt(req.body.complexity)});
    var myObj = {status: "ok"};
    res.send(JSON.stringify(myObj));
})

router.post('/purchase',function(req,res){
    if (typeof req.body.indecision !== 'undefined'){
        indecision = 2000;
    }else{
        indecision = req.body.indecision;    
    }
    if (typeof req.body.complexity !== 'undefined'){
        complexity = 1;
    }else{
        complexity = req.body.complexity;    
    }
    fruits = ["🍇","🍈","🍉","🍊","🍋","🍌","🍍","🥭","🍎","🍏","🍐","🍑","🍒","🍓","🥝"];
    some_random_fruit_array = shuffle(fruits).slice(0,7)
    shopping_list = some_random_fruit_array.join(" ");
    name_file = fs.readFileSync('names.json', 'utf8');
    names_obj = JSON.parse(name_file);
    names = names_obj.names
    shopper_name = names[Math.floor(Math.random() * names.length)];
    think(shopping_list,indecision)
    axios.post('http://' + grocer_host + ':' + grocer_port + '/deliver', {
        shopper_name: shopper_name,
        shopping_list: shopping_list,
        complexity: complexity
        }).then((response) => {
        })
    var myObj = {status: "ok"};
    res.send(JSON.stringify(myObj));
});


app.use('/', router);

app.listen(8080);

function shuffle(array) {
    var currentIndex = array.length, temporaryValue, randomIndex;
  
    // While there remain elements to shuffle...
    while (0 !== currentIndex) {
  
      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;
  
      // And swap it with the current element.
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }
  
    return array;
  }

  function think(shopping_list,indecision){
    a = []
    ind = parseInt(indecision)
    for (i = 0; i <= ind; i++) {
        a.push(shopping_list)
      }
  }

  queue.process(path.join(`${__dirname}/processor.js`));