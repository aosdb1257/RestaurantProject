package com.myspring.restaurant.vo;

import java.sql.Date;
import java.sql.Timestamp;

public class CustomerReserveFirstVO {
    private int reserve_Id;
    private String meal_Time;
    private java.sql.Date reserve_Date;
    private String time_Slot;
    private int floor;
    private java.sql.Timestamp created_At;

    public CustomerReserveFirstVO() {	}

	public CustomerReserveFirstVO(int reserve_Id, String meal_Time, Date reserve_Date, String time_Slot, int floor,
			Timestamp created_At) {
		super();
		this.reserve_Id = reserve_Id;
		this.meal_Time = meal_Time;
		this.reserve_Date = reserve_Date;
		this.time_Slot = time_Slot;
		this.floor = floor;
		this.created_At = created_At;
	}

	public int getReserve_Id() {
		return reserve_Id;
	}

	public void setReserve_Id(int reserve_Id) {
		this.reserve_Id = reserve_Id;
	}

	public String getMeal_Time() {
		return meal_Time;
	}

	public void setMeal_Time(String meal_Time) {
		this.meal_Time = meal_Time;
	}

	public java.sql.Date getReserve_Date() {
		return reserve_Date;
	}

	public void setReserve_Date(java.sql.Date reserve_Date) {
		this.reserve_Date = reserve_Date;
	}

	public String getTime_Slot() {
		return time_Slot;
	}

	public void setTime_Slot(String time_Slot) {
		this.time_Slot = time_Slot;
	}

	public int getFloor() {
		return floor;
	}

	public void setFloor(int floor) {
		this.floor = floor;
	}

	public java.sql.Timestamp getCreated_At() {
		return created_At;
	}

	public void setCreated_At(java.sql.Timestamp created_At) {
		this.created_At = created_At;
	}

}
