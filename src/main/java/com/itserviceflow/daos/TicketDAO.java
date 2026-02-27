/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.itserviceflow.daos;

import com.itserviceflow.models.Ticket;
import com.itserviceflow.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author vumin
 */
public class TicketDAO {

    public List<Ticket> getIncidentList(int userId, String role) {
        List<Ticket> list = new ArrayList<>();

        String sql;

        boolean isEndUser = "End-user".equalsIgnoreCase(role);

        if (isEndUser) {
            sql = "SELECT * FROM ticket "
                    + "WHERE ticket_type='INCIDENT' "
                    + "AND reported_by=?";
        } else {
            sql = "SELECT * FROM ticket "
                    + "WHERE ticket_type='INCIDENT'";
        }

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {

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

    public Ticket getTicketById(int id) {
        String sql = "SELECT * FROM ticket WHERE ticket_id = ?";

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    Ticket t = new Ticket();

                    t.setTicketId(rs.getInt("ticket_id"));
                    t.setTicketNumber(rs.getString("ticket_number"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setStatus(rs.getString("status"));
                    t.setPriority(rs.getString("priority"));
                    t.setReportedBy(rs.getInt("reported_by"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));

                    return t;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

}
