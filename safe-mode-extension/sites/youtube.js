var d = document;

if (/PREF=/.test(d.cookie)) {
        ('; ' + d.cookie).split('; ').forEach(function(cookie) {
                if (/^PREF=/.test(cookie) && !/f2=8000000/.test(cookie)) {
                        cookie += '&f2=8000000; domain=.youtube.com;';
                        d.cookie = cookie;
                        d.location.reload();
                }
        });
}
