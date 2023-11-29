component extends="commandbox.system.BaseCommand" {

    property name="JSONPrettyPrint" inject;

    function run(method = 'get', url = '', params = '') {
        var res = 'Please make sure all required parameters were passed in';
        var preparedURL = '';

        // validate the verb
        var methodValid = listFindNoCase('delete,get,patch,post,put', arguments.method);
        var urlValid = isValid('url', arguments.url);
        var hasParams = arguments.params.len();
        var paramsValid = hasParams ? isJSON(arguments.params) : true;

        if (!methodValid) {
            print.redLine('Invalid verb passed: ' & arguments.method);
            return;
        }

        if (!urlValid) {
            print.redLine('Invalid URL passed: ' & arguments.url);
            return;
        } else {
            preparedURL = arguments.url;
        }

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

        switch (arguments.method) {
            default:
                cfhttp(url = preparedURL);
                breeak;
        }

        res = cfhttp.fileContent;

        return isJSON(res) ? JSONPrettyPrint.formatJSON(res) : res;
    }

}
