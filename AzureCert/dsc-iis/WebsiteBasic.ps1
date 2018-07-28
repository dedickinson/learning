Configuration WebsiteBasic {

    Node 'Webserver' {

        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        
    }
}