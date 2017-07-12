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
			var map;
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
                "esri/geometry/Point",
                "esri/geometry/Polyline",
                "esri/geometry/Polygon",
                "esri/SpatialReference",
                "dojo/domReady!"],	
                    function (Map, Locator, esriRequest, InfoTemplate, Graphic, PictureMarkerSymbol, Multipoint, keys, on, dom) {
                        "use strict"

                        // Create map
                       	map = new Map("mapDiv", {
                            basemap: "national-geographic",
                            center: [-0.761248, 54.430794], //long, lat
                            zoom: 9
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
                        var geocodeService = new Locator("${pageUrl}");

                        // Wire events
                        on(map, "load", function () {
                            on(geocodeService, "address-to-locations-complete", geocodeResults);
                            on(geocodeService, "error", geocodeError);
                            on(dom.byId("btnSearch"), "click", geoSearch);
                            on(dom.byId("btnClear"), "click", clearFindGraphics);
                            on(dom.byId("cat"), "change", function (event) {
                                geoSearch();
                            });

                            //on(dom.byId("mapDiv"), "click", onMouseClick);
                        }); 

                        function onMouseClick() {
                            //alert('Mouse clicked');
                        	//geoSearch();
                        }   
                   

                        function fillRockTypeLists(places) {	

                        	var select = document.getElementById('cat');

                        	var place;

                        	var len = places.addresses.length;

                        	if(len == 0) {
                        		setDefaultRockType();
                            }else {

                            	var rockType, prevRockType;
                            	
	                            for (var i = 0; i < len; i++) {
	                                
	                                place = places.addresses[i];
	                                rockType = place.attributes.PlaceName;

	                                if(rockType != prevRockType) {
		                                var opt = document.createElement('option');
		                                opt.value = rockType;
		                                opt.innerHTML = rockType;
		                                select.appendChild(opt);

		                                prevRockType = rockType;
			                        }

	                                
	                            }
                        	}


                         }

                        function setDefaultRockType() {	

                        	var select = document.getElementById('cat');
                        	var opt = document.createElement('option');
                        	opt.value = document.getElementById('noData').textContent;
                            opt.innerHTML = document.getElementById('noData').textContent;
                            select.appendChild(opt);
                         }
                        

                        function removeOptions(selectbox)
                        {
                            var i;
                            for(i = selectbox.options.length - 1 ; i >= 0 ; i--)
                            {
                                selectbox.remove(i);
                            }
                        }

                        // Geocode against the user input
                        function geoSearch() {
                        	clearFindGraphics();
                        	removeOptions(document.getElementById('cat'));
                            
                            var boundingBox;
                            if (dom.byId('useMapExtent').checked)
                                boundingBox = map.extent;
                            // Set geocode options
                            var options = {

                                address: {
                                    "category": dom.byId("cat").value
                                },
                                outFields: ["Place_addr", "PlaceName", "AgeOnegl"],
                                searchExtent: boundingBox,
                                location: map.extent.getCenter(),
                                distance: 1
                            }
                            // Execute geosearch
                            geocodeService.addressToLocations(options);
                            //parseJsonForOption();
                        }

                        // Geocode results
                        function geocodeResults(places) {
                            if (places.addresses.length > 0) {
                                clearFindGraphics();

                                fillRockTypeLists(places);
                                
                                // Objects for the graphic
                                var rcs, rcs_d, age_onegl, place, attributes, infoTemplate, pt, graphic, placeName = "";
                                // Create and add graphics with pop-ups
                                for (var i = 0; i < places.addresses.length; i++) {
                                    place = places.addresses[i];

									rcs = place.attributes.Place_addr;
									rcs_d = place.attributes.PlaceName;
									age_onegl = place.attributes.AgeOnegl;
									
                                    pt = place.location;
                                    placeName = place.attributes.Place_addr ? "${address}<br/>" : '';
                                    attributes = {name: place.attributes.PlaceName, address: place.attributes.Place_addr, score: place.score, lat: pt.y.toFixed(5), lon: pt.x.toFixed(5)};
                                    infoTemplate = new InfoTemplate(place.address, "RCS: "+ rcs + "<br/>RCS_D: " + rcs_d + "<br/>AGE_ONEGL: " + age_onegl);
                                    graphic = new Graphic(pt, symbol, attributes, infoTemplate);
                                    map.graphics.add(graphic);
                                }
                                zoomToPlaces(places.addresses);
                            } else {
                                alert(document.getElementById('noData').textContent);
                                setDefaultRockType();
                            }

                        }

                        function geocodeError(errorInfo) {

                            alert(document.getElementById('noData').textContent);
                            setDefaultRockType();
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
                            map.setExtent(multiPoint.getExtent().expand(1)); 

                            //drawPolygon(places);
                            
                        }

                        function drawPolygon(places) {
                        	
                        	var polygons = new Array(places.length);

                            for (var i = 0; i < places.length; i++) {
                            	polygons.push(places[i].location.y + ',' + places[i].location.x);
                            }

                            var polygon = new esri.geometry.Polygon(new esri.SpatialReference({wkid:4326})); 
                            polygon.addRing([polygons]);

                            polygon.spatialReference = map.spatialReference;

                            console.log("Created polygons.");

                            // Add the polygon to map
                            var s = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_SOLID);
                            var polygonGraphic = new esri.Graphic(polygon, s, { keeper: true });
                            var polyLayer = new esri.layers.GraphicsLayer({ id: "poly" });
                            map.addLayer(polyLayer);
                            polyLayer.add(polygonGraphic);
                            
                            console.log("Polygons added on the map.");
                            
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
                            //map.setBasemap("streets");
                            //changeTab("streets");
                            pageLoad();
                        });
                        on(dom.byId("btnSatellite"), "click", function () {
                            //map.setBasemap("satellite");
                        	changeTab("satellite");
                        });
                        on(dom.byId("btnHybrid"), "click", function () {
                            //map.setBasemap("hybrid");
                            changeTab("hybrid");
                        });
                        on(dom.byId("btnTopo"), "click", function () {
                            //map.setBasemap("topo");
                            changeTab("topo");
                        });
                        on(dom.byId("btnGray"), "click", function () {
                            //map.setBasemap("gray");
                            changeTab("gray");
                        });
                        on(dom.byId("btnNatGeo"), "click", function () {
                            //map.setBasemap("national-geographic");
                            changeTab("national-geographic");
                        });
                    }
            );
        </script>
        
        <script type="text/javascript">
	        function pageLoad() {
	        	map.setBasemap("streets");
	        	var street = document.getElementById("btnStreets");
	        	street.style.backgroundColor = "#ebebeb";
	        }

	        function changeTab(t) {
	        
	        	map.setBasemap(t);

	        	var street = document.getElementById("btnStreets");
	        	
	        	if(t != "btnStreets") {		   		
			   		street.style.backgroundColor = "#fff";
	        	}

		   	}


        </script>

