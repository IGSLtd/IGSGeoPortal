package com.igs.geoportal.dao;

import java.util.ArrayList;
import java.util.List;

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
	
	private static final int SEARCH_RADIUS = 100;

	@Autowired
	private SessionFactory sessionFactory;

	private List<RockCategory> rockCategory;

	public List<RockCategory> getRockCategory() {
		return rockCategory;
	}

	@Transactional
	public String getRockDetails(RockDetails rd) {

		Session session = sessionFactory.getCurrentSession();

		if (rd != null) {

			try {
				
				List<Coordinate> coo = new ArrayList<Coordinate>();
				this.rockCategory = new ArrayList<RockCategory>();

				List<Coordinate> coordinateList = getCategoryId(rd);
				
				logger.debug("Total coordinates found=" + coordinateList.size());
				
				for (Coordinate c : coordinateList) {

					if (c != null && c.getCategoryId() > 0) {

						String sql = "from RockCategory as r inner join r.coordinates as coor where r.categoryId= :categoryId";
						Query query = session.createQuery(sql).setParameter("categoryId", c.getCategoryId());
						List<Object[]> listResult = query.list();

						for (Object[] aRow : listResult) {

							logger.debug(aRow[0]);

							this.rockCategory.add((RockCategory) aRow[0]);
							coo.add((Coordinate) aRow[1]);

						}

						logger.debug(rockCategory);
						logger.debug(coo);

					}
				}
				
				return process(rockCategory, coo);

			} catch (Exception e) {
				logger.debug(e, e);
			}
		}

		return null;
	}

	private String process(List<RockCategory> cat, List<Coordinate> coo) throws Exception {

		JSONObject obj = new JSONObject();

		if (!cat.isEmpty()) {

			JSONArray candidates = new JSONArray();

			for (int i = 0; i < cat.size(); i++) {

				JSONObject loc = new JSONObject();

				Point pnt = new Point(coo.get(i).getxAxis(), coo.get(i).getyAxis());

				Point location = conversionHelper.fromBNGLngLat(pnt);

				loc.put("x", location.getY());
				loc.put("y", location.getX());

				logger.debug("UTM coordinates, x=" + coo.get(i).getxAxis() + " y=" + coo.get(i).getyAxis() + ">> "
						+ "Lat=" + location.getX() + " Lng=" + location.getY());

				JSONObject attributes = new JSONObject();
				attributes.put("Place_addr", cat.get(i).getRcs());
				attributes.put("PlaceName", cat.get(i).getRcs_d());
				attributes.put("AgeOnegl", cat.get(i).getAge_onegl());

				JSONObject extent = new JSONObject();
				extent.put("xmin", location.getY());
				extent.put("ymin", location.getX());
				extent.put("xmax", location.getY());
				extent.put("ymax", location.getX());

				JSONObject wrapper = new JSONObject();
				wrapper.put("address", cat.get(i).getCategoryName());
				wrapper.put("location", loc);
				wrapper.put("score", 100);
				wrapper.put("attributes", attributes);
				wrapper.put("extent", extent);

				candidates.add(wrapper);

			}

			JSONObject spatialRef = new JSONObject();
			spatialRef.put("wkid", 4326);
			spatialRef.put("latestWkid", 4326);

			obj.put("spatialReference", spatialRef);
			obj.put("candidates", candidates);

			logger.debug("JSON=" + obj.toJSONString());

			return obj.toJSONString();

		}

		return obj.toJSONString();
	}

	@Transactional
	private List<Coordinate> getCategoryId(RockDetails rd) {

		Session session = sessionFactory.getCurrentSession();

		Point p = conversionHelper.fromUTMToLngLat(new Point(rd.getX(), rd.getY()));

		double lng = p.getX();
		double lat = p.getY();
		logger.debug("Lat=" + lat + ": Lng=" + lng);

		try {
			String sql = "SELECT coordinateId,categoryId, xAxis, yAxis, (6371 * acos (cos ( radians(" + lat
					+ ") ) * cos( radians( xAxis ) ) * cos( radians( yAxis ) - radians(" + lng + ") ) + sin ( radians("
					+ lat
					+ ") ) * sin( radians( yAxis ) ))) AS distance FROM Coordinate HAVING distance < "+ SEARCH_RADIUS + " ORDER BY distance;";

			logger.debug(sql);

			NativeQuery<Coordinate> query = session.createNativeQuery(sql, Coordinate.class);

			return query.list();

		} catch (Exception e) {
			logger.debug(e, e);
		}

		return null;
	}

}
