package com.igs.geoportal.dao;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.igs.geoportal.entity.RockCategory;

@Repository
public class RockCategoryDao {
	
	private Logger logger = Logger.getLogger(RockCategoryDao.class);
	
	@Autowired
	private SessionFactory sessionFactory;

	@Transactional
	public List<RockCategory> getRockCategory() {
		
		Session session = sessionFactory.getCurrentSession();

		try {
			
			Query<RockCategory> query = session.createQuery("from RockCategory", RockCategory.class);

			List<RockCategory> cat = query.getResultList();
			
			logger.debug(cat);
			
			return cat;

			
			
		} catch (Exception e) {
			logger.debug(e);
		}
		
		return null;
	}

}
