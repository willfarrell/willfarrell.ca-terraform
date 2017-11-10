'use strict';
exports.handler = (event, context, callback) => {
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    headers['Strict-Transport-Security'] = [{key: 'Strict-Transport-Security', value:"max-age=31536000; includeSubdomains; preload"}];
    headers['X-Content-Type-Options']    = [{key: 'X-Content-Type-Options', value:"nosniff"}];
    headers['X-Frame-Options']           = [{key: 'X-Frame-Options', value:"DENY"}];
    headers['X-XSS-Protection']          = [{key: 'X-XSS-Protection', value:"1; mode=block"}];
    headers['Referrer-Policy']           = [{key: 'Referrer-Policy', value:"no-referrer"}];

    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/default-src
    headers['Content-Security-Policy']   = [{key: 'Content-Security-Policy', value:
        "default-src 'none';" +
        " img-src 'self';" +
        " script-src 'self';" +
        " style-src 'self';" +
        " base-uri 'none';" +
        " frame-uri 'none';" +
        " frame-ancestors 'self';" +
        " block-all-mixed-content;" +
        " upgrade-insecure-requests;" +
        " reflected-xss block;" +
        " referrer no-referrer-when-downgrade"}];

    // Symantec Class 3 Secure Server CA - G4: pin-sha256="9n0izTnSRF+W4W4JTq51avSXkWhQB8duS2bxVLfzXsY="
    // COMODO ECC Certification Authority: pin-sha256="58qRu/uxh4gFezqAcERupSkRYBlBAvfcw7mEjGPLnNU="
    // IdenTrust Commercial Root CA 1: pin-sha256="B+hU8mp8vTiZJ6oEG/7xts0h3RQ4GK2UfcZVqeWH/og="
    // headers['Public-Key-Pins-Report-Only'] =
    //     'pin-sha256="JSMzqOOrtyOT1kmau6zKhgT676hGgczD5VMdRMyJZFA=";' +
    //     ' pin-sha256="YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=";' +
    //     ' max-age=1296001; includeSubDomains';

    callback(null, response);
};
