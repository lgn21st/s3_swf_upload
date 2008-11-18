var s3_swf = {
    obj: function() {
        return document["s3_upload"];
    },
    init: function() {
        this.obj().init("http://localhost:3000/s3_signatures", "", "", "", "");
    },
    upload: function(prefix_path) {
        this.obj().upload(prefix_path);
    },
    onSuccess: function() {
    },
    onFailed: function() {
    },
    onSelected: function(fileName, fileSize) {
    },
    onCancel: function() {
    }
}