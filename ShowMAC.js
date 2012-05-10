/*  
 *  ShowMAC
 *  Access the device Mac Adress in Phonegap
 *
 *  Created by Philipp Fehre on 5/9/12.
 *  Copyright (c) 2012 Cospired. All rights reserved.
 */

(function(){

	function ShowMAC(){}
 
	/*
 	 * get the MAC address as string and pass to callbacks
	 */
	ShowMAC.prototype.get = function(callback) {
		// fake fail callback
		fail = function(){};
    return Cordova.exec( callback, fail, "com.cospired.ShowMAC", "getMAC", "" );
	};

  /* 
   * Add Plugin to Cordova
   */ 
	Cordova.addConstructor(function() {
		if(!window.plugins) {
			window.plugins = {};
		}
		if(!window.plugins.showmac) {
    		window.plugins.showmac = new ShowMAC();
		}
	});

})();