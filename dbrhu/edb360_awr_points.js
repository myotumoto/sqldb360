
var racData = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData1 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData2 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData3 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData4 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData5 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData6 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData7 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];


var instData8 = [ [new Date(2025,2,5,17,44,36) , null, null ] ];

function populateEmptyColumns(numColumns,lArray){
var emptyCols=[]
var i
for (i = 0; i < numColumns; i++) {
emptyCols.push(',0')
}
for (i = 0; i<lArray.length; i++) {
lArray[i]=lArray[i].concat(emptyCols)
}
return lArray
}

function initializeArrays(n) {
populateEmptyColumns(n,racData)
populateEmptyColumns(n,instData1)
populateEmptyColumns(n,instData2)
populateEmptyColumns(n,instData3)
populateEmptyColumns(n,instData4)
populateEmptyColumns(n,instData5)
populateEmptyColumns(n,instData6)
populateEmptyColumns(n,instData7)
populateEmptyColumns(n,instData8)
}
