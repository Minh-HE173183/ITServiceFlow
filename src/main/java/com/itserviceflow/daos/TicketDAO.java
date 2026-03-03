/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.itserviceflow.daos;

import com.itserviceflow.models.Ticket;
import static com.itserviceflow.utils.DBConnection.getConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author ADMIN
 */
public class TicketDAO {

    public boolean createServiceRequest(Ticket ticket) {
        // ticket_type mặc định là 'SERVICE_REQUEST' theo US06 
        String sql = "INSERT INTO ticket (ticket_number, ticket_type, title, description, justification, "
                + "status, priority, service_id, reported_by, department_id, created_at) "
                + "VALUES (?, 'SERVICE_REQUEST', ?, ?, ?, 'New', ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Tạo mã ticket tự động (Ví dụ: SR-20260302-001)
            String ticketNum = "SR-" + System.currentTimeMillis() / 1000;

            ps.setString(1, ticketNum);
            ps.setString(2, ticket.getTitle());
            ps.setString(3, ticket.getDescription());
            ps.setString(4, ticket.getJustification());
            ps.setString(5, ticket.getPriority());
            ps.setInt(6, ticket.getServiceId());
            ps.setInt(7, ticket.getReportedBy());
            ps.setInt(8, ticket.getDepartmentId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
import com.itserviceflow.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author vumin
 */
public class TicketDAO {

    public Ticket getTicketById(int ticketId) {
        String sql = "SELECT * FROM ticket WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTicket(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Ticket> getIncidentList(int userId, String roleName) {
        List<Ticket> list = new ArrayList<>();

        String sql;
        boolean isEndUser = "End-user".equalsIgnoreCase(roleName);

        if (isEndUser) {
            sql = "SELECT * FROM ticket "
                    + "WHERE ticket_type = 'INCIDENT' "
                    + "AND reported_by = ?";
        } else {
            sql = "SELECT * FROM ticket "
                    + "WHERE ticket_type = 'INCIDENT'";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            if (isEndUser) {
                ps.setInt(1, userId);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Ticket t = new Ticket();
                t.setTicketId(rs.getInt("ticket_id"));
                t.setTicketNumber(rs.getString("ticket_number"));
                t.setTitle(rs.getString("title"));
                t.setStatus(rs.getString("status"));
                t.setPriority(rs.getString("priority"));
                t.setReportedBy(rs.getInt("reported_by"));
                t.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ---------- incident-specific operations ----------
    public Ticket getIncidentById(int ticketId) {
        String sql = "SELECT * FROM ticket WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTicket(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Ticket> getRelatedIncidents(int incidentId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.* FROM ticket t "
                + "JOIN ticket_relation tr ON t.ticket_id = tr.target_ticket_id "
                + "WHERE tr.source_ticket_id = ? AND tr.relation_type = 'RELATED' "
                + "AND t.ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, incidentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTicket(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createIncidentTicket(Ticket incident, int createdBy) {
        String sql = "INSERT INTO ticket (ticket_number, ticket_type, title, description, status, priority, category_id, reported_by) "
                + "VALUES (?, 'INCIDENT', ?, ?, 'NEW', ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, "INC-" + System.currentTimeMillis());
            stmt.setString(2, incident.getTitle());
            stmt.setString(3, incident.getDescription());
            stmt.setString(4, incident.getPriority());
            stmt.setInt(5, incident.getCategoryId());
            stmt.setInt(6, incident.getReportedBy());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    incident.setTicketId(rs.getInt(1));
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateIncidentTicket(Ticket incident) {
        String sql = "UPDATE ticket SET title = ?, description = ?, status = ?, priority = ?, category_id = ? "
                + "WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, incident.getTitle());
            stmt.setString(2, incident.getDescription());
            stmt.setString(3, incident.getStatus());
            stmt.setString(4, incident.getPriority());
            stmt.setInt(5, incident.getCategoryId());
            stmt.setInt(6, incident.getTicketId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteIncidentTicket(int ticketId) {
        String checkSql = "SELECT status, assigned_to FROM ticket WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        String deleteSql = "DELETE FROM ticket WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, ticketId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    Integer assignedTo = (Integer) rs.getObject("assigned_to");
                    if ("NEW".equals(status) && assignedTo == null) {
                        try (PreparedStatement delStmt = conn.prepareStatement(deleteSql)) {
                            delStmt.setInt(1, ticketId);
                            return delStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelIncidentTicket(int ticketId) {
        String sql = "UPDATE ticket SET status = 'CANCELLED', cancelled_at = CURRENT_TIMESTAMP "
                + "WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean assignIncidentTicket(int ticketId, int assignedToUserId) {
        String sql = "UPDATE ticket SET assigned_to = ?, status = 'IN_PROGRESS' "
                + "WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignedToUserId);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean categorizeIncidentTicket(int ticketId, int categoryId) {
        String sql = "UPDATE ticket SET category_id = ? WHERE ticket_id = ? AND ticket_type = 'INCIDENT'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            stmt.setInt(2, ticketId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean linkRelatedIncidents(int sourceId, List<Integer> relatedIds, int createdBy) {
        if (relatedIds == null || relatedIds.isEmpty()) {
            return true;
        }
        String sql = "INSERT INTO ticket_relation (source_ticket_id, target_ticket_id, relation_type, created_by) "
                + "VALUES (?, ?, 'RELATED', ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int rid : relatedIds) {
                stmt.setInt(1, sourceId);
                stmt.setInt(2, rid);
                stmt.setInt(3, createdBy);
                stmt.addBatch();
            }
            stmt.executeBatch();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
        t.setDifficultyLevel(rs.getString("difficulty_level"));
        t.setCategoryId(rs.getInt("category_id"));
        t.setReportedBy(rs.getInt("reported_by"));
        t.setAssignedTo((Integer) rs.getObject("assigned_to"));
        t.setDepartmentId((Integer) rs.getObject("department_id"));
        t.setCause(rs.getString("cause"));
        t.setSolution(rs.getString("solution"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setUpdatedAt(rs.getTimestamp("updated_at"));
        return t;
    }

    /**
     * Fetches a ticket and joins ticket_category to get difficulty_level.
     * Use this when you need difficulty for logtime calculation.
     */
    public Ticket getTicketWithDetails(int ticketId) {
        String sql = "SELECT t.*, tc.difficulty_level "
                   + "FROM ticket t "
                   + "LEFT JOIN ticket_category tc ON t.category_id = tc.category_id "
                   + "WHERE t.ticket_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToTicket(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ---------- incident-specific operations ----------
}
