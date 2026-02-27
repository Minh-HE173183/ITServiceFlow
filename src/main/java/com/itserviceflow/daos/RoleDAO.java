package com.itserviceflow.daos;

import com.itserviceflow.models.Role;
import com.itserviceflow.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class RoleDAO {
    private Connection conn;

    public RoleDAO() {
        conn = DBConnection.getConnection();
    }

    public List<Role> listAll() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role WHERE status = 'ACTIVE'";
        try (PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                r.setDescription(rs.getString("description"));
                r.setPermission(rs.getString("permission"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Role findById(int id) {
        String sql = "SELECT * FROM role WHERE role_id = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Role r = new Role();
                    r.setRoleId(rs.getInt("role_id"));
                    r.setRoleName(rs.getString("role_name"));
                    r.setDescription(rs.getString("description"));
                    r.setPermission(rs.getString("permission"));
                    r.setStatus(rs.getString("status"));
                    return r;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