</head>
<!-- <body onload="pageLoad();"> -->
<body>

	<c:set var = "emptyRockTypeString" scope = "session" value = "No data available on this area."/>
	
	<div id="noData" style="display: none;"><c:out value = "${emptyRockTypeString}"/></div>

	<div class="panel panel-primary panel-fixed">
		<div class="panel-heading">
			<h3 class="panel-title">Search with rock type</h3>
		</div>
		<div class="panel-body">
			<div class="btn-toolbar">
				<div class="btn-group">
					<button id="btnStreets" class="btn btn-default">Streets</button>
					<button id="btnSatellite" class="btn btn-default">Satellite</button>
					<button id="btnHybrid" class="btn btn-default">Hybrid</button>
					<button id="btnTopo" class="btn btn-default">Topo</button>
					<!--<button id="btnGray" class="btn btn-default">Gray</button>-->
					<!--<button id="btnNatGeo" class="btn btn-default">National Geographic</button>-->
				</div>
			</div>
			
			<div>
			<br/>

			</div>
			<div class="form-group">

				<p>List of rocks.</p>
				<select class="form-control" id="cat">
				
				<c:choose>
				    <c:when test="${!empty rockCatgories}">
				        
						    <c:forEach var="row" items="${rockCatgories}">
								<option value="${row.rcs_d}">${row.rcs_d}</option>
							</c:forEach>
					
				    </c:when>
				    <c:otherwise>
				
							<option value="Please select rock type"><c:out value = "${emptyRockTypeString}"/></option>
				    </c:otherwise>
				</c:choose>
				</select>

			</div>
			<div class="form-inline">
				<div class="checkbox" id="searchmapCheckbox">
					<label> <input id="useMapExtent" type="checkbox" checked />
						Search map only
					</label>
				</div>
				<button class="btn btn-success" id="btnSearch">Go</button>
				<button id="btnClear" class="btn btn-default">Clear</button>
				<br> <br>More information on categories<br> can be found <a href="http://www.igsint.com/"
					target="_blank">here</a>
					 
			</div>



		</div>
	</div>
	<div id="mapDiv"></div>
</body>
</html>