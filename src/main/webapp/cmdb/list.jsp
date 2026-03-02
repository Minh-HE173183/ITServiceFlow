<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>Configuration Items - CMDB</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f7f6;
                    padding: 20px;
                }

                .container {
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                h2 {
                    color: #333;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }

                th {
                    background-color: #007bff;
                    color: white;
                }

                tr:hover {
                    background-color: #f1f1f1;
                }

                .btn {
                    padding: 8px 12px;
                    background-color: #28a745;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                    display: inline-block;
                    border: none;
                    cursor: pointer;
                }

                .btn-danger {
                    background-color: #dc3545;
                }

                .btn-info {
                    background-color: #17a2b8;
                }

                .btn-warning {
                    background-color: #ffc107;
                    color: #212529;
                }

                .action-btns {
                    display: flex;
                    gap: 5px;
                }

                .header-action {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .status-badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: bold;
                    color: white;
                }

                .status-ACTIVE {
                    background-color: #28a745;
                }

                .status-INACTIVE {
                    background-color: #6c757d;
                }

                .status-RETIRED {
                    background-color: #dc3545;
                }

                .status-UNDER_MAINTENANCE {
                    background-color: #ffc107;
                    color: #212529;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header-action">
                    <h2>Configuration Management Database (CMDB)</h2>
                    <a href="${pageContext.request.contextPath}/cmdb?action=add" class="btn">Register New CI</a>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>CI Code</th>
                            <th>Name</th>
                            <th>IP Address</th>
                            <th>Status</th>
                            <th>Owner ID</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ci" items="${configurationItems}">
                            <tr>
                                <td>${ci.ciCode}</td>
                                <td>${ci.ciName}</td>
                                <td>${ci.ipAddress == null ? 'N/A' : ci.ipAddress}</td>
                                <td><span class="status-badge status-${ci.status}">${ci.status}</span></td>
                                <td>${ci.ownerId == null ? 'Unassigned' : ci.ownerId}</td>
                                <td class="action-btns">
                                    <a href="${pageContext.request.contextPath}/cmdb?action=detail&id=${ci.ciId}"
                                        class="btn btn-info">View & relationships</a>

                                    <c:if test="${ci.status eq 'INACTIVE'}">
                                        <form action="${pageContext.request.contextPath}/cmdb?action=delete"
                                            method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${ci.ciId}">
                                            <button type="submit" class="btn btn-danger"
                                                onclick="return confirm('Are you sure you want to permanently delete this CI? It must not have linked tickets/relations.');">Delete</button>
                                        </form>
                                    </c:if>

                                    <!-- For simulation purposes, only allowing toggle between ACTIVE and INACTIVE to match DAO -->
                                    <c:if test="${ci.status eq 'ACTIVE' || ci.status eq 'INACTIVE'}">
                                        <form action="${pageContext.request.contextPath}/cmdb?action=toggleStatus"
                                            method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${ci.ciId}">
                                            <input type="hidden" name="currentStatus" value="${ci.status}">
                                            <button type="submit"
                                                class="btn ${ci.status eq 'ACTIVE' ? 'btn-danger' : 'btn-success'}">
                                                ${ci.status eq 'ACTIVE' ? 'Disable' : 'Enable'}
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty configurationItems}">
                            <tr>
                                <td colspan="6" style="text-align: center;">No Configuration Items found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </body>

        </html>
