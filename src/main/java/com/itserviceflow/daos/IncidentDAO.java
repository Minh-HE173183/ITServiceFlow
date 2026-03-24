package com.itserviceflow.daos;

import com.itserviceflow.models.Comment;
import com.itserviceflow.models.Ticket;
import com.itserviceflow.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidentDAO {

    private static final String TYPE = "INCIDENT";

    public List<Ticket> getAllIncidents(Integer userId, String roleName) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM ticket WHERE ticket_type = '" + TYPE + "'";
        if (userId != null && !"Admin".equals(roleName) && !"Support Agent".equals(roleName)) {
            // end user sees only his/her own tickets
            sql += " AND reported_by = ?";
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (sql.contains("reported_by = ?")) {
                stmt.setInt(1, userId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Ticket getIncidentById(int ticketId) {
        String sql = "SELECT * FROM ticket WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
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

    public boolean createIncident(Ticket t) {
        String sql = "INSERT INTO ticket (ticket_number, ticket_type, title, description, status, priority, impact, urgency, category_id, reported_by) " +
                "VALUES (?, '" + TYPE + "', ?, ?, 'NEW', ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "INC-" + System.currentTimeMillis());
            stmt.setString(2, t.getTitle());
            stmt.setString(3, t.getDescription());
            stmt.setString(4, t.getPriority());
            stmt.setString(5, t.getImpact());
            stmt.setString(6, t.getUrgency());
            if (t.getCategoryId() != null) {
                stmt.setInt(7, t.getCategoryId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }
            stmt.setInt(8, t.getReportedBy());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateIncident(Ticket t) {
        String sql = "UPDATE ticket SET title = ?, description = ?, status = ?, priority = ?, impact = ?, urgency = ?, category_id = ?, " +
                "assigned_to = ?, cause = ?, solution = ? WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, t.getTitle());
            stmt.setString(2, t.getDescription());
            stmt.setString(3, t.getStatus());
            stmt.setString(4, t.getPriority());
            stmt.setString(5, t.getImpact());
            stmt.setString(6, t.getUrgency());
            if (t.getCategoryId() != null) {
                stmt.setInt(7, t.getCategoryId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }
            if (t.getAssignedTo() != null) {
                stmt.setInt(8, t.getAssignedTo());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            stmt.setString(9, t.getCause());
            stmt.setString(10, t.getSolution());
            stmt.setInt(11, t.getTicketId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteIncident(int ticketId) {
        String checkSql = "SELECT status, assigned_to, (SELECT COUNT(*) FROM comment WHERE ticket_id = ?) AS ccount " +
                "FROM ticket WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        String delSql = "DELETE FROM ticket WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, ticketId);
            checkStmt.setInt(2, ticketId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    Integer assigned = (Integer) rs.getObject("assigned_to");
                    int cnt = rs.getInt("ccount");
                    if ("NEW".equals(status) && assigned == null && cnt == 0) {
                        try (PreparedStatement del = conn.prepareStatement(delSql)) {
                            del.setInt(1, ticketId);
                            return del.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelIncident(int ticketId) {
        String sql = "UPDATE ticket SET status = 'CANCELLED', cancelled_at = CURRENT_TIMESTAMP WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean assignIncident(int ticketId, int userId) {
        String sql = "UPDATE ticket SET assigned_to = ?, status = 'IN_PROGRESS' WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addComment(Comment comment) {
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

    public boolean linkTickets(int sourceId, int targetId, String relationType, int createdBy) {
        String sql = "INSERT INTO ticket_relation (source_ticket_id, target_ticket_id, relation_type, created_by) " +
                "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sourceId);
            stmt.setInt(2, targetId);
            stmt.setString(3, relationType);
            stmt.setInt(4, createdBy);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changeStatus(int ticketId, String newStatus) {
        String sql = "UPDATE ticket SET status = ? WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveIncident(int ticketId, int approverId, boolean approve) {
        String sql = "UPDATE ticket SET approval_status = ?, approved_by = ?, approved_at = CURRENT_TIMESTAMP " +
                "WHERE ticket_id = ? AND ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, approve ? "APPROVED" : "REJECTED");
            stmt.setInt(2, approverId);
            stmt.setInt(3, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Ticket> getRelatedTickets(int ticketId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.* FROM ticket t " +
                     "JOIN ticket_relation tr ON (t.ticket_id = tr.source_ticket_id OR t.ticket_id = tr.target_ticket_id) " +
                     "WHERE (tr.source_ticket_id = ? OR tr.target_ticket_id = ?) " +
                     "AND t.ticket_type = '" + TYPE + "'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            stmt.setInt(2, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
        t.setImpact(rs.getString("impact"));
        t.setUrgency(rs.getString("urgency"));
        t.setCategoryId(rs.getInt("category_id"));
        t.setReportedBy(rs.getInt("reported_by"));
        t.setAssignedTo((Integer) rs.getObject("assigned_to"));
        t.setDepartmentId((Integer) rs.getObject("department_id"));
        t.setCause(rs.getString("cause"));
        t.setSolution(rs.getString("solution"));
        t.setApprovalStatus(rs.getString("approval_status"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setUpdatedAt(rs.getTimestamp("updated_at"));
        return t;
    }
}
