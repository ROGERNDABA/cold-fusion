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
            height: 50%;
            float: left;
            width: 50%;
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
            FROM za.Suppliers
            WHERE Deleted = 0
            AND SupplierID IN (66,
            497,
            769,
            1376,
            3201)

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
                        "longitude": 18.602054242774337,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "The Cape Grace",
                        "latitude": -33.9087014,
                        "longitude": 18.4204936,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "Cape Town Rail Station",
                        "latitude": -33.9205558,
                        "longitude": 18.4262217,
                        "TravelMode": "TRANSIT"
                    },
                    {
                        "WayPoint": "Rovos Rail Station Pretoria",
                        "latitude": -25.7176659,
                        "longitude": 28.1905657,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "Bongani Mountain Lodge",
                        "latitude": -25.4599251,
                        "longitude": 31.2899048,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "SANP: KNP Olifants Rest Camp",
                        "latitude": -23.943,
                        "longitude": 31.14110000000005,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "Southern Sun O.R Tambo Intl Airport Hotel",
                        "latitude": -26.134674699999998,
                        "longitude": 28.227372647610082,
                        "TravelMode": "DRIVING"
                    },
                    {
                        "WayPoint": "O.R Tambo Intl Airport",
                        "latitude": -26.132936700000002,
                        "longitude": 28.232214537328055
                    }
                ]

                function BuildMultipleWayPoints(Array) {
                    var WayPointsCollection = [];
                    var SubWayPointCollection = [];

                    for (let index = 0; index < Array.length - 1; index++) {
                        const Element = Array[index];
                        const Element2 = Array[index + 1]
                        if (Element.TravelMode == Element2.TravelMode)
                            SubWayPointCollection.push(Element);
                        else {
                            SubWayPointCollection.push(Element);
                            SubWayPointCollection.push(Element2);
                            WayPointsCollection.push(SubWayPointCollection);
                            SubWayPointCollection = [];
                        }
                    }
                    return WayPointsCollection;
                }

                // console.log(BuildMultipleWayPoints(CoOrdinates));

                function initMap() {
                    var directionsService = new google.maps.DirectionsService;
                    var directionsDisplay = new google.maps.DirectionsRenderer;
                    var map = new google.maps.Map(document.getElementById('map'), {
                        zoom: 6,
                        center: {
                            lat: -34.2969541,
                            lng: 18.2479026
                        },
                        gestureHandling: 'greedy'
                    });
                    directionsDisplay.setMap(map);
                    var MultipleWayPoints = BuildMultipleWayPoints(CoOrdinates).reverse();
                    calculateAndDisplayRoute(MultipleWayPoints, map);
                }

                async function calculateAndDisplayRoute(MultipleWayPoints, map) {
                    directionsServices = [];
                    directionsDisplays = [];

                    var RouteColors = ['#00ff0c', '#ff00ff', '#00faff', '#ffaa00', '#ff0015'];
                    var ColorIndex = 0;

                    for (i = 0; i < MultipleWayPoints.length; i++) {

                        var Routes = MultipleWayPoints[i];
                        var RouteWayPoints = []

                        for (let index = 0; index < Routes.length; index++) {
                            const key = Routes[index];
                            RouteWayPoints.push({
                                location: new google.maps.LatLng(key.latitude, key.longitude),
                                stopover: true
                            })
                        };

                        directionsServices[i] = new google.maps.DirectionsService();
                        var Start = RouteWayPoints[0].location;
                        var End = RouteWayPoints[RouteWayPoints.length - 1].location;

                        var request = {
                            origin: Start,
                            destination: End,
                            waypoints: RouteWayPoints.slice(1, RouteWayPoints.length - 1),
                            optimizeWaypoints: true,
                            travelMode: Routes[0].TravelMode
                        };

                        // console.log(RouteWayPoints.slice(1, RouteWayPoints.length - 1));


                        directionsServices[i].route(request, async function (response, status) {
                            await response;
                            console.log(response);
                            var PreserveViewport = (i == 0) ? true : false;
                            console.log(PreserveViewport);

                            if (status == google.maps.DirectionsStatus.OK) {
                                directionsDisplays.push(new google.maps.DirectionsRenderer({
                                    preserveViewport: PreserveViewport,
                                    polylineOptions: {
                                        strokeColor: RouteColors[ColorIndex],
                                        strokeOpacity: 0.5,
                                        strokeWeight: 5
                                    }
                                }));
                                directionsDisplays[directionsDisplays.length - 1].setMap(map);
                                directionsDisplays[directionsDisplays.length - 1].setDirections(
                                    response);
                            } else {
                                // console.log(i);

                                PathArray = new google.maps.MVCArray([
                                    response.request.origin.location,
                                    response.request.destination.location
                                ]);

                                var PolyLine = new google.maps.Polyline({
                                    path: PathArray,
                                    geodesic: true,
                                    strokeColor: RouteColors[ColorIndex],
                                    strokeOpacity: 0.5,
                                    strokeWeight: 5
                                })
                                PolyLine.setMap(map);
                            }
                            ColorIndex = (ColorIndex == RouteColors.length - 1) ? 0 : ColorIndex + 1;
                        });
                    }
                }
            </script>
            <script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyB_FQrvDn9JgPvApBnO_9RvGp8P-EJ189g&language=en&region=JP&callback=initMap">
            </script>

</body>

</html>