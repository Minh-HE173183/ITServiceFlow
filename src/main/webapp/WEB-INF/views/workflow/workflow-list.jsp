<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <jsp:include page="/WEB-INF/views/layout/header.jsp">
                <jsp:param name="pageTitle" value="Workflows" />
                <jsp:param name="activeNav" value="workflows" />
            </jsp:include>

            <!-- ══════════════════════════════════════════
     TOPBAR
══════════════════════════════════════════ -->
            <div class="topbar d-flex align-items-center px-4">
                <div class="flex-grow-1">
                    <div class="topbar-title">Workflow Management</div>
                    <div class="topbar-sub">
                        Home / <span class="bc-current">Workflows</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/workflows?action=create"
                    class="btn btn-primary d-flex align-items-center gap-2">
                    <i class="bi bi-plus-lg"></i> New Workflow
                </a>
            </div>

            <!-- ══════════════════════════════════════════
     PAGE BODY
══════════════════════════════════════════ -->
            <div class="flex-grow-1 p-4">

                <%-- Flash messages --%>
                    <c:if test="${not empty sessionScope.flashSuccess}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2"
                            role="alert">
                            <i class="bi bi-check-circle-fill"></i>
                            <span>${sessionScope.flashSuccess}</span>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="flashSuccess" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.flashError}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2"
                            role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>${sessionScope.flashError}</span>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="flashError" scope="session" />
                    </c:if>

                    <%-- ── Stat cards ─────────────────────────────────────────── --%>
                        <div class="row g-3 mb-4">
                            <div class="col-6 col-xl-3">
                                <div class="stat-card p-3 d-flex align-items-center gap-3">
                                    <div class="stat-icon-wrap bg-primary bg-opacity-10">
                                        <i class="bi bi-diagram-3-fill text-primary"></i>
                                    </div>
                                    <div>
                                        <div class="text-secondary"
                                            style="font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.6px;">
                                            Total</div>
                                        <div class="fw-bold fs-4">${countAll}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-xl-3">
                                <div class="stat-card p-3 d-flex align-items-center gap-3">
                                    <div class="stat-icon-wrap" style="background:rgba(16,185,129,.15);">
                                        <i class="bi bi-play-circle-fill text-success"></i>
                                    </div>
                                    <div>
                                        <div class="text-secondary"
                                            style="font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.6px;">
                                            Active</div>
                                        <div class="fw-bold fs-4">${countActive}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-xl-3">
                                <div class="stat-card p-3 d-flex align-items-center gap-3">
                                    <div class="stat-icon-wrap" style="background:rgba(245,158,11,.15);">
                                        <i class="bi bi-pause-circle-fill text-warning"></i>
                                    </div>
                                    <div>
                                        <div class="text-secondary"
                                            style="font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.6px;">
                                            Inactive</div>
                                        <div class="fw-bold fs-4">${countInactive}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-xl-3">
                                <div class="stat-card p-3 d-flex align-items-center gap-3">
                                    <div class="stat-icon-wrap" style="background:rgba(59,130,246,.15);">
                                        <i class="bi bi-pencil-square text-info"></i>
                                    </div>
                                    <div>
                                        <div class="text-secondary"
                                            style="font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.6px;">
                                            Draft</div>
                                        <div class="fw-bold fs-4">${countDraft}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- ── Main table card ──────────────────────────────────────── --%>
                            <div class="workflow-card">

                                <%-- Card header: filter tabs + search --%>
                                    <div
                                        class="d-flex flex-wrap align-items-center justify-content-between gap-3 p-3 border-bottom border-secondary-subtle">
                                        <div class="filter-tabs flex-shrink-0">
                                            <a class="filter-tab ${statusFilter == '' ? 'active' : ''}"
                                                href="${pageContext.request.contextPath}/workflows">
                                                All <span class="fc">${countAll}</span>
                                            </a>
                                            <a class="filter-tab ${statusFilter == 'ACTIVE' ? 'active' : ''}"
                                                href="${pageContext.request.contextPath}/workflows?status=ACTIVE">
                                                Active <span class="fc">${countActive}</span>
                                            </a>
                                            <a class="filter-tab ${statusFilter == 'INACTIVE' ? 'active' : ''}"
                                                href="${pageContext.request.contextPath}/workflows?status=INACTIVE">
                                                Inactive <span class="fc">${countInactive}</span>
                                            </a>
                                            <a class="filter-tab ${statusFilter == 'DRAFT' ? 'active' : ''}"
                                                href="${pageContext.request.contextPath}/workflows?status=DRAFT">
                                                Draft <span class="fc">${countDraft}</span>
                                            </a>
                                        </div>

                                        <%-- Search (client-side) --%>
                                            <div class="input-group" style="max-width:260px;">
                                                <span
                                                    class="input-group-text bg-transparent border-secondary-subtle text-secondary">
                                                    <i class="bi bi-search"></i>
                                                </span>
                                                <input type="text" id="searchInput"
                                                    class="form-control border-secondary-subtle"
                                                    placeholder="Search workflows…" oninput="filterTable()" />
                                            </div>
                                    </div>

                                    <%-- Table --%>
                                        <div class="table-responsive">
                                            <table class="table table-dark table-hover mb-0" id="workflowTable">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Workflow Name</th>
                                                        <th>Description</th>
                                                        <th>Status</th>
                                                        <th>Created By</th>
                                                        <th>Last Updated</th>
                                                        <th class="text-center">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty workflows}">
                                                            <tr>
                                                                <td colspan="7">
                                                                    <div class="empty-state">
                                                                        <div class="empty-icon"><i
                                                                                class="bi bi-diagram-3"></i></div>
                                                                        <h5 class="mt-3 text-secondary">No workflows
                                                                            found</h5>
                                                                        <p class="text-secondary mb-4">Get started by
                                                                            creating your first workflow.</p>
                                                                        <a href="${pageContext.request.contextPath}/workflows?action=create"
                                                                            class="btn btn-primary">
                                                                            <i class="bi bi-plus-lg me-1"></i> Create
                                                                            Workflow
                                                                        </a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="wf" items="${workflows}" varStatus="loop">
                                                                <tr data-name="${wf.workflowName}">
                                                                    <td class="text-secondary">${loop.index + 1}</td>
                                                                    <td>
                                                                        <a class="workflow-name-link"
                                                                            href="${pageContext.request.contextPath}/workflows?action=detail&id=${wf.workflowId}">
                                                                            <i
                                                                                class="bi bi-diagram-3 me-1 text-secondary"></i>
                                                                            <c:out value="${wf.workflowName}" />
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <span class="text-secondary"
                                                                            style="font-size:12.5px;">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty wf.description}">
                                                                                    <c:out value="${wf.description.length() > 60
                                                        ? wf.description.substring(0, 60).concat('…')
                                                        : wf.description}" />
                                                                                </c:when>
                                                                                <c:otherwise><em>No description</em>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <span
                                                                            class="badge-status badge-${wf.status.toLowerCase()}">
                                                                            <c:out value="${wf.status}" />
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty wf.createdByName}">
                                                                                <div
                                                                                    class="d-flex align-items-center gap-2">
                                                                                    <div class="avatar-sm rounded-circle bg-secondary bg-opacity-25 d-flex align-items-center justify-content-center flex-shrink-0"
                                                                                        style="width:28px;height:28px;">
                                                                                        <i class="bi bi-person-fill text-secondary"
                                                                                            style="font-size:12px;"></i>
                                                                                    </div>
                                                                                    <span style="font-size:13px;">
                                                                                        <c:out
                                                                                            value="${wf.createdByName}" />
                                                                                    </span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise><span
                                                                                    class="text-secondary">—</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${not empty wf.updatedAt}">
                                                                                <fmt:formatDate value="${wf.updatedAt}"
                                                                                    pattern="dd MMM yyyy" />
                                                                                <br />
                                                                                <span class="text-secondary"
                                                                                    style="font-size:11px;">
                                                                                    <fmt:formatDate
                                                                                        value="${wf.updatedAt}"
                                                                                        pattern="HH:mm" />
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise><span
                                                                                    class="text-secondary">—</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <div
                                                                            class="d-flex align-items-center justify-content-center gap-1">

                                                                            <%-- View --%>
                                                                                <a href="${pageContext.request.contextPath}/workflows?action=detail&id=${wf.workflowId}"
                                                                                    class="btn-action btn-outline-secondary text-info"
                                                                                    title="View Detail"
                                                                                    data-bs-toggle="tooltip">
                                                                                    <i class="bi bi-eye"></i>
                                                                                </a>

                                                                                <%-- Edit --%>
                                                                                    <a href="${pageContext.request.contextPath}/workflows?action=edit&id=${wf.workflowId}"
                                                                                        class="btn-action btn-outline-secondary text-warning"
                                                                                        title="Edit"
                                                                                        data-bs-toggle="tooltip">
                                                                                        <i class="bi bi-pencil"></i>
                                                                                    </a>

                                                                                    <%-- Enable / Disable (not for
                                                                                        DRAFT) --%>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${wf.status == 'ACTIVE'}">
                                                                                                <button
                                                                                                    class="btn-action btn-outline-secondary text-warning"
                                                                                                    title="Disable"
                                                                                                    data-bs-toggle="tooltip"
                                                                                                    onclick="confirmToggle(${wf.workflowId}, 'INACTIVE', '${wf.workflowName}')">
                                                                                                    <i
                                                                                                        class="bi bi-pause-circle"></i>
                                                                                                </button>
                                                                                            </c:when>
                                                                                            <c:when
                                                                                                test="${wf.status == 'INACTIVE'}">
                                                                                                <button
                                                                                                    class="btn-action btn-outline-secondary text-success"
                                                                                                    title="Enable"
                                                                                                    data-bs-toggle="tooltip"
                                                                                                    onclick="confirmToggle(${wf.workflowId}, 'ACTIVE', '${wf.workflowName}')">
                                                                                                    <i
                                                                                                        class="bi bi-play-circle"></i>
                                                                                                </button>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <%-- DRAFT: publish as
                                                                                                    ACTIVE --%>
                                                                                                    <button
                                                                                                        class="btn-action btn-outline-secondary text-primary"
                                                                                                        title="Publish (set Active)"
                                                                                                        data-bs-toggle="tooltip"
                                                                                                        onclick="confirmToggle(${wf.workflowId}, 'ACTIVE', '${wf.workflowName}')">
                                                                                                        <i
                                                                                                            class="bi bi-send-check"></i>
                                                                                                    </button>
                                                                                            </c:otherwise>
                                                                                        </c:choose>

                                                                                        <%-- Delete --%>
                                                                                            <button
                                                                                                class="btn-action btn-outline-secondary text-danger"
                                                                                                title="Delete"
                                                                                                data-bs-toggle="tooltip"
                                                                                                onclick="confirmDelete(${wf.workflowId}, '${wf.workflowName}')">
                                                                                                <i
                                                                                                    class="bi bi-trash3"></i>
                                                                                            </button>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>

                                        <%-- Pagination placeholder --%>
                                            <c:if test="${not empty workflows}">
                                                <div
                                                    class="px-3 py-2 border-top border-secondary-subtle d-flex align-items-center justify-content-between">
                                                    <span class="text-secondary" style="font-size:12px;">
                                                        Showing <strong class="text-white">${workflows.size()}</strong>
                                                        workflow(s)
                                                    </span>
                                                </div>
                                            </c:if>
                            </div><%-- /.workflow-card --%>
            </div><%-- /.page-body --%>

                <%-- ══════════════════════════════════════════ DELETE CONFIRM MODAL
                    ══════════════════════════════════════════ --%>
                    <div class="modal fade" id="deleteModal" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-trash3 text-danger me-2"></i>Delete Workflow
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p class="text-secondary mb-0">
                                        Are you sure you want to delete workflow
                                        <strong id="deleteWfName"></strong>?
                                        This action <span class="text-danger fw-semibold">cannot be undone</span>.
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn"
                                        onclick="doDelete()">
                                        <i class="bi bi-trash3 me-1"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- ══════════════════════════════════════════ TOGGLE CONFIRM MODAL
                        ══════════════════════════════════════════ --%>
                        <div class="modal fade" id="toggleModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="toggleModalTitle">Change Status</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p class="text-secondary mb-0" id="toggleModalBody"></p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="button" class="btn btn-primary" id="confirmToggleBtn"
                                            onclick="doToggle()">Confirm</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- ── JavaScript ────────────────────────────────────────────── --%>
                            <script>
                                const CTX = '${pageContext.request.contextPath}';

                                // ── Lazy modal getters ────────────────────────────────
                                function getDeleteModal() {
                                    var el = document.getElementById('deleteModal');
                                    return bootstrap.Modal.getOrCreateInstance(el);
                                }
                                function getToggleModal() {
                                    var el = document.getElementById('toggleModal');
                                    return bootstrap.Modal.getOrCreateInstance(el);
                                }

                                // ── Safe JSON parser (logs raw response if not JSON) ──
                                async function safeJson(res) {
                                    var text = await res.text();
                                    console.log('[safeJson] status:', res.status, 'body:', text.substring(0, 300));
                                    try {
                                        return JSON.parse(text);
                                    } catch (e) {
                                        // Server returned HTML (error page / redirect)
                                        return { success: false, message: 'Server error (HTTP ' + res.status + '). Check console for details.' };
                                    }
                                }

                                // ── Tooltips ─────────────────────────────────────────
                                document.addEventListener('DOMContentLoaded', function () {
                                    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (el) {
                                        new bootstrap.Tooltip(el, { trigger: 'hover' });
                                    });
                                });

                                // ── Client-side search ────────────────────────────────
                                function filterTable() {
                                    var q = document.getElementById('searchInput').value.toLowerCase();
                                    document.querySelectorAll('#workflowTable tbody tr').forEach(function (row) {
                                        row.style.display = (row.dataset.name || '').toLowerCase().includes(q) ? '' : 'none';
                                    });
                                }

                                // ── Delete ────────────────────────────────────────────
                                var pendingDeleteId = null;

                                function confirmDelete(id, name) {
                                    pendingDeleteId = id;
                                    document.getElementById('deleteWfName').textContent = name;
                                    var btn = document.getElementById('confirmDeleteBtn');
                                    btn.disabled = false;
                                    btn.innerHTML = '<i class="bi bi-trash3 me-1"></i> Delete';
                                    getDeleteModal().show();
                                }

                                async function doDelete() {
                                    if (!pendingDeleteId) return;
                                    var btn = document.getElementById('confirmDeleteBtn');
                                    btn.disabled = true;
                                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Deleting…';
                                    try {
                                        var form = new FormData();
                                        form.append('action', 'delete');
                                        form.append('workflowId', pendingDeleteId);
                                        var res = await fetch(CTX + '/workflows', { method: 'POST', body: form });
                                        console.log('res', res);
                                        var data = await safeJson(res);
                                        getDeleteModal().hide();
                                        if (data.success) {
                                            showToast('Workflow deleted successfully.', 'success');
                                            setTimeout(function () { location.reload(); }, 900);
                                        } else {
                                            showToast(data.message || 'Failed to delete workflow.', 'danger');
                                            btn.disabled = false;
                                            btn.innerHTML = '<i class="bi bi-trash3 me-1"></i> Delete';
                                        }
                                    } catch (err) {
                                        console.error('Delete fetch error:', err);
                                        showToast('Network error. Please try again.', 'danger');
                                        btn.disabled = false;
                                        btn.innerHTML = '<i class="bi bi-trash3 me-1"></i> Delete';
                                    }
                                }

                                // ── Toggle (Enable / Disable) ─────────────────────────
                                var pendingToggleId = null;
                                var pendingNewStatus = null;

                                function confirmToggle(id, newStatus, name) {
                                    pendingToggleId = id;
                                    pendingNewStatus = newStatus;
                                    var label = newStatus === 'ACTIVE' ? 'enable' : 'disable';
                                    var icon = newStatus === 'ACTIVE'
                                        ? '<i class="bi bi-play-circle text-success me-2"></i>'
                                        : '<i class="bi bi-pause-circle text-warning me-2"></i>';
                                    document.getElementById('toggleModalTitle').innerHTML = icon + 'Confirm Status Change';
                                    document.getElementById('toggleModalBody').innerHTML =
                                        'You are about to <strong class="fw-semibold">' + label +
                                        '</strong> workflow <strong class="fw-semibold">' + name + '</strong>. Continue?';
                                    var confirmBtn = document.getElementById('confirmToggleBtn');
                                    confirmBtn.disabled = false;
                                    confirmBtn.className = newStatus === 'ACTIVE' ? 'btn btn-success' : 'btn btn-warning';
                                    confirmBtn.textContent = newStatus === 'ACTIVE' ? 'Enable' : 'Disable';
                                    getToggleModal().show();
                                }

                                async function doToggle() {
                                    if (!pendingToggleId) return;
                                    var btn = document.getElementById('confirmToggleBtn');
                                    btn.disabled = true;
                                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving…';
                                    try {
                                        var form = new FormData();
                                        form.append('action', 'toggle');
                                        form.append('workflowId', pendingToggleId);
                                        form.append('newStatus', pendingNewStatus);
                                        var res = await fetch(CTX + '/workflows', { method: 'POST', body: form });
                                        var data = await safeJson(res);
                                        getToggleModal().hide();
                                        if (data.success) {
                                            showToast('Workflow ' + (pendingNewStatus === 'ACTIVE' ? 'enabled' : 'disabled') + '.', 'success');
                                            setTimeout(function () { location.reload(); }, 900);
                                        } else {
                                            showToast(data.message || 'Status update failed.', 'danger');
                                            btn.disabled = false;
                                            btn.textContent = pendingNewStatus === 'ACTIVE' ? 'Enable' : 'Disable';
                                        }
                                    } catch (err) {
                                        console.error('Toggle fetch error:', err);
                                        showToast('Network error. Please try again.', 'danger');
                                        btn.disabled = false;
                                        btn.textContent = pendingNewStatus === 'ACTIVE' ? 'Enable' : 'Disable';
                                    }
                                }

                                // ── Toast helper ──────────────────────────────────────
                                function showToast(message, type) {
                                    const t = document.createElement('div');
                                    t.className = 'toast align-items-center text-white bg-' + type + ' border-0 position-fixed bottom-0 end-0 m-3';
                                    t.setAttribute('role', 'alert');
                                    t.style.zIndex = 9999;
                                    t.innerHTML = '<div class="d-flex"><div class="toast-body fw-semibold">' + message +
                                        '</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>';
                                    document.body.appendChild(t);
                                    new bootstrap.Toast(t, { delay: 3000 }).show();
                                    t.addEventListener('hidden.bs.toast', function () { t.remove(); });
                                }
                            </script>

                            <jsp:include page="/WEB-INF/views/layout/footer.jsp" />