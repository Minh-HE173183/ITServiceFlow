/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.itserviceflow.daos;
import com.itserviceflow.models.Article;
import com.itserviceflow.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class KnownErrorDAO {

    public List<Article> getAllKnownErrors() {
        List<Article> errors = new ArrayList<>();
        String sql = "SELECT * FROM article WHERE article_type = 'KNOWN_ERROR'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                errors.add(mapRowToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return errors;
    }

    public List<Article> searchKnownErrors(String keyword, String statusFilter) {
        List<Article> errors = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM article WHERE article_type = 'KNOWN_ERROR'");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("ALL");

        if (hasKeyword) {
            sql.append(" AND (title LIKE ? OR article_number LIKE ?)");
        }
        if (hasStatus) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (hasKeyword) {
                String likeKeyword = "%" + keyword.trim() + "%";
                stmt.setString(paramIndex++, likeKeyword);
                stmt.setString(paramIndex++, likeKeyword);
            }
            if (hasStatus) {
                stmt.setString(paramIndex++, statusFilter.trim());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    errors.add(mapRowToArticle(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return errors;
    }

    public Article getKnownErrorById(int articleId) {
        String sql = "SELECT * FROM article WHERE article_id = ? AND article_type = 'KNOWN_ERROR'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, articleId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToArticle(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createKnownError(Article error) {
        String sql = "INSERT INTO article (article_number, article_type, title, content, summary, status, author_id, symptom, cause, solution) "
                + "VALUES (?, 'KNOWN_ERROR', ?, ?, ?, 'PENDING', ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "KE-" + System.currentTimeMillis());
            stmt.setString(2, error.getTitle());
            stmt.setString(3, error.getContent());
            stmt.setString(4, error.getSummary());
            stmt.setInt(5, error.getAuthorId());
            stmt.setString(6, error.getSymptom());
            stmt.setString(7, error.getCause());
            stmt.setString(8, error.getSolution());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateKnownError(Article error) {
        String sql = "UPDATE article SET title = ?, content = ?, summary = ?, symptom = ?, cause = ?, solution = ? "
                + "WHERE article_id = ? AND article_type = 'KNOWN_ERROR'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, error.getTitle());
            stmt.setString(2, error.getContent());
            stmt.setString(3, error.getSummary());
            stmt.setString(4, error.getSymptom());
            stmt.setString(5, error.getCause());
            stmt.setString(6, error.getSolution());
            stmt.setInt(7, error.getArticleId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteKnownError(int articleId) {
        String sql = "DELETE FROM article WHERE article_id = ? AND article_type = 'KNOWN_ERROR' AND status IN ('PENDING', 'REJECTED')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, articleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean reviewKnownError(int articleId, String status, int approvedBy, String rejectionReason) {
        if (!"APPROVED".equals(status) && !"REJECTED".equals(status)) {
            return false;
        }

        String sql = "UPDATE article SET status = ?, approved_by = ?, approved_at = CURRENT_TIMESTAMP, rejection_reason = ? "
                + "WHERE article_id = ? AND article_type = 'KNOWN_ERROR'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, approvedBy);
            stmt.setString(3, rejectionReason);
            stmt.setInt(4, articleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleKnownErrorStatus(int articleId, String currentStatus) {
        String newStatus = "APPROVED".equals(currentStatus) ? "INACTIVE" : "APPROVED";
        String sql = "UPDATE article SET status = ? WHERE article_id = ? AND article_type = 'KNOWN_ERROR'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, articleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Article mapRowToArticle(ResultSet rs) throws SQLException {
        Article a = new Article();
        a.setArticleId(rs.getInt("article_id"));
        a.setArticleNumber(rs.getString("article_number"));
        a.setArticleType(rs.getString("article_type"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setSummary(rs.getString("summary"));
        a.setCategoryId(rs.getInt("category_id") == 0 ? null : rs.getInt("category_id"));
        a.setStatus(rs.getString("status"));
        a.setAuthorId(rs.getInt("author_id"));
        a.setSymptom(rs.getString("symptom"));
        a.setCause(rs.getString("cause"));
        a.setSolution(rs.getString("solution"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        return a;
    }
}
