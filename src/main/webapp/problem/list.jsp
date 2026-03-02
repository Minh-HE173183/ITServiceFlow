<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>Problem Tickets</title>
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
                }

                .btn-danger {
                    background-color: #dc3545;
                }

                .btn-info {
                    background-color: #17a2b8;
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
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header-action">
                    <h2>Problem Tickets List</h2>
                    <div>
                        <button type="button" class="btn btn-danger" onclick="submitBulkAction('bulkDelete')"
                            style="margin-right: 10px;">Delete Selected</button>
                        <a href="${pageContext.request.contextPath}/problem?action=add" class="btn">Create Problem
                            Ticket</a>
                    </div>
                </div>

                <form id="bulkForm" action="${pageContext.request.contextPath}/problem" method="post">
                    <input type="hidden" name="action" id="bulkActionType" value="bulkDelete">
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                                <th>ID</th>
                                <th>Ticket Number</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="problem" items="${problems}">
                                <tr>
                                    <td>
                                        <c:if test="${problem.status eq 'NEW' && problem.assignedTo == null}">
                                            <input type="checkbox" name="selectedIds" value="${problem.ticketId}"
                                                class="rowCheckbox">
                                        </c:if>
                                    </td>
                                    <td>${problem.ticketId}</td>
                                    <td>${problem.ticketNumber}</td>
                                    <td>${problem.title}</td>
                                    <td>${problem.status}</td>
                                    <td>${problem.createdAt}</td>
                                    <td class="action-btns">
                                        <a href="${pageContext.request.contextPath}/problem?action=detail&id=${problem.ticketId}"
                                            class="btn btn-info">View</a>
                                        <c:if test="${problem.status eq 'NEW' && problem.assignedTo == null}">
                                            <form action="${pageContext.request.contextPath}/problem?action=delete"
                                                method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${problem.ticketId}">
                                                <button type="submit" class="btn btn-danger"
                                                    onclick="return confirm('Are you sure you want to delete this problem ticket?');">Delete</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty problems}">
                                <tr>
                                    <td colspan="7" style="text-align: center;">No Problem Tickets found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </form>
            </div>

            <script>
                function toggleAll(source) {
                    checkboxes = document.getElementsByClassName('rowCheckbox');
                    for (var i = 0, n = checkboxes.length; i < n; i++) {
                        checkboxes[i].checked = source.checked;
                    }
                }

                function submitBulkAction(actionType) {
                    var checkboxes = document.querySelectorAll('.rowCheckbox:checked');
                    if (checkboxes.length === 0) {
                        alert('Please select at least one item.');
                        return;
                    }
                    if (confirm('Are you sure you want to perform this action on the selected items?')) {
                        document.getElementById('bulkActionType').value = actionType;
                        document.getElementById('bulkForm').submit();
                    }
                }
            </script>
        </body>

        </html>