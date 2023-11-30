component extends="commandbox.system.BaseCommand" {

	property name="RequestSetupService" inject="RequestSetupService@commandbox-apiman";

	/*
	 * @author Robert Zehnder
	 * Execute a GET request to specified endpoint
	 */
	function run(
		url         = "",
		query       = "",
		cookie      = "",
		showHeaders = false
	){
		var urlValid = isValid( "url", arguments.url );
		if ( !urlValid ) {
			print.redLine( "Invalid URL passed: " & arguments.url );
			return;
		}

		var req = {
			"method" : "GET",
			"url"    : {
				"raw"      : arguments.url,
				"protocol" : "",
				"host"     : [],
				"path"     : [],
				"query"    : []
			},
			"header"    : [],
			"arguments" : { "query" : arguments.query, "cookie" : arguments.cookie }
		};

		RequestSetupService.setupRequest( req );

		// DEBUG
		// print.line( req );
		// return;

		cfhttp(
			url     = req.url.raw,
			method  = req.method,
			charset = "utf-8"
		);

		if ( cfhttp.keyExists( "responseHeader" ) && arguments.showHeaders ) {
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
