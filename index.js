'use strict'


var express = require ('express')

var app = express()

app.get('/', function(req, res){
  res.send('Hello World This is my first ECS deployment using git hub actions ');
});

/* istanbul ignore next */
if (!module.parent) {
  app.listen(80);
  console.log('Express started on port 3000');
}
