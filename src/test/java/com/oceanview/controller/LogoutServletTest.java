package com.oceanview.controller;

import org.junit.jupiter.api.Test;
import org.mockito.*;

import javax.servlet.http.*;

import static org.mockito.Mockito.*;

class LogoutServletTest {

    @Test
    void testLogout() throws Exception {

        LogoutServlet servlet = new LogoutServlet();

        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        HttpSession session = mock(HttpSession.class);

        when(request.getSession(false)).thenReturn(session);

        servlet.doGet(request, response);

        verify(session).invalidate();
        verify(response).sendRedirect("login.jsp");
    }
}