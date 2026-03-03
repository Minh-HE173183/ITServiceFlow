<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${not empty incident ? 'Edit Incident' : 'Create Incident'}</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { background-color: white; padding: 30px; border-radius:8px; box-shadow:0 0 10px rgba(0,0,0,0.1); max-width:600px; margin:auto; }
        h2 { color:#333; margin-top:0; margin-bottom:20px; }
        .form-group { margin-bottom:15px; }
        label { display:block; font-weight:bold; margin-bottom:5px; color:#555; }
        input[type="text"], textarea, select { width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; box-sizing:border-box; font-family:Arial, sans-serif; }
        .btn { padding:10px 15px; background-color:#28a745; color:white; border:none; border-radius:4px; cursor:pointer; font-size:16px; width:100%; }
        .btn:hover { background-color:#218838; }
        .btn-secondary { background-color:#6c757d; display:block; text-align:center; text-decoration:none; margin-top:10px; }
        .help-text { font-size:12px; color:#777; margin-top:5px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>${not empty incident ? 'Update Incident Ticket' : 'Create Incident Ticket'}</h2>
        <form action="${pageContext.request.contextPath}/incident?action=${not empty incident ? 'update' : 'insert'}" method="post">
            <c:if test="${not empty incident}"><input type="hidden" name="id" value="${incident.ticketId}"></c:if>

            <div class="form-group">
                <label for="title">Title *</label>
                <input type="text" id="title" name="title" value="${incident.title}" required>
            </div>

            <div class="form-group">
                <label for="description">Description *</label>
                <textarea id="description" name="description" rows="5" required>${incident.description}</textarea>
            </div>

            <div class="form-group">
                <label for="priority">Priority</label>
                <select id="priority" name="priority">
                    <option value="LOW" ${incident.priority=='LOW' ? 'selected' : ''}>Low</option>
                    <option value="MEDIUM" ${incident.priority=='MEDIUM' ? 'selected' : ''}>Medium</option>
                    <option value="HIGH" ${incident.priority=='HIGH' ? 'selected' : ''}>High</option>
                </select>
            </div>

            <div class="form-group">
                <label for="categoryId">Category ID</label>
                <input type="number" id="categoryId" name="categoryId" value="${incident.categoryId}" min="0">
            </div>

            <c:if test="${not empty incident}">
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="NEW" ${incident.status=='NEW' ? 'selected' : ''}>New</option>
                        <option value="IN_PROGRESS" ${incident.status=='IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                        <option value="RESOLVED" ${incident.status=='RESOLVED' ? 'selected' : ''}>Resolved</option>
                        <option value="CANCELLED" ${incident.status=='CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </div>
            </c:if>

            <c:if test="${empty incident}">
                <div class="form-group">
                    <label for="relatedIds">Link Related Incidents (comma-separated IDs)</label>
                    <input type="text" id="relatedIds" name="relatedIds" placeholder="e.g. 101,102,103">
                    <div class="help-text">Optional – associate this ticket with existing incidents.</div>
                </div>
            </c:if>

            <button type="submit" class="btn">${not empty incident ? 'Save Changes' : 'Submit Incident'}</button>
            <a href="${pageContext.request.contextPath}/incident?action=list" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>