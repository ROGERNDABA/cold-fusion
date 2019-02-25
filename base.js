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
    var directionsDisplay = new google.maps.DirectionsRenderer({
        suppressMarkers: true
    });
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

    var RouteColors = ['#00ff0c', '#ff00ff', '#ff0015', '#ffaa00', '#00faff', '#a100ff', '#e9ff00', '#009104'];
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
                    },
                    suppressMarkers: true
                }));
                var iconBase = 'https://maps.google.com/mapfiles/kml/shapes/';

                var marker = new google.maps.Marker({
                    icon: './Markers/0.png',
                    position: response.request.origin.location,
                    map: map
                })
                await directionsDisplays[directionsDisplays.length - 1].setMap(map);
                await directionsDisplays[directionsDisplays.length - 1].setDirections(
                    response);
            } else {
                console.log(response);

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
                await PolyLine.setMap(map);
            }
            ColorIndex = (ColorIndex == RouteColors.length - 1) ? 0 : ColorIndex + 1;
        });
    }
}



///////BASE 2

// <cfoutput>
//     <script>
//         var ObjectResults = #ResultObject#;
//     </script>
// </cfoutput>

// <script>
// console.log(ObjectResults);

function BuildMapInformation(ObjectResults) {
    console.log('sdsdsdsdd');

    var MapInformation = [];

    for (let index = 0; index < ObjectResults.ROWCOUNT; index++) {
        const Element = ObjectResults[index];

        MapInformation.push({
            "SupplierName": ObjectResults.DATA.SUPPLIERNAME[index],
            "Latitude": parseFloat(ObjectResults.DATA.LATITUDE[index]),
            "Longitude": parseFloat(ObjectResults.DATA.LONGITUDE[index])
        })
    }
    console.log(MapInformation);
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
    await SetMarkers(map, MapInformation);
    ZoomPanEvent(map, MapInformation);
    // console.log('sdsdsdsd');
}

async function SetMarkers(map, MapInformation) {
    var Labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var LabelIndex = 0;
    for (let index = 0; index < MapInformation.length; index++) {
        const Element = MapInformation[index];




        var CoOrdinates = await new google.maps.LatLng(Element.Latitude, Element.Longitude)
        var Markers = [];

        var Marker = await new google.maps.Marker({
            map: map,
            label: {
                text: Labels[LabelIndex++ % Labels.length],
                fontWeight: 'bold'
            },
            animation: google.maps.Animation.DROP,
            position: CoOrdinates,
            icon: {
                url: `/Markers/${index}.png`,
                scaledSize: new google.maps.Size(40, 40)
            },
            title: Element.SupplierName
        })

        var InfoWindow = new google.maps.InfoWindow();

        await google.maps.event.addListener(Marker, 'click', (function (Marker,
            index) {
            $('#Legends').append(
                `<li class="LegendPoints" id="${index}">Point: ${Labels[LabelIndex -1 % Labels.length]}</li>`
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
    }

}

function animateMapZoomTo(map, targetZoom) {
    var currentZoom = arguments[2] || map.getZoom();
    if (currentZoom != targetZoom) {
        google.maps.event.addListenerOnce(map, 'zoom_changed', function (event) {
            animateMapZoomTo(map, targetZoom, currentZoom + (targetZoom > currentZoom ? 1 : -1));
        });
        setTimeout(function () {
            map.setZoom(currentZoom)
        }, 80);
    }
}

function ZoomPanEvent(map, MapInformation) {

    $('.LegendPoints').click(async function () {
        var PanPosition = new google.maps.LatLng(
            MapInformation[Number($(this).attr('id'))].Latitude,
            MapInformation[Number($(this).attr('id'))].Longitude,
        );

        map.setZoom(16);
        map.setCenter(PanPosition);
        // map.animateCamera(CameraUpdateFactory.newLatLngZoom(PanPosition, ZOOM_FACTOR));
        console.log($(this).attr('id'));
    })
}