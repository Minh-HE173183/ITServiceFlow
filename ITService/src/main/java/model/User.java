package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDateTime;

public class User {

    private Integer user_id;              // INT → Integer (cho phép null khi tạo mới)
    private String username;             // VARCHAR(100)
    private String email;                // VARCHAR(255)
    private String password_hash;             // VARCHAR(255) - đã hash
    private String full_name;             // VARCHAR(255) - full_name
    private String phone;                // VARCHAR(~20)
    private Integer role_id;              // INT - khóa ngoại tới bảng roles
    private Integer department_id;        // INT - khóa ngoại tới department
    private Boolean is_active;            // TINYINT(1) → Boolean (true = 1, false = 0)
    private String reset_token;           // VARCHAR(255)
    private LocalDateTime reset_token_expires;  // DATETIME
    private Boolean reset_token_used;      // TINYINT(1) → Boolean
    private LocalDateTime updated_at;     // DATETIME - tự động update
    private LocalDateTime last_login;     // DATETIME

    public User() {
    }

    public User(Integer user_id, String username, String email, String password_hash, String full_name, String phone, Integer role_id, Integer department_id, Boolean is_active, String reset_token, LocalDateTime reset_token_expires, Boolean reset_token_used, LocalDateTime updated_at, LocalDateTime last_login) {
        this.user_id = user_id;
        this.username = username;
        this.email = email;
        this.password_hash = password_hash;
        this.full_name = full_name;
        this.phone = phone;
        this.role_id = role_id;
        this.department_id = department_id;
        this.is_active = is_active;
        this.reset_token = reset_token;
        this.reset_token_expires = reset_token_expires;
        this.reset_token_used = reset_token_used;
        this.updated_at = updated_at;
        this.last_login = last_login;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getRole_id() {
        return role_id;
    }

    public void setRole_id(Integer role_id) {
        this.role_id = role_id;
    }

    public Integer getDepartment_id() {
        return department_id;
    }

    public void setDepartment_id(Integer department_id) {
        this.department_id = department_id;
    }

    public Boolean getIs_active() {
        return is_active;
    }

    public void setIs_active(Boolean is_active) {
        this.is_active = is_active;
    }

    public String getReset_token() {
        return reset_token;
    }

    public void setReset_token(String reset_token) {
        this.reset_token = reset_token;
    }

    public LocalDateTime getReset_token_expires() {
        return reset_token_expires;
    }

    public void setReset_token_expires(LocalDateTime reset_token_expires) {
        this.reset_token_expires = reset_token_expires;
    }

    public Boolean getReset_token_used() {
        return reset_token_used;
    }

    public void setReset_token_used(Boolean reset_token_used) {
        this.reset_token_used = reset_token_used;
    }

    public LocalDateTime getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDateTime updated_at) {
        this.updated_at = updated_at;
    }

    public LocalDateTime getLast_login() {
        return last_login;
    }

    public void setLast_login(LocalDateTime last_login) {
        this.last_login = last_login;
    }

    
    

}
