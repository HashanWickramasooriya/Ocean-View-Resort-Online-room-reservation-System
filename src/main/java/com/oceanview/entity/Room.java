package com.oceanview.entity;

import java.sql.Timestamp;

public class Room {

    private int roomId;
    private String roomNumber;
    private String roomName;
    private String roomType;          // STANDARD, DELUXE, SUITE, VILLA
    private double ratePerNight;
    private int capacity;
    private String description;
    private String facilities;        // comma-separated OR JSON
    private String images;            // comma-separated image paths
    private String status;            // AVAILABLE, OCCUPIED, etc.
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ---------------- CONSTRUCTORS ----------------
    public Room() {
    }

    public Room(int roomId, String roomNumber, String roomName, String roomType,
                double ratePerNight, int capacity, String description,
                String facilities, String images, String status,
                Timestamp createdAt, Timestamp updatedAt) {

        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomName = roomName;
        this.roomType = roomType;
        this.ratePerNight = ratePerNight;
        this.capacity = capacity;
        this.description = description;
        this.facilities = facilities;
        this.images = images;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ---------------- GETTERS & SETTERS ----------------

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public double getRatePerNight() {
        return ratePerNight;
    }

    public void setRatePerNight(double ratePerNight) {
        this.ratePerNight = ratePerNight;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
