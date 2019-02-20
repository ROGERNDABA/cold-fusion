<link rel="stylesheet" href="float-label.css">

<div class="container">
    <div class="row">
        <div class="mx-auto my-5 form-cont">
            <div class="d-flex switch">
                <div class="switch-login text-center p-2 bg-purple font-weight-bold">Login</div>
                <div class="switch-register text-center p-2 font-weight-bold">Sign Up</div>
            </div>
            <div class="card">
                <h5 class="card-title text-center mt-3 font-weight-bold">Login</h5>
                <form id="login-form" class="px-5 mx-5">
                    <input type="text" name="form-type" value="login" style="display:none">
                    <div class="form-group">
                        <input type="email" class="form-control" placeholder="email" name="email">
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control shadow" placeholder="Password" name="password">
                    </div>
                    <div class="button-group">
                        <button class="btn btn-block " type="submit"> <span>Login</span> </button>
                    </div>
                </form>
                <form id="register-form" class="px-2 gone">
                    <input type="text" name="form-type" value="register" style="display:none">
                    <div class="form-row">
                        <div class="col">
                            <input type="text" class="form-control" name="firstname" placeholder="First name">
                            <p class="errorText mt-1">fgfg</p>
                        </div>
                        <div class="col">
                            <input type="text" class="form-control" name="lastname" placeholder="Last name">
                            <p class="errorText mt-1"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="email" class="form-control" name="email" placeholder="Email">
                        <p class="errorText mt-1"></p>
                    </div>
                    <div class="form-row">
                        <div class="col form-group">
                            <select id="inputGender" class="form-control" name="gender">
                                <option selected disabled="disabled">Gender</option>
                                <option>Male</option>
                                <option>female</option>
                                <option>Other</option>
                                <option>Rather not say</option>
                            </select>
                        </div>
                        <div class="col form-group">
                            <select id="inputCountry" class="form-control" name="country">
                                <option selected>Country</option>
                                <option>South Africa</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" placeholder="Password" name="p1">
                        <p class="errorText mt-1"></p>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" placeholder="Confirm Password" name="p2">
                        <p class="errorText mt-1"></p>
                    </div>
                    <div class="button-group">
                        <button class="btn btn-block " type="submit" name="register-form"> <span>Create</span>
                        </button>
                    </div>
                </form>
            </div>
            <!-- <div class="col-sm" style="background-color:aqua">
                sdfd
            </div>
            <div class="col-sm" style="background-color:yellow">
                dfdf
            </div> -->
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {

        $('.switch-login, .switch-register').click(function () {
            if (!$(this).hasClass('bg-purple')) {
                $('.switch-login, .switch-register').removeClass('bg-purple');
                $(this).addClass('bg-purple')
            }
            if ($(this).hasClass('switch-login')) {
                $('.card-title').html('Login');
                $('#login-form').removeClass('gone');
                $('#register-form').addClass('gone')
            } else {
                $('.card-title').html('Sign Up');
                $('#register-form').removeClass('gone');
                $('#login-form').addClass('gone')
            }
        });


        function getFormData($form) {
            var unindexed_array = $form.serializeArray();
            var indexed_array = {};

            $.map(unindexed_array, function (n, i) {
                indexed_array[n['name']] = n['value'];
            });

            return indexed_array;
        }

        $("#register-form, #login-form").on("submit", function (event) {
            event.preventDefault();
            var formData = getFormData($(this));

            ajaxPost(formData, "root");
        });
    })
</script>