<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <div class="container-fluid bg-white p-4 rounded shadow-sm mb-4">
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
            <h2 class="h4 text-primary m-0">Problem Detail: ${problem.ticketNumber}</h2>
            <a href="${pageContext.request.contextPath}/problem?action=list" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to List
            </a>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <p class="mb-2"><strong>Title:</strong> ${problem.title}</p>
                <p class="mb-2"><strong>Status:</strong> <span class="badge bg-info">${problem.status}</span></p>
            </div>
            <div class="col-md-6">
                <p class="mb-2"><strong>Reported By:</strong> ${not empty problem.reportedByName ?
                    problem.reportedByName : 'User ID '.concat(problem.reportedBy)}</p>
                <p class="mb-2"><strong>Assigned To:</strong> ${problem.assignedTo == null ? 'Unassigned' : (not empty
                    problem.assignedToName ? problem.assignedToName : 'User ID '.concat(problem.assignedTo))}</p>
            </div>
        </div>

        <div class="mb-4">
            <strong>Description:</strong>
            <div class="p-3 bg-light rounded mt-2 border">${problem.description}</div>
        </div>

        <hr>
        <h3 class="h5 mt-4 mb-3 text-secondary">Root Cause Analysis (RCA)</h3>
        <div class="row">
            <div class="col-md-6">
                <strong>Root Cause:</strong>
                <div class="p-3 bg-white border rounded mt-2 text-danger">
                    ${problem.cause == null ? '<i>Not identified yet</i>' : problem.cause}
                </div>
            </div>
            <div class="col-md-6">
                <strong>Workaround/Solution:</strong>
                <div class="p-3 bg-white border rounded mt-2 text-success">
                    ${problem.solution == null ? '<i>No solution provided</i>' : problem.solution}
                </div>
            </div>
        </div>

        <div class="d-flex gap-2 mt-4">
            <a href="${pageContext.request.contextPath}/problem?action=edit&id=${problem.ticketId}"
                class="btn btn-warning">
                <i class="bi bi-pencil"></i> Edit/Update RCA
            </a>

            <c:if test="${problem.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/problem?action=cancel" method="post"
                    onsubmit="return confirm('Cancel this Problem investigation?');">
                    <input type="hidden" name="id" value="${problem.ticketId}">
                    <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle"></i> Cancel Ticket</button>
                </form>
            </c:if>

            <c:if test="${problem.assignedTo == null && problem.status ne 'CANCELLED'}">
                <form action="${pageContext.request.contextPath}/problem?action=assign" method="post" class="d-inline">
                    <input type="hidden" name="id" value="${problem.ticketId}">
                    <input type="hidden" name="assignedTo" value="1">
                    <button type="submit" class="btn btn-outline-primary"><i class="bi bi-person-check"></i> Assign to
                        Me</button>
                </form>
            </c:if>
        </div>
    </div>

    <div class="container-fluid bg-white p-4 rounded shadow-sm mb-4">
        <h3 class="h5 mb-3 text-secondary">Linked Incidents</h3>
        <c:if test="${not empty linkedIncidents}">
            <ul class="list-group">
                <c:forEach var="inc" items="${linkedIncidents}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span><strong>${inc.ticketNumber}</strong> - ${inc.title}</span>
                        <span class="badge bg-secondary rounded-pill">${inc.status}</span>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty linkedIncidents}">
            <p class="text-muted fst-italic">No incidents linked to this problem.</p>
        </c:if>
    </div>

    <div class="container-fluid bg-white p-4 rounded shadow-sm">
        <h3 class="h5 mb-3 text-secondary">Investigation Comments</h3>

        <c:if test="${not empty comments}">
            <div class="mb-4">
                <c:forEach var="cmt" items="${comments}">
                    <div class="card mb-2 border-0 bg-light">
                        <div class="card-body py-2 px-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <strong><i class="bi bi-person-circle"></i> User ID ${cmt.userId}</strong>
                                <small class="text-muted">
                                    <fmt:formatDate value="${cmt.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </small>
                            </div>
                            <p class="mb-0 text-dark" style="white-space: pre-wrap;">${cmt.commentText}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/problem?action=addComment" method="post">
            <input type="hidden" name="id" value="${problem.ticketId}">
            <div class="mb-3">
                <textarea class="form-control" name="commentText" rows="4"
                    placeholder="Add a new finding, note, or update..." required></textarea>
            </div>
            <button type="submit" class="btn btn-primary"><i class="bi bi-chat-text"></i> Post Comment</button>
        </form>
    </div>

    <jsp:include page="/includes/footer.jsp" />