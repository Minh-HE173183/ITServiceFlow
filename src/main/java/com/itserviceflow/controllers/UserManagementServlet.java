package com.itserviceflow.controllers;

import com.google.gson.Gson;
import com.itserviceflow.daos.DepartmentDAO;
import com.itserviceflow.daos.RoleDAO;
import com.itserviceflow.daos.UserDAO;
import com.itserviceflow.models.User;
import com.itserviceflow.utils.GsonConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = GsonConfig.getGson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("getInfo".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                User u = userDAO.findById(Integer.parseInt(idStr));
                resp.setContentType("application/json");
                resp.getWriter().write(gson.toJson(u));
                return;
            }
        }

        String search = req.getParameter("search");
        String roleIdStr = req.getParameter("roleId");
        String deptIdStr = req.getParameter("deptId");
        String sortBy = req.getParameter("sortBy");
        String order = req.getParameter("order");
        String pageStr = req.getParameter("page");

        Integer roleId = (roleIdStr != null && !roleIdStr.isEmpty()) ? Integer.parseInt(roleIdStr) : null;
        Integer deptId = (deptIdStr != null && !deptIdStr.isEmpty()) ? Integer.parseInt(deptIdStr) : null;
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int limit = 10;
        int offset = (page - 1) * limit;

        List<User> userList = userDAO.listUsers(search, roleId, deptId, sortBy, order, offset, limit);
        int totalUsers = userDAO.countUsers(search, roleId, deptId);
        int totalPages = (int) Math.ceil((double) totalUsers / limit);

        // Fetch meta data for filters
        req.setAttribute("userList", userList);
        req.setAttribute("roles", new RoleDAO().listAll());
        req.setAttribute("departments", new DepartmentDAO().listAll());
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", search);
        req.setAttribute("roleId", roleId);
        req.setAttribute("deptId", deptId);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("order", order);

        req.getRequestDispatcher("/admin/user-list.jsp").forward(req, resp);
    }
    
    // Additional admin actions like toggle status, edit user role, etc. can be added here
}
