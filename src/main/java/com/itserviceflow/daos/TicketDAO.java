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
            e.printStackTrace();
            return false;
        }
    }
}
