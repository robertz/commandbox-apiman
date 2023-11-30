component extends="commandbox.system.BaseCommand" {

    property name="RequestSetupService" inject="RequestSetupService@commandbox-apiman";

    function run(url = '', params = '', showHeaders = false) {
        var res = 'Please make sure all required parameters were passed in';
        var preparedURL = '';

        // validate the verb
        var urlValid = isValid('url', arguments.url);
        var hasParams = arguments.params.len();
        var paramsValid = hasParams ? isJSON(arguments.params) : true;

        if (!urlValid) {
            print.redLine('Invalid URL passed: ' & arguments.url);
            return;
        }

        preparedURL = arguments.url;


        // are there params and are they valid
        if (hasParams && paramsValid) {
            var p = deserializeJSON(arguments.params);
            var built = [];
            // iterate through the keys in deserialized params and build the query string
            for (var k in p) {
                // build a key-value pair array of params
                built.append(k & '=' & p[k]);
            }
            // apppend the params to the url string
            preparedURL &= '?' & built.toList('&');
        }

        cfhttp(url = preparedURL, method = "GET", charset = "utf-8");

        if (cfhttp.keyExists('responseHeader') && arguments.showHeaders) {
            for (var key in cfhttp.responseheader) {
                var keyValue = isSimpleValue(cfhttp.responseHeader[key]) ? cfhttp.responseHeader[key] : serializeJSON(
                    cfhttp.responseHeader[key]
                );
                print.yellowText(key & ': ' & keyValue);
                print.line();
            }
            print.line();
        }

        if (isJSON(cfhttp.fileContent)) {
            print.line(deserializeJSON(cfhttp.fileContent));
        } else if (isXML(cfhttp.fileContent)) {
            print.line(xmlParse(cfhttp.fileContent));
        } else {
            print.line(cfhttp.fileContent);
        }
    }

}
