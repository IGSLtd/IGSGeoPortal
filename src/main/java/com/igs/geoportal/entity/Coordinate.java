package com.igs.geoportal.entity;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;

@Entity
public class Coordinate implements Serializable{

	@Id
    private long coordinateId;

    private long categoryId;   
    private double xAxis, yAxis;
	public long getCoordinateId() {
		return coordinateId;
	}
	public void setCoordinateId(long coordinateId) {
		this.coordinateId = coordinateId;
	}
	public long getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
	}
	public double getxAxis() {
		return xAxis;
	}
	public void setxAxis(double xAxis) {
		this.xAxis = xAxis;
	}
	public double getyAxis() {
		return yAxis;
	}
	public void setyAxis(double yAxis) {
		this.yAxis = yAxis;
	}
	@Override
	public String toString() {
		return "Coordinate [coordinateId=" + coordinateId + ", categoryId=" + categoryId + ", xAxis=" + xAxis
				+ ", yAxis=" + yAxis + "]";
	}
    
}
