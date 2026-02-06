package model;

import java.time.LocalDateTime;

public class Department {

    private int departmentId;
    private String departmentName;
    private String departmentCode;
    private Integer managerId;              // nullable
    private Integer parentDepartmentId;     // nullable
    private String status;                  // ACTIVE / INACTIVE
    private LocalDateTime updatedAt;

    public Department() {
    }

    public Department(int departmentId, String departmentName, String departmentCode, Integer managerId, Integer parentDepartmentId, String status, LocalDateTime updatedAt) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.departmentCode = departmentCode;
        this.managerId = managerId;
        this.parentDepartmentId = parentDepartmentId;
        this.status = status;
        this.updatedAt = updatedAt;
    }

    
    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDepartmentCode() {
        return departmentCode;
    }

    public void setDepartmentCode(String departmentCode) {
        this.departmentCode = departmentCode;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }

    public Integer getParentDepartmentId() {
        return parentDepartmentId;
    }

    public void setParentDepartmentId(Integer parentDepartmentId) {
        this.parentDepartmentId = parentDepartmentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
