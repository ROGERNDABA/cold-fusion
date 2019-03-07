<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
</head>

<body>
    <script>
        $(document).ready(function () {
            var arr = [{
                lat: 1.1,
                lng: 2
            }, {
                lat: 1,
                lng: 2
            }, {
                lat: 1,
                lng: 2
            }, {
                lat: 1,
                lng: 2
            }, {
                lat: 1,
                lng: 2
            }];

            Array.prototype.AverageCoordinates = function (prop1, prop2) {
                var TotalLatitude = 0.0,
                    TotalLongitude = 0.0;
                for (var i = 0, _len = this.length; i < _len; i++) {
                    TotalLatitude += this[i][prop1];
                    TotalLongitude += this[i][prop2];
                }
                return {
                    lat: TotalLatitude / parseFloat(this.length),
                    lng: TotalLongitude / parseFloat(this.length)
                };
            }

            console.log(arr.AverageCoordinates("lat", "lng"))
        })
    </script>
</body>

</html>