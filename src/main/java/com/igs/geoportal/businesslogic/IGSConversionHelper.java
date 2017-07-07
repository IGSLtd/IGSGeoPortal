package com.igs.geoportal.businesslogic;

import org.apache.log4j.Logger;

import com.esri.core.geometry.Point;
import com.igs.geoportal.interfaces.IGSGeoDataConvertor;

import uk.me.jstott.jcoord.LatLng;
import uk.me.jstott.jcoord.OSRef;

public class IGSConversionHelper implements IGSGeoDataConvertor {
	
	private Logger logger = Logger.getLogger(IGSGeoDataConvertor.class);

	public Point fromUTMToLngLat(Point pnt) {

		if (pnt != null) {
			
			try {
				double mercatorX_lon = pnt.getX();
				double mercatorY_lat = pnt.getY();
				if (Math.abs(mercatorX_lon) < 180 && Math.abs(mercatorY_lat) < 90) {
					return pnt;
				}

				if ((Math.abs(mercatorX_lon) > 20037508.3427892) || (Math.abs(mercatorY_lat) > 20037508.3427892)) {
					return pnt;
				}

				double x = mercatorX_lon;
				double y = mercatorY_lat;
				double num3 = x / 6378137.0;
				double num4 = num3 * 57.295779513082323;
				double num5 = Math.floor((double) ((num4 + 180.0) / 360.0));
				double num6 = num4 - (num5 * 360.0);
				double num7 = 1.5707963267948966 - (2.0 * Math.atan(Math.exp((-1.0 * y) / 6378137.0)));
				mercatorX_lon = num6;
				mercatorY_lat = num7 * 57.295779513082323;
				return new Point(mercatorX_lon, mercatorY_lat);
				
			} catch (Exception e) {
				logger.error(e, e);
			}
		}

		return null;
	}

	public Point fromLngLatToUTM(Point pnt) {

		if (pnt != null) {

			try {
				
				double mercatorX_lon = pnt.getX();
				double mercatorY_lat = pnt.getY();
				if ((Math.abs(mercatorX_lon) > 180 || Math.abs(mercatorY_lat) > 90)) {
					return pnt;
				}

				double num = mercatorX_lon * 0.017453292519943295;
				double x = 6378137.0 * num;
				double a = mercatorY_lat * 0.017453292519943295;

				mercatorX_lon = x;
				mercatorY_lat = 3189068.5 * Math.log((1.0 + Math.sin(a)) / (1.0 - Math.sin(a)));
				return new Point(mercatorX_lon, mercatorY_lat);
				
			} catch (Exception e) {
				logger.error(e, e);
			}
		}

		return null;
	}
	
	//from British National Grid to long lat
	public Point fromBNGLngLat(Point pnt) {

		if (pnt != null) {

			try {
				
		        LatLng latLng = new OSRef(pnt.getX(), pnt.getY()).toLatLng();
		        latLng.toWGS84();
		        
		        return new Point(latLng.getLat(), latLng.getLng());
				
			} catch (Exception e) {
				logger.error(e, e);
			}
		}

		return null;
	}

}
