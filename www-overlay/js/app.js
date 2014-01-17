function endsWith(str, suffix) {
    return str.toLowerCase().indexOf(suffix.toLowerCase(), str.length - suffix.length) !== -1;
}

function gainit(){
    window.plugins.gaPlugin.init(
        function(){
            console.log("window.plugins.gaPlugin.init: success");
            gatrack("init","","", 1);
        },
        function(){console.log("window.plugins.gaPlugin.init: fail");},
        "UA-47125823-1",
        10
    );
}

function gatrack( cat, act, lbl, val ){
    window.plugins.gaPlugin.trackEvent(
        function(){console.log("trackevent good: cat="+cat+" act="+act+" lbl="+lbl+" val="+val)},
        function(){console.log("trackevent fail: cat="+cat+" act="+act+" lbl="+lbl+" val="+val)},
        cat, act, lbl, val
    );
}

function openFile(_subfolder, _file){
    console.log("_subfolder: " + _subfolder)
    console.log("_file: " + _file)

    var type="";
    if (endsWith(_file,".ppt"))
        type='application/vnd.ms-powerpoint';
    else if (endsWith(_file,".pptx"))
        type='application/vnd.openxmlformats-officedocument.presentationml.presentation';
    else if (endsWith(_file,".doc"))
        type='application/msword';
    else if (endsWith(_file,".docx"))
        type='application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    else if (endsWith(_file,".pdf"))
        type='application/pdf';

    console.log("type: " + type)

    if (type=''){
        alert('Unknown file type');
    } else {
        window.plugins.asset2sd.startActivity({
            asset_file: "www/"+_subfolder+"/"+_file,
            destination_file_location: "smartrack/"+_subfolder,
            destination_file: _file},
            function(showPath) { 
                gatrack("open",showPath,"", 1);
                window.plugins.webintent.startActivity({
                    action: window.plugins.webintent.ACTION_VIEW,
                    url: 'file://'+showPath,
                    type: type
                },
                function() {},
                function() {
                    alert('Failed to open URL via Android Intent.');
                        console.log("Failed to open URL via Android Intent. URL: " + theFile.fullPath)
                }
            );}, 
            function() { alert('fail'); }
        ); 
	}
}

