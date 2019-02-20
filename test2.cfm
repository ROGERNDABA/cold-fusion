<html>

<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Waypoints in Directions</title>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
    <style>
        #right-panel {
            font-family: 'Roboto', 'sans-serif';
            line-height: 30px;
            padding-left: 10px;
        }

        #right-panel select,
        #right-panel input {
            font-size: 15px;
        }

        #right-panel select {
            width: 100%;
        }

        #right-panel i {
            font-size: 12px;
        }

        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #map {
            height: 100%;
            float: left;
            width: 70%;
            height: 100%;
        }

        #right-panel {
            margin: 20px;
            border-width: 2px;
            width: 20%;
            height: 400px;
            float: left;
            text-align: left;
            padding-top: 0;
        }

        #directions-panel {
            margin-top: 10px;
            background-color: #FFEE77;
            padding: 10px;
            overflow: scroll;
            height: 174px;
        }
    </style>
</head>

<body>

    <cfset WayPoints=ArrayNew(1) />
    <cfset ArrayAppend(WayPoints, "The Cape Grace" ) />
    <cfset ArrayAppend(WayPoints, "Cape Town Rail Station" ) />
    <cfset ArrayAppend(WayPoints, "Rovos Rail Station Pretoria" ) />
    <cfset ArrayAppend(WayPoints, "Bongani Mountain Lodge" ) />
    <cfset ArrayAppend(WayPoints, "SANP: KNP Olifants Rest Camp" ) />
    <cfset ArrayAppend(WayPoints, "Southern Sun O R Tambo Intl Airport Hotel" ) />

    <cfdump var=#WayPoints#>

        <cfquery name="myQuery" datasource="TIO_TEST">
            SELECT *
            FROM Suppliers
            WHERE SupplierName
            (LIKE '%#WayPoints[1]#%'
            <cfloop array="#WayPoints#" index="i">
                OR SupplierName
                LIKE '%#i#%')
            </cfloop>
            AND Deleted = 0

        </cfquery>

        <cfdump var=#myQuery#>

            <div id="map"></div>
            <div id="right-panel">
                <div id="directions-panel"></div>
            </div>
            <script>
                var CoOrdinates = [{
                        "WayPoint": "Cape Town International Airport",
                        "latitude": -33.97109385,
                        "longitude": 18.602054242774337
                    },
                    {
                        "WayPoint": "The Cape Grace",
                        "latitude": -33.9087014,
                        "longitude": 18.4204936
                    },
                    {
                        "WayPoint": "Cape Town Rail Station",
                        "latitude": -33.924445,
                        "longitude": 18.4317089
                    },
                    {
                        "WayPoint": "Rovos Rail Station Pretoria",
                        "latitude": -25.7176659,
                        "longitude": 28.1905657
                    },
                    {
                        "WayPoint": "Bongani Mountain Lodge",
                        "latitude": -25.4599251,
                        "longitude": 31.2899048
                    },
                    {
                        "WayPoint": "SANP: KNP Olifants Rest Camp",
                        "latitude": -23.943,
                        "longitude": 31.14110000000005
                    },
                    {
                        "WayPoint": "Southern Sun O.R Tambo Intl Airport Hotel",
                        "latitude": -26.134674699999998,
                        "longitude": 28.227372647610082
                    },
                    {
                        "WayPoint": "O.R Tambo Intl Airport",
                        "latitude": -26.132936700000002,
                        "longitude": 28.232214537328055
                    }
                ]

                function initMap() {
                    var directionsService = new google.maps.DirectionsService;
                    var directionsDisplay = new google.maps.DirectionsRenderer;
                    var map = new google.maps.Map(document.getElementById('map'), {
                        zoom: 6,
                        center: {
                            lat: Math.floor(CoOrdinates[0].latitude) + 0.5,
                            lng: Math.floor(CoOrdinates[0].longitude) + 0.5
                        }
                    });
                    directionsDisplay.setMap(map);
                    calculateAndDisplayRoute(directionsService, directionsDisplay);
                }

                function calculateAndDisplayRoute(directionsService, directionsDisplay) {
                    var WayPoints = [];
                    for (let index = 1; index < CoOrdinates.length - 1; index++) {
                        const key = CoOrdinates[index];
                        WayPoints.push({
                            location: new google.maps.LatLng(key.latitude, key.longitude),
                            stopover: true
                        })
                        // console.log(`long: ${key.longitude}\nlat: ${key.latitude}`);

                    };


                    var WP1 = new google.maps.LatLng(-33.97109385, 18.602054242774337)
                    directionsService.route({
                        origin: WayPoints[0].location,
                        destination: WayPoints[WayPoints.length - 1].location,
                        waypoints: WayPoints.slice(1, WayPoints.length - 1),
                        optimizeWaypoints: true,
                        travelMode: 'DRIVING'
                    }, function (response, status) {
                        if (status === 'OK') {
                            directionsDisplay.setDirections(response);
                            var route = response.routes[0];
                        } else {
                            window.alert('Directions request failed due to ' + status);
                        }
                    });

                    // directionsService.route({
                    //     origin: WayPoints[0].location,
                    //     destination: WayPoints[1].location,
                    //     // waypoints: WayPoints.slice(1, WayPoints.length - 1),
                    //     optimizeWaypoints: true,
                    //     travelMode: 'DRIVING'
                    // }, function (response, status) {
                    //     if (status === 'OK') {
                    //         directionsDisplay.setDirections(response);
                    //         directionsDisplay.setMap(map);
                    //         var route = response.routes[0];
                    //     } else {
                    //         window.alert('Directions request failed due to ' + status);
                    //     }
                    // });
                    // directionsService.route({
                    //     origin: WayPoints[4].location,
                    //     destination: WayPoints[5].location,
                    //     // waypoints: WayPoints.slice(1, WayPoints.length - 1),
                    //     optimizeWaypoints: true,
                    //     travelMode: 'DRIVING'
                    // }, function (response, status) {
                    //     if (status === 'OK') {
                    //         directionsDisplay.setDirections(response);
                    //         var route = response.routes[0];
                    //     } else {
                    //         window.alert('Directions request failed due to ' + status);
                    //     }
                    // });
                }





                // var directionsDisplay;
                //     var directionsService = new google.maps.DirectionsService();
                //     var map;
                //     var locations1 = [["route1", "", 43.152068, -79.165230, 43.117574, -79.247694],
                //     ["route2", "", 43.096214, -79.037739, 42.8864468, -78.8783689],
                //     ];


                //     function initialize() {
                //         directionsDisplay = new google.maps.DirectionsRenderer();
                //         var awal = new google.maps.LatLng(43, -79);
                //         var mapOptions = {
                //             zoom: 10,
                //             center: awal
                //         }
                //         map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
                //         directionsDisplay.setMap(map);
                //         var i;
                //         directionsServices = [];
                //         directionsDisplays = [];
                //         for (i = 0; i < locations1.length; i++) {
                //             directionsServices[i] = new google.maps.DirectionsService();
                //             var start = new google.maps.LatLng(locations1[i][2], locations1[i][3]);
                //             var end = new google.maps.LatLng(locations1[i][4], locations1[i][5]);

                //             var request = {
                //                 origin: start,
                //                 destination: end,
                //                 optimizeWaypoints: true,
                //                 travelMode: google.maps.TravelMode.DRIVING
                //             };

                //             directionsServices[i].route(request, function (response, status) {
                //                 if (status == google.maps.DirectionsStatus.OK) {
                //                     directionsDisplays.push(new google.maps.DirectionsRenderer({ preserveViewport: true }));
                //                     directionsDisplays[directionsDisplays.length - 1].setMap(map);
                //                     directionsDisplays[directionsDisplays.length - 1].setDirections(response);
                //                 } else alert("Directions request failed:" + status);
                //             });
                //         }
                //     }
                //     google.maps.event.addDomListener(window, 'load', initialize);
            </script>
            <script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyB_FQrvDn9JgPvApBnO_9RvGp8P-EJ189g&language=en&region=JP&callback=initMap">
            </script>

</body>

</html>