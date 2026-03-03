/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.itserviceflow.daos;

import com.itserviceflow.models.TicketRelation;
import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */

public class ProblemDAO {

    public List<Ticket> getAllProblems(String keyword, String statusFilter) {
        List<Ticket> problems = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, ur.username AS reported_by_name, ua.username AS assigned_to_name " +
                        "FROM ticket t " +
                        "LEFT JOIN user ur ON t.reported_by = ur.user_id " +
                        "LEFT JOIN user ua ON t.assigned_to = ua.user_id " +
                        "WHERE t.ticket_type = 'PROBLEM'");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (t.ticket_number LIKE ? OR t.title LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append(" AND t.status = ?");
            params.add(statusFilter);
        }

        sql.append(" ORDER BY t.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    problems.add(mapRowToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return problems;
    }

    public Ticket getProblemById(int ticketId) {
        String sql = "SELECT t.*, ur.username AS reported_by_name, ua.username AS assigned_to_name " +
                "FROM ticket t " +
                "LEFT JOIN user ur ON t.reported_by = ur.user_id " +
                "LEFT JOIN user ua ON t.assigned_to = ua.user_id " +
                "WHERE t.ticket_id = ? AND t.ticket_type = 'PROBLEM'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTicket(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Ticket> getLinkedIncidents(int problemTicketId) {
        List<Ticket> incidents = new ArrayList<>();
        String sql = "SELECT t.*, ur.username AS reported_by_name, ua.username AS assigned_to_name FROM ticket t " +
                "JOIN ticket_relation tr ON t.ticket_id = tr.source_ticket_id " +
                "LEFT JOIN user ur ON t.reported_by = ur.user_id " +
                "LEFT JOIN user ua ON t.assigned_to = ua.user_id " +
                "WHERE tr.target_ticket_id = ? AND tr.relation_type = 'CAUSED_BY' AND t.ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, problemTicketId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    incidents.add(mapRowToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }

    public boolean createProblemTicket(Ticket problem, List<Integer> incidentIds, int createdBy) {
        String insertProblem = "INSERT INTO ticket (ticket_number, ticket_type, title, description, status, reported_by, cause, solution) "
                +
                "VALUES (?, 'PROBLEM', ?, ?, 'NEW', ?, ?, ?)";
        String insertRelation = "INSERT INTO ticket_relation (source_ticket_id, target_ticket_id, relation_type, created_by) "
                +
                "VALUES (?, ?, 'CAUSED_BY', ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int newProblemId = 0;
            try (PreparedStatement stmt = conn.prepareStatement(insertProblem, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, "PRB-" + System.currentTimeMillis());
                stmt.setString(2, problem.getTitle());
                stmt.setString(3, problem.getDescription());
                stmt.setInt(4, problem.getReportedBy());
                stmt.setString(5, problem.getCause());
                stmt.setString(6, problem.getSolution());
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        newProblemId = rs.getInt(1);
                    }
                }
            }

            if (newProblemId > 0 && incidentIds != null) {
                try (PreparedStatement relStmt = conn.prepareStatement(insertRelation)) {
                    for (int incId : incidentIds) {
                        relStmt.setInt(1, incId);
                        relStmt.setInt(2, newProblemId);
                        relStmt.setInt(3, createdBy);
                        relStmt.addBatch();
                    }
                    relStmt.executeBatch();
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean updateProblemTicket(Ticket problem) {
        String sql = "UPDATE ticket SET title = ?, description = ?, status = ?, cause = ?, solution = ? " +
                "WHERE ticket_id = ? AND ticket_type = 'PROBLEM'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, problem.getTitle());
            stmt.setString(2, problem.getDescription());
            stmt.setString(3, problem.getStatus());
            stmt.setString(4, problem.getCause());
            stmt.setString(5, problem.getSolution());
            stmt.setInt(6, problem.getTicketId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProblemTicket(int ticketId) {
        String checkSql = "SELECT status, assigned_to, " +
                "(SELECT COUNT(*) FROM ticket_relation WHERE target_ticket_id = ?) as rel_count " +
                "FROM ticket WHERE ticket_id = ? AND ticket_type = 'PROBLEM'";

        String deleteSql = "DELETE FROM ticket WHERE ticket_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, ticketId);
            checkStmt.setInt(2, ticketId);

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    Integer assignedTo = (Integer) rs.getObject("assigned_to");
                    int relCount = rs.getInt("rel_count");

                    if ("NEW".equals(status) && assignedTo == null && relCount == 0) {
                        try (PreparedStatement delStmt = conn.prepareStatement(deleteSql)) {
                            delStmt.setInt(1, ticketId);
                            return delStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelProblemTicket(int ticketId) {
        String sql = "UPDATE ticket SET status = 'CANCELLED', cancelled_at = CURRENT_TIMESTAMP " +
                "WHERE ticket_id = ? AND ticket_type = 'PROBLEM'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean assignProblemTicket(int ticketId, int assignedToUserId) {
        String sql = "UPDATE ticket SET assigned_to = ?, status = 'IN_PROGRESS' " +
                "WHERE ticket_id = ? AND ticket_type = 'PROBLEM'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignedToUserId);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addCommentToProblem(Comment comment) {
        String sql = "INSERT INTO comment (ticket_id, user_id, comment_text) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getTicketId());
            stmt.setInt(2, comment.getUserId());
            stmt.setString(3, comment.getCommentText());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Comment> getCommentsByTicketId(int ticketId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT * FROM comment WHERE ticket_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setTicketId(rs.getInt("ticket_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setCommentText(rs.getString("comment_text"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    comments.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    private Ticket mapRowToTicket(ResultSet rs) throws SQLException {
        Ticket t = new Ticket();
        t.setTicketId(rs.getInt("ticket_id"));
        t.setTicketNumber(rs.getString("ticket_number"));
        t.setTicketType(rs.getString("ticket_type"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setStatus(rs.getString("status"));
        t.setPriority(rs.getString("priority"));
        t.setCategoryId(rs.getInt("category_id"));
        t.setReportedBy(rs.getInt("reported_by"));
        t.setAssignedTo((Integer) rs.getObject("assigned_to"));
        t.setDepartmentId((Integer) rs.getObject("department_id"));
        t.setCause(rs.getString("cause"));
        t.setSolution(rs.getString("solution"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {
            t.setReportedByName(rs.getString("reported_by_name"));
        } catch (SQLException e) {
        }
        try {
            t.setAssignedToName(rs.getString("assigned_to_name"));
        } catch (SQLException e) {
        }

        return t;
    }
}
