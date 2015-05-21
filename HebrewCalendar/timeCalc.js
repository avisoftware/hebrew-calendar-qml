.pragma library

function timeString(y,m,d,min,tz) {
    var m1 = min + (tz * 60);
    var  houers= m1 / 60;
    var minutes =m1 % 60;

    var d1 = new Date(y,m,d, Math.floor(houers),Math.floor(minutes),0);
    var tz1 = tz * 60-((tz * 60)*2)-60;
    if (d1.getTimezoneOffset()===tz1){
                d1.setMinutes(d1.getMinutes()+60);
            }
     return Qt.formatTime (d1 , "hh:mm" );
}
