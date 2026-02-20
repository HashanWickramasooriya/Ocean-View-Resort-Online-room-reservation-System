package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.*;

import static org.mockito.Mockito.*;

class LoginServletTest {

    @InjectMocks
    private LoginServlet servlet;

    @Mock private UserDAO userDAO;
    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    //  ADMIN LOGIN
    @Test
    void testAdminLogin() throws Exception {

        when(request.getParameter("username")).thenReturn("admin");
        when(request.getParameter("password")).thenReturn("admin123");
        when(request.getSession()).thenReturn(session);

        servlet.doPost(request, response);

        verify(response).sendRedirect(contains("admindashboard.jsp"));
    }

    //  STAFF LOGIN
    @Test
    void testStaffLogin() throws Exception {

        User staff = new User();
        staff.setUsername("hashan");
        staff.setRole("STAFF");

        when(request.getParameter("username")).thenReturn("hashan");
        when(request.getParameter("password")).thenReturn("Abc123");
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("");

        when(userDAO.login("hashan", "Abc123"))
                .thenReturn(staff);

        servlet.doPost(request, response);

        verify(session).setAttribute("user", staff);
        verify(response).sendRedirect("/staff/dashboard");
    }
    

    //  INVALID LOGIN
    @Test
    void testInvalidLogin() throws Exception {

        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("username")).thenReturn("wrong");
        when(request.getParameter("password")).thenReturn("wrong");
        when(request.getSession()).thenReturn(session);

        when(userDAO.login(anyString(), anyString())).thenReturn(null);

        when(request.getRequestDispatcher("/login.jsp"))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }

    //  DATABASE EXCEPTION HANDLING
    @Test
    void testDatabaseExceptionHandling() throws Exception {

        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getParameter("username")).thenReturn("hashan");
        when(request.getParameter("password")).thenReturn("Abc123");
        when(request.getSession()).thenReturn(session);

        // Simulate DB failure
        when(userDAO.login(anyString(), anyString()))
                .thenThrow(new RuntimeException("DB Error"));

        when(request.getRequestDispatcher("/login.jsp"))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }
}