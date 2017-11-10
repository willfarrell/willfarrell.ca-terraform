'use strict';
exports.handler = (event, context, callback) => {
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    headers['Strict-Transport-Security'] = [{key: 'Strict-Transport-Security', value:"max-age=31536000; includeSubdomains; preload"}];
    headers['X-Content-Type-Options']    = [{key: 'X-Content-Type-Options', value:"nosniff"}];
    headers['X-Frame-Options']           = [{key: 'X-Frame-Options', value:"DENY"}];
    headers['X-XSS-Protection']          = [{key: 'X-XSS-Protection', value:"1; mode=block"}];
    headers['Referrer-Policy']           = [{key: 'Referrer-Policy', value:"no-referrer"}];

    headers['Content-Security-Policy']   = [{key: 'Content-Security-Policy', value:"default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"}];

    // headers['Strict-Transport-Security'] = "max-age=31536000; includeSubdomains; preload";
    // headers['Content-Security-Policy']   = "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'";
    // headers['X-Content-Type-Options']    = "nosniff";
    // headers['X-Frame-Options']           = "DENY";
    // headers['X-XSS-Protection']          = "1; mode=block";
    // headers['Referrer-Policy']           = "no-referrer";

    // Pinned Keys are the Amazon intermediate: "s:/C=US/O=Amazon/OU=Server CA 1B/CN=Amazon"
    //   and LetsEncrypt "Let’s Encrypt Authority X1 (IdenTrust cross-signed)"
    //   and TODO add in comodo
    //headers['Public-Key-Pins']           = 'pin-sha256="JSMzqOOrtyOT1kmau6zKhgT676hGgczD5VMdRMyJZFA="; pin-sha256="YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg="; max-age=1296001; includeSubDomains';

    callback(null, response);
};
