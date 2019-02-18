<cfset requestBody=toString( getHttpRequestData().content ) />

<cfif isJSON( requestBody )>

    <!--- Echo back POST data. --->

    <cfset ajaxPost=deserializeJSON( requestBody )>
        <cfset session.loggedIn = 1/>

    <cfquery name="myQuery" datasource="RogerDataSource">
        SELECT *
        FROM Users
    </cfquery>
    
    <cfdump var=#myQuery#>
        <cfdump var=#session# />

</cfif>