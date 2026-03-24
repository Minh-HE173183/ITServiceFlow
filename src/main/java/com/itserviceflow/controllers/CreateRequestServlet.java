package com.itserviceflow.controllers;

import com.itserviceflow.daos.ServiceDAO;
import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.models.Service;
import com.itserviceflow.models.Ticket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/create-request")
public class CreateRequestServlet extends HttpServlet {
    private TicketDAO ticketDAO = new TicketDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
            int serviceId = Integer.parseInt(serviceIdStr);
            // Lấy thông tin service để hiển thị tên trên Form
            Service service = serviceDAO.getServiceById(serviceId);
            request.setAttribute("service", service);
        }
        
        request.getRequestDispatcher("/ticket/create-request.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Ticket ticket = new Ticket();
        String serviceIdParam = request.getParameter("serviceId");


        if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
            
            ticket.setServiceId(Integer.parseInt(serviceIdParam));
        } else {
            // Xử lý nếu thiếu ID (quay lại catalog)
            response.sendRedirect(request.getContextPath() + "/service-catalog?error=missing_id");
            return;
        }
//        ticket.setServiceId(Integer.parseInt(request.getParameter("serviceId")));
        ticket.setTitle(request.getParameter("title"));
        ticket.setDescription(request.getParameter("description"));
        ticket.setJustification(request.getParameter("justification"));
        ticket.setPriority(request.getParameter("priority"));
        
        // reportedBy lấy từ session sau khi login tạm thời để cứng ID = 1
        ticket.setReportedBy(1); 
        ticket.setDepartmentId(1);

        if (ticketDAO.createServiceRequest(ticket)) {
            // Sau khi tạo thành công, quay về catalog 
            response.sendRedirect(request.getContextPath() + "/service-catalog?msg=success");
        } else {
            request.setAttribute("error", "Error creating service request.");
            request.getRequestDispatcher("/ticket/create-request.jsp").forward(request, response);
        }
    }
}