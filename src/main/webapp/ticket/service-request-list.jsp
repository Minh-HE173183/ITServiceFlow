<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid bg-white p-4 rounded shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h4 text-primary m-0"><i class="bi bi-ticket-detailed me-2"></i>My Service Requests</h2>
        <a href="${pageContext.request.contextPath}/service-catalog" class="btn btn-primary shadow-sm">
            <i class="bi bi-plus-circle me-1"></i> Back to Catalog
        </a>
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
            </select>
        </div>
        <div class="col-md-3 d-flex gap-2">
            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Filter</button>
            <a href="${pageContext.request.contextPath}/ticket/service-request-list" class="btn btn-outline-secondary">
                <i class="bi bi-x-circle"></i>
            </a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle mt-3">
            <thead class="table-light">
                <tr>
                    <th>Ticket ID</th>
                    <th>Request Title</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Created At</th>
                    <th class="text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="req" items="${requestList}">
                    <tr>
                        <td><strong>#SR-${req.ticketId}</strong></td>
                        
                        <td class="text-primary fw-bold">${req.title}</td>
                        
                        <td>
                            <span class="badge ${req.priority == 'CRITICAL' ? 'bg-danger' : (req.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-info text-dark')}">
                                ${req.priority}
                            </span>
                        </td>
                        <td>
                            <span class="badge ${req.status == 'NEW' ? 'bg-primary' : (req.status == 'RESOLVED' ? 'bg-success' : 'bg-secondary')}">
                                ${req.status}
                            </span>
                        </td>
                        <td>
                            <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm" />
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
                        <td colspan="6" class="text-center text-muted fst-italic py-4">
                            <i class="bi bi-inbox fs-4 d-block mb-2"></i> No service requests found.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />