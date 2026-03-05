<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%-- KHÔNG khai báo taglib c ở đây để tránh xung đột --%>

<%-- 1. Include layout trước để nó định nghĩa prefix [c] cho toàn bộ trang --%>
<%@ include file="/common/admin-layout-top.jsp" %>

<%-- 2. Bây giờ mới dùng thẻ c:set (Lúc này prefix c đã được layout định nghĩa) --%>
<c:set var="pageTitle" value="Quản lý Service Catalog" scope="request"/>

<style>
    .hover-shadow { transition: all 0.3s ease; }
    .hover-shadow:hover { transform: translateY(-5px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important; }
    .text-truncate-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    #adminActions { left: 250px; right: 0; transition: all 0.3s ease; z-index: 1030; }
</style>

<div class="container-fluid">
    <%-- Hiển thị thông báo phản hồi từ hệ thống --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-info alert-dismissible fade show shadow-sm border-0" role="alert">
            <i class="bi bi-info-circle me-2"></i> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            <c:remove var="message" scope="session"/>
        </div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold"><i class="bi bi-hdd-network me-2"></i>Service Management</h3>
        <a href="${pageContext.request.contextPath}/admin/create-service" class="btn btn-success shadow-sm">
            <i class="bi bi-plus-circle me-1"></i> Create New Service
        </a>
    </div>

    <%-- Thanh tìm kiếm dịch vụ --%>
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/service-management" method="get" class="row g-2">
                <div class="col-md-10">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                        <input type="text" name="search" class="form-control border-start-0" 
                               placeholder="Tìm kiếm dịch vụ..." value="${lastSearch}">
                    </div>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Search</button>
                </div>
            </form>
        </div>
    </div>

    <%-- Form xử lý xóa --%>
    <form action="${pageContext.request.contextPath}/admin/delete-service" method="post" id="bulkDeleteForm">
        <div class="row">
            <c:forEach var="svc" items="${allServices}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm border-0 hover-shadow transition">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center border-bottom-0 pt-3">
                            <div class="form-check">
                                <input type="checkbox" name="serviceIds" value="${svc.serviceId}" class="form-check-input shadow-none">
                            </div>
                            <span class="badge ${svc.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} rounded-pill">
                                ${svc.status}
                            </span>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title fw-bold text-dark">${svc.serviceName}</h5>
                            <p class="card-text text-muted small text-truncate-2">${svc.description}</p>
                        </div>
                        <div class="card-footer bg-white border-top-0 pb-3">
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/admin/service-managedetail?id=${svc.serviceId}" class="btn btn-sm btn-outline-primary flex-grow-1">View</a>
                                <a href="${pageContext.request.contextPath}/admin/update-service?id=${svc.serviceId}" class="btn btn-sm btn-outline-warning flex-grow-1">Edit</a>
                                <button type="button" class="btn btn-sm btn-outline-danger flex-grow-1" onclick="confirmDeleteOne('${svc.serviceId}')">Delete</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="fixed-bottom p-3 bg-white border-top shadow-lg" id="adminActions" style="display:none;">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <span id="selectedCount" class="fw-bold text-primary">0 items selected</span>
                <button type="submit" class="btn btn-danger px-4" onclick="return confirm('Delete selected services? This only works for services with no requests.')">
                    <i class="bi bi-trash3 me-1"></i> Delete Selected Items
                </button>
            </div>
        </div>
    </form>
</div>

<%-- 3. Chèn phần Footer chung --%>
<%@ include file="/common/admin-layout-bottom.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('input[name="serviceIds"]');
        const adminActions = document.getElementById('adminActions');
        checkboxes.forEach(cb => {
            cb.addEventListener('change', () => {
                const checked = document.querySelectorAll('input[name="serviceIds"]:checked');
                if (adminActions) {
                    adminActions.style.display = checked.length > 0 ? 'block' : 'none';
                    document.getElementById('selectedCount').innerText = checked.length + ' items selected';
                }
            });
        });
    });

    function confirmDeleteOne(id) {
        if (confirm('Xóa dịch vụ này?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/delete-service';
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'serviceIds';
            input.value = id;
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>