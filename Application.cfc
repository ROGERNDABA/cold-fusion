<cfcomponent
    displayname="Application"
    output="true"
    hint="Handle the application.">

    <cfset this.name = 'Roger_2' />
    <cfset this.applicationTimeout = createTimeSpan( 0, 0, 10, 10 ) />
    <cfset this.sessionManagement = true />
    <cfset this.sessionTimeout = createTimeSpan( 0, 0, 10, 10 ) />
   

    <cffunction
        name="onApplicationStart"
        access="public"
        returntype="boolean"
        hint="I initialize the application.">

        <cfreturn true />
    </cffunction>

    <cffunction
        name="onSessionStart"
        access="public"
        returntype="void"
        hint="I initialize the session.">

        <cfset session.dateInitialized = now() />
         <cfset session.loggedIn = 0 />
         <cfset session.successMsg = "" />
         <cfset session.errorMsg = "" />


        <!--- Return out. --->
        <cfreturn />
    </cffunction>

    <cffunction
        name="onSessionEnd"
        access="public"
        returntype="void"
        hint="End of session.">
            <cfset session.loggedIn  = 0/>
        <cfreturn />
    </cffunction>




    <cffunction
        name = "onApplicationEnd" 
        returnType = "boolean" 
        access = "public"
        hint = "where the app ends">
        
        <cfreturn />
    </cffunction>

    <!---<cfdump var = #this#>--->

</cfcomponent>