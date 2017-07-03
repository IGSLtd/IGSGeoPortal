<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=7,IE=9">
<meta name="viewport"
	content="initial-scale=1, maximum-scale=1,user-scalable=no">
<title>IGS geo portal</title>
<link rel="shortcut icon" href="resources/images/favicon.ico">
<!-- ArcGIS API for JavaScript CSS-->
<link rel="stylesheet" href="//js.arcgis.com/3.10/js/esri/css/esri.css">
<!-- Web Framework CSS - Bootstrap (getbootstrap.com) and Bootstrap-map-js (github.com/esri/bootstrap-map-js) -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<link rel="stylesheet" type="text/css"
	href="resources/css/bootstrapmap.css">
<link rel="stylesheet" type="text/css"
	href="resources/css/igs-master.css">

<!-- ArcGIS API for JavaScript library references -->
<script src="//js.arcgis.com/3.10compact"></script>
<script>
            require(["esri/map",
                "esri/tasks/locator",
                "esri/request",
                "esri/InfoTemplate",
                "esri/graphic",
                "esri/symbols/PictureMarkerSymbol",
                "esri/geometry/Multipoint",
                "dojo/keys",
                "dojo/on",
                "dojo/dom",
                "dojo/domReady!"],
                    function (Map, Locator, esriRequest, InfoTemplate, Graphic, PictureMarkerSymbol, Multipoint, keys, on, dom) {
                        "use strict"

                        // Create map
                        var map = new Map("mapDiv", {
                            basemap: "national-geographic",
                            center: [-0.14256029394528014, 53.564213727494035], //long, lat
                            zoom: 12
                        });




                        // Set popup
                        var popup = map.infoWindow;
                        // popup.anchor = "top";
                        popup.highlight = false;
                        popup.titleInBody = false;
                        popup.domNode.className += " light";

                        // Get symbol
                        var symbol = new createPictureSymbol("//esri.github.io/quickstart-map-js/images/blue-pin.png", 0, 12, 13, 24);

                        // Create geoservice
                        //var geocodeService = new Locator("//geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer");
                        var geocodeService = new Locator("${pageContext.request.contextPath}");

                        // Wire events
                        on(map, "load", function () {
                            on(geocodeService, "address-to-locations-complete", geocodeResults);
                            on(geocodeService, "error", geocodeError);
                            on(dom.byId("btnSearch"), "click", geoSearch);
                            on(dom.byId("btnClear"), "click", clearFindGraphics);
                            on(dom.byId("cat"), "change", function (event) {
                                geoSearch();
                            });
                        });

                        // Geocode against the user input
                        function geoSearch() {
                            var boundingBox;
                            if (dom.byId('useMapExtent').checked)
                                boundingBox = map.extent;
                            // Set geocode options
                            var options = {
                                /*you can combine multiple categories in a single search and even combine category searches and normal search strings:
                                 
                                 address:{
                                 "SingleLine": "Pacific",
                                 "category": "Aquarium, Tourist Attraction"
                                 },
                                 
                                 but for now lets just search on a single category
                                 
                                 https://developers.arcgis.com/javascript/jsapi/locator-amd.html#addresstolocations       
                                 */
                                address: {
                                    "category": dom.byId("cat").value
                                },
                                outFields: ["Place_addr", "PlaceName"],
                                searchExtent: boundingBox,
                                location: map.extent.getCenter(),
                                distance: 1
                            }
                            // Execute geosearch
                            geocodeService.addressToLocations(options);
                        }

                        // Geocode results
                        function geocodeResults(places) {
                            if (places.addresses.length > 0) {
                                clearFindGraphics();
                                // Objects for the graphic
                                var place, attributes, infoTemplate, pt, graphic, placeName = "";
                                // Create and add graphics with pop-ups
                                for (var i = 0; i < places.addresses.length; i++) {
                                    place = places.addresses[i];
                                    pt = place.location;
                                    placeName = place.attributes.Place_addr ? "${address}<br/>" : '';
                                    attributes = {name: place.attributes.PlaceName, address: place.attributes.Place_addr, score: place.score, lat: pt.y.toFixed(5), lon: pt.x.toFixed(5)};
                                    infoTemplate = new InfoTemplate("${name}", placeName + "Lat/Lon: ${lat},${lon}<br/>Score: ${score}" + "<br/><a href='#' onclick='window.zoomToPlace(" + pt.x + "," + pt.y + ")'>Zoom</a>");
                                    graphic = new Graphic(pt, symbol, attributes, infoTemplate);
                                    map.graphics.add(graphic);
                                }
                                zoomToPlaces(places.addresses);
                            } else {
                                alert("Sorry, address or place not found.");
                            }
                        }

                        function geocodeError(errorInfo) {
                            alert("Sorry, place or address not found!");
                        }

                        window.zoomToPlace = function zoomToPlace(lon, lat) {
                            var level = map.getLevel();
                            level = level < 14 ? 14 : level + 1;
                            map.centerAndZoom([lon, lat], level);
                        }

                        function zoomToPlaces(places) {
                            var multiPoint = new Multipoint();
                            for (var i = 0; i < places.length; i++) {
                                multiPoint.addPoint(places[i].location);
                            }
                            map.setExtent(multiPoint.getExtent().expand(1.5));
                        }

                        function clearFindGraphics() {
                            map.infoWindow.hide();
                            map.graphics.clear();
                        }

                        function createPictureSymbol(url, xOffset, yOffset, xWidth, yHeight) {
                            return new PictureMarkerSymbol(
                                    {
                                        "angle": 0,
                                        "xoffset": xOffset, "yoffset": yOffset, "type": "esriPMS",
                                        "url": url,
                                        "contentType": "image/png",
                                        "width": xWidth, "height": yHeight
                                    });
                        }

                        // Wire UI Events
                        on(dom.byId("btnStreets"), "click", function () {
                            map.setBasemap("streets");
                        });
                        on(dom.byId("btnSatellite"), "click", function () {
                            map.setBasemap("satellite");
                        });
                        on(dom.byId("btnHybrid"), "click", function () {
                            map.setBasemap("hybrid");
                        });
                        on(dom.byId("btnTopo"), "click", function () {
                            map.setBasemap("topo");
                        });
                        on(dom.byId("btnGray"), "click", function () {
                            map.setBasemap("gray");
                        });
                        on(dom.byId("btnNatGeo"), "click", function () {
                            map.setBasemap("national-geographic");
                        });
                    }
            );
        </script>

</head>
<body>
	<div class="panel panel-primary panel-fixed">
		<div class="panel-heading">
			<h3 class="panel-title">Find Geology by Rock Category</h3>
		</div>
		<div class="panel-body">
			<form action="findWithPostcode">
				<div>
					<br /> <input type="text" name="postcode" id="postcode" placeholder="Postcode" /> <input class="btn btn-success"
						type="submit" value="Find" /> <br />
				</div>
			</form>
			<br>
			<div class="form-group">
				<select class="form-control" id="cat">
					<option value="Please select rock category">Please select
						rock category</option>
					<c:forEach var="row" items="${rockCatgories}">
						<option value="${row.categoryName}">${row.categoryName}</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-inline">
				<div id="searchmapCheckbox" class="checkbox">
					<label> <input id="useMapExtent" type="checkbox" checked />
						Search map only
					</label>
				</div>
				<button class="btn btn-success" id="btnSearch">Go</button>
				<button id="btnClear" class="btn btn-default">Clear</button>
				<br>
				<br>More information on rock categories<br> can be found <a
					href="http://igsint.com" target="_blank">here</a>
			</div>
		</div>
	</div>
	<div id="mapDiv"></div>
</body>
</html>