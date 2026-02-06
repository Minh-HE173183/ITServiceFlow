package model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String fullName;
    private String phone;
    private Integer departmentId;     // nullable
    private int roleId;
    private boolean isActive;
    private String resetToken;
    private LocalDateTime resetTokenExpires;
    private boolean resetTokenUsed;
    private LocalDateTime lastLogin;
    private LocalDateTime updatedAt;

    public User() {
    }

    public User(int userId, String username, String email, String passwordHash, String fullName, String phone, Integer departmentId, int roleId, boolean isActive, String resetToken, LocalDateTime resetTokenExpires, boolean resetTokenUsed, LocalDateTime lastLogin, LocalDateTime updatedAt) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.phone = phone;
        this.departmentId = departmentId;
        this.roleId = roleId;
        this.isActive = isActive;
        this.resetToken = resetToken;
        this.resetTokenExpires = resetTokenExpires;
        this.resetTokenUsed = resetTokenUsed;
        this.lastLogin = lastLogin;
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public LocalDateTime getResetTokenExpires() {
        return resetTokenExpires;
    }

    public void setResetTokenExpires(LocalDateTime resetTokenExpires) {
        this.resetTokenExpires = resetTokenExpires;
    }

    public boolean isResetTokenUsed() {
        return resetTokenUsed;
    }

    public void setResetTokenUsed(boolean resetTokenUsed) {
        this.resetTokenUsed = resetTokenUsed;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    
}