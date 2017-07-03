package com.igs.geoportal;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.igs.geoportal.dao.RockCategoryDao;

@Controller			
public class HomeController {
	
	private Logger logger = Logger.getLogger(HomeController.class);
	
	@Autowired
	RockCategoryDao catDao;

	
	@RequestMapping("/")
	public String home()
	{
		return "index.jsp";
	}
	
	@RequestMapping("/portal")
	public ModelAndView feedback()
	{
		
		ModelAndView mv = new ModelAndView("/jsp/portal.jsp");
		mv.addObject("rockCatgories", catDao.getRockCategory());
		return mv;
	}
	
	
}
