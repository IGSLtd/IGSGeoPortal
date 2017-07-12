package com.igs.geoportal;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.igs.geoportal.dao.RockCategoryDao;
import com.igs.geoportal.entity.RockDetails;

@Controller	
public class HomeController {
	
	private Logger logger = Logger.getLogger(HomeController.class);
	
	//by default load data for Grimsby
	@Autowired
	private RockDetails rd;
	
	@Autowired
	RockCategoryDao catDao;
	
	@Autowired
	@Resource(name = "igsProps")
	private Properties props;

	
	@RequestMapping("/")
	public String home()
	{
		return "index.jsp";
	}
	
	@RequestMapping("/portal")
	public ModelAndView getPortal()
	{
		rd.setCategory("UNNAMED IGNEOUS INTRUSION, PALAEOGENE");
		rd.setF("json");
		rd.setOutFields("Place_addr,PlaceName");
		rd.setSearchExtent("{\"xmin\":-269575.9589992872,\"ymin\":7237571.912886106,\"xmax\":14005.415938825274,\"ymax\":7319665.281264418,\"spatialReference\":{\"wkid\":102100,\"latestWkid\":3857}}");
		rd.setDistance(1);
		rd.setLocation("{\"x\":-127785.27153023097,\"y\":7278618.597075262,\"spatialReference\":{\"wkid\":102100,\"latestWkid\":3857}}");
		
		catDao.getRockDetails(rd);
		
		ModelAndView mv = new ModelAndView("/jsp/portal.jsp");
		mv.addObject("pageUrl", props.getProperty("host.url"));
		mv.addObject("rockCatgories", catDao.getRockCategory());
		return mv;
	}
	
	
}
