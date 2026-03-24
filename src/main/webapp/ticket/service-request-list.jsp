<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Lấy Role ID của người đang đăng nhập từ Session --%>
<c:set var="userRole" value="${sessionScope.user.roleId}" />

<div class="container-fluid bg-white p-4 rounded shadow-sm">
    
    <%-- HIỂN THỊ THÔNG BÁO --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            <c:remove var="message" scope="session"/>
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            <c:remove var="error" scope="session"/>
        </div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h4 text-primary m-0"><i class="bi bi-ticket-detailed me-2"></i>Service Requests</h2>
        
        <%-- Chỉ User (Role 1) mới thấy nút tạo mới Catalog --%>
        <c:if test="${userRole == 1}">
            <a href="${pageContext.request.contextPath}/service-catalog" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> Back to Catalog
            </a>
        </c:if>
    </div>

    <form action="${pageContext.request.contextPath}/ticket/service-request-list" method="get" 
          class="row g-3 mb-4 bg-light p-3 rounded border mx-0">
        <div class="col-md-6">
            <input type="text" name="search" class="form-control" placeholder="Search by Title..." value="${search}">
        </div>
        <div class="col-md-3">
            <select name="statusFilter" class="form-select">
                <option value="">All Statuses</option>
                <option value="NEW" ${statusFilter == 'NEW' ? 'selected' : ''}>NEW</option>
                <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                <option value="RESOLVED" ${statusFilter == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                <option value="CLOSED" ${statusFilter == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                <option value="CANCELLED" ${ticket.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
            </select>
        </div>
        <div class="col-md-3 d-flex gap-2">
            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Filter</button>
            <a href="${pageContext.request.contextPath}/ticket/service-request-list" class="btn btn-outline-secondary">
                <i class="bi bi-x-circle"></i>
            </a>
        </div>
    </form>

    <form action="${pageContext.request.contextPath}/ticket/delete-request" method="post" id="bulkDeleteForm">
        <input type="hidden" name="action" value="bulk">
        
        <%-- CHỈ HIỂN THỊ NÚT DELETE SELECTED CHO USER (ROLE 1) --%>
        <c:if test="${userRole == 1}">
            <div class="d-flex justify-content-end mb-2">
                <button type="submit" class="btn btn-danger btn-sm shadow-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa các Request đã chọn không?');">
                    <i class="bi bi-trash"></i> Delete Selected
                </button>
            </div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle mt-2">
                <thead class="table-light">
                    <tr>
                        <%-- CHỈ HIỂN THỊ CỘT CHECKBOX CHO USER (ROLE 1) --%>
                        <c:if test="${userRole == 1}">
                            <th class="text-center" style="width: 50px;">
                                <input class="form-check-input" type="checkbox" id="selectAll">
                            </th>
                        </c:if>
                        
                        <th>Ticket ID</th>
                        <th>Request Title</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${requestList}">
                        <tr>
                            <%-- CHỈ HIỂN THỊ Ô CHECKBOX CHO USER (ROLE 1) --%>
                            <c:if test="${userRole == 1}">
                                <td class="text-center align-middle">
                                    <%-- Dùng 'eq' (equals) thay cho '==' và 'or' thay cho '||' cho an toàn tuyệt đối --%>
                                    <c:if test="${req.status eq 'NEW' or req.status eq 'New'}">
                                        <input class="form-check-input ticket-checkbox" style="transform: scale(1.2);" type="checkbox" name="ticketIds" value="${req.ticketId}">
                                    </c:if>
                                </td>
                            </c:if>
                            
                            <td><strong>#SR-${req.ticketId}</strong></td>
                            <td class="text-primary fw-bold">${req.title}</td>
                            <td>
                                <span class="badge ${req.priority == 'CRITICAL' ? 'bg-danger' : (req.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-info text-dark')}">
                                    ${req.priority}
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-secondary ${req.status == 'New' ? 'bg-primary' : (req.status == 'RESOLVED' ? 'bg-success' : 'bg-secondary')}">
                                    ${req.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/request-detail?id=${req.ticketId}" 
                                   class="btn btn-sm btn-outline-primary" title="View Details">
                                    <i class="bi bi-eye"></i> View
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty requestList}">
                        <tr>
                            <%-- Gộp cột động: Nếu là User thì gộp 7 cột, Manager thì gộp 6 cột --%>
                            <td colspan="${userRole == 1 ? 7 : 6}" class="text-center text-muted fst-italic py-4">
                                <i class="bi bi-inbox fs-4 d-block mb-2"></i> No service requests found.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </form>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const selectAllCheckbox = document.getElementById('selectAll');
        const itemCheckboxes = document.querySelectorAll('.ticket-checkbox');

        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function() {
                itemCheckboxes.forEach(function(checkbox) {
                    checkbox.checked = selectAllCheckbox.checked;
                });
            });
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />