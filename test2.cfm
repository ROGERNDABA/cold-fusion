<html>

<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Waypoints in Directions</title>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
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
            height: 70%;
            float: left;
            width: 70%;
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



        <cfdump var=#myQuery# />

        <div id="map"></div>
        <div id="right-panel">
            <ul id="Legends">
            </ul>
        </div>



        <cfset ResultObject=#SerializeJSON(myQuery,true)# />

        <cfoutput>
            <script>
                var ObjectResults = #ResultObject#;
            </script>
        </cfoutput>

        <script>
            // console.log(ObjectResults);

            function BuildMapInformation(ObjectResults) {
                var MapInformation = [];

                for (let index = 0; index < ObjectResults.ROWCOUNT; index++) {
                    const Element = ObjectResults[index];

                    MapInformation.push({
                        "SupplierName": ObjectResults.DATA.SUPPLIERNAME[index],
                        "Latitude": parseFloat(ObjectResults.DATA.LATITUDE[index]),
                        "Longitude": parseFloat(ObjectResults.DATA.LONGITUDE[index])
                    })
                }
                return MapInformation;
            }


            async function initMap() {
                var map = new google.maps.Map(document.getElementById('map'), {
                    zoom: 5,
                    center: {
                        lat: -28.3708821,
                        lng: 22.0711449
                    },
                    gestureHandling: 'greedy'
                });
                var MapInformation = BuildMapInformation(ObjectResults);
                var Markers = await SetMarkers(map, MapInformation);
                SetMarkerEvents(Markers, MapInformation);
                ZoomPanEvent(map, MapInformation, Markers);
                // console.log('sdsdsdsd');
            }



            // Function that builds [{lat: ..., lng: ...}, ...] from
            // map information array 
            function BuildLocationsObject(MapInformation) {
                var Locations = [];
                MapInformation.forEach(Element => {
                    Locations.push({
                        lat: Element.Latitude,
                        lng: Element.Longitude
                    });
                });
                return Locations;
            }


            // function to define different positions of markers int the map as well as their attributes 
            function SetMarkers(map, MapInformation) {
                var Locations = BuildLocationsObject(MapInformation);

                // Labels string array
                var MarkerLabels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                var IconIndex = 0;

                var Markers = Locations.map(function (Location, i) {
                    var Element = MapInformation[i];

                    var Marker = new google.maps.Marker({
                        label: {
                            text: MarkerLabels[i++ % MarkerLabels.length],
                            fontWeight: 'bold'
                        },
                        animation: google.maps.Animation.DROP,
                        position: Location,
                        icon: {
                            url: `/Markers/${IconIndex++}.png`,
                            scaledSize: new google.maps.Size(40, 40)
                        },
                        title: Element.SupplierName
                    });

                    return Marker;
                });

                // MarkerClusterer js for clustering very close map markers
                var markerCluster = new MarkerClusterer(map, Markers, {
                    imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'
                });
                console.log(map.getZoom());

                return Markers;
            }


            function SetMarkerEvents(Markers, MapInformation) {
                var MarkerLabels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

                Markers.map(async (Marker, index) => {

                    var InfoWindow = new google.maps.InfoWindow();

                    await google.maps.event.addListener(Marker, 'mouseover', (function (Marker,
                        index) {
                        $('#Legends').append(
                            `<li class="LegendPoints" id="${index}">Point: ${[index++ % MarkerLabels.length]}</li>`
                        );

                        return function () {
                            var InfoWindowContent =
                                `<div id="content">
                                <div id="siteNote"></div>

                                <h1 id="firstHeading" style="text-align:center">${MapInformation[index].SupplierName}</h1>
                                <p><strong>${MapInformation[index].SupplierName}</strong> Lorem ipsum dolor sit amet,
                                    consectetur adipiscing elit, sed do eiusmod temp incididunt ut labore e dolore magna aliqua.
                                </p><br>
                                <em>More info: <a href="#">dfgtdfgtdftdf</a></em>
                            </div>
                            `;
                            InfoWindow.setContent(InfoWindowContent);
                            InfoWindow.open(map, Marker);
                        }
                    })(Marker, index));

                    google.maps.event.addListener(Marker, 'mouseout', function () {
                        if (InfoWindow) {
                            InfoWindow.close();
                        }
                    });
                })
            };

            function ZoomPanEvent(map, MapInformation, Markers) {

                $('.LegendPoints').click(async function () {
                    var MarkerIndex = Number($(this).attr('id'));
                    var TargetMarker = Markers[MarkerIndex];

                    var PanPosition = new google.maps.LatLng(
                        MapInformation[MarkerIndex].Latitude,
                        MapInformation[MarkerIndex].Longitude,
                    );

                    map.setZoom(16);
                    map.setCenter(PanPosition);
                    TargetMarker.setAnimation(google.maps.Animation.DROP);
                    setTimeout(function () {
                        TargetMarker.setAnimation(null);
                    }, 200);
                })
            }
        </script>
        <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
        </script>

        <script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyB_FQrvDn9JgPvApBnO_9RvGp8P-EJ189g&language=en&region=JP&callback=initMap" async defer>
        </script>

</body>

</html>