package com.itserviceflow.controllers;


import com.itserviceflow.daos.UserDAO;
import com.itserviceflow.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/admin/update-user")
public class UpdateUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userIdStr = req.getParameter("userId");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String roleIdStr = req.getParameter("roleId");
        String deptIdStr = req.getParameter("deptId");

        if (userIdStr == null || userIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        User u = userDAO.findById(Integer.parseInt(userIdStr));
        if (u != null) {
            u.setFullName(fullName);
            u.setEmail(email);
            u.setRoleId(Integer.parseInt(roleIdStr));
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                u.setDepartmentId(Integer.parseInt(deptIdStr));
            } else {
                u.setDepartmentId(null);
            }
            
            // Note: We need a specialized update method in UserDAO for admin edits
            if (userDAO.updateUserByAdmin(u)) {
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=User updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=Update failed");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=User not found");
        }
    }
}
