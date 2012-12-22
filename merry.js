var merry = db.runCommand(
 { mapreduce : "person",
   map : function() {emit(
     [this.born_year, this.forename === 'MERRY'], 1
   )},
   reduce : function(key, values) {
     var result=0;
     values.forEach(function(value){
       result+=value;
     });
     return result;
   },
   out: { inline: 1 },
   jsMode : true,
   verbose : true
 }
);
