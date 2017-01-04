fs = require('fs')
fs.readFile('gen1.sword', 'utf8', function (err,data) {
	if (err) {
		return console.log(err);
	}
	console.log(data);
});
