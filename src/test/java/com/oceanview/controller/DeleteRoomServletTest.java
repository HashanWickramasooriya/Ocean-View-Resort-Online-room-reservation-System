package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import javax.servlet.http.*;

import static org.mockito.Mockito.*;

class DeleteRoomServletTest {

    @InjectMocks
    private DeleteRoomServlet servlet;

    @Mock private RoomDAO dao;
    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    //  SUCCESSFUL DELETE
    @Test
    void testDeleteRoomSuccess() throws Exception {

        when(request.getParameter("id")).thenReturn("5");

        servlet.doGet(request, response);

        verify(dao).deleteRoom(5);
        verify(response).sendRedirect("manageRooms.jsp");
    }

    // DELETE FAILURE (Exception Handling)
    @Test
    void testDeleteRoomFailure() throws Exception {

        when(request.getParameter("id")).thenReturn("5");

        doThrow(new RuntimeException("DB Error"))
                .when(dao).deleteRoom(5);

        servlet.doGet(request, response);

        verify(response)
                .sendRedirect("manageRooms.jsp?error=Delete Failed");
    }
}