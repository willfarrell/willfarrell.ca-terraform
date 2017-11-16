'use strict';

// Reformat headers object for CF
const makeHeaders = (headers) => {
    Object.keys(headers).forEach((key) => {
        headers[key.toLowerCase()] = {
            key: key,
            value: headers[key]
        }
    });
    return headers;
};

exports.handler = (event, context, callback) => {
    const response = event.Records[0].cf.response;
    const securityHeaders = {
        "Strict-Transport-Security": "max-age=31536000; includeSubdomains; preload",
        "X-Content-Type-Options": "nosniff",
        "X-Frame-Options": "DENY",
        "X-XSS-Protection": "1; mode=block",
        "Referrer-Policy": "no-referrer",
        "Content-Security-Policy-Report-Only":
            "default-src 'none';" +
            " img-src 'self';" +
            " script-src 'self';" +
            " style-src 'self';" +
            " base-uri 'none';" +
            " frame-uri 'none';" +
            " frame-ancestors 'self';" +
            " require-sri-for script style;" +
            " block-all-mixed-content;" +
            " upgrade-insecure-requests;" +
            " reflected-xss block;" +
            " referrer no-referrer-when-downgrade" +
            " report-uri https://"+process.env.REPORT_URI_SUBDOMAIN+".report-uri.com/r/d/csp/reportOnly"
    };

    response.headers = Object.assign({}, response.headers, makeHeaders(securityHeaders));


    // Symantec Class 3 Secure Server CA - G4: pin-sha256="9n0izTnSRF+W4W4JTq51avSXkWhQB8duS2bxVLfzXsY="
    // COMODO ECC Certification Authority: pin-sha256="58qRu/uxh4gFezqAcERupSkRYBlBAvfcw7mEjGPLnNU="
    // IdenTrust Commercial Root CA 1: pin-sha256="B+hU8mp8vTiZJ6oEG/7xts0h3RQ4GK2UfcZVqeWH/og="
    // response.headers['Public-Key-Pins-Report-Only'] =
    //     'pin-sha256="JSMzqOOrtyOT1kmau6zKhgT676hGgczD5VMdRMyJZFA=";' +
    //     ' pin-sha256="YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=";' +
    //     ' max-age=1296001; includeSubDomains';

    callback(null, response);
};
