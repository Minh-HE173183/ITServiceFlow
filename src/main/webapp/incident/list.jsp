<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Incident Tickets</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .btn { padding: 8px 12px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px; display: inline-block;}
        .btn-danger { background-color: #dc3545; }
        .btn-info { background-color: #17a2b8; }
        .action-btns { display: flex; gap: 5px; }
        .header-action { display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-action">
            <h2>Incident Tickets List</h2>
            <a href="${pageContext.request.contextPath}/incident?action=add" class="btn">Create Incident Ticket</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Ticket Number</th>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="inc" items="${incidents}">
                    <tr>
                        <td>${inc.ticketId}</td>
                        <td>${inc.ticketNumber}</td>
                        <td>${inc.title}</td>
                        <td>${inc.status}</td>
                        <td>${inc.createdAt}</td>
                        <td class="action-btns">
                            <a href="${pageContext.request.contextPath}/incident?action=detail&id=${inc.ticketId}" class="btn btn-info">View</a>
                            <c:if test="${inc.status eq 'NEW' && inc.assignedTo == null}">
                                <form action="${pageContext.request.contextPath}/incident?action=delete" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${inc.ticketId}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this incident ticket?');">Delete</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty incidents}">
                    <tr>
                        <td colspan="6" style="text-align: center;">No Incident Tickets found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>