component {

	/*
	 * @author Robert Zehnder
	 * Build all required request options to make an http call
	 */
	function setupRequest( required struct req ){
		// What is the protocol
		req.url.protocol = req.url.raw.findNoCase( "https" ) == 1 ? "https" : "http";
		// Build the host parts
		req.url.host     = req.url.raw
			.replaceNoCase( req.url.protocol & "://", "" )
			.listFirst( "/" )
			.listToArray( "." );
		// Build the path parts
		req.url.path = listFirst(
			req.url.raw.replaceNoCase( req.url.protocol & "://" & req.url.host.toList( "." ) & "/", "" ),
			"?"
		).listToArray( "/" );
		// Build query strings
		var qs = req.url.raw.listRest( "?" ).listToArray( "&" );
		for ( var el in qs ) {
			var t        = {};
			t[ "key" ]   = el.listFirst( "=" );
			t[ "value" ] = el.listRest( "=" );
			req.url.query.append( t );
		}
	}

}
