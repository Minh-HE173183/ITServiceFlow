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
                    align-items: flex-start;
                    flex-direction: column;
                    gap: 10px;
                    margin-bottom: 20px;
                }

                .header-top {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    width: 100%;
                }

                .search-bar {
                    display: flex;
                    gap: 10px;
                    background: #eef2f5;
                    padding: 15px;
                    border-radius: 8px;
                    width: 100%;
                    box-sizing: border-box;
                    align-items: center;
                }

                .search-bar input[type="text"],
                .search-bar select {
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                }

                .btn-search {
                    background-color: #007bff;
                    color: white;
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
                    <div class="header-top">
                        <h2>Configuration Management Database (CMDB)</h2>
                        <div>
                            <button type="button" class="btn btn-danger" onclick="submitBulkAction('bulkDelete')"
                                style="margin-right: 5px;">Bulk Delete</button>
                            <button type="button" class="btn btn-warning"
                                onclick="submitBulkAction('bulkToggleStatus', 'INACTIVE')"
                                style="margin-right: 5px;">Bulk Disable</button>
                            <button type="button" class="btn btn-info"
                                onclick="submitBulkAction('bulkToggleStatus', 'ACTIVE')"
                                style="margin-right: 10px;">Bulk Enable</button>
                            <a href="${pageContext.request.contextPath}/cmdb?action=add" class="btn">Register New CI</a>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/cmdb" method="get" class="search-bar">
                        <input type="hidden" name="action" value="list">
                        <input type="text" name="keyword" placeholder="Search by name or code..." value="${keyword}"
                            style="flex: 1;">
                        <select name="status">
                            <option value="ALL" ${statusFilter=='ALL' ? 'selected' : '' }>All Statuses</option>
                            <option value="ACTIVE" ${statusFilter=='ACTIVE' ? 'selected' : '' }>Active</option>
                            <option value="INACTIVE" ${statusFilter=='INACTIVE' ? 'selected' : '' }>Inactive</option>
                            <option value="RETIRED" ${statusFilter=='RETIRED' ? 'selected' : '' }>Retired</option>
                            <option value="UNDER_MAINTENANCE" ${statusFilter=='UNDER_MAINTENANCE' ? 'selected' : '' }>
                                Under Maintenance</option>
                        </select>
                        <button type="submit" class="btn btn-search">Search</button>
                        <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn"
                            style="background-color: #6c757d;">Clear</a>
                    </form>
                </div>

                <form id="bulkForm" action="${pageContext.request.contextPath}/cmdb" method="post">
                    <input type="hidden" name="action" id="bulkActionType" value="">
                    <input type="hidden" name="toggleTo" id="bulkToggleTo" value="">
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
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
                                    <td>
                                        <input type="checkbox" name="selectedIds" value="${ci.ciId}"
                                            class="rowCheckbox">
                                    </td>
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
                                    <td colspan="7" style="text-align: center;">No Configuration Items found.</td>
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

                function submitBulkAction(actionType, extraParam) {
                    var checkboxes = document.querySelectorAll('.rowCheckbox:checked');
                    if (checkboxes.length === 0) {
                        alert('Please select at least one item.');
                        return;
                    }
                    if (confirm('Are you sure you want to perform this action on the selected items? \nWarning: Ensure the selected items are in the valid state for this action.')) {
                        document.getElementById('bulkActionType').value = actionType;

                        if (actionType === 'bulkToggleStatus') {
                            document.getElementById('bulkToggleTo').value = extraParam;
                        }

                        document.getElementById('bulkForm').submit();
                    }
                }
            </script>
        </body>

        </html>