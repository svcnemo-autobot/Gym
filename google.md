# Output of `curl http://google.com`

Command:

```sh
curl http://google.com
```

The response below is the captured standard output. The workstation's egress
policy rejected plain HTTP, so this is an HTTP 403 error page, not Google's
homepage. Curl exited with status 0 because it was not run with `--fail`.
The capture used connection and total-time limits without following redirects.

```html
<!DOCTYPE HTML>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Error response</title>
    </head>
    <body>
        <h1>Error response</h1>
        <p>Error code: 403</p>
        <p>Message: plain HTTP dependency sources are denied.</p>
        <p>Error code explanation: 403 - Request forbidden -- authorization will not help.</p>
    </body>
</html>

```
