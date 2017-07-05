package com.igs.geoportal.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Component;

@Component
public class RockDetails 
{

	private static Logger logger = Logger.getLogger(RockDetails.class);
	private String category;
	private String f, outFields;
	
	private String searchExtent, location;
	
	private int distance;
	
	JSONParser parser = new JSONParser();

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getF() {
		return f;
	}

	public void setF(String f) {
		this.f = f;
	}

	public String getOutFields() {
		return outFields;
	}

	public void setOutFields(String outFields) {
		this.outFields = outFields;
	}

	public String getSearchExtent() {
		return searchExtent;
	}

	public void setSearchExtent(String searchExtent) {
		this.searchExtent = searchExtent;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getDistance() {
		return distance;
	}

	public void setDistance(int distance) {
		this.distance = distance;
	}


	public JSONObject getSearchExtentJson() throws Exception{
		return (JSONObject) parser.parse(searchExtent);
	}
	
	public JSONObject getLocationJson() throws Exception{
		return (JSONObject) parser.parse(location);
	}
	
	public double getX() {
		
		try {
			
			JSONObject l = getLocationJson();
			
			if(l != null && l.containsKey("x")) {
				return (Double) l.get("x");
			}
			
		}catch(Exception e) {
			logger.error(e, e);
		}
		
		
		return 0;
	}
	
	public double getY() {
		
		try {
			
			JSONObject l = getLocationJson();
			
			if(l != null && l.containsKey("y")) {
				return (Double) l.get("y");
			}
			
		}catch(Exception e) {
			logger.error(e, e);
		}
		
		return 0;
	}
	
}
