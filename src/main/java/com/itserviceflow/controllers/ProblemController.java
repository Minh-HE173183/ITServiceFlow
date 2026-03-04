package com.itserviceflow.controllers;

import com.itserviceflow.daos.ProblemDAO;
import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.models.User;
import com.itserviceflow.utils.AuthUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/problem")
public class ProblemController extends HttpServlet {

    private ProblemDAO problemDAO;

    @Override
    public void init() throws ServletException {
        problemDAO = new ProblemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        User currentUser = AuthUtils.getCurrentUser(request);
        request.setAttribute("currentUser", currentUser); // pass for UI rules (e.g. hide delete buttons)

        switch (action) {
            case "list":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_IT_DIRECTOR))
                    return;
                listProblems(request, response);
                break;
            case "detail":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_IT_DIRECTOR))
                    return;
                viewProblemDetail(request, response);
                break;
            case "add":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER))
                    return;
                showProblemForm(request, response);
                break;
            case "edit":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                showEditForm(request, response);
                break;
            default:
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_IT_DIRECTOR))
                    return;
                listProblems(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/problem?action=list");
            return;
        }

        if (!AuthUtils.isLoggedIn(request, response)) {
            return;
        }

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        switch (action) {
            case "insert":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER))
                    return;
                insertProblem(request, response);
                break;
            case "update":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                updateProblem(request, response);
                break;
            case "delete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER))
                    return;
                deleteProblem(request, response);
                break;
            case "bulkDelete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER)) {
                    return;
                }
                bulkDeleteProblem(request, response);
                break;
            case "cancel":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER))
                    return;
                cancelProblem(request, response);
                break;
            case "assign":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER))
                    return;
                assignProblem(request, response);
                break;
            case "addComment":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                addComment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/problem?action=list");
                break;
        }
    }

    private void listProblems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");

        List<Ticket> problems = problemDAO.getAllProblems(keyword, statusFilter);
        request.setAttribute("problems", problems);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "ALL");
        request.getRequestDispatcher("/problem/list.jsp").forward(request, response);
    }

    private void viewProblemDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket problem = problemDAO.getProblemById(id);
        List<Ticket> linkedIncidents = problemDAO.getLinkedIncidents(id);
        List<Comment> comments = problemDAO.getCommentsByTicketId(id);

        request.setAttribute("problem", problem);
        request.setAttribute("linkedIncidents", linkedIncidents);
        request.setAttribute("comments", comments);
        request.getRequestDispatcher("/problem/detail.jsp").forward(request, response);
    }

    private void showProblemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/problem/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket problem = problemDAO.getProblemById(id);
        request.setAttribute("problem", problem);
        request.getRequestDispatcher("/problem/form.jsp").forward(request, response);
    }

    private void insertProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String cause = request.getParameter("cause");
        String solution = request.getParameter("solution");

        Ticket problem = new Ticket();
        problem.setTitle(title);
        problem.setDescription(description);
        problem.setCause(cause);
        problem.setSolution(solution);
        User user = AuthUtils.getCurrentUser(request);
        problem.setReportedBy(user.getUserId());

        String[] incidentIdStrs = request.getParameterValues("incidentIds");
        List<Integer> incidentIds = new ArrayList<>();
        if (incidentIdStrs != null) {
            String combined = String.join(",", incidentIdStrs);
            for (String str : combined.split(",")) {
                if (!str.trim().isEmpty()) {
                    try {
                        incidentIds.add(Integer.parseInt(str.trim()));
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
        }

        problemDAO.createProblemTicket(problem, incidentIds, user.getUserId());
        response.sendRedirect(request.getContextPath() + "/problem?action=list");
    }

    private void updateProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String cause = request.getParameter("cause");
        String solution = request.getParameter("solution");

        Ticket problem = new Ticket();
        problem.setTicketId(id);
        problem.setTitle(title);
        problem.setDescription(description);
        problem.setStatus(status);
        problem.setCause(cause);
        problem.setSolution(solution);

        problemDAO.updateProblemTicket(problem);
        response.sendRedirect(request.getContextPath() + "/problem?action=detail&id=" + id);
    }

    private void deleteProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket ticket = problemDAO.getProblemById(id);

        // UC37: Delete only if NEW, unlinked, unassigned
        if (ticket != null && "NEW".equals(ticket.getStatus()) && ticket.getAssignedTo() == null) {
            List<Ticket> links = problemDAO.getLinkedIncidents(id);
            if (links == null || links.isEmpty()) {
                problemDAO.deleteProblemTicket(id);
            }
        }
        response.sendRedirect(request.getContextPath() + "/problem?action=list");
    }

    private void bulkDeleteProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        if (ids != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    Ticket ticket = problemDAO.getProblemById(id);
                    if (ticket != null && "NEW".equals(ticket.getStatus()) && ticket.getAssignedTo() == null) {
                        List<Ticket> links = problemDAO.getLinkedIncidents(id);
                        if (links == null || links.isEmpty()) {
                            problemDAO.deleteProblemTicket(id);
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/problem?action=list");
    }

    private void cancelProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        problemDAO.cancelProblemTicket(id);
        response.sendRedirect(request.getContextPath() + "/problem?action=detail&id=" + id);
    }

    private void assignProblem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int assignedTo = Integer.parseInt(request.getParameter("assignedTo"));
        problemDAO.assignProblemTicket(id, assignedTo);
        response.sendRedirect(request.getContextPath() + "/problem?action=detail&id=" + id);
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String commentText = request.getParameter("commentText");

        User user = AuthUtils.getCurrentUser(request);

        Comment comment = new Comment();
        comment.setTicketId(id);
        comment.setUserId(user.getUserId());
        comment.setCommentText(commentText);

        problemDAO.addCommentToProblem(comment);
        response.sendRedirect(request.getContextPath() + "/problem?action=detail&id=" + id);
    }
}
