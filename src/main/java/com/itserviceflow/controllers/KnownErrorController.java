package com.itserviceflow.controllers;

import com.itserviceflow.daos.KnownErrorDAO;
import com.itserviceflow.models.Article;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/known-error")
public class KnownErrorController extends HttpServlet {
    private KnownErrorDAO knownErrorDAO;

    @Override
    public void init() throws ServletException {
        knownErrorDAO = new KnownErrorDAO();
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
                listKnownErrors(request, response);
                break;
            case "detail":
                viewKnownErrorDetail(request, response);
                break;
            case "add":
                showKnownErrorForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listKnownErrors(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/known-error?action=list");
            return;
        }

        switch (action) {
            case "insert":
                insertKnownError(request, response);
                break;
            case "update":
                updateKnownError(request, response);
                break;
            case "delete":
                deleteKnownError(request, response);
                break;
            case "bulkDelete":
                bulkDeleteKnownError(request, response);
                break;
            case "review":
                reviewKnownError(request, response);
                break;
            case "bulkReview":
                bulkReviewKnownError(request, response);
                break;
            case "toggleStatus":
                toggleKnownErrorStatus(request, response);
                break;
            case "bulkToggleStatus":
                bulkToggleKnownErrorStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/known-error?action=list");
                break;
        }
    }

    private void listKnownErrors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Article> errors = knownErrorDAO.getAllKnownErrors();
        request.setAttribute("knownErrors", errors);
        request.getRequestDispatcher("/known-error/list.jsp").forward(request, response);
    }

    private void viewKnownErrorDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Article ke = knownErrorDAO.getKnownErrorById(id);
        request.setAttribute("knownError", ke);
        request.getRequestDispatcher("/known-error/detail.jsp").forward(request, response);
    }

    private void showKnownErrorForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/known-error/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Article ke = knownErrorDAO.getKnownErrorById(id);
        request.setAttribute("knownError", ke);
        request.getRequestDispatcher("/known-error/form.jsp").forward(request, response);
    }

    private void insertKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String symptom = request.getParameter("symptom");
        String cause = request.getParameter("cause");
        String solution = request.getParameter("solution");

        Article ke = new Article();
        ke.setTitle(title);
        ke.setSummary(summary);
        ke.setContent(content);
        ke.setSymptom(symptom);
        ke.setCause(cause);
        ke.setSolution(solution);

        ke.setAuthorId(5);

        knownErrorDAO.createKnownError(ke);
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void updateKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String symptom = request.getParameter("symptom");
        String cause = request.getParameter("cause");
        String solution = request.getParameter("solution");

        Article ke = new Article();
        ke.setArticleId(id);
        ke.setTitle(title);
        ke.setSummary(summary);
        ke.setContent(content);
        ke.setSymptom(symptom);
        ke.setCause(cause);
        ke.setSolution(solution);

        knownErrorDAO.updateKnownError(ke);
        response.sendRedirect(request.getContextPath() + "/known-error?action=detail&id=" + id);
    }

    private void deleteKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        knownErrorDAO.deleteKnownError(id);
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void bulkDeleteKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        if (ids != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    knownErrorDAO.deleteKnownError(id);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void reviewKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status"); 
        String rejectionReason = request.getParameter("rejectionReason");

        knownErrorDAO.reviewKnownError(id, status, 10, rejectionReason);
        response.sendRedirect(request.getContextPath() + "/known-error?action=detail&id=" + id);
    }

    private void bulkReviewKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        String status = request.getParameter("status"); 
        String rejectionReason = "Bulk reviewed";
        if (ids != null && status != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    knownErrorDAO.reviewKnownError(id, status, 10, rejectionReason);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void toggleKnownErrorStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("currentStatus");
        knownErrorDAO.toggleKnownErrorStatus(id, currentStatus);
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void bulkToggleKnownErrorStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        String toggleTo = request.getParameter("toggleTo"); 
        if (ids != null && toggleTo != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    String mockCurrentStatus = toggleTo.equals("INACTIVE") ? "APPROVED" : "INACTIVE";
                    knownErrorDAO.toggleKnownErrorStatus(id, mockCurrentStatus);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }
}
