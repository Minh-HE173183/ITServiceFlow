package com.itserviceflow.controllers;

import com.itserviceflow.daos.ProblemDAO;
import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;

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

        switch (action) {
            case "list":
                listProblems(request, response);
                break;
            case "detail":
                viewProblemDetail(request, response);
                break;
            case "add":
                showProblemForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
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

        switch (action) {
            case "insert":
                insertProblem(request, response);
                break;
            case "update":
                updateProblem(request, response);
                break;
            case "delete":
                deleteProblem(request, response);
                break;
            case "cancel":
                cancelProblem(request, response);
                break;
            case "assign":
                assignProblem(request, response);
                break;
            case "addComment":
                addComment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/problem?action=list");
                break;
        }
    }

    private void listProblems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Ticket> problems = problemDAO.getAllProblems();
        request.setAttribute("problems", problems);
        request.getRequestDispatcher("/problem/list.jsp").forward(request, response);
    }

    private void viewProblemDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Ticket problem = problemDAO.getProblemById(id);
        List<Ticket> linkedIncidents = problemDAO.getLinkedIncidents(id);

        request.setAttribute("problem", problem);
        request.setAttribute("linkedIncidents", linkedIncidents);
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

        Ticket problem = new Ticket();
        problem.setTitle(title);
        problem.setDescription(description);
        // Assuming current user is logged in, hardcoding 1 for reportedBy
        problem.setReportedBy(1);

        String[] incidentIdStrs = request.getParameterValues("incidentIds");
        List<Integer> incidentIds = new ArrayList<>();
        if (incidentIdStrs != null) {
            for (String str : incidentIdStrs) {
                if (!str.trim().isEmpty()) {
                    incidentIds.add(Integer.parseInt(str));
                }
            }
        }

        problemDAO.createProblemTicket(problem, incidentIds, 1);
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
        problemDAO.deleteProblemTicket(id);
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

        // Assuming user 1
        Comment comment = new Comment();
        comment.setTicketId(id);
        comment.setUserId(1);
        comment.setCommentText(commentText);

        problemDAO.addCommentToProblem(comment);
        response.sendRedirect(request.getContextPath() + "/problem?action=detail&id=" + id);
    }
}
