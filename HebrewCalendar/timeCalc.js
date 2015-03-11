.pragma library

function timeString(m) {
    //2 it is time zone
    var m1 = m + (2 * 60);
    var  houers= m1 / 60;
    var minutes =m1 % 60;
     return Qt.formatTime (new Date(96,1,1, Math.floor(houers),Math.floor(minutes),0) , "hh:mm" );
}
