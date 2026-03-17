<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <div class="container-fluid bg-white p-5 rounded shadow-sm mb-4">
        <!-- Document Header -->
        <div class="d-flex justify-content-between align-items-start mb-4 border-bottom pb-4">
            <div>
                <div class="d-flex align-items-center gap-3 mb-2">
                    <h2 class="h3 fw-bold text-dark m-0">${article.title}</h2>
                </div>
                <div class="text-muted small">
                    <span class="me-3"><i class="bi bi-file-earmark-text"></i> ${article.articleNumber}</span>
                    <span class="me-3"><i class="bi bi-person"></i> Author ID: ${article.authorId}</span>
                    <span><i class="bi bi-clock"></i> Last Updated: ${article.updatedAt}</span>
                </div>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/knowledge-base?action=list"
                    class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i> Back to Knowledge Base
                </a>
            </div>
        </div>

        <!-- Summary -->
        <div class="mb-5 lead text-secondary border-start border-4 border-primary ps-3" style="font-size: 1.1rem;">
            ${article.summary}
        </div>

        <!-- Body Section -->
        <h4 class="h5 fw-bold text-primary mb-3 border-bottom pb-2">Technical Details</h4>

        <div class="row g-4 mb-5">
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm bg-light">
                    <div class="card-body">
                        <h5 class="card-title h6 fw-bold text-dark"><i class="bi bi-bug text-danger"></i> Symptom</h5>
                        <p class="card-text text-secondary mt-3" style="white-space: pre-wrap;">${article.symptom}
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm bg-light">
                    <div class="card-body">
                        <h5 class="card-title h6 fw-bold text-dark"><i class="bi bi-search text-warning"></i> Root Cause
                        </h5>
                        <p class="card-text text-secondary mt-3" style="white-space: pre-wrap;">${article.cause}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm bg-light mb-5 border-start border-success border-4">
            <div class="card-body p-4">
                <h5 class="card-title h6 fw-bold text-success mb-3"><i class="bi bi-check-circle-fill"></i> Workaround &
                    Solution</h5>
                <p class="card-text text-dark" style="white-space: pre-wrap; font-size: 1.05rem;">${article.solution}
                </p>
            </div>
        </div>

        <c:if test="${not empty article.content}">
            <h4 class="h5 fw-bold text-primary mb-3 border-bottom pb-2">Detailed Content / References</h4>
            <div class="p-4 bg-light rounded" style="white-space: pre-wrap;">
                ${article.content}
            </div>
        </c:if>
    </div>

    <jsp:include page="/includes/footer.jsp" />