package com.itserviceflow.controllers;


import com.itserviceflow.daos.UserDAO;
import com.itserviceflow.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        // Fresh reload from DB to ensure latest data
        User currentUser = userDAO.findById(user.getUserId());
        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User sessionUser = (User) req.getSession().getAttribute("user");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            User u = new User();
            u.setUserId(sessionUser.getUserId());
            u.setFullName(fullName);
            u.setPhone(phone);

            if (userDAO.updateProfile(u)) {
                sessionUser.setFullName(fullName);
                sessionUser.setPhone(phone);
                req.setAttribute("message", "Cập nhật thông tin thành công!");
            } else {
                req.setAttribute("error", "Cập nhật thất bại!");
            }
        } else if ("changePassword".equals(action)) {
            String currentPass = req.getParameter("currentPassword");
            String newPass = req.getParameter("newPassword");
            String confirmPass = req.getParameter("confirmPassword");
            
            if (newPass == null || !newPass.equals(confirmPass)) {
                req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                doGet(req, resp);
                return;
            }

            User userFromDb = userDAO.findById(sessionUser.getUserId());
            if (currentPass.equals( userFromDb.getPasswordHash())) {
                userDAO.updatePassword(sessionUser.getUserId(), newPass);
                req.setAttribute("message", "Đổi mật khẩu thành công!");
            } else {
                req.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            }
        }

        doGet(req, resp);
    }
}
