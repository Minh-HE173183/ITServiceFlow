<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${not empty incident ? 'Edit Incident' : 'Create Incident'}</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); max-width:600px; margin:auto; }
        h2 { color:#333; margin-top:0; margin-bottom:20px; }
        .form-group { margin-bottom:15px; }
        label { display:block; font-weight:bold; margin-bottom:5px; color:#555; }
        input[type="text"], textarea, select, input[type="number"] { width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; box-sizing:border-box; font-family: Arial, sans-serif; }
        .btn { padding:10px 15px; background-color:#28a745; color:white; border:none; border-radius:4px; cursor:pointer; font-size:16px; width:100%; }
        .btn:hover { background-color:#218838; }
        .btn-secondary { background-color:#6c757d; display:block; text-align:center; text-decoration:none; margin-top:10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>${not empty incident ? 'Update Incident Ticket' : 'Create Incident Ticket'}</h2>
        <form action="${pageContext.request.contextPath}/incident?action=${not empty incident ? 'update' : 'insert'}" method="post">
            <c:if test="${not empty incident}">
                <input type="hidden" name="ticketId" value="${incident.ticketId}">
            </c:if>
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
                    <option value="LOW" ${incident.priority=='LOW'?'selected':''}>LOW</option>
                    <option value="MEDIUM" ${incident.priority=='MEDIUM'?'selected':''}>MEDIUM</option>
                    <option value="HIGH" ${incident.priority=='HIGH'?'selected':''}>HIGH</option>
                    <option value="CRITICAL" ${incident.priority=='CRITICAL'?'selected':''}>CRITICAL</option>
                </select>
            </div>
            <div class="form-group">
                <label for="impact">Impact</label>
                <select id="impact" name="impact">
                    <option value="LOW" ${incident.impact=='LOW'?'selected':''}>LOW</option>
                    <option value="MEDIUM" ${incident.impact=='MEDIUM'?'selected':''}>MEDIUM</option>
                    <option value="HIGH" ${incident.impact=='HIGH'?'selected':''}>HIGH</option>
                    <option value="CRITICAL" ${incident.impact=='CRITICAL'?'selected':''}>CRITICAL</option>
                </select>
            </div>
            <div class="form-group">
                <label for="urgency">Urgency</label>
                <select id="urgency" name="urgency">
                    <option value="LOW" ${incident.urgency=='LOW'?'selected':''}>LOW</option>
                    <option value="MEDIUM" ${incident.urgency=='MEDIUM'?'selected':''}>MEDIUM</option>
                    <option value="HIGH" ${incident.urgency=='HIGH'?'selected':''}>HIGH</option>
                    <option value="CRITICAL" ${incident.urgency=='CRITICAL'?'selected':''}>CRITICAL</option>
                </select>
            </div>
            <div class="form-group">
                <label for="categoryId">Category</label>
                <select id="categoryId" name="categoryId">
                    <option value="" ${incident.categoryId == null ? 'selected':''}></option>
                    <c:forEach var="categ" items="${categories}">
                        <option value="${categ.categoryId}" ${incident.categoryId == categ.categoryId ? 'selected':''}>${categ.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <c:if test="${not empty incident}">
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="NEW" ${incident.status=='NEW'?'selected':''}>NEW</option>
                        <option value="IN_PROGRESS" ${incident.status=='IN_PROGRESS'?'selected':''}>IN_PROGRESS</option>
                        <option value="ON_HOLD" ${incident.status=='ON_HOLD'?'selected':''}>ON_HOLD</option>
                        <option value="RESOLVED" ${incident.status=='RESOLVED'?'selected':''}>RESOLVED</option>
                        <option value="CLOSED" ${incident.status=='CLOSED'?'selected':''}>CLOSED</option>
                    </select>
                </div>
            </c:if>
            <button type="submit" class="btn">${not empty incident ? 'Save' : 'Submit'}</button>
            <a href="${pageContext.request.contextPath}/incident?action=list" class="btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>