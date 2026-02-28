<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <jsp:include page="/WEB-INF/views/layout/header.jsp">
                <jsp:param name="pageTitle" value="Workflow Detail" />
                <jsp:param name="activeNav" value="workflows" />
            </jsp:include>

            <!-- ══════════════════════════════════════════
     TOPBAR
══════════════════════════════════════════ -->
            <div class="topbar d-flex align-items-center px-4">
                <div class="flex-grow-1">
                    <div class="topbar-title">Workflow Detail</div>
                    <div class="topbar-sub">
                        <a href="${pageContext.request.contextPath}/workflows"
                            class="text-secondary text-decoration-none">
                            Workflows
                        </a>
                        / <span class="bc-current">
                            <c:out value="${workflow.workflowName}" />
                        </span>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/workflows"
                        class="btn btn-secondary d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                    <a href="${pageContext.request.contextPath}/workflows?action=edit&id=${workflow.workflowId}"
                        class="btn btn-warning d-flex align-items-center gap-2">
                        <i class="bi bi-pencil"></i> Edit
                    </a>
                    <c:choose>
                        <c:when test="${workflow.status == 'ACTIVE'}">
                            <button class="btn btn-outline-warning d-flex align-items-center gap-2"
                                onclick="doToggle(${workflow.workflowId}, 'INACTIVE')">
                                <i class="bi bi-pause-circle"></i> Disable
                            </button>
                        </c:when>
                        <c:when test="${workflow.status == 'INACTIVE'}">
                            <button class="btn btn-outline-success d-flex align-items-center gap-2"
                                onclick="doToggle(${workflow.workflowId}, 'ACTIVE')">
                                <i class="bi bi-play-circle"></i> Enable
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-outline-primary d-flex align-items-center gap-2"
                                onclick="doToggle(${workflow.workflowId}, 'ACTIVE')">
                                <i class="bi bi-send-check"></i> Publish
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <button class="btn btn-outline-danger d-flex align-items-center gap-2"
                        onclick="doDelete(${workflow.workflowId}, '${workflow.workflowName}')">
                        <i class="bi bi-trash3"></i> Delete
                    </button>
                </div>
            </div>

            <!-- ══════════════════════════════════════════
     PAGE BODY
══════════════════════════════════════════ -->
            <div class="flex-grow-1 p-4">
                <div class="row g-4">

                    <%-- ── Left col: main info ─────────────────────────────── --%>
                        <div class="col-lg-8">

                            <%-- Info card --%>
                                <div class="workflow-card mb-4">
                                    <div
                                        class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom border-secondary-subtle">
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="bi bi-diagram-3-fill text-primary"></i>
                                            <span class="fw-bold">Workflow Information</span>
                                        </div>
                                        <span class="badge-status badge-${workflow.status.toLowerCase()}">
                                            <c:out value="${workflow.status}" />
                                        </span>
                                    </div>

                                    <div class="p-4">
                                        <div class="mb-3">
                                            <div class="detail-label mb-1">Workflow Name</div>
                                            <div class="detail-value fs-5 fw-semibold">
                                                <c:out value="${workflow.workflowName}" />
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <div class="detail-label mb-1">Description</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty workflow.description}">
                                                        <c:out value="${workflow.description}" />
                                                    </c:when>
                                                    <c:otherwise><em class="text-secondary">No description
                                                            provided.</em></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <hr class="border-secondary-subtle" />

                                        <%-- Meta grid --%>
                                            <div class="row g-3">
                                                <div class="col-sm-6">
                                                    <div class="detail-label">Workflow ID</div>
                                                    <div class="detail-value">
                                                        <code class="text-info">#${workflow.workflowId}</code>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="detail-label">Created By</div>
                                                    <div class="detail-value d-flex align-items-center gap-2 mt-1">
                                                        <div class="avatar-sm rounded-circle bg-secondary bg-opacity-25 d-flex align-items-center justify-content-center flex-shrink-0"
                                                            style="width:28px;height:28px;">
                                                            <i class="bi bi-person-fill text-secondary"
                                                                style="font-size:12px;"></i>
                                                        </div>
                                                        <span>
                                                            <c:choose>
                                                                <c:when test="${not empty workflow.createdByName}">
                                                                    <c:out value="${workflow.createdByName}" />
                                                                </c:when>
                                                                <c:otherwise>Unknown</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="detail-label">Last Updated</div>
                                                    <div class="detail-value">
                                                        <c:choose>
                                                            <c:when test="${not empty workflow.updatedAt}">
                                                                <fmt:formatDate value="${workflow.updatedAt}"
                                                                    pattern="dd MMM yyyy, HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="detail-label">Status</div>
                                                    <div class="detail-value mt-1">
                                                        <span
                                                            class="badge-status badge-${workflow.status.toLowerCase()}">
                                                            <c:out value="${workflow.status}" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                    </div>
                                </div>

                                <%-- Workflow Summary --%>
                                    <div class="workflow-card mb-4">
                                        <div
                                            class="d-flex align-items-center gap-2 px-4 py-3 border-bottom border-secondary-subtle">
                                            <i class="bi bi-eye text-success"></i>
                                            <span class="fw-bold">Workflow Summary</span>
                                        </div>
                                        <div class="p-4" id="workflowSummary">
                                            <div class="text-center py-4 text-secondary" id="summaryLoading">
                                                <div class="spinner-border spinner-border-sm mb-2"></div>
                                                <p class="mb-0">Loading workflow summary...</p>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Workflow Config JSON --%>
                                        <div class="workflow-card">
                                            <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom border-secondary-subtle"
                                                style="cursor:pointer;" data-bs-toggle="collapse"
                                                data-bs-target="#jsonCollapse">
                                                <i class="bi bi-code-square text-info"></i>
                                                <span class="fw-bold">Raw Configuration (JSON)</span>
                                                <i class="bi bi-chevron-down ms-auto text-secondary"></i>
                                            </div>
                                            <div class="collapse" id="jsonCollapse">
                                                <div class="p-4">
                                                    <c:choose>
                                                        <c:when test="${not empty workflow.workflowConfig}">
                                                            <pre class="config-preview"
                                                                id="rawConfigJson"><c:out value="${workflow.workflowConfig}"/></pre>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-center py-4 text-secondary">
                                                                <i class="bi bi-braces fs-3 opacity-50"></i>
                                                                <p class="mt-2 mb-0">No configuration defined yet.</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                        </div><%-- /.col-lg-8 --%>

                            <%-- ── Right col: quick actions + info ────────────────── --%>
                                <div class="col-lg-4">

                                    <%-- Status control card --%>
                                        <div class="workflow-card mb-4">
                                            <div
                                                class="d-flex align-items-center gap-2 px-4 py-3 border-bottom border-secondary-subtle">
                                                <i class="bi bi-toggle-on text-success"></i>
                                                <span class="fw-bold">Status Control</span>
                                            </div>
                                            <div class="p-4">
                                                <p class="text-secondary small mb-3">
                                                    Change the workflow status to control whether it can be used by the
                                                    ticket engine.
                                                </p>
                                                <c:if test="${workflow.status != 'ACTIVE'}">
                                                    <button
                                                        class="btn btn-success w-100 mb-2 d-flex align-items-center justify-content-center gap-2"
                                                        onclick="doToggle(${workflow.workflowId}, 'ACTIVE')">
                                                        <i class="bi bi-play-circle-fill"></i>
                                                        ${workflow.status == 'DRAFT' ? 'Publish as Active' : 'Enable
                                                        Workflow'}
                                                    </button>
                                                </c:if>
                                                <c:if test="${workflow.status == 'ACTIVE'}">
                                                    <button
                                                        class="btn btn-warning w-100 mb-2 d-flex align-items-center justify-content-center gap-2"
                                                        onclick="doToggle(${workflow.workflowId}, 'INACTIVE')">
                                                        <i class="bi bi-pause-circle-fill"></i> Disable Workflow
                                                    </button>
                                                </c:if>
                                                <c:if test="${workflow.status != 'DRAFT'}">
                                                    <div class="text-center">
                                                        <small class="text-secondary">
                                                            Current status: <span
                                                                class="badge-status badge-${workflow.status.toLowerCase()} ms-1">
                                                                <c:out value="${workflow.status}" />
                                                            </span>
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${workflow.status == 'DRAFT'}">
                                                    <div class="alert alert-info d-flex gap-2 p-2 mt-2" role="alert">
                                                        <i class="bi bi-info-circle-fill flex-shrink-0"></i>
                                                        <small>Draft workflows are not yet available to the ticket
                                                            engine.</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>

                                        <%-- Quick actions --%>
                                            <div class="workflow-card mb-4">
                                                <div
                                                    class="d-flex align-items-center gap-2 px-4 py-3 border-bottom border-secondary-subtle">
                                                    <i class="bi bi-lightning text-warning"></i>
                                                    <span class="fw-bold">Quick Actions</span>
                                                </div>
                                                <div class="p-3 d-flex flex-column gap-2">
                                                    <a href="${pageContext.request.contextPath}/workflows?action=edit&id=${workflow.workflowId}"
                                                        class="btn btn-outline-secondary d-flex align-items-center gap-2">
                                                        <i class="bi bi-pencil-square text-warning"></i> Edit Workflow
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/workflows"
                                                        class="btn btn-outline-secondary d-flex align-items-center gap-2">
                                                        <i class="bi bi-list-ul text-info"></i> All Workflows
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/workflows?action=create"
                                                        class="btn btn-outline-secondary d-flex align-items-center gap-2">
                                                        <i class="bi bi-plus-lg text-success"></i> New Workflow
                                                    </a>
                                                    <hr class="border-secondary-subtle my-1" />
                                                    <button
                                                        class="btn btn-outline-danger d-flex align-items-center gap-2"
                                                        onclick="doDelete(${workflow.workflowId}, '${workflow.workflowName}')">
                                                        <i class="bi bi-trash3"></i> Delete Workflow
                                                    </button>
                                                </div>
                                            </div>

                                </div><%-- /.col-lg-4 --%>
                </div><%-- /.row --%>
            </div><%-- /.page-body --%>

                <%-- ══════════════════════════════════════════ DELETE MODAL ══════════════════════════════════════════
                    --%>
                    <div class="modal fade" id="deleteModal" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content bg-dark border border-secondary-subtle">
                                <div class="modal-header border-secondary-subtle">
                                    <h5 class="modal-title"><i class="bi bi-trash3 text-danger me-2"></i>Delete Workflow
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p class="text-secondary mb-0">
                                        Are you sure you want to delete
                                        <strong class="text-white" id="delName"></strong>?
                                        This action <span class="text-danger fw-semibold">cannot be undone</span>.
                                    </p>
                                </div>
                                <div class="modal-footer border-secondary-subtle">
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button class="btn btn-danger" id="doDelBtn">
                                        <i class="bi bi-trash3 me-1"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Categories metadata for summary --%>
                        <script type="application/json" id="metaCategories">
                        [
                            <c:forEach items="${categories}" var="c" varStatus="loop">
                                {"id": ${c.categoryId}, "name": "${c.categoryName}"}${!loop.last ? ',' : ''}
                            </c:forEach>
                        ]
                    </script>

                        <script>
                            const CTX = '${pageContext.request.contextPath}';
                            const CATEGORIES = JSON.parse(document.getElementById('metaCategories').textContent || '[]');

                            /* ---- DELETE ---- */
                            let delId = null;
                            let delModal = null;

                            function doDelete(id, name) {
                                delId = id;
                                document.getElementById('delName').textContent = name;
                                // Lazy-init: safe even if bootstrap loads asynchronously (defer in header.jsp)
                                if (!delModal) {
                                    delModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                                }
                                delModal.show();
                            }

                            document.getElementById('doDelBtn').addEventListener('click', async () => {
                                const btn = document.getElementById('doDelBtn');
                                btn.disabled = true;
                                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Deleting…';

                                const form = new FormData();
                                form.append('action', 'delete');
                                form.append('workflowId', delId);

                                const res = await fetch(CTX + '/workflows', { method: 'POST', body: form });
                                const data = await res.json();

                                if (data.success) {
                                    window.location.href = CTX + '/workflows';
                                } else {
                                    delModal.hide();
                                    alert('Delete failed. Please try again.');
                                    btn.disabled = false;
                                    btn.innerHTML = '<i class="bi bi-trash3 me-1"></i> Delete';
                                }
                            });

                            /* ---- TOGGLE ---- */
                            async function doToggle(id, newStatus) {
                                const form = new FormData();
                                form.append('action', 'toggle');
                                form.append('workflowId', id);
                                form.append('newStatus', newStatus);

                                const res = await fetch(CTX + '/workflows', { method: 'POST', body: form });
                                const data = await res.json();

                                if (data.success) {
                                    location.reload();
                                } else {
                                    alert('Status update failed. Please try again.');
                                }
                            }
                            /* ---- SUMMARY RENDERING ---- */
                            (function initSummary() {
                                const configEl = document.getElementById('rawConfigJson');
                                const raw = configEl ? configEl.textContent.trim() : '';
                                const summaryDiv = document.getElementById('workflowSummary');
                                if (!raw || raw === 'null' || raw === '') {
                                    summaryDiv.innerHTML = '<div class="alert alert-info">No configuration defined.</div>';
                                    return;
                                }

                                try {
                                    const cfg = JSON.parse(raw);
                                    let html = '';

                                    // Trigger
                                    html += `<div class="mb-4">
                                    <div class="detail-label mb-2"><i class="bi bi-lightning-fill text-warning me-1"></i> Trigger</div>
                                    <div class="badge bg-primary fs-6">\${cfg.trigger || 'Unknown'}</div>
                                </div>`;

                                    // Conditions
                                    if (cfg.conditions) {
                                        html += `<div class="mb-4">
                                            <div class="detail-label mb-2"><i class="bi bi-filter-circle text-info me-1"></i> Trigger Conditions</div>`;

                                        function renderSummaryNode(node) {
                                            if (!node) return '';
                                            if (node.type === 'condition' || node.field) {
                                                let fieldLabel = (node.field || '').replace('_', ' ').toUpperCase();
                                                let val = node.value;
                                                if (node.field === 'category_id') {
                                                    const cat = CATEGORIES.find(c => c.id == val);
                                                    val = cat ? cat.name : ('Category #' + val);
                                                }
                                                let badgeClass = 'border-info text-info';
                                                if (node.field === 'priority') badgeClass = 'border-warning text-warning';
                                                if (node.field === 'ticket_type') badgeClass = 'border-primary text-primary';

                                                return `<span class="badge border \${badgeClass} p-2 px-3 rounded-pill bg-dark bg-opacity-25 my-1">
                                                    <span class="opacity-75">\${fieldLabel}</span> 
                                                    <span class="mx-1">\${node.operator === 'NOT_EQUALS' ? 'is not' : 'is'}</span> 
                                                    <strong class="text-white">\${val}</strong>
                                                </span>`;
                                            } else if (node.type === 'group' || node.logic) {
                                                const logic = node.logic || 'AND';
                                                const criteria = node.criteria || [];
                                                if (criteria.length === 0) return '';

                                                const childrenHtml = criteria.map(c => renderSummaryNode(c)).join('');
                                                return `<div class="border border-secondary-subtle border-opacity-25 rounded p-2 px-3 bg-dark bg-opacity-10 my-2">
                                                    <div class="small text-secondary mb-1" style="font-size:10px;">MATCH \${logic}</div>
                                                    <div class="d-flex flex-wrap gap-2">\${childrenHtml}</div>
                                                </div>`;
                                            }
                                            return '';
                                        }

                                        if (Array.isArray(cfg.conditions)) {
                                            html += `<div class="d-flex flex-wrap gap-2">` + cfg.conditions.map(c => renderSummaryNode(c)).join('') + `</div>`;
                                        } else {
                                            html += renderSummaryNode(cfg.conditions);
                                        }
                                        html += `</div>`;
                                    }

                                    // Steps
                                    if (cfg.steps && cfg.steps.length > 0) {
                                        html += `<div class="mb-0">
                                        <div class="detail-label mb-2"><i class="bi bi-list-ol text-success me-1"></i> Approval Steps</div>
                                        <div class="list-group">`;
                                        cfg.steps.forEach((s, idx) => {
                                            html += `<div class="list-group-item bg-dark border-secondary-subtle d-flex align-items-center gap-3 py-3">
                                            <div class="avatar-sm rounded-circle bg-success bg-opacity-25 text-success d-flex align-items-center justify-content-center flex-shrink-0" style="width:32px;height:32px;">\${idx + 1}</div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold text-white">\${s.name || 'Step ' + (idx + 1)}</div>
                                                <div class="small text-secondary">Assigned to: <span class="text-info">\${s.role}</span> &bull; Action: <span class="text-info">\${s.action}</span></div>
                                            </div>
                                            <div class="text-end">
                                                <div class="small text-secondary">SLA</div>
                                                <div class="fw-bold text-warning">\${s.sla_hours}h</div>
                                            </div>
                                        </div>`;
                                        });
                                        html += `</div></div>`;
                                    }

                                    summaryDiv.innerHTML = html;
                                } catch (e) {
                                    summaryDiv.innerHTML = '<div class="alert alert-danger">Error parsing configuration JSON.</div>';
                                }
                            })();
                        </script>

                        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />