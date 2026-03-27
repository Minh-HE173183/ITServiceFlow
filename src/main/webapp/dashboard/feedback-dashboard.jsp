<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/common/admin-layout-top.jsp" %>

<%-- ── Page header ─────────────────────────────────────────────── --%>
<div class="d-flex align-items-center justify-content-between mb-4">
    <div>
        <h4 class="fw-bold mb-0" style="color:#222d32;">
            <i class="bi bi-chat-dots me-2 text-success"></i>Feedback & CSAT Dashboard
        </h4>
        <small class="text-muted">
            Thống kê feedback, CSAT score và phân tích theo agent, thời gian.
        </small>
    </div>
    <a href="${pageContext.request.contextPath}/incident?action=list"
       class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-ticket-perforated me-1"></i>Incidents
    </a>
</div>

<%-- ── Quick navigation ───────────────────────────────────────── --%>
<div class="d-flex gap-2 flex-wrap mb-4">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="btn btn-outline-primary btn-sm">
        <i class="bi bi-speedometer2"></i> Executive Dashboard</a>
    <a href="${pageContext.request.contextPath}/incident?action=list" 
       class="btn btn-outline-info btn-sm">
        <i class="bi bi-lightning-fill"></i> Incidents</a>
    <a href="${pageContext.request.contextPath}/problem?action=list" 
       class="btn btn-outline-warning btn-sm">
        <i class="bi bi-exclamation-octagon-fill"></i> Problems</a>
    <a href="${pageContext.request.contextPath}/cmdb?action=list" 
       class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-server"></i> CMDB</a>
</div>

<%-- ── KPI Cards ───────────────────────────────────────────────── --%>
<div class="row g-4 mb-4">
    <div class="col-md-3">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="card-title text-white-50 text-uppercase">Tổng Feedback</h6>
                        <h3 class="mb-0">${feedbackTotal}</h3>
                        <small>Số lượng feedback</small>
                    </div>
                    <div class="align-self-center">
                        <i class="bi bi-chat-dots fs-1"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-success text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="card-title text-white-50 text-uppercase">CSAT Score</h6>
                        <h3 class="mb-0">${csatScore}%</h3>
                        <small>Tỷ lệ hài lòng</small>
                    </div>
                    <div class="align-self-center">
                        <i class="bi bi-star-fill fs-1"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-info text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="card-title text-white-50 text-uppercase">Hài lòng</h6>
                        <h3 class="mb-0">${satisfiedCount}</h3>
                        <small>Rating = 1</small>
                    </div>
                    <div class="align-self-center">
                        <i class="bi bi-hand-thumbs-up fs-1"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-warning text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="card-title text-white-50 text-uppercase">Chưa hài lòng</h6>
                        <h3 class="mb-0">${feedbackTotal - satisfiedCount}</h3>
                        <small>Rating = 0</small>
                    </div>
                    <div class="align-self-center">
                        <i class="bi bi-hand-thumbs-down fs-1"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ── Charts grid ─────────────────────────────────────────────── --%>
<div class="row g-4">
    <%-- Feedback by Agent --%>
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="bi bi-people-fill text-info me-2"></i>
                    Feedback theo Agent
                </h5>
            </div>
            <div class="card-body">
                <c:set var="maxFeedback" value="1" />
                <c:forEach var="e" items="${feedbackByAgent}">
                    <c:if test="${e.value > maxFeedback}">
                        <c:set var="maxFeedback" value="${e.value}" />
                    </c:if>
                </c:forEach>
                <div class="mt-3">
                    <c:forEach var="e" items="${feedbackByAgent}">
                        <c:set var="pct"
                               value="${maxFeedback > 0 ? (e.value * 100 / maxFeedback) : 0}" />
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3" style="width:120px; font-weight:500;">${e.key}</div>
                            <div class="flex-grow-1 bg-light rounded-pill" style="height:10px;">
                                <div class="bg-success rounded-pill" style="height:100%; width:${pct}%;"></div>
                            </div>
                            <div class="ms-3 fw-bold">${e.value}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty feedbackByAgent}">
                        <p class="text-muted text-center py-3">Chưa có dữ liệu feedback.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <%-- Feedback by Time --%>
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-fill text-warning me-2"></i>
                    Feedback theo thời gian (7 ngày)
                </h5>
            </div>
            <div class="card-body">
                <c:set var="maxTime" value="1" />
                <c:forEach var="e" items="${feedbackByTime}">
                    <c:if test="${e.value > maxTime}">
                        <c:set var="maxTime" value="${e.value}" />
                    </c:if>
                </c:forEach>
                <div class="mt-3">
                    <c:forEach var="e" items="${feedbackByTime}">
                        <c:set var="pct"
                               value="${maxTime > 0 ? (e.value * 100 / maxTime) : 0}" />
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3" style="width:120px; font-weight:500;">${e.key}</div>
                            <div class="flex-grow-1 bg-light rounded-pill" style="height:10px;">
                                <div class="bg-warning rounded-pill" style="height:100%; width:${pct}%;"></div>
                            </div>
                            <div class="ms-3 fw-bold">${e.value}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty feedbackByTime}">
                        <p class="text-muted text-center py-3">Chưa có dữ liệu feedback.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <%-- CSAT Score Detail --%>
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="bi bi-shield-check text-success me-2"></i>
                    CSAT Score Chi tiết
                </h5>
            </div>
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-3">
                        <h1 class="display-4 mb-0" style="color: ${csatScore >= 80 ? '#27ae60' : csatScore >= 50 ? '#f39c12' : '#c0392b'};">
                            <fmt:formatNumber value="${csatScore}" maxFractionDigits="2" minFractionDigits="2" />%
                        </h1>
                    </div>
                    <div class="col-md-9">
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar" style="width: ${csatScore}%; 
                                background: ${csatScore >= 80 ? 'linear-gradient(90deg,#27ae60,#2ecc71)' : csatScore >= 50 ? 'linear-gradient(90deg,#f39c12,#f1c40f)' : 'linear-gradient(90deg,#c0392b,#e74c3c)'};">
                            </div>
                        </div>
                        <p class="text-muted mb-0">
                            <strong>${satisfiedCount}</strong> feedback hài lòng trong tổng
                            <strong>${feedbackTotal}</strong> feedback.
                            <c:choose>
                                <c:when test="${csatScore >= 80}">
                                    <span class="text-success fw-semibold"> ✓ Đạt mục tiêu</span>
                                </c:when>
                                <c:when test="${csatScore >= 50}">
                                    <span class="text-warning fw-semibold"> ⚠ Cần chú ý</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold"> ✗ Chưa đạt mục tiêu</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Feedback Summary Table --%>
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="bi bi-table text-primary me-2"></i>
                    Bảng tổng hợp
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th>Agent</th>
                                <th>Feedback</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${feedbackByAgent}">
                                <tr>
                                    <td style="font-weight:500;">${e.key}</td>
                                    <td>${e.value}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty feedbackByAgent}">
                                <tr>
                                    <td colspan="2" class="text-muted text-center py-3">Chưa có dữ liệu feedback.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ── Footer note ─────────────────────────────────────────────── --%>
<div class="text-muted text-end mt-4" style="font-size:12px;">
    <i class="bi bi-info-circle me-1"></i>
    Dữ liệu phản ánh số liệu thời gian thực. Vui lòng làm mới trang để nhận các giá trị mới nhất.
</div>

<jsp:include page="/common/admin-layout-bottom.jsp" />