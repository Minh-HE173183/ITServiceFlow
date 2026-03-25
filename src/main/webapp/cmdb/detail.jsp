<jsp:include page="/includes/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<script type="text/javascript" src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
<style type="text/css">
    #relationshipMap {
        width: 100%;
        height: 400px;
        border: 1px solid lightgray;
        border-radius: 5px;
        background-color: #f8f9fa;
    }
</style>

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
                <p class="mb-2"><strong>Type:</strong> ${ci.ciTypeName}</p>
                <p class="mb-2"><strong>Owner:</strong> ${ci.ownerName == null ? '<span
                        class="text-muted fst-italic">Unassigned</span>' : ci.ownerName}</p>
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
            <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addRelationModal">
                <i class="bi bi-link-45deg"></i> Connect CI
            </button>
        </div>

        <c:if test="${not empty relationships}">
            <!-- Visual Map Container -->
            <div id="relationshipMap" class="mb-4"></div>
            
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Parent CI</th>
                            <th>Relationship Type</th>
                            <th>Child CI</th>
                            <th>Description</th>
                            <th class="text-center" style="width: 100px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rel" items="${relationships}">
                            <tr>
                                <td>
                                    <c:if test="${rel.parentCiId eq ci.ciId}"><strong class="text-primary">[This CI]
                                            (${rel.parentCiCode})</strong></c:if>
                                    <c:if test="${rel.parentCiId ne ci.ciId}"><a href="${pageContext.request.contextPath}/cmdb?action=detail&id=${rel.parentCiId}">${rel.parentCiName} (${rel.parentCiCode})</a></c:if>
                                </td>
                                <td class="text-info fw-bold"><i class="bi bi-arrow-right"></i> ${rel.relationshipType}
                                </td>
                                <td>
                                    <c:if test="${rel.childCiId eq ci.ciId}"><strong class="text-primary">[This CI]
                                            (${rel.childCiCode})</strong></c:if>
                                    <c:if test="${rel.childCiId ne ci.ciId}"><a href="${pageContext.request.contextPath}/cmdb?action=detail&id=${rel.childCiId}">${rel.childCiName} (${rel.childCiCode})</a></c:if>
                                </td>
                                <td class="text-muted">${rel.description}</td>
                                <td class="text-center">
                                    <form action="${pageContext.request.contextPath}/cmdb" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to remove this relationship?');">
                                        <input type="hidden" name="action" value="deleteRelationship">
                                        <input type="hidden" name="relationshipId" value="${rel.relationshipId}">
                                        <input type="hidden" name="ciId" value="${ci.ciId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Remove Connection">
                                            <i class="bi bi-x-circle"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    var nodeSet = {};
                    nodeSet[${ci.ciId}] = { 
                        id: ${ci.ciId}, 
                        label: '${ci.ciName}\\n(${ci.ciCode})', 
                        shape: 'box', 
                        color: { background: '#0d6efd', border: '#0a58ca' }, 
                        font: {color: 'white'} 
                    };
                    
                    <c:forEach var="rel" items="${relationships}">
                        nodeSet[${rel.parentCiId}] = nodeSet[${rel.parentCiId}] || { 
                            id: ${rel.parentCiId}, 
                            label: '${rel.parentCiName}\\n(${rel.parentCiCode})', 
                            shape: 'box',
                            color: { background: '#ffffff', border: '#6c757d' }
                        };
                        nodeSet[${rel.childCiId}] = nodeSet[${rel.childCiId}] || { 
                            id: ${rel.childCiId}, 
                            label: '${rel.childCiName}\\n(${rel.childCiCode})', 
                            shape: 'box',
                            color: { background: '#ffffff', border: '#6c757d' }
                        };
                    </c:forEach>
                    
                    var nodesArray = [];
                    for (var key in nodeSet) {
                        nodesArray.push(nodeSet[key]);
                    }
                    var nodes = new vis.DataSet(nodesArray);

                    var edges = new vis.DataSet([
                        <c:forEach var="rel" items="${relationships}" varStatus="status">
                            { 
                                from: ${rel.parentCiId}, 
                                to: ${rel.childCiId}, 
                                label: '${rel.relationshipType}', 
                                font: {align: 'horizontal', size: 12, color: '#0dcaf0'}, 
                                arrows: 'to' 
                            }${not status.last ? ',' : ''}
                        </c:forEach>
                    ]);

                    var container = document.getElementById('relationshipMap');
                    var data = {
                        nodes: nodes,
                        edges: edges
                    };
                    var options = {
                        edges: {
                            color: '#adb5bd',
                            smooth: {
                                type: 'cubicBezier'
                            }
                        },
                        layout: {
                            hierarchical: {
                                direction: 'UD',
                                sortMethod: 'directed',
                                nodeSpacing: 150
                            }
                        },
                        physics: false,
                        interaction: {
                            hover: true,
                            navigationButtons: true,
                            keyboard: true
                        }
                    };

                    var network = new vis.Network(container, data, options);
                });
            </script>
        </c:if>
        <c:if test="${empty relationships}">
            <div class="alert alert-secondary m-0" role="alert">
                <i class="bi bi-info-circle"></i> This CI has no recorded relationships with other infrastructure
                components.
            </div>
        </c:if>
    </div>
    </div>

    <!-- Add Relationship Modal -->
    <div class="modal fade" id="addRelationModal" tabindex="-1" aria-labelledby="addRelationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/cmdb" method="POST">
                <input type="hidden" name="action" value="addRelationship">
                <input type="hidden" name="parentCiId" value="${ci.ciId}">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addRelationModalLabel"><i class="bi bi-link"></i> Connect to another CI</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3 border-bottom pb-2">
                            <span class="text-muted small">Current CI (Parent):</span><br>
                            <strong>${ci.ciName} (${ci.ciCode})</strong>
                        </div>
                        
                        <div class="mb-3">
                            <label for="relationshipType" class="form-label fw-bold">Relationship Type *</label>
                            <select class="form-select" id="relationshipType" name="relationshipType" required>
                                <option value="">Select relationship type...</option>
                                <option value="DEPENDS_ON">Depends On</option>
                                <option value="CONNECTED_TO">Connected To</option>
                                <option value="RUNS_ON">Runs On</option>
                                <option value="HOSTED_BY">Hosted By</option>
                                <option value="PART_OF">Part Of</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="childCiId" class="form-label fw-bold">Connect To (Child CI) *</label>
                            <select class="form-select" id="childCiId" name="childCiId" required>
                                <option value="">Search and select CI...</option>
                                <c:forEach var="otherCi" items="${allCis}">
                                    <option value="${otherCi.ciId}">${otherCi.ciCode} - ${otherCi.ciName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="2" placeholder="Briefly describe the relationship..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-diagram-2"></i> Create Relationship</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />