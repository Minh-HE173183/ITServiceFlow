<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <jsp:include page="/WEB-INF/views/layout/header.jsp">
            <jsp:param name="pageTitle" value="${formAction == 'create' ? 'Create Workflow' : 'Edit Workflow'}" />
            <jsp:param name="activeNav" value="workflows" />
        </jsp:include>

        <!-- Font Awesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
            crossorigin="anonymous" />

        <style>
            .step-card {
                background: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
            }

            .step-card:hover {
                border-color: #0d6efd;
            }

            .step-number {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                background: #0d6efd;
                color: #fff;
                font-size: 13px;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }

            .step-connector {
                width: 2px;
                background: #dee2e6;
                min-height: 16px;
                margin-left: 27px;
            }

            .trigger-option {
                cursor: pointer;
                border: 2px solid #dee2e6;
                border-radius: 8px;
                padding: 14px 16px;
                user-select: none;
                background: #fff;
            }

            .trigger-option:hover {
                border-color: #0d6efd;
                background: #f0f5ff;
            }

            .trigger-option.selected {
                border-color: #0d6efd;
                background: #e7f0ff;
            }

            .trigger-option .trigger-icon {
                font-size: 1.4rem;
                color: #0d6efd;
                margin-bottom: 8px;
            }

            .notif-toggle {
                cursor: pointer;
                border: 1px solid #dee2e6;
                border-radius: 6px;
                padding: 9px 14px;
                background: #fff;
            }

            .notif-toggle.active {
                border-color: #198754;
                background: #eaf7ef;
            }

            .notif-toggle.active .notif-check {
                color: #198754;
            }

            .notif-check {
                color: #ced4da;
            }

            .action-badge {
                font-size: 11px;
                padding: 2px 10px;
                border-radius: 4px;
                font-weight: 600;
                display: inline-block;
            }

            .badge-approve {
                background: #cfe2ff;
                color: #084298;
            }

            .badge-review {
                background: #cff4fc;
                color: #055160;
            }

            .badge-execute {
                background: #d1e7dd;
                color: #0a3622;
            }

            .badge-notify {
                background: #fff3cd;
                color: #664d03;
            }

            .empty-steps-placeholder {
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                padding: 36px;
                text-align: center;
                color: #6c757d;
                background: #f8f9fa;
            }

            .workflow-card {
                background: #fff;
                border: 1px solid #dee2e6;
                border-radius: 10px;
                overflow: hidden;
            }

            .btn-add-step {
                border: 1px dashed #0d6efd;
                color: #0d6efd;
                background: transparent;
                border-radius: 8px;
            }

            .btn-add-step:hover {
                background: #e7f0ff;
                color: #0a58ca;
            }

            .json-preview-box {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                font-family: 'Courier New', monospace;
                font-size: 12px;
                color: #0550ae;
                padding: 14px;
                max-height: 180px;
                overflow-y: auto;
                white-space: pre;
            }

            .card-header-bar {
                background: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }
        </style>

        <!-- TOPBAR -->
        <div class="topbar d-flex align-items-center px-4">
            <div class="flex-grow-1">
                <div class="topbar-title">
                    <c:choose>
                        <c:when test="${formAction == 'create'}">Create New Workflow</c:when>
                        <c:otherwise>Edit Workflow</c:otherwise>
                    </c:choose>
                </div>
                <div class="topbar-sub">
                    <a href="${pageContext.request.contextPath}/workflows"
                        class="text-secondary text-decoration-none">Workflows</a>
                    /
                    <span class="bc-current">
                        <c:choose>
                            <c:when test="${formAction == 'create'}">New</c:when>
                            <c:otherwise>
                                <c:out value="${workflow.workflowName}" />
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/workflows"
                class="btn btn-outline-secondary d-flex align-items-center gap-2">
                <i class="fa fa-arrow-left"></i> Back to List
            </a>
        </div>

        <!-- PAGE BODY -->
        <div class="flex-grow-1 p-4">
            <div class="row justify-content-center">
                <div class="col-xl-10 col-xxl-9">

                    <%-- Error alert --%>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4"
                                role="alert">
                                <i class="fa fa-triangle-exclamation flex-shrink-0"></i>
                                <span>
                                    <c:out value="${error}" />
                                </span>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form id="workflowForm" method="post" action="${pageContext.request.contextPath}/workflows"
                            novalidate>

                            <input type="hidden" name="action" value="${formAction}" />
                            <input type="hidden" name="workflowId" value="${workflow.workflowId}" />
                            <input type="hidden" name="createdBy"
                                value="${sessionScope.loggedInUser != null ? sessionScope.loggedInUser.userId : ''}" />
                            <input type="hidden" name="workflowConfig" id="workflowConfigHidden" />

                            <!-- ── Basic Info ───────────────────────────────── -->
                            <div class="workflow-card mb-4">
                                <div class="card-header-bar d-flex align-items-center gap-2 px-4 py-3">
                                    <i class="fa fa-circle-info text-primary"></i>
                                    <span class="fw-bold">Basic Information</span>
                                </div>
                                <div class="p-4">
                                    <div class="row g-4">

                                        <div class="col-12">
                                            <label class="form-label" for="workflowName">Workflow Name <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" id="workflowName" name="workflowName"
                                                class="form-control" placeholder="e.g. IT Equipment Purchase Approval"
                                                value="<c:out value='${workflow.workflowName}'/>" maxlength="255"
                                                required />
                                            <div class="invalid-feedback">Workflow name is required.</div>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label" for="description">Description</label>
                                            <textarea id="description" name="description" class="form-control" rows="3"
                                                placeholder="Describe what this workflow does, who it applies to, and when it is triggered…"><c:out value="${workflow.description}"/></textarea>
                                            <div class="form-text text-secondary mt-1">
                                                <span id="descCharCount">0</span>/500 characters
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <label class="form-label" for="status">Status <span
                                                    class="text-danger">*</span></label>
                                            <select id="status" name="status" class="form-select" required>
                                                <option value="" disabled>— Select Status —</option>
                                                <option value="DRAFT" <c:if
                                                    test="${workflow.status == 'DRAFT'    || empty workflow.status}">
                                                    selected</c:if>>Draft</option>
                                                <option value="ACTIVE" <c:if test="${workflow.status == 'ACTIVE'}">
                                                    selected</c:if>>Active</option>
                                                <option value="INACTIVE" <c:if test="${workflow.status == 'INACTIVE'}">
                                                    selected</c:if>>Inactive</option>
                                            </select>
                                            <div id="statusHint" class="mt-2"></div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- ── Trigger ──────────────────────────────────── -->
                            <div class="workflow-card mb-4">
                                <div class="card-header-bar d-flex align-items-center gap-2 px-4 py-3">
                                    <i class="fa fa-bolt text-warning"></i>
                                    <span class="fw-bold">Trigger</span>
                                    <span class="badge bg-secondary ms-1" style="font-size:10px;">When does this
                                        workflow start?</span>
                                </div>
                                <div class="p-4">
                                    <div class="row g-3" id="triggerOptions">

                                        <div class="col-sm-6 col-lg-3">
                                            <div class="trigger-option" data-trigger="TICKET_CREATED"
                                                onclick="selectTrigger(this)">
                                                <div class="trigger-icon"><i class="fa fa-ticket"></i></div>
                                                <div class="fw-semibold text-dark" style="font-size:13px;">Ticket
                                                    Created</div>
                                                <div class="text-muted" style="font-size:11px;">Fires when a new
                                                    ticket is submitted</div>
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-lg-3">
                                            <div class="trigger-option" data-trigger="TICKET_UPDATED"
                                                onclick="selectTrigger(this)">
                                                <div class="trigger-icon"><i class="fa fa-pen-to-square"></i></div>
                                                <div class="fw-semibold text-dark" style="font-size:13px;">Ticket
                                                    Updated</div>
                                                <div class="text-muted" style="font-size:11px;">Fires when a ticket
                                                    status changes</div>
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-lg-3">
                                            <div class="trigger-option" data-trigger="SLA_BREACH"
                                                onclick="selectTrigger(this)">
                                                <div class="trigger-icon"><i class="fa fa-clock"></i></div>
                                                <div class="fw-semibold text-dark" style="font-size:13px;">SLA Breach
                                                </div>
                                                <div class="text-muted" style="font-size:11px;">Fires when SLA
                                                    deadline is missed</div>
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-lg-3">
                                            <div class="trigger-option" data-trigger="MANUAL"
                                                onclick="selectTrigger(this)">
                                                <div class="trigger-icon"><i class="fa fa-hand-pointer"></i></div>
                                                <div class="fw-semibold text-dark" style="font-size:13px;">Manual</div>
                                                <div class="text-muted" style="font-size:11px;">Triggered by an
                                                    agent manually</div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- ── Steps Builder ────────────────────────────── -->
                            <div class="workflow-card mb-4">
                                <div
                                    class="card-header-bar d-flex align-items-center justify-content-between px-4 py-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa fa-list-ol text-success"></i>
                                        <span class="fw-bold">Approval Steps</span>
                                        <span class="badge bg-success ms-1" id="stepCountBadge"
                                            style="font-size:10px;">0 steps</span>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-primary" onclick="addStep()">
                                        <i class="fa fa-plus me-1"></i>Add Step
                                    </button>
                                </div>
                                <div class="p-4">
                                    <div id="stepsContainer">
                                        <div class="empty-steps-placeholder" id="emptyStepsPlaceholder">
                                            <i class="fa fa-diagram-project d-block mb-2" style="font-size:2rem;"></i>
                                            <div class="fw-semibold mb-1">No steps added yet</div>
                                            <div style="font-size:12px;">Click "Add Step" to define the approval chain
                                                for this workflow.</div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-add-step w-100 mt-3 py-2 d-none"
                                        id="addStepBtn" onclick="addStep()">
                                        <i class="fa fa-plus-circle me-2"></i>Add Another Step
                                    </button>
                                </div>
                            </div>

                            <!-- ── Notifications ────────────────────────────── -->
                            <div class="workflow-card mb-4">
                                <div class="card-header-bar d-flex align-items-center gap-2 px-4 py-3">
                                    <i class="fa fa-bell text-info"></i>
                                    <span class="fw-bold">Notifications</span>
                                    <span class="badge bg-secondary ms-1" style="font-size:10px;">Who gets
                                        notified?</span>
                                </div>
                                <div class="p-4">
                                    <div class="row g-3">

                                        <div class="col-12">
                                            <div class="text-secondary mb-3" style="font-size:13px;">
                                                <i class="fa fa-circle-info me-1"></i>
                                                Select which events trigger notifications and who receives them.
                                            </div>
                                        </div>

                                        <!-- On Create -->
                                        <div class="col-md-4">
                                            <div class="fw-semibold text-dark mb-2" style="font-size:13px;">
                                                <i class="fa fa-circle-play text-success me-1"></i>On Ticket Creation
                                            </div>
                                            <div class="d-flex flex-column gap-2">
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_create" data-recipient="requester">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Requester</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_create" data-recipient="manager">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Manager</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_create" data-recipient="it_support">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">IT Support</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_create" data-recipient="next_approver">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Next Approver</span>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- On Approve -->
                                        <div class="col-md-4">
                                            <div class="fw-semibold text-dark mb-2" style="font-size:13px;">
                                                <i class="fa fa-circle-check text-primary me-1"></i>On Approval
                                            </div>
                                            <div class="d-flex flex-column gap-2">
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_approve" data-recipient="requester">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Requester</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_approve" data-recipient="manager">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Manager</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_approve" data-recipient="it_support">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">IT Support</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_approve" data-recipient="next_approver">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Next Approver</span>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- On Reject -->
                                        <div class="col-md-4">
                                            <div class="fw-semibold text-dark mb-2" style="font-size:13px;">
                                                <i class="fa fa-circle-xmark text-danger me-1"></i>On Rejection
                                            </div>
                                            <div class="d-flex flex-column gap-2">
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_reject" data-recipient="requester">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Requester</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_reject" data-recipient="manager">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Manager</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_reject" data-recipient="it_support">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">IT Support</span>
                                                </label>
                                                <label class="notif-toggle d-flex align-items-center gap-2">
                                                    <input type="checkbox" class="d-none notif-cb"
                                                        data-event="on_reject" data-recipient="next_approver">
                                                    <i class="fa fa-circle-check notif-check fs-5"></i><span
                                                        style="font-size:13px;">Next Approver</span>
                                                </label>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- ── JSON Preview (collapsible) ───────────────── -->
                            <div class="workflow-card mb-4">
                                <div class="card-header-bar d-flex align-items-center justify-content-between px-4 py-3"
                                    style="cursor:pointer;" data-bs-toggle="collapse"
                                    data-bs-target="#jsonPreviewCollapse">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa fa-code text-secondary"></i>
                                        <span class="text-secondary fw-semibold" style="font-size:13px;">Preview
                                            Generated JSON</span>
                                    </div>
                                    <i class="fa fa-chevron-down text-secondary"></i>
                                </div>
                                <div class="collapse" id="jsonPreviewCollapse">
                                    <div class="px-4 pb-4 pt-3">
                                        <div class="json-preview-box" id="jsonPreview">{}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- ── Form Actions ──────────────────────────────── -->
                            <div class="d-flex align-items-center justify-content-end gap-3">
                                <a href="${pageContext.request.contextPath}/workflows" class="btn btn-secondary px-4">
                                    <i class="fa fa-xmark me-1"></i>Cancel
                                </a>
                                <button type="button" class="btn btn-outline-secondary px-4" onclick="saveDraft()">
                                    <i class="fa fa-floppy-disk me-1"></i>Save as Draft
                                </button>
                                <button type="submit" class="btn btn-primary px-4" id="submitBtn">
                                    <c:choose>
                                        <c:when test="${formAction == 'create'}">
                                            <i class="fa fa-plus-circle me-1"></i>Create Workflow
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa fa-check-circle me-1"></i>Save Changes
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </div>

                        </form>
                </div>
            </div>
        </div>

        <%-- Safe data island --%>
            <script type="application/json"
                id="existingConfig"><c:out value="${workflow.workflowConfig}" escapeXml="false"/></script>

            <script>
                // ════════════════════════════════════════
                // STATE
                // ════════════════════════════════════════
                let selectedTrigger = 'TICKET_CREATED';
                let steps = [];
                let stepIdCounter = 0;

                const ROLES = ['Manager', 'Finance', 'IT Support', 'HR', 'Director', 'Security Team', 'Legal'];
                const ACTIONS = [
                    { value: 'APPROVE_REJECT', label: 'Approve / Reject', badgeClass: 'badge-approve' },
                    { value: 'REVIEW', label: 'Review Only', badgeClass: 'badge-review' },
                    { value: 'EXECUTE', label: 'Execute Task', badgeClass: 'badge-execute' },
                    { value: 'NOTIFY', label: 'Notify Only', badgeClass: 'badge-notify' },
                ];

                // Cache DOM refs that renderSteps() uses — must be BEFORE init() runs
                var _placeholder = document.getElementById('emptyStepsPlaceholder');
                var _addStepBtn = document.getElementById('addStepBtn');

                // ════════════════════════════════════════
                // INIT
                // ════════════════════════════════════════
                (function init() {
                    const dataEl = document.getElementById('existingConfig');
                    const raw = dataEl ? dataEl.textContent.trim() : '';
                    if (raw && raw !== 'null') {
                        try {
                            const cfg = JSON.parse(raw);
                            if (cfg.trigger) selectedTrigger = cfg.trigger;
                            if (Array.isArray(cfg.steps)) {
                                cfg.steps.forEach(function (s) {
                                    steps.push({
                                        id: ++stepIdCounter,
                                        name: s.name || '',
                                        role: s.role || ROLES[0],
                                        action: s.action || 'APPROVE_REJECT',
                                        sla_hours: s.sla_hours || 24
                                    });
                                });
                            }
                            if (cfg.notifications) {
                                ['on_create', 'on_approve', 'on_reject'].forEach(function (evt) {
                                    var arr = cfg.notifications[evt];
                                    if (Array.isArray(arr)) {
                                        arr.forEach(function (recipient) {
                                            var cb = document.querySelector('.notif-cb[data-event="' + evt + '"][data-recipient="' + recipient + '"]');
                                            if (cb) { cb.checked = true; toggleNotif(cb.closest('label'), cb); }
                                        });
                                    }
                                });
                            }
                        } catch (e) { }
                    }
                    renderTriggerSelection();
                    renderSteps();
                    updateJsonPreview();
                })();

                // ════════════════════════════════════════
                // TRIGGER
                // ════════════════════════════════════════
                function selectTrigger(el) {
                    document.querySelectorAll('.trigger-option').forEach(function (o) { o.classList.remove('selected'); });
                    el.classList.add('selected');
                    selectedTrigger = el.dataset.trigger;
                    updateJsonPreview();
                }
                function renderTriggerSelection() {
                    document.querySelectorAll('.trigger-option').forEach(function (o) {
                        if (o.dataset.trigger === selectedTrigger) o.classList.add('selected');
                    });
                }

                // ════════════════════════════════════════
                // STEPS
                // ════════════════════════════════════════
                function addStep() {
                    stepIdCounter++;
                    steps.push({ id: stepIdCounter, name: '', role: ROLES[0], action: 'APPROVE_REJECT', sla_hours: 24 });
                    renderSteps();
                    updateJsonPreview();
                }
                function removeStep(id) {
                    steps = steps.filter(function (s) { return s.id !== id; });
                    renderSteps();
                    updateJsonPreview();
                }
                function moveStep(id, dir) {
                    var idx = steps.findIndex(function (s) { return s.id === id; });
                    if (idx < 0) return;
                    var newIdx = idx + dir;
                    if (newIdx < 0 || newIdx >= steps.length) return;
                    var tmp = steps[idx]; steps[idx] = steps[newIdx]; steps[newIdx] = tmp;
                    renderSteps();
                    updateJsonPreview();
                }
                function updateStepField(id, field, value) {
                    var s = steps.find(function (s) { return s.id === id; });
                    if (s) {
                        s[field] = (field === 'sla_hours') ? (parseInt(value, 10) || 0) : value;
                    }
                    updateJsonPreview();
                }


                function renderSteps() {
                    var container = document.getElementById('stepsContainer');
                    var badge = document.getElementById('stepCountBadge');

                    badge.textContent = steps.length + ' step' + (steps.length !== 1 ? 's' : '');

                    if (steps.length === 0) {
                        // Re-attach placeholder in case innerHTML wiped it before
                        if (!_placeholder.parentNode || _placeholder.parentNode !== container) {
                            container.innerHTML = '';
                            container.appendChild(_placeholder);
                        }
                        _placeholder.style.display = '';
                        _addStepBtn.classList.add('d-none');
                        return;
                    }

                    // Has steps — hide placeholder, build step cards
                    _placeholder.style.display = 'none';
                    _addStepBtn.classList.remove('d-none');

                    var html = '';
                    steps.forEach(function (s, i) {
                        var actionInfo = ACTIONS.find(function (a) { return a.value === s.action; }) || ACTIONS[0];
                        var roleOptions = ROLES.map(function (r) {
                            return '<option value="' + r + '" ' + (s.role === r ? 'selected' : '') + '>' + r + '</option>';
                        }).join('');
                        var actionOptions = ACTIONS.map(function (a) {
                            return '<option value="' + a.value + '" ' + (s.action === a.value ? 'selected' : '') + '>' + a.label + '</option>';
                        }).join('');

                        var upBtn = i > 0
                            ? '<button type="button" class="btn btn-sm p-0 text-secondary" title="Move Up" onclick="moveStep(' + s.id + ', -1)"><i class="fa fa-chevron-up"></i></button>'
                            : '<span style="display:inline-block;width:22px;"></span>';
                        var downBtn = i < steps.length - 1
                            ? '<button type="button" class="btn btn-sm p-0 text-secondary" title="Move Down" onclick="moveStep(' + s.id + ', 1)"><i class="fa fa-chevron-down"></i></button>'
                            : '<span style="display:inline-block;width:22px;"></span>';
                        var connector = i < steps.length - 1
                            ? '<div class="step-connector my-1"></div>'
                            : '';

                        html +=
                            '<div class="step-card p-3 mb-2 d-flex align-items-start gap-3" data-step-id="' + s.id + '">' +
                            '<div class="d-flex flex-column align-items-center gap-1 pt-1">' +
                            '<div class="step-number">' + (i + 1) + '</div>' +
                            upBtn + downBtn +
                            '</div>' +
                            '<div class="flex-grow-1 row g-3">' +
                            '<div class="col-md-4">' +
                            '<label class="form-label text-secondary" style="font-size:11px;margin-bottom:4px;">STEP NAME</label>' +
                            '<input type="text" class="form-control form-control-sm" placeholder="e.g. Manager Approval"' +
                            ' value="' + escHtml(s.name) + '"' +
                            ' oninput="updateStepField(' + s.id + ', \'name\', this.value)" />' +
                            '</div>' +
                            '<div class="col-md-3">' +
                            '<label class="form-label text-secondary" style="font-size:11px;margin-bottom:4px;">ASSIGNED ROLE</label>' +
                            '<select class="form-select form-select-sm" onchange="updateStepField(' + s.id + ', \'role\', this.value)">' +
                            roleOptions +
                            '</select>' +
                            '</div>' +
                            '<div class="col-md-3">' +
                            '<label class="form-label text-secondary" style="font-size:11px;margin-bottom:4px;">ACTION TYPE</label>' +
                            '<select class="form-select form-select-sm" onchange="updateStepField(' + s.id + ', \'action\', this.value)">' +
                            actionOptions +
                            '</select>' +
                            '</div>' +
                            '<div class="col-md-2">' +
                            '<label class="form-label text-secondary" style="font-size:11px;margin-bottom:4px;">SLA (hours)</label>' +
                            '<input type="number" class="form-control form-control-sm" min="1" max="8760"' +
                            ' value="' + s.sla_hours + '"' +
                            ' oninput="updateStepField(' + s.id + ', \'sla_hours\', this.value)" />' +
                            '</div>' +
                            '<div class="col-12">' +
                            '<span class="action-badge ' + actionInfo.badgeClass + '">' + actionInfo.label + '</span>' +
                            '</div>' +
                            '</div>' +
                            '<button type="button" class="btn btn-sm btn-link text-danger p-0 mt-1 flex-shrink-0" title="Remove Step" onclick="removeStep(' + s.id + ')">' +
                            '<i class="fa fa-trash"></i>' +
                            '</button>' +
                            '</div>' + connector;
                    });

                    // Detach placeholder before wiping innerHTML, then re-insert hidden
                    if (_placeholder.parentNode === container) {
                        container.removeChild(_placeholder);
                    }
                    container.innerHTML = html;
                }

                // ════════════════════════════════════════
                // NOTIFICATIONS
                // ════════════════════════════════════════
                document.querySelectorAll('.notif-toggle').forEach(function (label) {
                    label.addEventListener('click', function () {
                        var cb = this.querySelector('.notif-cb');
                        cb.checked = !cb.checked;
                        toggleNotif(this, cb);
                    });
                });
                function toggleNotif(label, cb) {
                    if (cb.checked) label.classList.add('active');
                    else label.classList.remove('active');
                    updateJsonPreview();
                }
                function getNotifications() {
                    var notifs = { on_create: [], on_approve: [], on_reject: [] };
                    document.querySelectorAll('.notif-cb:checked').forEach(function (cb) {
                        if (notifs[cb.dataset.event]) notifs[cb.dataset.event].push(cb.dataset.recipient);
                    });
                    return notifs;
                }

                // ════════════════════════════════════════
                // JSON BUILD
                // ════════════════════════════════════════
                function buildConfig() {
                    return {
                        trigger: selectedTrigger,
                        steps: steps.map(function (s, i) {
                            return { order: i + 1, name: s.name || ('Step ' + (i + 1)), role: s.role, action: s.action, sla_hours: s.sla_hours };
                        }),
                        notifications: getNotifications()
                    };
                }
                function updateJsonPreview() {
                    var json = JSON.stringify(buildConfig(), null, 2);
                    document.getElementById('jsonPreview').textContent = json;
                    document.getElementById('workflowConfigHidden').value = json;
                }

                // ════════════════════════════════════════
                // STATUS HINT
                // ════════════════════════════════════════
                var statusSelect = document.getElementById('status');
                var statusHint = document.getElementById('statusHint');
                var hints = {
                    DRAFT: { cls: 'alert-secondary', icon: 'fa-pencil', text: '<strong>Draft:</strong> Not yet active. The workflow won\'t run until set to Active.' },
                    ACTIVE: { cls: 'alert-success', icon: 'fa-circle-play', text: '<strong>Active:</strong> Live — will be applied to new tickets automatically.' },
                    INACTIVE: { cls: 'alert-warning', icon: 'fa-circle-pause', text: '<strong>Inactive:</strong> Paused — will not trigger for new tickets.' }
                };
                function updateStatusHint() {
                    var h = hints[statusSelect.value];
                    if (h) {
                        statusHint.innerHTML =
                            '<div class="alert ' + h.cls + ' d-flex align-items-center gap-2 p-2 mb-0" role="alert">' +
                            '<i class="fa ' + h.icon + ' flex-shrink-0"></i>' +
                            '<small>' + h.text + '</small></div>';
                    } else { statusHint.innerHTML = ''; }
                }
                statusSelect.addEventListener('change', updateStatusHint);
                updateStatusHint();

                // ════════════════════════════════════════
                // CHAR COUNTER
                // ════════════════════════════════════════
                var descArea = document.getElementById('description');
                var charCount = document.getElementById('descCharCount');
                function updateCharCount() {
                    var len = descArea.value.length;
                    charCount.textContent = len;
                    charCount.style.color = len > 480 ? '#ef4444' : '';
                }
                descArea.addEventListener('input', updateCharCount);
                updateCharCount();

                // ════════════════════════════════════════
                // SAVE AS DRAFT
                // ════════════════════════════════════════
                function saveDraft() {
                    document.getElementById('status').value = 'DRAFT';
                    document.getElementById('workflowForm').requestSubmit();
                }

                // ════════════════════════════════════════
                // FORM SUBMIT
                // ════════════════════════════════════════
                var submitBtn = document.getElementById('submitBtn');
                var submitBtnOrigHTML = submitBtn.innerHTML;

                document.getElementById('workflowForm').addEventListener('submit', function (e) {
                    updateJsonPreview();
                    if (!this.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                        this.classList.add('was-validated');
                        return;
                    }
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving…';
                    setTimeout(function () {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = submitBtnOrigHTML;
                    }, 15000);
                });

                window.addEventListener('pageshow', function (e) {
                    if (e.persisted) {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = submitBtnOrigHTML;
                    }
                });

                // ════════════════════════════════════════
                // UTILS
                // ════════════════════════════════════════
                function escHtml(str) {
                    if (!str) return '';
                    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
                }
            </script>

            <jsp:include page="/WEB-INF/views/layout/footer.jsp" />