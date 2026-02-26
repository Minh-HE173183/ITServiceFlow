package com.itserviceflow.controllers;


import com.itserviceflow.daos.UserDAO;
import com.itserviceflow.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/admin/add-user")
public class AddUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String roleIdStr = req.getParameter("roleId");
        String deptIdStr = req.getParameter("deptId");

        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setUsername(username);
        u.setPasswordHash(password); // In real app, hash this
        u.setRoleId(Integer.parseInt(roleIdStr));
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            u.setDepartmentId(Integer.parseInt(deptIdStr));
        }
        u.setIsActive(true);

        if (userDAO.addUser(u)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=User added successfully");
        } else {
            req.setAttribute("error", "Could not add user");
            req.getRequestDispatcher("/admin/users").forward(req, resp);
        }
    }
}
