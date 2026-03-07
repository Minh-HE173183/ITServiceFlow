<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <div class="container-fluid bg-white p-4 rounded shadow-sm mb-4">
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
            <h2 class="h4 text-primary m-0">Known Error Detail: ${knownError.articleNumber}</h2>
            <a href="${pageContext.request.contextPath}/known-error?action=list" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to List
            </a>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <p class="mb-2"><strong>Status:</strong>
                    <c:choose>
                        <c:when test="${knownError.status eq 'APPROVED'}"><span class="badge bg-success">APPROVED</span>
                        </c:when>
                        <c:when test="${knownError.status eq 'PENDING'}"><span
                                class="badge bg-warning text-dark">PENDING</span></c:when>
                        <c:when test="${knownError.status eq 'REJECTED'}"><span class="badge bg-danger">REJECTED</span>
                        </c:when>
                        <c:when test="${knownError.status eq 'INACTIVE'}"><span
                                class="badge bg-secondary">INACTIVE</span>
                        </c:when>
                        <c:otherwise><span class="badge bg-primary">${knownError.status}</span></c:otherwise>
                    </c:choose>
                </p>
                <p class="mb-2"><strong>Author ID:</strong> ${knownError.authorId}</p>
            </div>
        </div>
        <div class="col-md-6">
            <p class="mb-2"><strong>Last Updated:</strong> ${knownError.updatedAt}</p>
        </div>
    </div>

    <c:if test="${knownError.status eq 'REJECTED'}">
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2"></i>
            <strong>This Article has been REJECTED.</strong> Please edit to resolve issues.
        </div>
    </c:if>

    <div class="mb-3">
        <strong>Title:</strong>
        <div class="p-3 bg-light border rounded mt-1">${knownError.title}</div>
    </div>
    <div class="mb-4">
        <strong>Summary:</strong>
        <div class="p-3 bg-light border rounded mt-1">${knownError.summary}</div>
    </div>

    <hr>
    <h3 class="h5 mt-4 mb-3 text-secondary">Technical Details</h3>
    <div class="row mb-3">
        <div class="col-md-6">
            <strong>Symptom:</strong>
            <div class="p-3 bg-white border rounded mt-2 text-dark" style="white-space: pre-wrap;">${knownError.symptom}
            </div>
        </div>
        <div class="col-md-6">
            <strong>Root Cause:</strong>
            <div class="p-3 bg-white border rounded mt-2 text-danger" style="white-space: pre-wrap;">${knownError.cause}
            </div>
        </div>
    </div>

    <div class="mb-3">
        <strong>Workaround & Solution:</strong>
        <div class="p-3 bg-white border rounded mt-2 text-success" style="white-space: pre-wrap;">${knownError.solution}
        </div>
    </div>

    <c:if test="${not empty knownError.content}">
        <div class="mb-4">
            <strong>Detailed Content / References:</strong>
            <div class="p-3 bg-light border rounded mt-2" style="white-space: pre-wrap;">${knownError.content}</div>
        </div>
    </c:if>

    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/known-error?action=edit&id=${knownError.articleId}"
            class="btn btn-warning">
            <i class="bi bi-pencil"></i> Edit Article
        </a>
    </div>

    <c:if test="${knownError.status eq 'PENDING'}">
        <div class="container-fluid bg-white p-4 rounded shadow-sm border border-warning">
            <h3 class="h5 text-warning mb-3"><i class="bi bi-shield-check"></i> Admin Review Panel</h3>
            <p class="text-muted">Please review the details above to approve or reject this article to make it
                available
                for Support Agents.</p>

            <form action="${pageContext.request.contextPath}/known-error?action=review" method="post">
                <input type="hidden" name="id" value="${knownError.articleId}">

                <div class="mb-3">
                    <label class="form-label fw-bold">Rejection Reason (Optional):</label>
                    <textarea class="form-control" name="rejectionReason" rows="3"
                        placeholder="If rejecting, please state the reason..."></textarea>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" name="status" value="APPROVED" class="btn btn-success">
                        <i class="bi bi-check-circle"></i> Approve Article
                    </button>
                    <button type="submit" name="status" value="REJECTED" class="btn btn-danger">
                        <i class="bi bi-x-circle"></i> Reject Article
                    </button>
                </div>
            </form>
        </div>
    </c:if>

    <jsp:include page="/includes/footer.jsp" />