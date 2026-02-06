package model;

import java.time.LocalDateTime;

public class Role {

    private int roleId;
    private String roleName;
    private String description;
    private String permission;      // JSON string
    private String status;          // ACTIVE / INACTIVE
    private LocalDateTime updatedAt; // nếu cần

    public Role() {
    }

    public Role(int roleId, String roleName, String description, String permission, String status, LocalDateTime updatedAt) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.description = description;
        this.permission = permission;
        this.status = status;
        this.updatedAt = updatedAt;
    }
    

    // Getters & Setters
    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPermission() {
        return permission;
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
