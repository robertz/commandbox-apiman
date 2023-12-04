component extends="commandbox.system.BaseCommand" {

	property name="RequestSetupService" inject="RequestSetupService@commandbox-apiman";

	/*
	 * @author Robert Zehnder
	 * Execute a PUT request to specified endpoint
	 */
	function run(
		url             = "",
		query           = "",
		header          = "",
		cookie          = "",
		form            = "",
		body            = "",
		username        = "",
		password        = "",
		responseHeaders = false
	){
		var req = {
			"method" : "PUT",
			"url"    : {
				"raw"      : "",
				"protocol" : "",
				"host"     : [],
				"path"     : [],
				"query"    : []
			},
			"header"    : [],
			"cookie"    : [],
			"arguments" : {
				"url"         : [],
				"query"       : [],
				"header"      : [],
				"cookie"      : [],
				"form"        : [],
				"body"        : "",
				"user"        : "",
				"pass"        : "",
				"showHeaders" : false
			},
			"raw_arguments" : arguments
		};

		// Breakout arguments and populate the req structure
		RequestSetupService.parseArgs( req );
		RequestSetupService.setupRequest( req );

		if ( !isValid( "url", req.url.raw ) ) {
			print.redLine( "Invalid URL passed: " & req.url.raw );
			return;
		}

		// DEBUG
		// print.line( req );
		// return;

		cfhttp(
			url      = req.url.raw,
			method   = req.method,
			username = req.arguments.user,
			password = req.arguments.pass,
			charset  = "utf-8"
		) {
			for ( var h in req.header ) {
				if ( h.type == "body" ) {
					cfhttpparam( type = h.type, value = h.value );
				} else {
					cfhttpparam( type = h.type, name = h.key, value = h.value );
				}
			}

			for ( var c in req.cookie ) {
				cfhttpparam( type = "cookie", name = c.key, value = c.value );
			}
		};

		if ( cfhttp.keyExists( "responseHeader" ) && req.arguments.showHeaders ) {
			for ( var key in cfhttp.responseheader ) {
				var keyValue = isSimpleValue( cfhttp.responseHeader[ key ] ) ? cfhttp.responseHeader[ key ] : serializeJSON(
					cfhttp.responseHeader[ key ]
				);
				print.yellowText( key & ": " & keyValue );
				print.line();
			}
			print.line();
		}

		if ( isJSON( cfhttp.fileContent ) ) {
			print.line( deserializeJSON( cfhttp.fileContent ) );
		} else if ( isXML( cfhttp.fileContent ) ) {
			print.line( xmlParse( cfhttp.fileContent ) );
		} else {
			print.line( cfhttp.fileContent );
		}
	}

}
