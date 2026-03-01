package com.itserviceflow.controllers;

import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.daos.RoleDAO;
import com.itserviceflow.models.Ticket;

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
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
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
                viewIncidentDetail(request, response);
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
            case "categorize":
                categorizeIncident(request, response);
                break;
            case "link":
                linkIncident(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/incident?action=list");
                break;
        }
    }

    private void listIncidents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // use session user info to filter for end‑users
        jakarta.servlet.http.HttpSession session = request.getSession();
        com.itserviceflow.models.User user = (com.itserviceflow.models.User) session.getAttribute("user");
        int userId = 0;
        String roleName = "";
        if (user != null) {
            userId = user.getUserId();
            // if roleName not yet set, lookup from DB
            if (user.getRoleName() == null || user.getRoleName().isEmpty()) {
                RoleDAO rdao = new RoleDAO();
                String rn = rdao.getRoleNameById(user.getRoleId());
                user.setRoleName(rn);
            }
            roleName = user.getRoleName();
        }
        List<Ticket> list = ticketDAO.getIncidentList(userId, roleName);
        request.setAttribute("incidentList", list);
        request.getRequestDispatcher("/incidents/incident-list.jsp").forward(request, response);
    }

    private void viewIncidentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket incident = ticketDAO.getIncidentById(id);
        List<Ticket> related = ticketDAO.getRelatedIncidents(id);
        request.setAttribute("incident", incident);
        request.setAttribute("relatedIncidents", related);
        request.getRequestDispatcher("/incidents/incident-detail.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/incidents/incident-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket incident = ticketDAO.getIncidentById(id);
        request.setAttribute("incident", incident);
        request.getRequestDispatcher("/incidents/incident-form.jsp").forward(request, response);
    }

    private void insertIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Ticket incident = new Ticket();
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setPriority(priority);
        incident.setCategoryId(categoryId);
        incident.setReportedBy(1); // stubbed

        String relatedIdsStr = request.getParameter("relatedIds");
        List<Integer> relatedIds = new ArrayList<>();
        if (relatedIdsStr != null && !relatedIdsStr.trim().isEmpty()) {
            for (String s : relatedIdsStr.split(",")) {
                try {
                    relatedIds.add(Integer.parseInt(s.trim()));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        ticketDAO.createIncidentTicket(incident, 1);
        if (!relatedIds.isEmpty()) {
            ticketDAO.linkRelatedIncidents(incident.getTicketId(), relatedIds, 1);
        }
        response.sendRedirect(request.getContextPath() + "/incident?action=list");
    }

    private void updateIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Ticket incident = new Ticket();
        incident.setTicketId(id);
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setStatus(status);
        incident.setPriority(priority);
        incident.setCategoryId(categoryId);

        ticketDAO.updateIncidentTicket(incident);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void deleteIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ticketDAO.deleteIncidentTicket(id);
        response.sendRedirect(request.getContextPath() + "/incident?action=list");
    }

    private void cancelIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ticketDAO.cancelIncidentTicket(id);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void assignIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int assignedTo = Integer.parseInt(request.getParameter("assignedTo"));
        ticketDAO.assignIncidentTicket(id, assignedTo);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void categorizeIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        ticketDAO.categorizeIncidentTicket(id, categoryId);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    private void linkIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String relatedIdsStr = request.getParameter("relatedIds");
        List<Integer> relatedIds = new ArrayList<>();
        if (relatedIdsStr != null && !relatedIdsStr.trim().isEmpty()) {
            for (String s : relatedIdsStr.split(",")) {
                try {
                    relatedIds.add(Integer.parseInt(s.trim()));
                } catch (NumberFormatException ignored) {
                }
            }
        }
        ticketDAO.linkRelatedIncidents(id, relatedIds, 1);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }
}
