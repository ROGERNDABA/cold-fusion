<html lang="en">

<head>
    <cfinclude template="header.cfm">

<body>
    <cfinclude template="navbar.cfm" runOnce="true">
        <div id="root" class="root">
            <!--- Handle messages success/error --->
            <cfif session.successMsg NEQ "">
                <div class="alert alert-success" role="alert">
                    <cfoutput>#session.successMsg#</cfoutput>
                </div>
                <cfelseif session.errorMsg NEQ "">
                    <div class="alert alert-danger" role="alert">
                        <cfoutput>#session.errorMsg#</cfoutput>
                    </div>
            </cfif>
            <div id="content">ssss</div>

            <cfif NOT session.loggedIn>
                <script>
                    $(document).ready(function () {
                        $('#root').load('forms.cfm');
                    });
                </script>
                <cfelse>
                    <script>
                        $(document).ready(function () {
                            $('#root').load('test.cfm');
                        });
                    </script>
            </cfif>
        </div>

        <div id="respy">
        </div>

        <script>
            $(document).ready(function () {


                $('#submit').on('click', function () {
                    ajaxPost({
                        "firstname": "roger",
                        "lastname": "ndaba"
                    }, "root")
                });
            })
        </script>
</body>

</html>