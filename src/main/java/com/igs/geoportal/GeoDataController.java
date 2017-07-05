package com.igs.geoportal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.igs.geoportal.dao.RockCategoryDao;
import com.igs.geoportal.entity.RockDetails;

import org.apache.log4j.Logger;

@Controller
public class GeoDataController {
	
	private Logger logger = Logger.getLogger(GeoDataController.class);
	private final String NO_DATA_FOUND = "{\"error\": {\"code\": 400,\"message\": \"Unable to complete operation.\",\"details\": [\"The category value entered is not a supported value.\"]}}";
	private final String RESPONSE = "{\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326},\"candidates\":[{\"address\":\"Triassic Rocks\",\"location\":{\"x\":-0.2984210,\"y\":53.5258550},\"score\":100,\"attributes\":{\"Place_addr\":\"LEX-TRIA\",\"PlaceName\":\"Triassic Rocks\"},\"extent\":{\"xmin\":-1.16,\"ymin\":53.5258500,\"xmax\":-0.2984210,\"ymax\":53.5258500}},{\"address\":\"Lias Group\",\"location\":{\"x\":-0.08144884374996764,\"y\":53.29768103786283},\"score\":100,\"attributes\":{\"Place_addr\":\"LEX-LI\",\"PlaceName\":\"Lias Group\"},\"extent\":{\"xmin\":-0.0138064370116,\"ymin\":53.29768103786,\"xmax\":-0.0138064370116,\"ymax\":53.29768103786}}]}";
	
	@Autowired
	RockCategoryDao catDao;
	
	@RequestMapping("/findAddressCandidates")
	public ResponseEntity<String> list(@ModelAttribute("rockDetails") RockDetails rockDetails) {

		
		String rc = null;
		try{
			rc = catDao.getRockDetails(rockDetails);
			logger.debug(rc);
		}catch(Exception e) {
			logger.error(e, e);
		}
		
		return new ResponseEntity<String>((rc != null) ? rc : RESPONSE, HttpStatus.OK);
	}
}
