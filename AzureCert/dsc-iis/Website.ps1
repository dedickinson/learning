Configuration Website {
    param ( 
        [Parameter(Mandatory=$true)] 
        [ValidateNotNullorEmpty()]
        [string]
        $webfilesPath,

        [Parameter(Mandatory=$true)] 
        [ValidateNotNullorEmpty()]
        [string]
        $credentialName
    )

    $storageCredential = Get-AutomationPSCredential $credentialName

    # The Node statement specifies which targets this configuration will be applied to.
    Node 'Webserver' {

        # The first resource block ensures that the Web-Server (IIS) feature is enabled.
        WindowsFeature 'WebServer' {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        # The second resource block ensures that the website content copied to the website root folder.
        File 'WebFiles'
        {
            Ensure          = "Present"
            Type            = "Directory"
            Recurse         = $true
            SourcePath      = $webfilesPath
            DestinationPath = 'c:\inetpub\wwwroot'
            Credential      = $storageCredential
        }
    }
}