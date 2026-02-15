/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbcontext.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.User;

/**
 *
 * @author Lo Pc
 */
public class UserDAO {

    private Connection conn;

    public UserDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            System.err.println("error!" + e.getMessage());
        }
    }

    public List<User> getListUser() {
        List<User> user = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User u = new User();
                int user_id = rs.getInt("user_id");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String password_hash = rs.getString("password_hash");
                String full_name = rs.getString("full_name");
                String phone = rs.getString("phone");
                int department_id = rs.getInt("department_id");
                int role_id = rs.getInt("role_id");
                boolean is_active = rs.getBoolean("is_active");
                String reset_token = rs.getString("reset_token");
                Timestamp reset_token_expires = rs.getTimestamp("reset_token_expires");
                boolean reset_token_used = rs.getBoolean("reset_token_used");
                Timestamp last_login = rs.getTimestamp("last_login");
                Timestamp updated_at = rs.getTimestamp("updated_at");
                u.setUser_id(user_id);
                u.setUsername(username);
                u.setEmail(email);
                u.setPassword_hash(password_hash);
                u.setPhone(phone);
                u.setDepartment_id(department_id);
                u.setRole_id(role_id);
                u.setIs_active(is_active);
                u.setReset_token(reset_token);
                u.setReset_token_expires(LocalDateTime.MIN);
                u.setReset_token_used(reset_token_used);
                u.setLast_login(LocalDateTime.MIN);
                u.setUpdated_at(LocalDateTime.MAX);
                user.add(u);
            }
        } catch (Exception e) {
            System.err.println("error! " + e.getMessage());
        }
        return user;
    }
    public User login(String Username, String Password) {
        String sql = "select * from Users where username = ? and password = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, Username);
            st.setString(2, Password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                int user_id = rs.getInt("user_id");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String password_hash = rs.getString("password_hash");
                String full_name = rs.getString("full_name");
                String phone = rs.getString("phone");
                int department_id = rs.getInt("department_id");
                int role_id = rs.getInt("role_id");
                boolean is_active = rs.getBoolean("is_active");
                String reset_token = rs.getString("reset_token");
                Timestamp reset_token_expires = rs.getTimestamp("reset_token_expires");
                boolean reset_token_used = rs.getBoolean("reset_token_used");
                Timestamp last_login = rs.getTimestamp("last_login");
                Timestamp updated_at = rs.getTimestamp("updated_at");
                u.setUser_id(user_id);
                u.setUsername(username);
                u.setEmail(email);
                u.setPassword_hash(password_hash);
                u.setPhone(phone);
                u.setDepartment_id(department_id);
                u.setRole_id(role_id);
                u.setIs_active(is_active);
                u.setReset_token(reset_token);
                u.setReset_token_expires(LocalDateTime.MIN);
                u.setReset_token_used(reset_token_used);
                u.setLast_login(LocalDateTime.MIN);
                u.setUpdated_at(LocalDateTime.MAX);
                return u;
            }
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
        return null;
    }
}
