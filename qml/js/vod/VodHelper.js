.pragma library

function fixCase(s) {
    var words = s.split(" ");
    var res = "";

    for(var i = 0; i < words.length; i++) {
        res += words[i][0].toUpperCase() + words[i].slice(1).toLowerCase() + " ";
    }

    return res.trim();
}
