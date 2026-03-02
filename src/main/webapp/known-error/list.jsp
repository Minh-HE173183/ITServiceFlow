<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>Known Errors</title>
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

                .status-PENDING {
                    background-color: #ffc107;
                    color: #212529;
                }

                .status-APPROVED {
                    background-color: #28a745;
                }

                .status-REJECTED {
                    background-color: #dc3545;
                }

                .status-INACTIVE {
                    background-color: #6c757d;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header-action">
                    <h2>Known Error Database (KEDB)</h2>
                    <a href="${pageContext.request.contextPath}/known-error?action=add" class="btn">Create Known
                        Error</a>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Article Number</th>
                            <th>Title</th>
                            <th>Status</th>
                            <th>Author ID</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="error" items="${knownErrors}">
                            <tr>
                                <td>${error.articleId}</td>
                                <td>${error.articleNumber}</td>
                                <td>${error.title}</td>
                                <td><span class="status-badge status-${error.status}">${error.status}</span></td>
                                <td>${error.authorId}</td>
                                <td class="action-btns">
                                    <a href="${pageContext.request.contextPath}/known-error?action=detail&id=${error.articleId}"
                                        class="btn btn-info">View</a>

                                    <c:if test="${error.status eq 'PENDING' || error.status eq 'REJECTED'}">
                                        <form action="${pageContext.request.contextPath}/known-error?action=delete"
                                            method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${error.articleId}">
                                            <button type="submit" class="btn btn-danger"
                                                onclick="return confirm('Are you sure you want to delete this known error?');">Delete</button>
                                        </form>
                                    </c:if>

                                    <c:if test="${error.status eq 'APPROVED' || error.status eq 'INACTIVE'}">
                                        <form
                                            action="${pageContext.request.contextPath}/known-error?action=toggleStatus"
                                            method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${error.articleId}">
                                            <input type="hidden" name="currentStatus" value="${error.status}">
                                            <button type="submit"
                                                class="btn ${error.status eq 'APPROVED' ? 'btn-warning' : 'btn-info'}">
                                                ${error.status eq 'APPROVED' ? 'Disable' : 'Enable'}
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty knownErrors}">
                            <tr>
                                <td colspan="6" style="text-align: center;">No Known Errors found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </body>

        </html>
