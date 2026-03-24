<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid bg-white p-4 rounded shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h4 text-primary m-0">Configuration Management Database (CMDB)</h2>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-danger" onclick="submitBulkAction('bulkDelete')">
                <i class="bi bi-trash"></i> Bulk Delete
            </button>
            <button type="button" class="btn btn-warning" onclick="submitBulkAction('bulkToggleStatus', 'INACTIVE')">
                <i class="bi bi-pause-circle"></i> Bulk Disable
            </button>
            <button type="button" class="btn btn-success" onclick="submitBulkAction('bulkToggleStatus', 'ACTIVE')">
                <i class="bi bi-play-circle"></i> Bulk Enable
            </button>
            <a href="${pageContext.request.contextPath}/cmdb?action=add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Register New CI
            </a>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/cmdb" method="get"
          class="bg-light p-3 rounded mb-4 border d-flex gap-3 align-items-center">
        <input type="hidden" name="action" value="list">

        <div class="flex-grow-1">
            <input type="text" class="form-control" name="keyword" placeholder="Search by name or code..."
                   value="${keyword}">
        </div>

        <div style="width: 250px;">
            <select class="form-select" name="status">
                <option value="ALL" ${statusFilter=='ALL' ? 'selected' : '' }>All Statuses</option>
                <option value="ACTIVE" ${statusFilter=='ACTIVE' ? 'selected' : '' }>Active</option>
                <option value="INACTIVE" ${statusFilter=='INACTIVE' ? 'selected' : '' }>Inactive</option>
                <option value="RETIRED" ${statusFilter=='RETIRED' ? 'selected' : '' }>Retired</option>
                <option value="UNDER_MAINTENANCE" ${statusFilter=='UNDER_MAINTENANCE' ? 'selected' : '' }>Under
                    Maintenance</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Search</button>
        <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn btn-outline-secondary">Clear</a>
    </form>

    <form id="bulkForm" action="${pageContext.request.contextPath}/cmdb" method="post">
        <input type="hidden" name="action" id="bulkActionType" value="">
        <input type="hidden" name="toggleTo" id="bulkToggleTo" value="">

        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle mt-3">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40px;"><input type="checkbox" id="selectAll" class="form-check-input"
                                                        onclick="toggleAll(this)"></th>
                        <th>CI Code</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>IP Address</th>
                        <th>Status</th>
                        <th>Owner</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ci" items="${configurationItems}">
                        <tr>
                            <td>
                                <input type="checkbox" name="selectedIds" value="${ci.ciId}"
                                       class="rowCheckbox form-check-input">
                            </td>
                            <td><strong>${ci.ciCode}</strong></td>
                            <td>${ci.ciName}</td>
                            <td>${ci.ciTypeName}</td>
                            <td>${ci.ipAddress == null ? '<span class="text-muted fst-italic">N/A</span>' :
                                  ci.ipAddress}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ci.status eq 'ACTIVE'}"><span class="badge bg-success">ACTIVE</span>
                                    </c:when>
                                    <c:when test="${ci.status eq 'INACTIVE'}"><span
                                            class="badge bg-secondary">INACTIVE</span></c:when>
                                    <c:when test="${ci.status eq 'RETIRED'}"><span
                                            class="badge bg-danger">RETIRED</span></c:when>
                                    <c:when test="${ci.status eq 'UNDER_MAINTENANCE'}"><span
                                            class="badge bg-warning text-dark">UNDER_MAINTENANCE</span></c:when>
                                    <c:otherwise><span class="badge bg-primary">${ci.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${ci.ownerName == null ? '<span class="text-muted fst-italic">Unassigned</span>' :
                                  ci.ownerName}</td>
                            <td class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/cmdb?action=detail&id=${ci.ciId}"
                                   class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-diagram-3"></i> View
                                </a>

                                <c:if test="${ci.status eq 'INACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/cmdb?action=delete" method="post"
                                          class="m-0">
                                        <input type="hidden" name="id" value="${ci.ciId}">
                                        <button type="submit" class="btn btn-danger btn-sm"
                                                onclick="return confirm('Are you sure you want to permanently delete this CI? It must not have linked tickets/relations.');">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
                                </c:if>

                                <!-- For simulation purposes, only allowing toggle between ACTIVE and INACTIVE to match DAO -->
                                <c:if test="${ci.status eq 'ACTIVE' || ci.status eq 'INACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/cmdb?action=toggleStatus"
                                          method="post" class="m-0">
                                        <input type="hidden" name="id" value="${ci.ciId}">
                                        <input type="hidden" name="currentStatus" value="${ci.status}">
                                        <button type="submit"
                                                class="btn ${ci.status eq 'ACTIVE' ? 'btn-secondary' : 'btn-success'} btn-sm">
                                            <i
                                                class="bi ${ci.status eq 'ACTIVE' ? 'bi-pause-circle' : 'bi-play-circle'}"></i>
                                            ${ci.status eq 'ACTIVE' ? 'Disable' : 'Enable'}
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty configurationItems}">
                        <tr>
                            <td colspan="7" class="text-center text-muted fst-italic py-4">No Configuration Items found.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
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

<jsp:include page="/includes/footer.jsp" />