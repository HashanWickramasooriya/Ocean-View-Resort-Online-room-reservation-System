package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.*;

import static org.mockito.Mockito.*;

class AddUserServletTest {

    @InjectMocks
    private AddUserServlet servlet;

    @Mock private UserDAO userDAO;
    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    //  ADD NEW STAFF 
    @Test
    void testAddNewStaff() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(admin);

        when(request.getParameter("username")).thenReturn("staff1");
        when(request.getParameter("fullName")).thenReturn("Staff One");
        when(request.getParameter("email")).thenReturn("staff@test.com");
        when(request.getParameter("phone")).thenReturn("12345");
        when(request.getParameter("password")).thenReturn("pass");
        when(request.getParameter("role")).thenReturn("STAFF");

        when(userDAO.isUsernameExists("staff1")).thenReturn(false);
        when(userDAO.createUser(any())).thenReturn(true);

        servlet.doPost(request, response);

        verify(response).sendRedirect(contains("manageStaff.jsp"));
    }

    //  DUPLICATE USERNAME
    @Test
    void testDuplicateUsername() throws Exception {

        User admin = new User();
        admin.setRole("ADMIN");

        RequestDispatcher dispatcher = mock(RequestDispatcher.class);

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(admin);

        when(request.getParameter("username")).thenReturn("staff1");
        when(request.getParameter("fullName")).thenReturn("Staff One");
        when(request.getParameter("email")).thenReturn("staff@test.com");
        when(request.getParameter("phone")).thenReturn("12345");
        when(request.getParameter("password")).thenReturn("pass");
        when(request.getParameter("role")).thenReturn("STAFF");

       
        when(userDAO.createUser(any())).thenReturn(false);

        when(request.getRequestDispatcher("/admin/addUser.jsp"))
                .thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(dispatcher).forward(request, response);
    }

    //  UNAUTHORIZED ACCESS
    @Test
    void testUnauthorizedAccess() throws Exception {

        User staff = new User();
        staff.setRole("STAFF"); 

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(staff);

        servlet.doPost(request, response);

        verify(response).sendRedirect(contains("login.jsp"));
    }
}