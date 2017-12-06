Class RNR.Service Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Map Prefix="/travel" Forward="RNR.Travel.BestPractices"/>

<Route Url="/destinations" Method="GET" Call="Destinations"/>
</Routes>
}

ClassMethod Destinations() As %Status
{
	Set %response.Expires = 86400
	Set %response.Headers("Cache-Control") = "max-age=86400"
    Set obj = {"destinations": ["London","Madrid","Tokyo"]} 
    Write obj.%ToJSON()
    Quit 1
}

}
