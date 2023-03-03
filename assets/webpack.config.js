var path = require("path");
module.exports = {
    entry: "./js/app.js",
    output: {
        path: path.join(__dirname, "../priv/static/assets"),
        filename: "app.js"
    }
};