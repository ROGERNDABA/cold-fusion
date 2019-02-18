<link rel="stylesheet" href="navbar.css">
<div class=" fixed-top" style="background-color:black">
<nav class="navbar navbar-expand-sm">
    <a class="navbar-brand" href="#">
    <img src="https://i.ibb.co/vkCH0sc/imageedit-1-5078652434.png" alt="imageedit-1-5078652434" border="0" width="30" height="30">
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span><i class="fas fa-bars"></i></span>
    </button>
<script>
$(document).ready(function () {
$(".nav-link").click(function(e){
    e.preventDefault();

    //console.log( $(this).attr("href") )
    $("#root").html('Please Stand By......').load($(this).attr("href"));
})

})
</script>

    

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="test1.cfm">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="test2.cfm">Link</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Disabled</a>
            </li>
        </ul>
    </div>
</nav>
</div>