package com.oceanview.entity;

public class RoomImage {
	
    private int imageId;
    private int roomId;
    private String imagePath;

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}
