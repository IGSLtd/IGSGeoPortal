package com.igs.geoportal.entity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

@Entity
public class RockCategory {
	
	@Id
	private long categoryId;
	private String categoryName;
    private String rcs;
    private String rcs_d;
    private String age_onegl;
    
    @ManyToOne
    @JoinColumn(name="categoryId", insertable = false, updatable = false)
    private Coordinate coordinate;

	
	
	public long getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getRcs() {
		return rcs;
	}
	public void setRcs(String rcs) {
		this.rcs = rcs;
	}
	public String getRcs_d() {
		return rcs_d;
	}
	public void setRcs_d(String rcs_d) {
		this.rcs_d = rcs_d;
	}
	public String getAge_onegl() {
		return age_onegl;
	}
	public void setAge_onegl(String age_onegl) {
		this.age_onegl = age_onegl;
	}	
	
	public Coordinate getCoordinate() {
		return coordinate;
	}
	public void setCoordinates(Coordinate coordinates) {
		this.coordinate = coordinates;
	}
	@Override
	public String toString() {
		return "RockCategory [categoryId=" + categoryId + ", categoryName=" + categoryName + ", rcs=" + rcs + ", rcs_d="
				+ rcs_d + ", age_onegl=" + age_onegl + "]";
	}
	

}
