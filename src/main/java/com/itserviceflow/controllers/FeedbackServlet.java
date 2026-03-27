package com.itserviceflow.controllers;

import com.itserviceflow.daos.FeedbackDAO;
import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.models.Feedback;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO = new FeedbackDAO();
    private TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            submitFeedback(request, response, currentUser);
        }
    }
    
    private void submitFeedback(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        int ticketId;
        try {
            ticketId = Integer.parseInt(request.getParameter("ticketId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=0&feedbackError=invalidTicket");
            return;
        }
        
        int rating;
        try {
            rating = Integer.parseInt(request.getParameter("rating"));
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + "&feedbackError=invalidRating");
            return;
        }
        
        String feedbackText = request.getParameter("feedbackText");
        if (feedbackText == null) {
            feedbackText = "";
        }
        
        // Kiểm tra ticket có tồn tại và đã closed chưa
        Ticket ticket = ticketDAO.getTicketById(ticketId);
        if (ticket == null || !"CLOSED".equals(ticket.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + "&feedbackError=invalidTicket");
            return;
        }
        
        // Kiểm tra đã có feedback chưa
        if (feedbackDAO.hasFeedback(ticketId)) {
            response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + "&feedbackError=alreadySubmitted");
            return;
        }
        
        // Tạo feedback mới
        Feedback feedback = new Feedback();
        feedback.setTicketId(ticketId);
        feedback.setUserId(currentUser.getUserId());
        // Fix null pointer: chuyển Integer null sang int 0
        Integer assignedTo = ticket.getAssignedTo();
        int agentId = (assignedTo != null) ? assignedTo : 0;
        feedback.setAgentId(agentId);
        feedback.setRating(rating);
        feedback.setFeedbackText(feedbackText);
        
        // Debug thông tin feedback
        System.out.println("=== DEBUG FEEDBACK ===");
        System.out.println("Ticket ID: " + ticketId);
        System.out.println("User ID: " + currentUser.getUserId());
        System.out.println("Agent ID: " + agentId);
        System.out.println("Rating: " + rating);
        System.out.println("Feedback Text: " + feedbackText);
        System.out.println("Ticket Status: " + ticket.getStatus());
        System.out.println("Ticket AssignedTo: " + ticket.getAssignedTo());
        System.out.println("=====================");
        
        boolean saved = feedbackDAO.saveFeedback(feedback);
        System.out.println("Save result: " + saved);
        
        String param = saved ? "&feedbackSuccess=1" : "&feedbackError=saveFailed";
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + param);
    }
}