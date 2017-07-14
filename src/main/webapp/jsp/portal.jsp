<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
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

<%@ include file="portal-js-minis.jsp" %> 


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