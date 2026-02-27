package com.itserviceflow.controllers;


import com.itserviceflow.daos.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-actions")
public class UserActionsServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        
        if ("delete".equals(action)) {
            userDAO.deleteUser(id);
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=User deleted");
        } else if ("toggle".equals(action)) {
            String statusStr = req.getParameter("status");
            boolean newStatus = "true".equals(statusStr);
            userDAO.toggleStatus(id, newStatus);
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=Status updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }
}
