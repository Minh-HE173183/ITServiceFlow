package com.itserviceflow.controllers;

import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/ticket/service-request-list")
public class ServiceRequestListServlet extends HttpServlet {
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("loggedInUser");
//        
//        // Kiểm tra đăng nhập
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");

        // --- BƯỚC SỬA LỖI PHÂN QUYỀN Ở ĐÂY ---
        // Lấy roleId từ User model
//        Integer roleId = currentUser.getRoleId();
        String roleString = "END_USER"; // Mặc định là người dùng bình thường

        // Mapping roleId với các biến logic trong DAO (Giả sử theo chuẩn thông thường)
        // BẠN HÃY ĐỔI SỐ 1, 2, 3 NÀY CHO KHỚP VỚI BẢNG 'role' TRONG DATABASE CỦA BẠN NHÉ
        int currentUserId = 1; // Giả sử ID của bạn là 1
    Integer roleId = 3;    // Giả sử Role 3 là END_USER
    
    if (roleId != null) {
        if (roleId == 1) { 
            roleString = "ADMIN";   
        } else if (roleId == 2) {
            roleString = "SUPPORT"; 
        } else if (roleId == 3) {
            roleString = "END_USER"; 
        }
    }

    // Gọi DAO lấy danh sách Ticket là Service Request
    List<Ticket> requests = ticketDAO.getRequestsByRole(
        currentUserId, // Truyền ID giả lập
        roleString,    // Truyền quyền giả lập
        search, 
        statusFilter
    );

    request.setAttribute("requestList", requests);
    request.setAttribute("search", search);
    request.setAttribute("statusFilter", statusFilter);
    
    request.getRequestDispatcher("/ticket/service-request-list.jsp").forward(request, response);
    }
}