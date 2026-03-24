<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .step-progress { display: flex; justify-content: space-between; position: relative; margin-bottom: 2rem; }
    .step-progress::before { content: ""; position: absolute; top: 15px; left: 0; width: 100%; height: 3px; background-color: #e9ecef; z-index: 1; }
    .step { text-align: center; position: relative; z-index: 2; flex: 1; }
    .step-icon { width: 35px; height: 35px; border-radius: 50%; background-color: #e9ecef; color: #6c757d; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; font-weight: bold; border: 3px solid #fff; }
    .step.completed .step-icon { background-color: #198754; color: #fff; }
    .step.active .step-icon { background-color: #0d6efd; color: #fff; box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.25); }
    .step-label { font-size: 0.85rem; font-weight: 600; color: #6c757d; }
    .step.completed .step-label, .step.active .step-label { color: #212529; }
</style>

<div class="container-fluid bg-light p-4 rounded shadow-sm mb-5">
    
    <%-- Hiển thị thông báo sau khi Update --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm"><i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button><c:remove var="message" scope="session"/></div>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}<button type="button" class="btn-close" data-bs-dismiss="alert"></button><c:remove var="error" scope="session"/></div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb bg-transparent p-0 m-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/ticket/service-request-list">Requests Management</a></li>
                <li class="breadcrumb-item active" aria-current="page">#SR-${ticket.ticketId}</li>
            </ol>
        </nav>
        <a href="${pageContext.request.contextPath}/ticket/service-request-list" class="btn btn-outline-secondary btn-sm shadow-sm">
            <i class="bi bi-arrow-left"></i> Back to List
        </a>
    </div>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-4">
            <h5 class="card-title fw-bold mb-4 text-dark"><i class="bi bi-bar-chart-steps me-2"></i>Fulfillment Progress</h5>
            <c:set var="isNew" value="${ticket.status == 'NEW' || ticket.status == 'PENDING_APPROVAL'}" />
            <c:set var="isInProgress" value="${ticket.status == 'IN_PROGRESS' || ticket.status == 'APPROVED'}" />
            <c:set var="isResolved" value="${ticket.status == 'RESOLVED'}" />
            <c:set var="isClosed" value="${ticket.status == 'CLOSED'}" />
            <div class="step-progress">
                <div class="step ${isNew || isInProgress || isResolved || isClosed ? 'completed' : 'active'}">
                    <div class="step-icon"><i class="bi bi-file-earmark-check"></i></div><div class="step-label">Submitted</div>
                </div>
                <div class="step ${isInProgress || isResolved || isClosed ? 'completed' : (isNew ? '' : 'active')}">
                    <div class="step-icon"><i class="bi bi-person-check"></i></div><div class="step-label">Approved</div>
                </div>
                <div class="step ${isResolved || isClosed ? 'completed' : (isInProgress ? 'active' : '')}">
                    <div class="step-icon"><i class="bi bi-gear-wide-connected"></i></div><div class="step-label">Fulfillment</div>
                </div>
                <div class="step ${isClosed ? 'completed' : (isResolved ? 'active' : '')}">
                    <div class="step-icon"><i class="bi bi-check-circle"></i></div><div class="step-label">Resolved</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom py-3">
                    <h4 class="mb-0 text-primary">${ticket.title}</h4>
                </div>
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-card-text me-2"></i>Business Justification</h6>
                    <p class="text-muted bg-light p-3 rounded border-start border-4 border-primary mb-4">${not empty ticket.justification ? ticket.justification : 'No justification provided.'}</p>
                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-info-square me-2"></i>Additional Description</h6>
                    <p class="text-secondary">${not empty ticket.description ? ticket.description : 'No additional information.'}</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Request Details</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-3"><small class="text-muted d-block">Status</small><span class="badge bg-secondary fs-6 ${ticket.status == 'NEW' ? 'bg-primary' : (ticket.status == 'RESOLVED' ? 'bg-success' : 'bg-secondary')} fs-6">${ticket.status}</span></li>
                        <li class="mb-3"><small class="text-muted d-block">Priority</small><span class="badge ${ticket.priority == 'CRITICAL' ? 'bg-danger' : (ticket.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-info text-dark')}">${ticket.priority}</span></li>
                        <li class="mb-3"><small class="text-muted d-block">Requester</small><strong><i class="bi bi-person me-1"></i> ${ticket.reportedByName}</strong></li>
                        <li class="mb-3"><small class="text-muted d-block">Created Date</small><span class="text-dark"><i class="bi bi-calendar3 me-1"></i> <fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span></li>
                        <li><small class="text-muted d-block">Ticket ID</small><span class="font-monospace text-secondary">#SR-${ticket.ticketId}</span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0 mt-4 border-top border-4 border-warning">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 text-dark fw-bold"><i class="bi bi-pencil-square me-2"></i>Update Fulfillment Progress</h5>
        </div>
        <div class="card-body p-4 bg-light">
            <form action="${pageContext.request.contextPath}/update-request" method="post">
                <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                <input type="hidden" name="assignedTo" value="${ticket.assignedTo}">
                
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Update Status</label>
                        <select name="status" class="form-select border-secondary">
                            <option value="NEW" ${ticket.status == 'NEW' ? 'selected' : ''}>NEW</option>
                            <option value="IN_PROGRESS" ${ticket.status == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                            <option value="RESOLVED" ${ticket.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                            <option value="CLOSED" ${ticket.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                            <option value="CANCELLED" ${ticket.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                    </div>
                    <div class="col-md-8 mb-3">
                        <label class="form-label fw-bold">Resolution Notes / Comments</label>
                        <textarea name="solution" class="form-control border-secondary" rows="3" placeholder="Nhập tiến độ xử lý, hoặc ghi chú giải pháp tại đây...">${ticket.solution}</textarea>
                    </div>
                </div>
                <div class="d-flex justify-content-end gap-2 mt-2">
                    <c:if test="${empty ticket.assignedTo || ticket.status == 'NEW'}">
                        <button type="submit" name="action" value="take" class="btn btn-warning shadow-sm fw-bold"><i class="bi bi-person-raised-hand me-1"></i> Take Ticket</button>
                    </c:if>
                    
                   
                    <button type="submit" name="action" value="update" class="btn btn-primary shadow-sm fw-bold px-4"><i class="bi bi-save me-1"></i> Save Update</button>
                </div>
                    <%-- FORM ASSIGN (CHỈ DÀNH CHO MANAGER) --%>
                     <c:if test="${ticket.status eq 'NEW' or ticket.status eq 'New'}">
                        <div class="card shadow-sm border-0 mb-4 bg-light">
                            <div class="card-body p-4">
                                <h5 class="fw-bold text-dark mb-3"><i class="bi bi-person-plus me-2"></i>Assign Request</h5>

                                <form action="${pageContext.request.contextPath}/ticket/assign-request" method="post" class="row g-2 align-items-center">
                                    <input type="hidden" name="ticketId" value="${ticket.ticketId}">

                                    <div class="col-md-8">
                                        <select name="assignedTo" class="form-select border-primary" required>
                                            <option value="">-- Select IT Support Agent --</option>

                                            <option value="2">Nguyễn Văn A (IT Support - ID: 2)</option>
                                            <option value="4">Trần Thị B (IT Support - ID: 4)</option>

                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-primary w-100 shadow-sm">
                                            <i class="bi bi-send-check"></i> Confirm Assign
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>
            </form>
        </div>
    </div>

</div>
<jsp:include page="/includes/footer.jsp" />