'use strict';

const headers = {
    "any": {
        "Server":"",
        "X-Content-Type-Options": "nosniff",
        "Referrer-Policy": "no-referrer",
        "Strict-Transport-Security": "max-age=31536000; includeSubdomains; preload"
    },
    "html": {
        // Content-Security-Policy-Report-Only: https://{report-uri}.report-uri.com/r/d/csp/reportOnly
        // Content-Security-Policy:             https://{report-uri}.report-uri.com/r/d/csp/enforce
        "Content-Security-Policy": "default-src 'none';" +
            " img-src 'self';" +
            " font-src data:;" +
            " script-src 'sha256-WEV9nNvWNzOmIgrlHxClw0smC6l2EhhvH+AHudWF46c=';" +
            " style-src 'unsafe-inline';" +
            " connect-src 'none';" +
            " form-action 'none';" +
            " base-uri 'none';" +
            " frame-ancestors 'none';" +
            " block-all-mixed-content;" +
            " upgrade-insecure-requests;" +
            " report-uri https://willfarrell.report-uri.com/r/d/csp/enforce",
        "Feature-Policy": "" + 
            " camera 'none';" +
            " fullscreen 'none';" +
            " gyroscope 'none';" +
            " geolocation 'none';" +
            " magnetometer 'none';" +
            " microphone 'none';" +
            " midi 'none';" +
            " payment 'none';" +
            " speaker 'none';" +
            " sync-xhr 'none'",
        "X-Frame-Options": "DENY",
        "X-XSS-Protection": "1; mode=block",
        "X-UA-Compatible":"ie=edge"
    }
};

// Reformat headers object for CF
function makeHeaders (headers) {
    const formattedHeaders = {};
    Object.keys(headers).forEach((key) => {
        formattedHeaders[key.toLowerCase()] = [{
            key: key,
            value: headers[key]
        }]
    });
    return formattedHeaders;
}

function getHeaders(mime) {
    return makeHeaders(headers[mime])
}

function handler (event, context, callback) {
    const request = event.Records[0].cf.request;
    const response = event.Records[0].cf.response;

    let responseHeaders = getHeaders('any');

    // Catch 304 w/o Content-Type from S3
    if (!response.headers['content-type'] && request.uri === '/') {
        response.headers['content-type'] = [{
            key:'Content-Type',
            value:'text/html; charset=utf-8'
        }];
    }

    if (response.headers['content-type'] && response.headers['content-type'][0].value.indexOf('text/html') !== -1) {
        Object.assign(responseHeaders, getHeaders('html'));
    }

    Object.assign(response.headers, responseHeaders);

    return callback(null, response);
}

module.exports = {
    makeHeaders,
    headers,
    handler
};
