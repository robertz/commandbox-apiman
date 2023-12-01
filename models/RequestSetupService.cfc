component {

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
