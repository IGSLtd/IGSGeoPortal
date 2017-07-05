package com.igs.geoportal.interfaces;

import com.esri.core.geometry.Point;

public interface IGSGeoDataConvertor {

	public Point fromUTMToLngLat(Point p);
	
	public Point fromLngLatToUTM(Point p);
}
