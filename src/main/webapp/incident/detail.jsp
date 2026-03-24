<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Incident Detail - ${incident.ticketNumber}</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        h2,h3 { color: #333; margin-top:0; }
        .detail-group { margin-bottom:15px; }
        .label { font-weight:bold; color:#555; }
        .value { color:#000; }
        .btn { padding:8px 12px; background-color:#007bff; color:white; text-decoration:none; border-radius:4px; border:none; cursor:pointer; display:inline-block; font-size:14px; }
        .btn-warning { background-color:#ffc107; color:#212529; }
        .btn-danger { background-color:#dc3545; }
        .btn-secondary { background-color:#6c757d; }
        .btn-group { margin-top:20px; display:flex; gap:10px; }
        ul { list-style-type:none; padding:0; }
        li { padding:10px; background:#eaeff5; margin-bottom:5px; border-radius:4px; }
        .form-group { margin-bottom:15px; }
        textarea,input[type="text"],select,input[type="number"] { width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; box-sizing:border-box; }
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
        <div class="detail-group"><span class="label">Impact:</span> <span class="value">${incident.impact}</span></div>
        <div class="detail-group"><span class="label">Urgency:</span> <span class="value">${incident.urgency}</span></div>
        <div class="detail-group"><span class="label">Category:</span> <span class="value">${incident.categoryId}</span></div>
        <div class="detail-group"><span class="label">Reported By:</span> <span class="value">${incident.reportedBy}</span></div>
        <div class="detail-group"><span class="label">Assigned To:</span> <span class="value">${incident.assignedTo == null ? 'Unassigned' : incident.assignedTo}</span></div>
        <div class="detail-group"><span class="label">Approval:</span> <span class="value">${incident.approvalStatus}</span></div>
        <hr>
        <div class="btn-group">
            <c:if test="${incident.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/incident?action=cancel" method="post" onsubmit="return confirm('Cancel this incident?');">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <button type="submit" class="btn btn-danger">Cancel</button>
                </form>
            </c:if>
            <c:if test="${incident.assignedTo == null && incident.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/incident?action=assign" method="post" style="display:flex; gap:5px; align-items:center;">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <input type="hidden" name="assignedTo" value="5"> <!-- provide real user id in UI later -->
                    <button type="submit" class="btn">Assign</button>
                </form>
            </c:if>
            <c:if test="${incident.approvalStatus == 'PENDING' && sessionScope.user.roleName == 'General Manager'}">
                <form action="${pageContext.request.contextPath}/incident?action=approve" method="post" style="display:flex; gap:5px;">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <input type="hidden" name="approve" value="true">
                    <button type="submit" class="btn btn-warning">Approve</button>
                </form>
                <form action="${pageContext.request.contextPath}/incident?action=approve" method="post" style="display:flex; gap:5px;">
                    <input type="hidden" name="id" value="${incident.ticketId}">
                    <input type="hidden" name="approve" value="false">
                    <button type="submit" class="btn btn-danger">Reject</button>
                </form>
            </c:if>
        </div>
        <hr>
        <h3>Update Status</h3>
        <form action="${pageContext.request.contextPath}/incident?action=changeStatus" method="post">
            <input type="hidden" name="id" value="${incident.ticketId}">
            <select name="newStatus">
                <option value="NEW" ${incident.status=='NEW'?'selected':''}>NEW</option>
                <option value="IN_PROGRESS" ${incident.status=='IN_PROGRESS'?'selected':''}>IN_PROGRESS</option>
                <option value="ON_HOLD" ${incident.status=='ON_HOLD'?'selected':''}>ON_HOLD</option>
                <option value="RESOLVED" ${incident.status=='RESOLVED'?'selected':''}>RESOLVED</option>
                <option value="CLOSED" ${incident.status=='CLOSED'?'selected':''}>CLOSED</option>
            </select>
            <button type="submit" class="btn btn-info">Change</button>
        </form>
    </div>
    <div class="container">
        <h3>Linked Tickets</h3>
        <!-- Show relationship list or placeholder -->
        <c:if test="${not empty incident.relatedTickets}">
            <ul>
                <c:forEach var="rel" items="${incident.relatedTickets}">
                    <li><strong>${rel.ticketNumber}</strong> - ${rel.title} [${rel.status}]</li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty incident.relatedTickets}">
            <p style="color:#666;">No related incidents.</p>
        </c:if>
        <!-- simple link form -->
        <form action="${pageContext.request.contextPath}/incident?action=link" method="post" style="margin-top:15px;">
            <input type="hidden" name="sourceId" value="${incident.ticketId}">
            <div class="form-group">
                <label>Target Ticket ID</label>
                <input type="number" name="targetId" required>
            </div>
            <div class="form-group">
                <label>Relation Type</label>
                <select name="relationType">
                    <option value="RELATED">RELATED</option>
                    <option value="PARENT_CHILD">PARENT_CHILD</option>
                    <option value="DUPLICATE">DUPLICATE</option>
                    <option value="BLOCKS">BLOCKS</option>
                    <option value="CAUSED_BY">CAUSED_BY</option>
                </select>
            </div>
            <button type="submit" class="btn">Link Ticket</button>
        </form>
    </div>
    <div class="container">
        <h3>Comments</h3>
        <form action="${pageContext.request.contextPath}/incident?action=addComment" method="post">
            <input type="hidden" name="id" value="${incident.ticketId}">
            <div class="form-group">
                <textarea name="commentText" rows="4" placeholder="Add comment..." required></textarea>
            </div>
            <button type="submit" class="btn">Add Comment</button>
        </form>
    </div>
</body>
</html>