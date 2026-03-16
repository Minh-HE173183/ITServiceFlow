<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <div class="container-fluid bg-white p-4 rounded shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h4 text-primary m-0"><i class="bi bi-book"></i> Knowledge Base</h2>
        </div>

        <form action="${pageContext.request.contextPath}/known-error" method="get"
            class="row g-3 mb-4 bg-light p-3 rounded border mx-0">
            <input type="hidden" name="action" value="list">
            <div class="col-md-9">
                <input type="text" name="searchQuery" class="form-control"
                    placeholder="Search knowledge base articles..." value="${searchQuery}">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Search</button>
                <a href="${pageContext.request.contextPath}/knowledge-base?action=list"
                    class="btn btn-outline-secondary"><i class="bi bi-x-circle"></i> Clear</a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle mt-3">
                <thead class="table-light">
                    <tr>
                        <th>Article Number</th>
                        <th>Title</th>
                        <th style="width: 120px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="article" items="${articles}">
                        <tr>
                            <td class="fw-bold text-primary">${article.articleNumber}</td>
                            <td>${article.title}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/knowledge-base?action=view&id=${article.articleId}"
                                    class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                    Read <i class="bi bi-arrow-right"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty articles}">
                        <tr>
                            <td colspan="3" class="text-center text-muted fst-italic py-4">No articles found in the
                                knowledge base.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-3">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                                href="?action=list&searchQuery=${searchQuery}&statusFilter=${statusFilter}&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link"
                                    href="?action=list&searchQuery=${searchQuery}&statusFilter=${statusFilter}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                                href="?action=list&searchQuery=${searchQuery}&statusFilter=${statusFilter}&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />