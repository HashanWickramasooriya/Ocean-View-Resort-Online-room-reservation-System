package com.oceanview.entity;

public class Room {
    private int roomId;
    private String roomNumber;
    private String roomName;
    private String roomType;
    private double ratePerNight;
    private int adultCapacity;
    private int childCapacity;
    private String description;
    private String facilities;
    private String status;

    // Getters & Setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }
    public int getAdultCapacity() { return adultCapacity; }
    public void setAdultCapacity(int adultCapacity) { this.adultCapacity = adultCapacity; }
    public int getChildCapacity() { return childCapacity; }
    public void setChildCapacity(int childCapacity) { this.childCapacity = childCapacity; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
