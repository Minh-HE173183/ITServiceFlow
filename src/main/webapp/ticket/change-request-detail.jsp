<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container-fluid bg-light p-4 rounded shadow-sm mb-5">
    
   <div class="d-flex justify-content-between align-items-center mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb bg-transparent p-0 m-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/change-request/list">Change Management</a></li>
                <li class="breadcrumb-item active" aria-current="page">#CR-${ticket.ticketId}</li>
            </ol>
        </nav>
        
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/change-request/list" class="btn btn-outline-secondary btn-sm shadow-sm">
                <i class="bi bi-arrow-left"></i> Back to List
            </a>
            
            <%-- HIỂN THỊ NÚT EDIT NẾU NGƯỜI DÙNG CHÍNH LÀ NGƯỜI TẠO VÀ STATUS ĐANG LÀ NEW --%>
            <c:if test="${ticket.reportedBy == sessionScope.user.userId and ticket.status eq 'NEW'}">
                <a href="${pageContext.request.contextPath}/change-request/edit?id=${ticket.ticketId}" class="btn btn-warning btn-sm shadow-sm fw-bold">
                    <i class="bi bi-pencil-square"></i> Edit Request
                </a>
            </c:if>
        </div>
    </div>

    <div class="row g-4">
        <%-- CỘT TRÁI: THÔNG TIN CHI TIẾT --%>
        <div class="col-md-8">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white border-bottom py-3">
                    <h4 class="mb-0 text-primary">${ticket.title}</h4>
                </div>
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-card-text me-2"></i>Change Description</h6>
                    <p class="text-secondary mb-4">${ticket.description}</p>

                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-shield-exclamation me-2"></i>Impact & Risk Assessment</h6>
                    <p class="text-muted bg-light p-3 rounded border-start border-4 border-warning mb-4">
                        ${not empty ticket.impactAssessment ? ticket.impactAssessment : 'No impact assessment provided.'}
                    </p>

                    <div class="row g-3">
                        <div class="col-12">
                            <h6 class="fw-bold text-dark mb-2"><i class="bi bi-tools me-2"></i>Implementation Plan</h6>
                            <p class="text-secondary bg-white border p-3 rounded">${not empty ticket.implementationPlan ? ticket.implementationPlan : 'N/A'}</p>
                        </div>
                        <div class="col-12">
                            <h6 class="fw-bold text-dark mb-2"><i class="bi bi-arrow-counterclockwise me-2"></i>Rollback Plan</h6>
                            <p class="text-secondary bg-white border p-3 rounded">${not empty ticket.rollbackPlan ? ticket.rollbackPlan : 'N/A'}</p>
                        </div>
                        <div class="col-12">
                            <h6 class="fw-bold text-dark mb-2"><i class="bi bi-check2-square me-2"></i>Test Plan</h6>
                            <p class="text-secondary bg-white border p-3 rounded">${not empty ticket.testPlan ? ticket.testPlan : 'N/A'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- CỘT PHẢI: THUỘC TÍNH VÀ LỊCH TRÌNH --%>
        <div class="col-md-4">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Change Details</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-3"><small class="text-muted d-block">Status</small>
                            <span class="badge bg-secondary fs-6 ${ticket.status == 'NEW' ? 'bg-primary' : (ticket.status == 'APPROVED' ? 'bg-success' : 'bg-secondary')}">${ticket.status}</span>
                        </li>
                        <li class="mb-3"><small class="text-muted d-block">Change Type</small>
                            <span class="badge bg-info text-dark">${not empty ticket.changeType ? ticket.changeType : 'NORMAL'}</span>
                        </li>
                        <li class="mb-3"><small class="text-muted d-block">Risk Level</small>
                            <span class="badge ${ticket.riskLevel == 'HIGH' or ticket.riskLevel == 'CRITICAL' ? 'bg-danger' : 'bg-warning text-dark'}">${not empty ticket.riskLevel ? ticket.riskLevel : 'MEDIUM'}</span>
                        </li>
                        <li class="mb-3"><small class="text-muted d-block">Requester</small><strong><i class="bi bi-person me-1"></i> ${ticket.reportedByName}</strong></li>
                        <li class="mb-3"><small class="text-muted d-block">Assigned To</small>
                            <strong><i class="bi bi-headset me-1"></i> ${not empty ticket.assignedToName ? ticket.assignedToName : '<span class="text-warning">Chưa phân công</span>'}</strong>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="card shadow-sm border-0 mb-4 border-top border-4 border-info">
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="bi bi-calendar-event me-2"></i>Schedule Info</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-3"><small class="text-muted d-block">Scheduled Start</small>
                            <span class="fw-bold text-primary">
                                <c:choose>
                                    <c:when test="${not empty ticket.scheduledStart}">
                                        <fmt:formatDate value="${ticket.scheduledStart}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>TBD</c:otherwise>
                                </c:choose>
                            </span>
                        </li>
                        <li class="mb-3"><small class="text-muted d-block">Scheduled End</small>
                            <span class="fw-bold text-primary">
                                <c:choose>
                                    <c:when test="${not empty ticket.scheduledEnd}">
                                        <fmt:formatDate value="${ticket.scheduledEnd}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>TBD</c:otherwise>
                                </c:choose>
                            </span>
                        </li>
                        <li class="mb-3"><small class="text-muted d-block">Downtime Required?</small>
                            <span class="badge ${ticket.downtimeRequired ? 'bg-danger' : 'bg-success'}">${ticket.downtimeRequired ? 'YES' : 'NO'}</span>
                        </li>
                    </ul>
                </div>
            </div>
            
            <%-- CAB DECISION INFO --%>
            <div class="card shadow-sm border-0 bg-dark text-white">
                <div class="card-body p-4">
                    <h6 class="fw-bold border-bottom border-secondary pb-2 mb-3"><i class="bi bi-bank me-2"></i>CAB Decision</h6>
                    <div class="d-flex align-items-center mb-2">
                        <h4 class="m-0 me-2 ${ticket.cabDecision == 'APPROVED' ? 'text-success' : (ticket.cabDecision == 'REJECTED' ? 'text-danger' : 'text-warning')}">
                            <i class="bi ${ticket.cabDecision == 'APPROVED' ? 'bi-check-circle-fill' : (ticket.cabDecision == 'REJECTED' ? 'bi-x-circle-fill' : 'bi-hourglass-split')}"></i>
                        </h4>
                        <span class="fs-5 fw-bold">${not empty ticket.cabDecision ? ticket.cabDecision : 'PENDING'}</span>
                    </div>
                    <p class="small text-light mb-0 mt-2">${not empty ticket.cabComment ? ticket.cabComment : 'No comments from CAB yet.'}</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />