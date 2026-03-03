<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <div class="container-fluid bg-white p-4 rounded shadow-sm mb-4">
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
            <h2 class="h4 text-primary m-0">Configuration Item: ${ci.ciName} (${ci.ciCode})</h2>
            <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to CMDB
            </a>
        </div>

        <div class="mb-4">
            <span class="fs-5 me-2">Status:</span>
            <c:choose>
                <c:when test="${ci.status eq 'ACTIVE'}"><span class="badge bg-success fs-6">ACTIVE</span></c:when>
                <c:when test="${ci.status eq 'INACTIVE'}"><span class="badge bg-secondary fs-6">INACTIVE</span></c:when>
                <c:when test="${ci.status eq 'RETIRED'}"><span class="badge bg-danger fs-6">RETIRED</span></c:when>
                <c:when test="${ci.status eq 'UNDER_MAINTENANCE'}"><span
                        class="badge bg-warning text-dark fs-6">UNDER_MAINTENANCE</span></c:when>
                <c:otherwise><span class="badge bg-primary fs-6">${ci.status}</span></c:otherwise>
            </c:choose>
        </div>

        <div class="row mb-4">
            <div class="col-md-6 border-end">
                <h3 class="h5 text-secondary mb-3"><i class="bi bi-info-circle"></i> General Info</h3>
                <p class="mb-2"><strong>Type ID:</strong> ${ci.ciTypeId}</p>
                <p class="mb-2"><strong>Owner ID:</strong> ${ci.ownerId == null ? '<span
                        class="text-muted fst-italic">Unassigned</span>' : ci.ownerId}</p>
                <p class="mb-2"><strong>Location:</strong> ${ci.location == null ? '<span
                        class="text-muted fst-italic">N/A</span>' : ci.location}</p>
                <p class="mb-2"><strong>Last Updated:</strong> ${ci.updatedAt}</p>
            </div>
            <div class="col-md-6 ps-md-4">
                <h3 class="h5 text-secondary mb-3"><i class="bi bi-pc-display"></i> Technical Details</h3>
                <p class="mb-2"><strong>Manufacturer:</strong> ${ci.manufacturer == null ? '<span
                        class="text-muted fst-italic">N/A</span>' : ci.manufacturer}</p>
                <p class="mb-2"><strong>Model:</strong> ${ci.model == null ? '<span
                        class="text-muted fst-italic">N/A</span>' : ci.model}</p>
                <p class="mb-2"><strong>Serial Num:</strong> <span
                        class="badge bg-light text-dark border">${ci.serialNumber
                        == null ? 'N/A' : ci.serialNumber}</span></p>
                <p class="mb-2"><strong>IP Address:</strong> <a href="#">${ci.ipAddress == null ? '<span
                            class="text-muted fst-italic">N/A</span>' : ci.ipAddress}</a></p>
            </div>
        </div>

        <div class="mb-4">
            <strong>Description:</strong>
            <div class="p-3 bg-light rounded mt-2 border">${ci.description == null ? '<span
                    class="text-muted fst-italic">No
                    description</span>' : ci.description}</div>
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/cmdb?action=edit&id=${ci.ciId}" class="btn btn-warning">
                <i class="bi bi-pencil"></i> Edit Configuration Item
            </a>
        </div>
    </div>

    <div class="container-fluid p-4 rounded shadow-sm border border-warning mb-4" style="background-color: #fffdf5;">
        <h3 class="h5 text-warning mb-3"><i class="bi bi-exclamation-triangle-fill"></i> Impact Analysis (What happens
            if
            this CI fails?)</h3>
        <p class="text-dark">The following configuration items depend on or are hosted by this infrastructure branch. A
            failure here will potentially cause outages for downstream items:</p>

        <c:if test="${not empty impactedCis}">
            <ul class="list-group">
                <c:forEach var="impactCi" items="${impactedCis}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong>${impactCi.ciCode}</strong>: ${impactCi.ciName}
                            <span class="text-muted"><i class="bi bi-hdd-network"></i> IP: ${impactCi.ipAddress}</span>
                        </div>
                        <span class="badge bg-secondary rounded-pill">${impactCi.status}</span>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty impactedCis}">
            <div class="alert alert-success m-0" role="alert">
                <i class="bi bi-check-circle-fill"></i> No downstream dependencies detected. Impact is isolated.
            </div>
        </c:if>
    </div>

    <div class="container-fluid bg-white p-4 rounded shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="h5 m-0 text-secondary"><i class="bi bi-diagram-2"></i> CI Relationship Map</h3>
        </div>

        <c:if test="${not empty relationships}">
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Parent CI ID</th>
                            <th>Relationship Type</th>
                            <th>Child CI ID</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rel" items="${relationships}">
                            <tr>
                                <td>
                                    <c:if test="${rel.parentCiId eq ci.ciId}"><strong class="text-primary">[This CI]
                                            (${rel.parentCiId})</strong></c:if>
                                    <c:if test="${rel.parentCiId ne ci.ciId}">${rel.parentCiId}</c:if>
                                </td>
                                <td class="text-info fw-bold"><i class="bi bi-arrow-right"></i> ${rel.relationshipType}
                                </td>
                                <td>
                                    <c:if test="${rel.childCiId eq ci.ciId}"><strong class="text-primary">[This CI]
                                            (${rel.childCiId})</strong></c:if>
                                    <c:if test="${rel.childCiId ne ci.ciId}">${rel.childCiId}</c:if>
                                </td>
                                <td class="text-muted">${rel.description}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty relationships}">
            <div class="alert alert-secondary m-0" role="alert">
                <i class="bi bi-info-circle"></i> This CI has no recorded relationships with other infrastructure
                components.
            </div>
        </c:if>
    </div>

    <jsp:include page="/includes/footer.jsp" />