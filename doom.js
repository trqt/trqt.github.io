
// Override the document body
function inject() {
	console.log("Stager: Injecting iframe...");
	document.title = "DOOM > DOM";
	document.getElementsByTagName('body')[0].innerHTML = '<iframe src="https://raz0red.github.io/webprboom/" allowfullscreen style="position:fixed; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;">';
}

// Check whether or not the DOM can be injected straight away or has to be invoked via events
if (document.readyState === "complete" || document.readyState === "interactive") {
	console.log("Stager: DOM ready");
	inject();
} else if (window.attachEvent) {
	console.log("Stager: Attaching to onload");
	window.attachEvent('onload', inject);
} else if (window.addEventListener) {
	console.log("Stager: Attaching to load");
	window.addEventListener('load', inject, false);	
} else {
	console.log("Stager: Fallback to iframe count");
	fc = document.getElementsByTagName('iframe').length;
	setInterval(
		function() {
			if (document.getElementsByTagName('iframe').length != fc) {
				return;
			} else {
				inject();
			}
		},
		300
	);
}
