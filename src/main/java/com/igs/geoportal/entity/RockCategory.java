package com.igs.geoportal.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="RockCategory")
public class RockCategory {
	
	@Id
	private int categoryId;
	@Column(name = "categoryName", unique = true,
			nullable = false, length = 100)
	private String categoryName;
	
	
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	
	@Override
	public String toString() {
		return "RockCategory [categoryId=" + categoryId + ", categoryName=" + categoryName + "]";
	}

}
