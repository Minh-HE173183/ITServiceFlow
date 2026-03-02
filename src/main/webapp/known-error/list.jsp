<jsp:include page="/includes/header.jsp" />

<div class="container-fluid bg-white p-4 rounded shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h4 text-primary m-0">Known Error Database (KEDB)</h2>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-warning" onclick="submitBulkAction('bulkReview', 'APPROVED')">
                <i class="bi bi-check-circle"></i> Bulk Approve
            </button>
            <button type="button" class="btn btn-danger" onclick="submitBulkAction('bulkDelete')">
                <i class="bi bi-trash"></i> Bulk Delete
            </button>
            <button type="button" class="btn btn-secondary" onclick="submitBulkAction('bulkToggleStatus', 'INACTIVE')">
                <i class="bi bi-pause-circle"></i> Bulk Disable
            </button>
            <button type="button" class="btn btn-success" onclick="submitBulkAction('bulkToggleStatus', 'APPROVED')">
                <i class="bi bi-play-circle"></i> Bulk Enable
            </button>
            <a href="${pageContext.request.contextPath}/known-error?action=add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Create Known Error
            </a>
        </div>
    </div>

    <form id="bulkForm" action="${pageContext.request.contextPath}/known-error" method="post">
        <input type="hidden" name="action" id="bulkActionType" value="">
        <input type="hidden" name="status" id="bulkStatus" value="">
        <input type="hidden" name="toggleTo" id="bulkToggleTo" value="">

        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle mt-3">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40px;"><input type="checkbox" id="selectAll" class="form-check-input"
                                onclick="toggleAll(this)"></th>
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
                            <td>
                                <input type="checkbox" name="selectedIds" value="${error.articleId}"
                                    class="rowCheckbox form-check-input">
                            </td>
                            <td>${error.articleId}</td>
                            <td>${error.articleNumber}</td>
                            <td>${error.title}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${error.status eq 'APPROVED'}"><span
                                            class="badge bg-success">APPROVED</span></c:when>
                                    <c:when test="${error.status eq 'PENDING'}"><span
                                            class="badge bg-warning text-dark">PENDING</span></c:when>
                                    <c:when test="${error.status eq 'REJECTED'}"><span
                                            class="badge bg-danger">REJECTED</span></c:when>
                                    <c:when test="${error.status eq 'INACTIVE'}"><span
                                            class="badge bg-secondary">INACTIVE</span></c:when>
                                    <c:otherwise><span class="badge bg-primary">${error.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${error.authorId}</td>
                            <td class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/known-error?action=detail&id=${error.articleId}"
                                    class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-eye"></i> View
                                </a>

                                <c:if test="${error.status eq 'PENDING' || error.status eq 'REJECTED'}">
                                    <form action="${pageContext.request.contextPath}/known-error?action=delete"
                                        method="post" class="m-0">
                                        <input type="hidden" name="id" value="${error.articleId}">
                                        <button type="submit" class="btn btn-danger btn-sm"
                                            onclick="return confirm('Are you sure you want to delete this known error?');">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${error.status eq 'APPROVED' || error.status eq 'INACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/known-error?action=toggleStatus"
                                        method="post" class="m-0">
                                        <input type="hidden" name="id" value="${error.articleId}">
                                        <input type="hidden" name="currentStatus" value="${error.status}">
                                        <button type="submit"
                                            class="btn ${error.status eq 'APPROVED' ? 'btn-secondary' : 'btn-success'} btn-sm">
                                            <i
                                                class="bi ${error.status eq 'APPROVED' ? 'bi-pause-circle' : 'bi-play-circle'}"></i>
                                            ${error.status eq 'APPROVED' ? 'Disable' : 'Enable'}
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty knownErrors}">
                        <c:if test="${empty knownErrors}">
                            <tr>
                                <td colspan="7" class="text-center text-muted fst-italic py-4">No Known Errors found.
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

            if (actionType === 'bulkReview') {
                document.getElementById('bulkStatus').value = extraParam;
            } else if (actionType === 'bulkToggleStatus') {
                document.getElementById('bulkToggleTo').value = extraParam;
            }

            document.getElementById('bulkForm').submit();
        }
    }
</script>

<jsp:include page="/includes/footer.jsp" />