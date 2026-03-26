package com.itserviceflow.daos;

import com.itserviceflow.models.Feedback;
import com.itserviceflow.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    public boolean saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (ticket_id, user_id, agent_id, rating, feedback_text, submitted_at, updated_at) "
                   + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, feedback.getTicketId());
            ps.setInt(2, feedback.getUserId());
            ps.setInt(3, feedback.getAgentId());
            ps.setInt(4, feedback.getRating());
            ps.setString(5, feedback.getFeedbackText());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Feedback getFeedbackByTicketId(int ticketId) {
        String sql = "SELECT * FROM feedback WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Feedback feedback = new Feedback();
                    feedback.setFeedbackId(rs.getInt("feedback_id"));
                    feedback.setTicketId(rs.getInt("ticket_id"));
                    feedback.setUserId(rs.getInt("user_id"));
                    feedback.setAgentId(rs.getInt("agent_id"));
                    feedback.setRating(rs.getInt("rating"));
                    feedback.setFeedbackText(rs.getString("feedback_text"));
                    feedback.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return feedback;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean hasFeedback(int ticketId) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE ticket_id = ?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}