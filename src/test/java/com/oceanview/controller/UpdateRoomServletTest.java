package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.entity.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import javax.servlet.ServletContext;
import javax.servlet.http.*;

import java.io.File;
import java.util.*;

import static org.mockito.Mockito.*;

class UpdateRoomServletTest {

    @InjectMocks
    private UpdateRoomServlet servlet;

    @Mock private RoomDAO dao;
    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private ServletContext servletContext;
    @Mock private Part part;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    //  UPDATE ROOM DETAILS
    @Test
    void testUpdateRoomDetails() throws Exception {

        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("roomName")).thenReturn("Deluxe Room");
        when(request.getParameter("roomType")).thenReturn("DELUXE");
        when(request.getParameter("rate")).thenReturn("5000");
        when(request.getParameter("adultCapacity")).thenReturn("2");
        when(request.getParameter("childCapacity")).thenReturn("1");
        when(request.getParameter("description")).thenReturn("Nice room");
        when(request.getParameter("facilities")).thenReturn("WiFi");
        when(request.getParameter("status")).thenReturn("AVAILABLE");

        when(request.getServletContext()).thenReturn(servletContext);
        when(servletContext.getRealPath("")).thenReturn("test-path");

        when(request.getParts()).thenReturn(Collections.emptyList());

        servlet.doPost(request, response);

        verify(dao).updateRoom(any(Room.class));
        verify(response).sendRedirect("manageRooms.jsp");
    }

    //  ADD ADDITIONAL IMAGES
    @Test
    void testAddAdditionalImages() throws Exception {

        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("roomName")).thenReturn("Deluxe Room");
        when(request.getParameter("roomType")).thenReturn("DELUXE");
        when(request.getParameter("rate")).thenReturn("5000");
        when(request.getParameter("adultCapacity")).thenReturn("2");
        when(request.getParameter("childCapacity")).thenReturn("1");
        when(request.getParameter("description")).thenReturn("Nice room");
        when(request.getParameter("facilities")).thenReturn("WiFi");
        when(request.getParameter("status")).thenReturn("AVAILABLE");

        when(request.getServletContext()).thenReturn(servletContext);
        when(servletContext.getRealPath("")).thenReturn("test-path");

        // Mock file upload
        when(part.getName()).thenReturn("images");
        when(part.getSize()).thenReturn(100L);
        when(part.getSubmittedFileName()).thenReturn("room.jpg");

        when(request.getParts()).thenReturn(Arrays.asList(part));

        servlet.doPost(request, response);

        verify(dao).updateRoom(any(Room.class));
        verify(dao).addRoomImages(eq(1), anyList());
        verify(response).sendRedirect("manageRooms.jsp");
    }
}