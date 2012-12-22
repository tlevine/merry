var csv = function(merry){
  console.log('year,Merry,count')
  merry.results.map(function(r){
    var year = r._id[0] ? r._id[0] : 'NA'
    var ismerry = r._id[1] ? 'TRUE' : 'FALSE'
    console.log(year + ',' + ismerry + ',' + r.value); 
  })
}

var filename = process.argv[1]
if (filename){
  var fs = require('fs')
  csv(JSON.parse(fs.readFileSync(filename)))
}
