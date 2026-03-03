package com.itserviceflow.daos;

import com.itserviceflow.models.TimeLog;
import com.itserviceflow.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the time_log table.
 */
public class TimeLogDAO {

    /**
     * Inserts a new time log entry.
     */
    public boolean insertLog(TimeLog log) {
        String sql = "INSERT INTO time_log (ticket_id, user_id, activity_type, time_spent, description) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, log.getTicketId());
            stmt.setInt(2, log.getUserId());
            stmt.setString(3, log.getActivityType());
            stmt.setDouble(4, log.getTimeSpent());
            stmt.setString(5, log.getDescription());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        log.setLogId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Returns all time log entries for a given ticket, ordered newest first.
     * Joins with user table to get agent name.
     */
    public List<TimeLog> getLogsByTicketId(int ticketId) {
        List<TimeLog> list = new ArrayList<>();
        String sql = "SELECT tl.*, u.full_name AS agent_name, t.ticket_number "
                   + "FROM time_log tl "
                   + "JOIN `user` u ON tl.user_id = u.user_id "
                   + "JOIN ticket t ON tl.ticket_id = t.ticket_id "
                   + "WHERE tl.ticket_id = ? "
                   + "ORDER BY tl.logged_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns total hours logged for a ticket.
     */
    public double getTotalTimeByTicket(int ticketId) {
        String sql = "SELECT COALESCE(SUM(time_spent), 0) FROM time_log WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Returns all time logs for a specific agent (newest first).
     */
    public List<TimeLog> getLogsByUser(int userId) {
        List<TimeLog> list = new ArrayList<>();
        String sql = "SELECT tl.*, u.full_name AS agent_name, t.ticket_number "
                   + "FROM time_log tl "
                   + "JOIN `user` u ON tl.user_id = u.user_id "
                   + "JOIN ticket t ON tl.ticket_id = t.ticket_id "
                   + "WHERE tl.user_id = ? "
                   + "ORDER BY tl.logged_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private TimeLog mapRow(ResultSet rs) throws SQLException {
        TimeLog log = new TimeLog();
        log.setLogId(rs.getInt("log_id"));
        log.setTicketId(rs.getInt("ticket_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setActivityType(rs.getString("activity_type"));
        log.setTimeSpent(rs.getDouble("time_spent"));
        log.setDescription(rs.getString("description"));
        log.setLoggedAt(rs.getTimestamp("logged_at"));
        log.setUpdatedAt(rs.getTimestamp("updated_at"));
        log.setAgentName(rs.getString("agent_name"));
        log.setTicketNumber(rs.getString("ticket_number"));
        return log;
    }
}
