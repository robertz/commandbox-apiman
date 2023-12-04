component {

	/*
	 * @author Robert Zehnder
	 * Parse out positional arguments
	 */
	function parseArgs( required struct req ){
		var keys = req.raw_arguments.keyList().listToArray();
		var done = false;
		var idx  = 1;

		while ( !done ) {
			if ( req.raw_arguments[ idx ].find( "-" ) == 1 ) {
				switch ( req.raw_arguments[ idx ] ) {
					case "-u":
						// user
						req.arguments.user = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-p":
						// pass
						req.arguments.pass = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-q":
						// query params
						req.arguments.query = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-c":
						// cookies
						req.arguments.cookie = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-h":
						// headers
						req.arguments.header = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-f":
						// form fields
						req.arguments.form = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-d":
						// data
						req.arguments.body = req.raw_arguments[ idx + 1 ];
						idx += 2;
						break;
					case "-showHeaders":
						req.arguments.showHeaders = true;
						idx += 1;
						break;
					default:
						break;
				}
			} else {
				if ( isValid( "url", req.raw_arguments[ idx ] ) ) {
					req.url.raw = req.raw_arguments[ idx ];
				}
				idx++;
			}
			if ( idx > keys.len() ) done = true;
		}
	}

	/*
	 * @author Robert Zehnder
	 * Build all required request options to make an http call
	 */
	function setupRequest( required struct req ){
		// should the url be built since arguments were passed
		var buildUrl = false;

		// What is the protocol
		req.url.protocol = req.url.raw.findNoCase( "https" ) == 1 ? "https" : "http";

		// Build the host parts
		req.url.host = req.url.raw
			.replaceNoCase( req.url.protocol & "://", "" )
			.listFirst( "/" )
			.listToArray( "." );

		// Build the path parts
		req.url.path = listFirst(
			req.url.raw.replaceNoCase( req.url.protocol & "://" & req.url.host.toList( "." ) & "/", "" ),
			"?"
		).listToArray( "/" );

		// Parse query string from the url
		var qs = req.url.raw.listRest( "?" ).listToArray( "&" );
		for ( var el in qs ) {
			var t        = {};
			t[ "key" ]   = el.listFirst( "=" );
			t[ "value" ] = el.listRest( "=" );
			req.url.query.append( t );
		}

		// Set query values passed as arguments
		if ( req.arguments.query.len() ) {
			buildUrl = true;
			qs       = req.arguments.query.listToArray( ";" );
			for ( var el in qs ) {
				var t        = {};
				t[ "key" ]   = trim( el.listFirst( "=" ) );
				t[ "value" ] = trim( el.listRest( "=" ) );
				req.url.query.append( t );
			}
		}

		// Set headers
		if ( req.arguments.header.len() ) {
			var hs = req.arguments.header.listToArray( ";" );
			for ( var el in hs ) {
				var t        = {};
				t[ "type" ]  = "header";
				t[ "key" ]   = trim( el.listFirst( "=" ) );
				t[ "value" ] = trim( el.listRest( "=" ) );
				req.header.append( t );
			}
		}

		// Set cookies
		if ( req.arguments.cookie.len() ) {
			var cs = req.arguments.cookie.listToArray( ";" );
			for ( var el in cs ) {
				var t        = {};
				t[ "key" ]   = trim( el.listFirst( "=" ) );
				t[ "value" ] = trim( el.listRest( "=" ) );
				req.cookie.append( t );
			}
		}

		// verb specific processing for put/post requests
		if ( listFind( "POST,PUT", req.method ) ) {
			if ( req.arguments.form.len() ) {
				var fs = req.arguments.form.listToArray( ";" );
				for ( var el in fs ) {
					var t        = {};
					t[ "type" ]  = "formfield";
					t[ "key" ]   = trim( el.listFirst( "=" ) );
					t[ "value" ] = trim( el.listRest( "=" ) );
					req.header.append( t );
				}
			}
			if ( req.arguments.body.len() ) {
				var t        = {};
				t[ "type" ]  = "body";
				t[ "key" ]   = "body";
				t[ "value" ] = req.arguments.body;
				req.header.append( t );
			}
		}

		// If there was a query passed as an argument rebuild the url
		if ( buildUrl ) {
			var computed = req.url.protocol & "://" & req.url.host.toList( "." ) & "/" & req.url.path.toList( "/" );
			qs           = "";
			if ( req.url.query.len() ) {
				for ( var q in req.url.query ) {
					qs = qs.listAppend( q.key & "=" & q.value, "&" );
				}
				computed &= "?" & qs;
				req.url.raw = computed;
			}
		}
	}

}
