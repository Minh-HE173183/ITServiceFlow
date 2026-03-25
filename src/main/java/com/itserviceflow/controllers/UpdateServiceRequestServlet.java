package com.itserviceflow.controllers;

import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/update-request")
public class UpdateServiceRequestServlet extends HttpServlet {
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Kiểm tra session đăng nhập (Tạm giả lập để bạn test)
        /*
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");
        if (currentUser == null || currentUser.getRoleId() == 3) { // Phân quyền: End-user không được phép update
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
            return;
        }
        int currentUserId = currentUser.getUserId();
        */
        int currentUserId = 2; // Giả lập ID = 2 (Nhân viên Support)

        // 2. Lấy dữ liệu từ Form
        String ticketIdStr = request.getParameter("ticketId");
        String status = request.getParameter("status");
        String solution = request.getParameter("solution");
        String action = request.getParameter("action"); // Nút bấm là gì?

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Integer assignedTo = null;

            // Nếu Support bấm nút "Take Ticket" (Nhận việc), thì gán ID của họ vào
            if ("take".equals(action)) {
                assignedTo = currentUserId;
                status = "IN_PROGRESS"; // Tự động chuyển sang Đang xử lý
            } else {
                // Nếu update bình thường, giữ nguyên assignedTo cũ (bạn có thể lấy từ DB hoặc đẩy hidden input từ form)
                String assignedToStr = request.getParameter("assignedTo");
                if (assignedToStr != null && !assignedToStr.isEmpty()) {
                    assignedTo = Integer.parseInt(assignedToStr);
                }
            }

            // 3. Thực thi update
            boolean isUpdated = ticketDAO.updateServiceRequestProgress(ticketId, status, solution, assignedTo);

            if (isUpdated) {
                request.getSession().setAttribute("message", "Cập nhật tiến trình thành công!");
            } else {
                request.getSession().setAttribute("error", "Lỗi: Không thể cập nhật Request.");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi dữ liệu đầu vào.");
        }

        // 4. Load lại trang Chi tiết Request để xem kết quả
        response.sendRedirect(request.getContextPath() + "/request-detail?id=" + ticketIdStr);
    }
}