package com.igs.geoportal.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.esri.core.geometry.Point;
import com.igs.geoportal.businesslogic.IGSConversionHelper;
import com.igs.geoportal.entity.Coordinate;
import com.igs.geoportal.entity.RockCategory;
import com.igs.geoportal.entity.RockDetails;

@Repository
public class RockCategoryDao {

	private Logger logger = Logger.getLogger(RockCategoryDao.class);

	private IGSConversionHelper conversionHelper = new IGSConversionHelper();
	
	private static final int SEARCH_RADIUS = 50;
	private static final int LIMIT = 100;

	@Autowired
	private SessionFactory sessionFactory;

	private List<RockCategory> rockCategory;

	public List<RockCategory> getRockCategory() {
		return rockCategory;
	}

	@Transactional
	public String getRockDetails(RockDetails rd) {

		Session session = sessionFactory.getCurrentSession();

		JSONObject obj = new JSONObject();
		
		if (rd != null) {

			try {
				
				List<Coordinate> coo = new ArrayList<Coordinate>();
				this.rockCategory = new ArrayList<RockCategory>();

				List<Coordinate> coordinateList = getCategoryId(rd);
				
				if(coordinateList != null 
						&& !coordinateList.isEmpty()) {
					
				
					Map<String, RockCategory> hm = new HashMap<String, RockCategory>();
				
					logger.debug("Total coordinates found=" + coordinateList.size());
				
					for (Coordinate c : coordinateList) {
	
						if (c != null && c.getCategoryId() > 0) {
	
							String sql = "from RockCategory as r inner join r.coordinates as coor where r.categoryId= :categoryId";
							Query query = session.createQuery(sql).setParameter("categoryId", c.getCategoryId());
							List<Object[]> listResult = query.list();

							
							for (Object[] aRow : listResult) {
	
								logger.debug(aRow[0]);

								RockCategory rc = (RockCategory) aRow[0];
								
								if(!hm.containsKey(rc.getRcs_d())) {
									hm.put(rc.getRcs_d(), rc);
									this.rockCategory.add(rc);
								}
								
								coo.add((Coordinate) aRow[1]);

	
							}
	
						}
					}
					
					logger.debug(rockCategory);
					//logger.debug(coo);
					
					JSONArray candidates = new JSONArray();
					
					for(RockCategory cat : rockCategory) {
						
						logger.debug(cat);
						process(cat, coo, candidates);
						
					}
					
					JSONObject spatialRef = new JSONObject();
					spatialRef.put("wkid", 4326);
					spatialRef.put("latestWkid", 4326);

					obj.put("spatialReference", spatialRef);
					obj.put("candidates", candidates);

					logger.debug("JSON=" + obj.toJSONString());
					return obj.toJSONString();
				
				}

			} catch (Exception e) {
				logger.error(e, e);
			}
		}

		return obj.toJSONString();
	}
	

	private void process(RockCategory cat, List<Coordinate> coo, JSONArray candidates) throws Exception {

		

		if (cat != null) {

			

			for (int i = 0; i < coo.size(); i++) {

				JSONObject loc = new JSONObject();

				Point pnt = new Point(coo.get(i).getxAxis(), coo.get(i).getyAxis());

				Point location = conversionHelper.fromBNGLngLat(pnt);

				loc.put("x", location.getY());
				loc.put("y", location.getX());

				logger.debug("UTM coordinates, x=" + coo.get(i).getxAxis() + " y=" + coo.get(i).getyAxis() + ">> "
						+ "Lat=" + location.getX() + " Lng=" + location.getY());

				JSONObject attributes = new JSONObject();
				attributes.put("Place_addr", cat.getRcs());
				attributes.put("PlaceName", cat.getRcs_d());
				attributes.put("AgeOnegl", cat.getAge_onegl());

				JSONObject extent = new JSONObject();
				extent.put("xmin", location.getY());
				extent.put("ymin", location.getX());
				extent.put("xmax", location.getY());
				extent.put("ymax", location.getX());

				JSONObject wrapper = new JSONObject();
				wrapper.put("address", cat.getCategoryName());
				wrapper.put("location", loc);
				wrapper.put("score", 100);
				wrapper.put("attributes", attributes);
				wrapper.put("extent", extent);
				candidates.add(wrapper);

			}




		}

	}
	
	

	@Transactional
	private List<Coordinate> getCategoryId(RockDetails rd) {

		Session session = sessionFactory.getCurrentSession();
		List<Coordinate> lists = new ArrayList<Coordinate>();
		Map<Long, Long> hm = new HashMap();

		Point p = conversionHelper.fromUTMToLngLat(new Point(rd.getX(), rd.getY()));

		double lng = p.getX();
		double lat = p.getY();
		logger.debug("Lat=" + lat + ": Lng=" + lng);

		try {
			
			String sql = "SELECT coordinateId,categoryId, xAxis, yAxis, lat, lon, (6371 * acos (cos ( radians(" 
					+ lat + ") ) * cos( radians( lat ) ) * cos( radians( lon ) - radians(" + lng + ") ) + sin ( radians(" 
					+ lat + ") ) * sin( radians( lat ) ))) AS distance FROM Coordinate HAVING distance < "+ SEARCH_RADIUS + " ORDER BY distance limit " + LIMIT;

			logger.debug(sql);

			NativeQuery<Coordinate> query = session.createNativeQuery(sql, Coordinate.class);

			List<Coordinate> coo = query.list();

			if(!coo.isEmpty()) {
				
				for(Coordinate c : coo) {
					
					if(!hm.containsKey(c.getCategoryId())) {
						
						hm.put(c.getCategoryId(), c.getCategoryId());
						lists.add(c);
						logger.debug(c);
					}
				}
				
			}

		} catch (Exception e) {
			logger.error(e, e);
		}

		return lists;
	}

}
