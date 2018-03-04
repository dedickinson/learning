function FindProxyForURL(url, host) {
    // See: https://findproxyforurl.com/example-pac-file/

    // If the hostname matches, send direct.
    if (dnsDomainIs(host, "*.lab.example.com")) 
        return "DIRECT";
    
    // DEFAULT RULE: All other traffic, use below proxies, in fail-over order.
    return "PROXY proxy.lab.example.com:3128;";
     
}