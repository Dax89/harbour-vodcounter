.pragma library

.import harbour.vodcounter.LocalStorageFile 1.0 as LocalStorageFile

var config = { };

function load() {
    var configstring = LocalStorageFile.LocalStorageFile.load();

    if(configstring.length > 0)
        config = JSON.parse(configstring);
}

function save() {
    LocalStorageFile.LocalStorageFile.save(JSON.stringify(config));
}
