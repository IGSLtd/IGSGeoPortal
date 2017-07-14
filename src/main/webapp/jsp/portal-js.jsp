<script>
	var map;
	require(
			[ "esri/map", "esri/tasks/locator", "esri/request",
					"esri/InfoTemplate", "esri/graphic",
					"esri/symbols/PictureMarkerSymbol",
					"esri/geometry/Multipoint", "dojo/keys", "dojo/on",
					"dojo/dom", "esri/geometry/Point",
					"esri/geometry/Polyline", "esri/geometry/Polygon",
					"esri/SpatialReference", "dojo/domReady!" ],
			function(Map, Locator, esriRequest, InfoTemplate, Graphic,
					PictureMarkerSymbol, Multipoint, keys, on, dom) {
				"use strict"

				// Create map
				map = new Map("mapDiv", {
					basemap : "national-geographic",
					center : [ -0.761248, 54.430794 ], //long, lat
					zoom : 9
				});

				// Set popup
				var popup = map.infoWindow;
				// popup.anchor = "top";
				popup.highlight = false;
				popup.titleInBody = false;
				popup.domNode.className += " light";

				// Get symbol
				var symbol = new createPictureSymbol(
						"//esri.github.io/quickstart-map-js/images/blue-pin.png",
						0, 12, 13, 24);

				// Create geoservice
				//var geocodeService = new Locator("//geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer");
				var geocodeService = new Locator("${pageUrl}");

				// Wire events
				on(map, "load", function() {
					on(geocodeService, "address-to-locations-complete",
							geocodeResults);
					on(geocodeService, "error", geocodeError);
					on(dom.byId("btnSearch"), "click", geoSearch);
					on(dom.byId("btnClear"), "click", clearFindGraphics);
					on(dom.byId("cat"), "change", function(event) {
						geoSearch();
					});

					//on(dom.byId("mapDiv"), "click", onMouseClick);
					geoSearch();
				});

				function onMouseClick() {
					//alert('Mouse clicked');
					//geoSearch();
				}

				function fillRockTypeLists(places) {

					var select = document.getElementById('cat');

					var place;

					var len = places.addresses.length;

					if (len == 0) {
						setDefaultRockType();
					} else {

						var rockType, prevRockType;

						for (var i = 0; i < len; i++) {

							place = places.addresses[i];
							rockType = place.attributes.PlaceName;

							if (rockType != prevRockType) {
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

				function removeOptions(selectbox) {
					var i;
					for (i = selectbox.options.length - 1; i >= 0; i--) {
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

						address : {
							"category" : dom.byId("cat").value
						},
						outFields : [ "Place_addr", "PlaceName", "AgeOnegl" ],
						searchExtent : boundingBox,
						location : map.extent.getCenter(),
						distance : 1
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
							placeName = place.attributes.Place_addr ? "${address}<br/>"
									: '';
							attributes = {
								name : place.attributes.PlaceName,
								address : place.attributes.Place_addr,
								score : place.score,
								lat : pt.y.toFixed(5),
								lon : pt.x.toFixed(5)
							};
							infoTemplate = new InfoTemplate("<img id=\"igs-alert-icon\" src=\"http://igs-geodata.com/resources/images/favicon.ico\" height=\"20\" width=\"20\" style=\" margin-right: 10px;\"/>" 
									+ "<span id=\"alert-title-text\ style\"margin-right: 20px; \"><b>"+ place.address + "</b></span>",
									"<b>RCS:</b> " + rcs + "<br/><b>RCS_D:</b> " + rcs_d
											+ "<br/><b>AGE_ONEGL:</b> " + age_onegl);
							graphic = new Graphic(pt, symbol, attributes,
									infoTemplate);
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
					map.centerAndZoom([ lon, lat ], level);
				}

				function zoomToPlaces(places) {

					//var multiPoint = new Multipoint();
					//for (var i = 0; i < places.length; i++) {
						//multiPoint.addPoint(places[i].location);
					//}
					//map.setExtent(multiPoint.getExtent().expand(1));

					drawPolygon(places);

				}

				function drawPolygon(places) {
					
					var polygons = new Array(places.length);

					for (var i = 0; i < places.length; i++) {
						polygons.push(places[i].location.x + ','
								+ places[i].location.y);
					}

					var polygon = new esri.geometry.Polygon(
							new esri.SpatialReference({
								wkid : 4326
							}));
					polygon.addRing([ polygons ]);

					polygon.spatialReference = map.spatialReference;

					console.log("Created polygons.");

					// Add the polygon to map
					var s = new esri.symbol.SimpleFillSymbol()
							.setStyle(esri.symbol.SimpleFillSymbol.STYLE_SOLID);
					var polygonGraphic = new esri.Graphic(polygon, s, {
						keeper : true
					});
					var polyLayer = new esri.layers.GraphicsLayer({
						id : "poly"
					});
					map.addLayer(polyLayer);
					polyLayer.add(polygonGraphic);

					console.log("Polygons added on the map.");

				}

				function clearFindGraphics() {
					map.infoWindow.hide();
					map.graphics.clear();
				}

				function createPictureSymbol(url, xOffset, yOffset, xWidth,
						yHeight) {
					return new PictureMarkerSymbol({
						"angle" : 0,
						"xoffset" : xOffset,
						"yoffset" : yOffset,
						"type" : "esriPMS",
						"url" : url,
						"contentType" : "image/png",
						"width" : xWidth,
						"height" : yHeight
					});
				}

				// Wire UI Events
				on(dom.byId("btnStreets"), "click", function() {
					//map.setBasemap("streets");
					//changeTab("streets");
					pageLoad();
				});
				on(dom.byId("btnSatellite"), "click", function() {
					//map.setBasemap("satellite");
					changeTab("satellite");
				});
				on(dom.byId("btnHybrid"), "click", function() {
					//map.setBasemap("hybrid");
					changeTab("hybrid");
				});
				on(dom.byId("btnTopo"), "click", function() {
					//map.setBasemap("topo");
					changeTab("topo");
				});
				on(dom.byId("btnGray"), "click", function() {
					//map.setBasemap("gray");
					changeTab("gray");
				});
				on(dom.byId("btnNatGeo"), "click", function() {
					//map.setBasemap("national-geographic");
					changeTab("national-geographic");
				});

			});
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

		if (t != "btnStreets") {
			street.style.backgroundColor = "#fff";
		}

	}
</script>