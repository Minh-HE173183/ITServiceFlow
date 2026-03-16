package com.itserviceflow.controllers;

import com.itserviceflow.daos.KnownErrorDAO;
import com.itserviceflow.models.Article;
import com.itserviceflow.utils.AuthUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/knowledge-base")
public class KnowledgeBaseController extends HttpServlet {
    private KnownErrorDAO knownErrorDAO;

    @Override
    public void init() {
        knownErrorDAO = new KnownErrorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtils.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewArticleDetail(request, response);
                break;
            case "list":
            default:
                listArticles(request, response);
                break;
        }
    }

    private void listArticles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("searchQuery");

        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * pageSize;

        // Force status filter to only APPROVED for the knowledge base
        int totalRecords = knownErrorDAO.getTotalKnownErrors(keyword, "APPROVED");
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        List<Article> articles = knownErrorDAO.searchKnownErrors(keyword, "APPROVED", offset, pageSize);

        request.setAttribute("articles", articles);
        request.setAttribute("searchQuery", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/knowledge-base/list.jsp").forward(request, response);
    }

    private void viewArticleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Article ke = knownErrorDAO.getKnownErrorById(id);

        // Only allow viewing if it is APPROVED
        if (ke == null || !"APPROVED".equals(ke.getStatus())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found or not published.");
            return;
        }

        request.setAttribute("article", ke);
        request.getRequestDispatcher("/knowledge-base/view.jsp").forward(request, response);
    }
}
