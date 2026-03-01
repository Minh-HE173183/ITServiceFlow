<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Incident Detail - ${incident.ticketNumber}</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        h2,h3 { color: #333; margin-top:0; }
        .detail-group { margin-bottom: 15px; }
        .label { font-weight: bold; color: #555; }
        .value { color: #000; }
        .btn { padding: 8px 12px; background-color: #007bff; color: white; text-decoration: none; border-radius:4px; border:none; cursor:pointer; display:inline-block; font-size:14px; }
        .btn-warning { background-color:#ffc107; color:#212529; }
        .btn-danger { background-color:#dc3545; }
        .btn-secondary { background-color:#6c757d; }
        .btn-group { margin-top:20px; display:flex; gap:10px; }
        ul { list-style-type:none; padding:0; }
        li { padding:10px; background:#eaeff5; margin-bottom:5px; border-radius:4px; }
        .form-group { margin-bottom:15px; }
        textarea, input[type="text"], input[type="number"], select { width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; box-sizing:border-box; }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/incident?action=list" class="btn btn-secondary" style="margin-bottom:20px;">&larr; Back to List</a>

        <h2>Incident Detail: ${incident.ticketNumber}</h2>
        <div class="detail-group"><span class="label">Title:</span> <span class="value">${incident.title}</span></div>
        <div class="detail-group"><span class="label">Description:</span> <span class="value">${incident.description}</span></div>
        <div class="detail-group"><span class="label">Status:</span> <span class="value">${incident.status}</span></div>
        <div class="detail-group"><span class="label">Priority:</span> <span class="value">${incident.priority}</span></div>
        <div class="detail-group"><span class="label">Category:</span> <span class="value">${incident.categoryId}</span></div>
        <div class="detail-group"><span class="label">Reported By:</span> <span class="value">${incident.reportedBy}</span></div>
        <div class="detail-group"><span class="label">Assigned To:</span> <span class="value">${incident.assignedTo == null ? 'Unassigned' : incident.assignedTo}</span></div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/incident?action=edit&id=${incident.ticketId}" class="btn btn-warning">Edit</a>
            <c:if test="${incident.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/incident?action=cancel" method="post" onsubmit="return confirm('Cancel this ticket?');">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <button type="submit" class="btn btn-danger">Cancel Ticket</button>
                </form>
            </c:if>
            <c:if test="${incident.assignedTo == null && incident.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/incident?action=assign" method="post" style="display:flex; gap:5px; align-items:center;">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <input type="hidden" name="assignedTo" value="5">
                    <button type="submit" class="btn">Assign to Me (5)</button>
                </form>
            </c:if>
        </div>
    </div>

    <div class="container">
        <h3>Related Incidents</h3>
        <c:if test="${not empty relatedIncidents}">
            <ul>
                <c:forEach var="inc" items="${relatedIncidents}">
                    <li><strong>${inc.ticketNumber}</strong> - ${inc.title} <span style="float:right; color:#666;">[${inc.status}]</span></li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty relatedIncidents}"><p style="color:#666;">No related incidents.</p></c:if>
    </div>
</body>
</html>