<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.itserviceflow.models.Ticket" %>
<%@ page import="com.itserviceflow.models.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    User user = (User) session.getAttribute("user");
    List<Ticket> list = (List<Ticket>) request.getAttribute("incidentList");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Incident Management - ITServiceFlow</title>
        <style>
            :root {
                --primary-color: #3b82f6;
                --primary-hover: #2563eb;
                --success-color: #10b981;
                --success-hover: #059669;
                --danger-color: #ef4444;
                --danger-hover: #dc2626;
                --warning-color: #f59e0b;
                --warning-hover: #d97706;
                --text-primary: #1f2937;
                --text-secondary: #6b7280;
                --bg-color: #f8fafc;
                --card-bg: #ffffff;
                --border-color: #e5e7eb;
                --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: var(--bg-color);
                color: var(--text-primary);
                line-height: 1.6;
            }

            /* Header Styles */
            .header {
                background: linear-gradient(135deg, var(--primary-color), #8b5cf6);
                color: white;
                padding: 20px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: var(--shadow);
            }

            .header h1 {
                font-size: 1.5rem;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 15px;
                background: rgba(255, 255, 255, 0.1);
                padding: 10px 20px;
                border-radius: 25px;
            }

            .user-name {
                font-weight: 600;
                font-size: 1.1rem;
            }

            .user-role {
                font-size: 0.9rem;
                opacity: 0.8;
                background: rgba(255, 255, 255, 0.2);
                padding: 4px 12px;
                border-radius: 15px;
            }

            /* Main Container */
            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 20px;
            }

            /* Card Styles */
            .card {
                background: var(--card-bg);
                border-radius: 16px;
                box-shadow: var(--shadow);
                overflow: hidden;
            }

            .card-header {
                background-color: var(--card-bg);
                padding: 25px 30px;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--text-primary);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-actions {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            /* Table Styles */
            .table-container {
                overflow-x: auto;
                max-height: 70vh;
                overflow-y: auto;
            }

            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                min-width: 800px;
            }

            thead th {
                position: sticky;
                top: 0;
                background-color: #f8fafc;
                color: var(--text-secondary);
                font-weight: 600;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                padding: 15px;
                border-bottom: 2px solid var(--border-color);
                text-align: left;
                z-index: 10;
            }

            tbody td {
                padding: 15px;
                border-bottom: 1px solid var(--border-color);
                vertical-align: middle;
                font-size: 0.95rem;
            }

            tbody tr:hover {
                background-color: #f8fafc;
                transition: background-color 0.2s ease;
            }

            /* Badge Styles */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            /* Status Badges */
            .status-new {
                background-color: #dbeafe;
                color: #1d4ed8;
            }
            .status-in-progress {
                background-color: #f3e8ff;
                color: #5b21b6;
            }
            .status-resolved {
                background-color: #d1fae5;
                color: #065f46;
            }
            .status-cancelled {
                background-color: #fee2e2;
                color: #991b1b;
            }

            /* Priority Badges */
            .priority-low {
                background-color: #e5e7eb;
                color: #374151;
            }
            .priority-medium {
                background-color: #fef3c7;
                color: #92400e;
            }
            .priority-high {
                background-color: #fee2e2;
                color: #991b1b;
            }

            /* Action Buttons */
            .btn {
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-color), #8b5cf6);
                color: white;
                box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(59, 130, 246, 0.4);
                background: linear-gradient(135deg, var(--primary-hover), #7c3aed);
            }

            .btn-secondary {
                background-color: var(--text-secondary);
                color: white;
            }

            .btn-secondary:hover {
                background-color: var(--text-primary);
                transform: translateY(-2px);
            }

            .btn-success {
                background-color: var(--success-color);
                color: white;
            }

            .btn-success:hover {
                background-color: var(--success-hover);
                transform: translateY(-2px);
            }

            .btn-warning {
                background-color: var(--warning-color);
                color: white;
            }

            .btn-warning:hover {
                background-color: var(--warning-hover);
                transform: translateY(-2px);
            }

            .btn-danger {
                background-color: var(--danger-color);
                color: white;
            }

            .btn-danger:hover {
                background-color: var(--danger-hover);
                transform: translateY(-2px);
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: var(--text-secondary);
            }

            .empty-state h3 {
                font-size: 1.5rem;
                margin-bottom: 10px;
            }

            .empty-state p {
                font-size: 1rem;
                margin-bottom: 30px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .header {
                    padding: 15px 20px;
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .container {
                    margin: 20px auto;
                    padding: 0 15px;
                }

                .card-header {
                    padding: 20px;
                    flex-direction: column;
                    gap: 15px;
                    align-items: flex-start;
                }

                .table-container {
                    font-size: 0.8rem;
                }

                tbody td {
                    padding: 12px 8px;
                }

                thead th {
                    padding: 12px 8px;
                }
            }

            /* Additional Enhancements */
            .incident-id {
                font-family: 'Courier New', monospace;
                font-weight: 700;
                color: var(--primary-color);
            }

            .incident-title {
                font-weight: 600;
                color: var(--text-primary);
            }

            .incident-title:hover {
                color: var(--primary-color);
            }

            .timestamp {
                font-size: 0.8rem;
                color: var(--text-secondary);
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <h1>🚨 Incident Management</h1>
            <div class="user-info">
                <div class="user-name">👤 ${user.fullName}</div>
                <div class="user-role">${user.roleName}</div>
            </div>
        </div>

        <!-- Main Container -->
        <div class="container">
            <div class="card">
                <!-- Card Header -->
                <div class="card-header">
                    <div class="card-title">📋 Incident List</div>
                    <div class="card-actions">
                        <a href="${pageContext.request.contextPath}/incident?action=add" class="btn btn-primary">
                            ➕ New Incident
                        </a>
                        <a href="${pageContext.request.contextPath}/incident?action=list" class="btn btn-secondary">
                            🔄 Refresh
                        </a>
                    </div>
                </div>

                <!-- Table Container -->
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Ticket Number</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Priority</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty incidentList}">
                                    <tr>
                                        <td colspan="7">
                                            <div class="empty-state">
                                                <h3>📭 No Incidents Found</h3>
                                                <p>There are no incidents to display at the moment.</p>
                                                <a href="${pageContext.request.contextPath}/incident?action=add" class="btn btn-primary">
                                                    ➕ Create Your First Incident
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="incident" items="${incidentList}">
                                        <tr>
                                            <td>
                                                <span class="incident-id">#${incident.ticketId}</span>
                                            </td>
                                            <td>
                                                <span style="font-family: 'Courier New', monospace; font-weight: 600; color: #6b7280;">
                                                    ${incident.ticketNumber}
                                                </span>
                                            </td>
                                            <td>
                                                <div>
                                                    <div class="incident-title">${incident.title}</div>
                                                    <div class="timestamp">
                                                        Reported by User #${incident.reportedBy}
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${incident.status == 'NEW'}">
                                                        <span class="badge status-new">${incident.status}</span>
                                                    </c:when>
                                                    <c:when test="${incident.status == 'IN_PROGRESS'}">
                                                        <span class="badge status-in-progress">${incident.status}</span>
                                                    </c:when>
                                                    <c:when test="${incident.status == 'RESOLVED'}">
                                                        <span class="badge status-resolved">${incident.status}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge status-cancelled">${incident.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${incident.priority == 'LOW'}">
                                                        <span class="badge priority-low">🟢 Low</span>
                                                    </c:when>
                                                    <c:when test="${incident.priority == 'MEDIUM'}">
                                                        <span class="badge priority-medium">🟡 Medium</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge priority-high">🟠 High</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="timestamp">
                                                    ${incident.createdAt}
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 8px;">
                                                    <a href="${pageContext.request.contextPath}/incident?action=detail&id=${incident.ticketId}" 
                                                       class="btn btn-primary">
                                                        👁️ View
                                                    </a>
                                                    <c:if test="${incident.status != 'RESOLVED' && incident.status != 'CANCELLED'}">
                                                        <a href="${pageContext.request.contextPath}/incident?action=edit&id=${incident.ticketId}" 
                                                           class="btn btn-warning">
                                                            ✏️ Edit
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${incident.status == 'NEW'}">
                                                        <a href="${pageContext.request.contextPath}/incident?action=cancel&id=${incident.ticketId}" 
                                                           class="btn btn-danger">
                                                            ❌ Cancel
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </body>
</html>
