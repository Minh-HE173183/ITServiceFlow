package com.itserviceflow.daos;

import com.itserviceflow.models.TicketCategory;
import com.itserviceflow.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketCategoryDAO {

    public List<TicketCategory> getAllCategories() {
        List<TicketCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM ticket_category ORDER BY category_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                categories.add(mapRowToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<TicketCategory> getActiveCategories() {
        List<TicketCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM ticket_category WHERE is_active = 1 ORDER BY category_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                categories.add(mapRowToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    private TicketCategory mapRowToCategory(ResultSet rs) throws SQLException {
        TicketCategory cat = new TicketCategory();
        cat.setCategoryId(rs.getInt("category_id"));
        cat.setCategoryName(rs.getString("category_name"));
        cat.setCategoryCode(rs.getString("category_code"));
        cat.setCategoryType(rs.getString("category_type"));
        cat.setDescription(rs.getString("description"));
        cat.setParentCategoryId((Integer) rs.getObject("parent_category_id"));
        cat.setActive(rs.getBoolean("is_active"));
        cat.setUpdatedAt(rs.getTimestamp("updated_at"));
        return cat;
    }
}
