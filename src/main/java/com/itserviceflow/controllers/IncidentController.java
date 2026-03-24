package com.itserviceflow.controllers;

<<<<<<< HEAD
import com.itserviceflow.daos.IncidentDAO;
import com.itserviceflow.daos.TicketCategoryDAO;
import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User;
=======
import com.itserviceflow.daos.TicketDAO;
import com.itserviceflow.daos.RoleDAO;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User;
import com.itserviceflow.utils.TimeLogService;
>>>>>>> origin

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<< HEAD
=======
import jakarta.servlet.http.HttpSession;
>>>>>>> origin
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/incident")
public class IncidentController extends HttpServlet {
<<<<<<< HEAD
    private IncidentDAO incidentDAO;
    private TicketCategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        incidentDAO = new IncidentDAO();
        categoryDAO = new TicketCategoryDAO();
=======
    private TicketDAO ticketDAO;
    private TimeLogService timeLogService;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
        timeLogService = new TimeLogService();
>>>>>>> origin
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
<<<<<<< HEAD
=======

>>>>>>> origin
        switch (action) {
            case "list":
                listIncidents(request, response);
                break;
            case "detail":
<<<<<<< HEAD
                viewDetail(request, response);
=======
                viewIncidentDetail(request, response);
>>>>>>> origin
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
<<<<<<< HEAD
=======

>>>>>>> origin
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
<<<<<<< HEAD
            case "addComment":
                addComment(request, response);
=======
            case "categorize":
                categorizeIncident(request, response);
>>>>>>> origin
                break;
            case "link":
                linkIncident(request, response);
                break;
<<<<<<< HEAD
            case "changeStatus":
                changeStatus(request, response);
                break;
            case "approve":
                approveIncident(request, response);
=======
            case "logtime":
                manualLogTime(request, response);
>>>>>>> origin
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/incident?action=list");
                break;
        }
    }

    private void listIncidents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
<<<<<<< HEAD
<<<<<<< Updated upstream
        User user = (User) request.getSession().getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;
        String roleName = (user != null) ? user.getRoleName() : null;
        List<Ticket> list = incidentDAO.getAllIncidents(userId, roleName);
        request.setAttribute("incidents", list);
        request.getRequestDispatcher("/incident/list.jsp").forward(request, response);
=======
=======
>>>>>>> origin
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
<<<<<<< HEAD
        request.getRequestDispatcher("/incidents/incidentList.jsp").forward(request, response);
>>>>>>> Stashed changes
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
=======
        request.getRequestDispatcher("/incidents/incident-list.jsp").forward(request, response);
    }

    private void viewIncidentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket incident = ticketDAO.getTicketWithDetails(id);
        List<Ticket> related = ticketDAO.getRelatedIncidents(id);

        // Load time logs for this ticket
        com.itserviceflow.daos.TimeLogDAO timeLogDAO = new com.itserviceflow.daos.TimeLogDAO();
        java.util.List<com.itserviceflow.models.TimeLog> timeLogs = timeLogDAO.getLogsByTicketId(id);
        double totalTimeSpent = timeLogDAO.getTotalTimeByTicket(id);

        request.setAttribute("incident", incident);
        request.setAttribute("relatedIncidents", related);
        request.setAttribute("timeLogs", timeLogs);
        request.setAttribute("totalTimeSpent", totalTimeSpent);
        request.getRequestDispatcher("/incidents/incident-detail.jsp").forward(request, response);
>>>>>>> origin
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
<<<<<<< HEAD
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/incident/form.jsp").forward(request, response);
=======
        request.getRequestDispatcher("/incidents/incident-form.jsp").forward(request, response);
>>>>>>> origin
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
<<<<<<< HEAD
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
=======
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

        // Get current logged-in user
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int creatorId = (currentUser != null) ? currentUser.getUserId() : 1;

        Ticket incident = new Ticket();
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setPriority(priority);
        incident.setCategoryId(categoryId);
        incident.setReportedBy(creatorId);
        incident.setTicketType("INCIDENT");

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

        boolean created = ticketDAO.createIncidentTicket(incident, creatorId);
        if (created && incident.getTicketId() > 0) {
            // Load full details (including difficulty_level) for logtime calc
            Ticket full = ticketDAO.getTicketWithDetails(incident.getTicketId());
            if (full != null) {
                timeLogService.autoLog(full, creatorId, "INVESTIGATION");
            }
        }
        if (!relatedIds.isEmpty()) {
            ticketDAO.linkRelatedIncidents(incident.getTicketId(), relatedIds, creatorId);
        }
        response.sendRedirect(request.getContextPath() + "/incident?action=list");
    }

    private void updateIncident(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String newStatus = request.getParameter("status");
        String priority = request.getParameter("priority");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        // Fetch current status before update to detect transitions
        Ticket existing = ticketDAO.getTicketWithDetails(id);
        String oldStatus = (existing != null) ? existing.getStatus() : "";

        Ticket incident = new Ticket();
        incident.setTicketId(id);
        incident.setTitle(title);
        incident.setDescription(description);
        incident.setStatus(newStatus);
        incident.setPriority(priority);
        incident.setCategoryId(categoryId);

        ticketDAO.updateIncidentTicket(incident);

        // Auto-log on status transitions
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int agentId = (currentUser != null) ? currentUser.getUserId() : 1;

        if (existing != null && newStatus != null && !newStatus.equals(oldStatus)) {
            if ("RESOLVED".equals(newStatus)) {
                timeLogService.autoLog(existing, agentId, "RESOLVED");
            } else if ("CLOSED".equals(newStatus)) {
                timeLogService.autoLog(existing, agentId, "CLOSED");
            }
        }

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

        // Auto-log ASSIGNED activity
        Ticket ticket = ticketDAO.getTicketWithDetails(id);
        if (ticket != null) {
            timeLogService.autoLog(ticket, assignedTo, "ASSIGNED");
        }

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
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int userId = (currentUser != null) ? currentUser.getUserId() : 1;
        ticketDAO.linkRelatedIncidents(id, relatedIds, userId);
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + id);
    }

    /**
     * Handles manual time log submission from the agent via the incident-detail form.
     */
    private void manualLogTime(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int ticketId = Integer.parseInt(request.getParameter("id"));
        double timeSpent;
        try {
            timeSpent = Double.parseDouble(request.getParameter("timeSpent"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + "&logError=invalidTime");
            return;
        }
        String description = request.getParameter("logDescription");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int agentId = (currentUser != null) ? currentUser.getUserId() : 1;

        boolean saved = timeLogService.manualLog(ticketId, agentId, timeSpent, description);
        String param = saved ? "&logSuccess=1" : "&logError=saveFailed";
        response.sendRedirect(request.getContextPath() + "/incident?action=detail&id=" + ticketId + param);
>>>>>>> origin
    }
}
