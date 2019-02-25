<html>

<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Waypoints in Directions</title>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <style>
        #right-panel {
            /* font-family: 'Roboto', 'sans-serif';
            line-height: 30px; */
            padding-left: 10px;
        }



        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #map {
            height: 60%;
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

        #Legends {
            list-style: none;
        }
        #Legends li {
            display: inline-block;
            cursor: pointer;
            margin: 5px;
        }
        #Legends span {
            border: 1px solid #ccc;
            float: left;
            width: 12px;
            height: 12px;
            margin: 2px;
        }
    </style>
</head>

<body>


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


    <div id="map"></div>
    <div id="right-panel">
        <ul id="Legends">
            <h4>Point Keys</h4>
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
                scale: 1,
                center: {
                    lat: -28.3708821,
                    lng: 22.0711449
                },
                gestureHandling: 'greedy'
            });
            var MapInformation = BuildMapInformation(ObjectResults);
            var Markers = await SetMarkers(map, MapInformation);
            SetMarkerEvents(map, Markers, MapInformation);
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
                if (IconIndex == 8)
                    IconIndex = 0;



                return Marker;
            });

            // MarkerClusterer js for clustering very close map markers
            var markerCluster = new MarkerClusterer(map, Markers, {
                imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'
            });
            console.log(map.getZoom());

            return Markers;
        }



        function SetMarkerEvents(map, Markers, MapInformation) {
            var MarkerLabels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            var PointColors = ['#00ff0c', '#ff00ff', '#ff0015', '#ffaa00', '#00faff', '#a100ff', '#e9ff00', '#009104'];
            var ColorIndex = 0;

            Markers.map(async (Marker, index) => {

                var InfoWindow = new google.maps.InfoWindow();

                await google.maps.event.addListener(Marker, 'mouseover', (function (Marker,
                    index) {
                    var LabelIndex = index;

                    $('#Legends').append(

                        `<li id="${index}" class="LegendPoints"><span style="background-color: ${PointColors[ColorIndex++]}"></span>&nbsp;Point: ${MarkerLabels[LabelIndex++ % MarkerLabels.length]}
                            </li><br>`

                    );
                    ColorIndex = (ColorIndex == 8) ? 0 : ColorIndex;



                    return function () {
                        var InfoWindowContent =
                            `<div id="content">
                                <div id="siteNote"></div>

                                <h2 id="firstHeading" style="text-align:center">${MapInformation[index].SupplierName}</h2>
                                <p><img src="https://www.w3schools.com/howto/img_forest.jpg" width="120" height="90" style="float:left;
                                    margin-right: 10px;margin-bottom: 2px;">
                                    <strong>${MapInformation[index].SupplierName}</strong> Lorem ipsum dolor sit amet,
                                    consectetur adipiscing elit, sed do eiusmod temp incididunt ut labore e dolore magna aliqua.
                                </p><br>
                                <em>More info: <a href="#">dfgtdfgtdftdf</a></em>
                            </div>
                            `;
                        InfoWindow.setContent(InfoWindowContent);
                        InfoWindow.open(map, Marker);
                    }
                })(Marker, index));

                google.maps.event.addListener(map, 'click', function () {
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
                TargetMarker.setAnimation(google.maps.Animation.BOUNCE);
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