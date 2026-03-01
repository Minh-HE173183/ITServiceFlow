package com.itserviceflow.controllers;

import com.itserviceflow.daos.IncidentDAO;
import com.itserviceflow.daos.TicketCategoryDAO;
import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/incident")
public class IncidentController extends HttpServlet {
    private IncidentDAO incidentDAO;
    private TicketCategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        incidentDAO = new IncidentDAO();
        categoryDAO = new TicketCategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "list":
                listIncidents(request, response);
                break;
            case "detail":
                viewDetail(request, response);
                break;
            case "add":
                showForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listIncidents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/incident?action=list");
            return;
        }
        switch (action) {
            case "insert":
                insertIncident(request, response);
                break;
            case "update":
                updateIncident(request, response);
                break;
            case "delete":
                deleteIncident(request, response);
                break;
            case "cancel":
                cancelIncident(request, response);
                break;
            case "assign":
                assignIncident(request, response);
                break;
            case "addComment":
                addComment(request, response);
                break;
            case "link":
                linkIncident(request, response);
                break;
            case "changeStatus":
                changeStatus(request, response);
                break;
            case "approve":
                approveIncident(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/incident?action=list");
                break;
        }
    }

    private void listIncidents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;
        String roleName = (user != null) ? user.getRoleName() : null;
        List<Ticket> list = incidentDAO.getAllIncidents(userId, roleName);
        request.setAttribute("incidents", list);
        request.getRequestDispatcher("/incident/list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket t = incidentDAO.getIncidentById(id);
        request.setAttribute("incident", t);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        // fetch related tickets for display
        request.setAttribute("relatedTickets", incidentDAO.getRelatedTickets(id));
        request.getRequestDispatcher("/incident/detail.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/incident/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket t = incidentDAO.getIncidentById(id);
        request.setAttribute("incident", t);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/incident/form.jsp").forward(request, response);
    }

    private void insertIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Ticket t = buildFromRequest(request);
        t.setReportedBy(((User)request.getSession().getAttribute("user")).getUserId());
        incidentDAO.createIncident(t);
        response.sendRedirect(request.getContextPath() + "/incident?action=list");
    }

    private void updateIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Ticket t = buildFromRequest(request);
        t.setTicketId(Integer.parseInt(request.getParameter("ticketId")));
        incidentDAO.updateIncident(t);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + t.getTicketId());
    }

    private void deleteIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        incidentDAO.deleteIncident(id);
        response.sendRedirect(request.getContextPath() + "/incident?action=list");
    }

    private void cancelIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        incidentDAO.cancelIncident(id);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void assignIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int assignee = Integer.parseInt(request.getParameter("assignedTo"));
        incidentDAO.assignIncident(id, assignee);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String text = request.getParameter("commentText");
        Comment c = new Comment();
        c.setTicketId(id);
        c.setUserId(((User)request.getSession().getAttribute("user")).getUserId());
        c.setCommentText(text);
        incidentDAO.addComment(c);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void linkIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int source = Integer.parseInt(request.getParameter("sourceId"));
        int target = Integer.parseInt(request.getParameter("targetId"));
        String type = request.getParameter("relationType");
        incidentDAO.linkTickets(source, target, type, ((User)request.getSession().getAttribute("user")).getUserId());
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + source);
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("newStatus");
        incidentDAO.changeStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void approveIncident(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean approve = "true".equals(request.getParameter("approve"));
        incidentDAO.approveIncident(id, ((User)request.getSession().getAttribute("user")).getUserId(), approve);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private Ticket buildFromRequest(HttpServletRequest request) {
        Ticket t = new Ticket();
        t.setTitle(request.getParameter("title"));
        t.setDescription(request.getParameter("description"));
        t.setPriority(request.getParameter("priority"));
        t.setImpact(request.getParameter("impact"));
        t.setUrgency(request.getParameter("urgency"));
        String cat = request.getParameter("categoryId");
        if (cat != null && !cat.isEmpty()) t.setCategoryId(Integer.parseInt(cat));
        return t;
    }
}
