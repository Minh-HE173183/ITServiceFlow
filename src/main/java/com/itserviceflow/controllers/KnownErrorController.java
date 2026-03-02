package com.itserviceflow.controllers;

import com.itserviceflow.daos.KnownErrorDAO;
import com.itserviceflow.models.Article;
import com.itserviceflow.models.User;
import com.itserviceflow.utils.AuthUtils;

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

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        User currentUser = AuthUtils.getCurrentUser(request);
        request.setAttribute("currentUser", currentUser);

        switch (action) {
            case "list":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_SUPPORT_AGENT, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_IT_DIRECTOR))
                    return;
                listKnownErrors(request, response);
                break;
            case "detail":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_SUPPORT_AGENT, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_IT_DIRECTOR))
                    return;
                viewKnownErrorDetail(request, response);
                break;
            case "add":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                showKnownErrorForm(request, response);
                break;
            case "edit":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                showEditForm(request, response);
                break;
            default:
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_SUPPORT_AGENT, AuthUtils.ROLE_TECHNICAL_EXPERT,
                        AuthUtils.ROLE_MANAGER, AuthUtils.ROLE_IT_DIRECTOR))
                    return;
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

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        switch (action) {
            case "insert":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                insertKnownError(request, response);
                break;
            case "update":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                updateKnownError(request, response);
                break;
            case "delete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                deleteKnownError(request, response);
                break;
            case "bulkDelete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_TECHNICAL_EXPERT))
                    return;
                bulkDeleteKnownError(request, response);
                break;
            case "review":
                reviewKnownError(request, response); // Admin check inside or base fallback
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

        User user = AuthUtils.getCurrentUser(request);
        ke.setAuthorId(user.getUserId());

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
        Article ke = knownErrorDAO.getKnownErrorById(id);
        // UC45: Delete only if PENDING or REJECTED
        if (ke != null && ("PENDING".equals(ke.getStatus()) || "REJECTED".equals(ke.getStatus()))) {
            knownErrorDAO.deleteKnownError(id);
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void bulkDeleteKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        if (ids != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    Article ke = knownErrorDAO.getKnownErrorById(id);
                    if (ke != null && ("PENDING".equals(ke.getStatus()) || "REJECTED".equals(ke.getStatus()))) {
                        knownErrorDAO.deleteKnownError(id);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void reviewKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!AuthUtils.hasRole(request, response))
            return; // Admin check implicit because this only needs Admin, but let's check correctly
        if (AuthUtils.getCurrentUser(request).getRoleId() != AuthUtils.ROLE_ADMIN) {
            response.sendRedirect(request.getContextPath() + "/auth?action=forbid");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String rejectionReason = request.getParameter("rejectionReason");

        User user = AuthUtils.getCurrentUser(request);
        knownErrorDAO.reviewKnownError(id, status, user.getUserId(), rejectionReason);
        response.sendRedirect(request.getContextPath() + "/known-error?action=detail&id=" + id);
    }

    private void bulkReviewKnownError(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (AuthUtils.getCurrentUser(request).getRoleId() != AuthUtils.ROLE_ADMIN) {
            response.sendRedirect(request.getContextPath() + "/auth?action=forbid");
            return;
        }

        String[] ids = request.getParameterValues("selectedIds");
        String status = request.getParameter("status");
        String rejectionReason = "Bulk reviewed";
        User user = AuthUtils.getCurrentUser(request);
        if (ids != null && status != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    knownErrorDAO.reviewKnownError(id, status, user.getUserId(), rejectionReason);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void toggleKnownErrorStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (AuthUtils.getCurrentUser(request).getRoleId() != AuthUtils.ROLE_ADMIN) {
            response.sendRedirect(request.getContextPath() + "/auth?action=forbid");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("currentStatus");
        knownErrorDAO.toggleKnownErrorStatus(id, currentStatus);
        response.sendRedirect(request.getContextPath() + "/known-error?action=list");
    }

    private void bulkToggleKnownErrorStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (AuthUtils.getCurrentUser(request).getRoleId() != AuthUtils.ROLE_ADMIN) {
            response.sendRedirect(request.getContextPath() + "/auth?action=forbid");
            return;
        }

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
