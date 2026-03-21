<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.google.gson.Gson" %>
        <%@ page import="java.util.List" %>
            <% Gson gson=new Gson(); %>
                <%@ include file="/common/admin-layout-top.jsp" %>

                    <!-- Font Awesome 6 -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
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

                    <div class="breadcrumb-custom">
                        <i class="bi bi-house-door me-1"></i> Trang chủ &gt;
                        <a href="${pageContext.request.contextPath}/workflows"
                            class="text-decoration-none text-secondary">Quản lý Workflow</a>
                        &gt;
                        <c:choose>
                            <c:when test="${formAction == 'create'}">Tạo mới</c:when>
                            <c:otherwise>
                                <c:out value="${workflow.workflowName}" />
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0 fw-bold">
                            <c:choose>
                                <c:when test="${formAction == 'create'}"><i
                                        class="bi bi-plus-circle me-2 text-primary"></i>Tạo Workflow mới</c:when>
                                <c:otherwise><i class="bi bi-pencil-square me-2 text-warning"></i>Chỉnh sửa Workflow
                                </c:otherwise>
                            </c:choose>
                        </h5>
                        <a href="${pageContext.request.contextPath}/workflows" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>

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
                            value="${sessionScope.user != null ? sessionScope.user.userId : ''}" />
                        <input type="hidden" name="workflowConfig" id="workflowConfigHidden" />

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
                                        <input type="text" id="workflowName" name="workflowName" class="form-control"
                                            placeholder="IT Equipment Purchase Approval"
                                            value="<c:out value='${workflow.workflowName}'/>" maxlength="255"
                                            required />
                                        <div class="invalid-feedback">Workflow name is required.</div>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label" for="description">Description</label>
                                        <textarea id="description" name="description" class="form-control" rows="3"
                                            placeholder="Describe what this workflow does…"><c:out value="${workflow.description}"/></textarea>
                                        <div class="form-text text-secondary mt-1"><span id="descCharCount">0</span>/500
                                            characters</div>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="form-label" for="status">Status <span
                                                class="text-danger">*</span></label>
                                        <select id="status" name="status" class="form-select" required>
                                            <option value="DRAFT" <c:if
                                                test="${workflow.status == 'DRAFT' || empty workflow.status}">selected
                                                </c:if>>Draft</option>
                                            <option value="ACTIVE" <c:if test="${workflow.status == 'ACTIVE'}">selected
                                                </c:if>>Active</option>
                                            <option value="INACTIVE" <c:if test="${workflow.status == 'INACTIVE'}">
                                                selected</c:if>>Inactive</option>
                                        </select>
                                        <div id="statusHint" class="mt-2"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="workflow-card mb-4">
                            <div class="card-header-bar d-flex align-items-center gap-2 px-4 py-3">
                                <i class="fa fa-bolt text-warning"></i>
                                <span class="fw-bold">Trigger</span>
                            </div>
                            <div class="p-4">
                                <div class="row g-3" id="triggerOptions">
                                    <div class="col-sm-6 col-lg-3">
                                        <div class="trigger-option" data-trigger="TICKET_CREATED"
                                            onclick="selectTrigger(this)">
                                            <div class="trigger-icon"><i class="fa fa-ticket"></i></div>
                                            <div class="fw-semibold text-dark" style="font-size:13px;">Ticket Created
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 col-lg-3">
                                        <div class="trigger-option" data-trigger="TICKET_UPDATED"
                                            onclick="selectTrigger(this)">
                                            <div class="trigger-icon"><i class="fa fa-pen-to-square"></i></div>
                                            <div class="fw-semibold text-dark" style="font-size:13px;">Ticket Updated
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 col-lg-3">
                                        <div class="trigger-option" data-trigger="SLA_BREACH"
                                            onclick="selectTrigger(this)">
                                            <div class="trigger-icon"><i class="fa fa-clock"></i></div>
                                            <div class="fw-semibold text-dark" style="font-size:13px;">SLA Breach</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="workflow-card mb-4" id="conditionsCard" style="display:none;">
                            <div class="card-header-bar d-flex align-items-center justify-content-between px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="fa fa-filter text-info"></i>
                                    <span class="fw-bold">Trigger Conditions</span>
                                    <span class="badge bg-info ms-1" id="conditionCountBadge"
                                        style="font-size:10px;">All tickets</span>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="addCondition()"><i
                                        class="bi bi-plus-circle me-1"></i>Add Condition</button>
                            </div>
                            <div class="p-4">
                                <div id="conditionsContainer">
                                    <div class="text-center py-2 text-muted" id="noConditionsMsg">
                                        <small><i class="fa fa-info-circle me-1"></i> No conditions set.</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="workflow-card mb-4">
                            <div class="card-header-bar d-flex align-items-center justify-content-between px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="fa fa-list-ol text-success"></i>
                                    <span class="fw-bold">Approval Steps</span>
                                    <span class="badge bg-success ms-1" id="stepCountBadge" style="font-size:10px;">0
                                        steps</span>
                                </div>
                                <button type="button" class="btn btn-sm btn-primary" onclick="addStep()"><i
                                        class="fa fa-plus me-1"></i>Add Step</button>
                            </div>
                            <div class="p-4">
                                <div id="stepsContainer">
                                    <div class="empty-steps-placeholder" id="emptyStepsPlaceholder">
                                        <div class="fw-semibold">No steps added yet</div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-add-step w-100 mt-3 py-2 d-none" id="addStepBtn"
                                    onclick="addStep()">
                                    <i class="fa fa-plus-circle me-2"></i>Add Another Step
                                </button>
                            </div>
                        </div>

<!--                        <div class="workflow-card mb-4">
            <div class="card-header-bar d-flex align-items-center justify-content-between px-4 py-3"
                style="cursor:pointer;" data-bs-toggle="collapse" data-bs-target="#jsonPreviewCollapse">
                <div class="d-flex align-items-center gap-2">
                    <i class="fa fa-code text-secondary"></i>
                    <span class="text-secondary fw-semibold" style="font-size:13px;">Preview Generated
                        JSON</span>
                </div>
                <i class="fa fa-chevron-down text-secondary"></i>
            </div>
            <div class="collapse" id="jsonPreviewCollapse">
                <div class="px-4 pb-4 pt-3">
                    <div class="json-preview-box" id="jsonPreview">{}</div>
                </div>
            </div>
        </div>-->

                        <div class="d-flex align-items-center justify-content-end gap-3">
                            <a href="${pageContext.request.contextPath}/workflows" class="btn btn-secondary px-4"><i
                                    class="fa fa-xmark me-1"></i>Cancel</a>
                            <button type="button" class="btn btn-outline-secondary px-4" onclick="saveDraft()"><i
                                    class="fa fa-floppy-disk me-1"></i>Save as Draft</button>
                            <button type="submit" class="btn btn-primary px-4" id="submitBtn"><i
                                    class="fa fa-check-circle me-1"></i>Save</button>
                        </div>
                    </form>

                    <%-- Data Islands --%>
                        <script type="application/json"
                            id="existingConfig"><c:out value="${workflow.workflowConfig}" escapeXml="false"/></script>
                        <script type="application/json" id="metaTicketTypes"><%
List<?> _tt = (List<?>) request.getAttribute("ticketTypes");
if (_tt == null) _tt = List.of("INCIDENT","SERVICE_REQUEST","PROBLEM","CHANGE");
out.print(gson.toJson(_tt));
    %></script>
                        <script type="application/json" id="metaPriorities"><%
List<?> _pr = (List<?>) request.getAttribute("priorities");
if (_pr == null) _pr = List.of("LOW","MEDIUM","HIGH","CRITICAL");
out.print(gson.toJson(_pr));
    %></script>
                        <script type="application/json" id="metaCategories"><%
    List<?> _cats = (List<?>) request.getAttribute("categories");
    if (_cats == null) _cats = List.of();
    out.print(gson.toJson(_cats));
    %></script>

                        <script>
                            // STATE
                            let selectedTrigger = 'TICKET_CREATED';
                            let steps = [];
                            let conditions = [];
                            let conditionLogic = 'AND';
                            let stepIdCounter = 0;
                            let conditionIdCounter = 0;
                            let TICKET_TYPES = [];
                            let PRIORITIES = [];
                            let CATEGORIES = [];

                            // INIT DATA FROM ISLANDS
                            try {
                                TICKET_TYPES = JSON.parse(document.getElementById('metaTicketTypes').textContent.trim() || '[]');
                                PRIORITIES = JSON.parse(document.getElementById('metaPriorities').textContent.trim() || '[]');
                                CATEGORIES = JSON.parse(document.getElementById('metaCategories').textContent.trim() || '[]');
                            } catch (e) {
                                console.error('Error parsing metadata islands:', e);
                            }

                            const ROLES = ['Manager', 'Finance', 'IT Support', 'HR', 'Director', 'Security Team', 'Legal'];
                            const ACTIONS = [
                                { value: 'APPROVE_REJECT', label: 'Approve / Reject', badgeClass: 'badge-approve' },
                                { value: 'REVIEW', label: 'Review Only', badgeClass: 'badge-review' },
                                { value: 'EXECUTE', label: 'Execute Task', badgeClass: 'badge-execute' },
                                { value: 'NOTIFY', label: 'Notify Only', badgeClass: 'badge-notify' },
                            ];

                            var _placeholder = document.getElementById('emptyStepsPlaceholder');
                            var _addStepBtn = document.getElementById('addStepBtn');

                            (function init() {
                                const dataEl = document.getElementById('existingConfig');
                                const raw = dataEl ? dataEl.textContent.trim() : '';
                                if (raw && raw !== 'null') {
                                    try {
                                        const cfg = JSON.parse(raw);
                                        if (cfg.trigger)
                                            selectedTrigger = cfg.trigger;
                                        if (cfg.conditions) {
                                            conditionLogic = cfg.conditions.logic || 'AND';
                                            (cfg.conditions.criteria || []).forEach(c => {
                                                conditions.push({ id: ++conditionIdCounter, field: c.field, operator: c.operator || 'EQUALS', value: c.value });
                                            });
                                        }
                                        if (Array.isArray(cfg.steps)) {
                                                cfg.steps.forEach(s => {
                                                    // If action is NOTIFY, SLA should always be 0 and not editable
                                                    const actionVal = s.action || 'APPROVE_REJECT';
                                                    const slaVal = (actionVal === 'NOTIFY') ? 0 : (s.sla_hours || 24);
                                                    steps.push({ id: ++stepIdCounter, name: s.name || '', role: s.role || ROLES[0], action: actionVal, sla_hours: slaVal });
                                                });
                                            }
                                    } catch (e) {
                                    }
                                }
                                renderTriggerSelection();
                                renderConditions();
                                renderSteps();
                                updateJsonPreview();
                                updateTriggerUI();
                                loadTicketTypesFromApi();
                            })();

                            function loadTicketTypesFromApi() {
                                var ctxMeta = document.querySelector('meta[name="ctx-path"]');
                                var ctx = ctxMeta ? ctxMeta.getAttribute('content') : '';
                                fetch(ctx + '/workflows?action=api-ticket-types')
                                    .then(res => res.ok ? res.json() : [])
                                    .then(data => {
                                        if (Array.isArray(data) && data.length > 0) {
                                            TICKET_TYPES = data;
                                            renderConditions();
                                        }
                                    }).catch(() => {
                                    });
                            }

                            function selectTrigger(el) {
                                document.querySelectorAll('.trigger-option').forEach(o => o.classList.remove('selected'));
                                el.classList.add('selected');
                                selectedTrigger = el.dataset.trigger;
                                updateTriggerUI();
                                updateJsonPreview();
                            }

                            function updateTriggerUI() {
                                const card = document.getElementById('conditionsCard');
                                card.style.display = ['TICKET_CREATED', 'TICKET_UPDATED', 'SLA_BREACH'].includes(selectedTrigger) ? 'block' : 'none';
                            }

                            function renderTriggerSelection() {
                                document.querySelectorAll('.trigger-option').forEach(o => {
                                    if (o.dataset.trigger === selectedTrigger)
                                        o.classList.add('selected');
                                });
                                updateTriggerUI();
                            }

                            function addCondition() {
                                conditionIdCounter++;
                                const nextField = conditions.length === 0 ? 'ticket_type' : (conditions.length === 1 ? 'priority' : 'category_id');
                                conditions.push({ id: conditionIdCounter, field: nextField, operator: 'EQUALS', value: '' });
                                renderConditions();
                                updateJsonPreview();
                            }

                            function removeCondition(id) {
                                conditions = conditions.filter(c => c.id !== id);
                                renderConditions();
                                updateJsonPreview();
                            }

                            function updateCondition(id, field, value) {
                                const c = conditions.find(c => c.id === id);
                                if (c) {
                                    c[field] = value;
                                    if (field === 'field')
                                        c.value = '';
                                }
                                if (field === 'field')
                                    renderConditions();
                                updateJsonPreview();
                            }

                            function renderConditions() {
                                const container = document.getElementById('conditionsContainer');
                                const badge = document.getElementById('conditionCountBadge');
                                if (conditions.length === 0) {
                                    container.innerHTML = '<div class="text-center py-4 text-secondary opacity-50"><small>No conditions set.</small></div>';
                                    badge.textContent = 'All tickets';
                                    return;
                                }
                                badge.textContent = conditions.length + (conditions.length === 1 ? ' condition' : ' conditions');
                                let html = '';
                                if (conditions.length > 1) {
                                    html += `<div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom border-secondary-subtle">
<span class="text-secondary small">Match</span>
<select class="form-select form-select-sm fw-bold border-secondary-subtle" style="width: auto;" onchange="conditionLogic = this.value; updateJsonPreview();">
<option value="AND" \${conditionLogic === 'AND' ? 'selected' : ''}>ALL (AND)</option>
<option value="OR" \${conditionLogic === 'OR' ? 'selected' : ''}>ANY (OR)</option>
</select>
<span class="text-secondary small">of the following conditions:</span>
</div>`;
                                }
                                html += '<div class="conditions-list">';
                                conditions.forEach(c => html += renderConditionRow(c));
                                html += '</div>';
                                container.innerHTML = html;
                            }

                            function renderConditionRow(c) {
                                const fieldOptions = [
                                    { value: 'ticket_type', label: 'Ticket Type' },
                                    { value: 'priority', label: 'Priority' },
                                    { value: 'category_id', label: 'Category' }
                                ].map(f => `<option value="\${f.value}" \${c.field === f.value ? 'selected' : ''}>\${f.label}</option>`).join('');

                                const operatorOptions = [
                                    { value: 'EQUALS', label: 'is' },
                                    { value: 'NOT_EQUALS', label: 'is not' }
                                ].map(o => `<option value="\${o.value}" \${c.operator === o.value ? 'selected' : ''}>\${o.label}</option>`).join('');

                                let valueInput = '';
                                if (c.field === 'ticket_type') {
                                    valueInput = `<select class="form-select form-select-sm" onchange="updateCondition(\${c.id}, 'value', this.value)">
<option value="">-- Type --</option>
\${TICKET_TYPES.map(t => '<option value="' + t + '"' + (c.value === t ? ' selected' : '') + '>' + t + '</option>').join('')}
</select>`;
                                } else if (c.field === 'priority') {
                                    valueInput = `<select class="form-select form-select-sm" onchange="updateCondition(\${c.id}, 'value', this.value)">
<option value="">-- Priority --</option>
\${PRIORITIES.map(p => '<option value="' + p + '"' + (c.value === p ? ' selected' : '') + '>' + p + '</option>').join('')}
</select>`;
                                } else if (c.field === 'category_id') {
                                    valueInput = `<select class="form-select form-select-sm" onchange="updateCondition(\${c.id}, 'value', this.value)">
<option value="">-- Category --</option>
\${CATEGORIES.map(cat => '<option value="' + cat.categoryId + '"' + (c.value == cat.categoryId ? ' selected' : '') + '>' + cat.categoryName + '</option>').join('')}
</select>`;
                                }

                                return `<div class="row g-2 mb-2 align-items-center condition-row p-2 border border-secondary-subtle rounded bg-light bg-opacity-10">
<div class="col-md-3">
<select class="form-select form-select-sm" onchange="updateCondition(\${c.id}, 'field', this.value)">\${fieldOptions}</select>
</div>
<div class="col-md-2">
<select class="form-select form-select-sm" onchange="updateCondition(\${c.id}, 'operator', this.value)">\${operatorOptions}</select>
</div>
<div class="col-md-6">\${valueInput}</div>
<div class="col-md-1 text-end">
<button type="button" class="btn btn-sm text-danger" onclick="removeCondition(\${c.id})"><i class="bi bi-trash"></i></button>
</div>
</div>`;
                            }

                            function addStep() {
                                stepIdCounter++;
                                steps.push({ id: stepIdCounter, name: '', role: ROLES[0], action: 'APPROVE_REJECT', sla_hours: 24 });
                                renderSteps();
                                updateJsonPreview();
                            }

                            function renderSteps() {
                                var container = document.getElementById('stepsContainer');
                                var badge = document.getElementById('stepCountBadge');
                                badge.textContent = steps.length + ' step' + (steps.length !== 1 ? 's' : '');
                                if (steps.length === 0) {
                                    container.innerHTML = '<div class="empty-steps-placeholder"><div class="fw-semibold">No steps added yet</div></div>';
                                    _addStepBtn.classList.add('d-none');
                                    return;
                                }
                                _addStepBtn.classList.remove('d-none');
                                let html = '';
                                steps.forEach(function(s, i) {
                                    var roleOptions = ROLES.map(function(r) { return '<option value="' + r + '"' + (s.role === r ? ' selected' : '') + '>' + r + '</option>'; }).join('');
                                    var actionOptions = ACTIONS.map(function(a) { return '<option value="' + a.value + '"' + (a.value === s.action ? ' selected' : '') + '>' + a.label + '</option>'; }).join('');
                                    var upBtn = i > 0 ? '<button type="button" class="btn btn-sm p-0 text-secondary" title="Move Up" onclick="moveStep(' + s.id + ', -1)"><i class="fa fa-chevron-up"></i></button>' : '<span style="display:inline-block;width:22px;"></span>';
                                    var downBtn = i < steps.length - 1 ? '<button type="button" class="btn btn-sm p-0 text-secondary" title="Move Down" onclick="moveStep(' + s.id + ', 1)"><i class="fa fa-chevron-down"></i></button>' : '<span style="display:inline-block;width:22px;"></span>';
                                    // SLA input is not editable for NOTIFY-only steps; show disabled 0
                                    var slaHtml = '';
                                    if (String(s.action).toUpperCase() === 'NOTIFY') {
                                        slaHtml = '<div class="col-md-2"><input type="number" class="form-control form-control-sm" value="0" disabled /></div>';
                                    } else {
                                        slaHtml = '<div class="col-md-2"><input type="number" class="form-control form-control-sm" value="' + s.sla_hours + '" oninput="updateStepField(' + s.id + ', \'sla_hours\', this.value)" /></div>';
                                    }
                                    html += '<div class="step-card p-3 mb-2 d-flex align-items-start gap-3">'
                                        + '<div class="d-flex flex-column align-items-center gap-1">'
                                        + '<div class="step-number">' + (i + 1) + '</div>'
                                        + upBtn + ' ' + downBtn
                                        + '</div>'
                                        + '<div class="flex-grow-1 row g-3">'
                                        + '<div class="col-md-4"><input type="text" class="form-control form-control-sm" placeholder="Step Name" value="' + escHtml(s.name) + '" oninput="updateStepField(' + s.id + ', \'name\', this.value)" /></div>'
                                        + '<div class="col-md-3"><select class="form-select form-select-sm" onchange="updateStepField(' + s.id + ', \'role\', this.value)">' + roleOptions + '</select></div>'
                                        + '<div class="col-md-3"><select class="form-select form-select-sm" onchange="updateStepField(' + s.id + ', \'action\', this.value)">' + actionOptions + '</select></div>'
                                        + slaHtml
                                        + '</div>'
                                        + '<button type="button" class="btn btn-sm text-danger" onclick="removeStep(' + s.id + ')"><i class="fa fa-trash"></i></button>'
                                        + '</div>';
                                });
                                container.innerHTML = html;
                            }

                            function updateStepField(id, field, value) {
                                var s = steps.find(s => s.id === id);
                                if (s) {
                                    if (field === 'action') {
                                        s[field] = value;
                                        // If switched to NOTIFY, SLA must be 0 and not editable
                                        if (String(value).toUpperCase() === 'NOTIFY') {
                                            s.sla_hours = 0;
                                        } else {
                                            // If previously 0 due to NOTIFY, reset to reasonable default
                                            if (!s.sla_hours || s.sla_hours === 0) s.sla_hours = 24;
                                        }
                                        // Re-render steps so SLA input shows/hides correctly
                                        renderSteps();
                                        updateJsonPreview();
                                        return;
                                    }
                                    if (field === 'sla_hours') {
                                        s[field] = parseInt(value, 10) || 0;
                                    } else {
                                        s[field] = value;
                                    }
                                }
                                updateJsonPreview();
                            }
                            function removeStep(id) {
                                steps = steps.filter(s => s.id !== id);
                                renderSteps();
                                updateJsonPreview();
                            }
                            function moveStep(id, dir) {
                                var idx = steps.findIndex(s => s.id === id);
                                if (idx < 0)
                                    return;
                                var newIdx = idx + dir;
                                if (newIdx < 0 || newIdx >= steps.length)
                                    return;
                                var tmp = steps[idx];
                                steps[idx] = steps[newIdx];
                                steps[newIdx] = tmp;
                                renderSteps();
                                updateJsonPreview();
                            }

                            function buildConfig() {
                                return {
                                    trigger: selectedTrigger,
                                    conditions: { type: 'group', logic: conditionLogic, criteria: conditions.map(c => ({ type: 'condition', field: c.field, operator: c.operator, value: c.value })) },
                                    steps: steps.map(s => ({ name: s.name, role: s.role, action: s.action, sla_hours: s.sla_hours }))
                                };
                            }
                            function updateJsonPreview() {
                                var json = JSON.stringify(buildConfig(), null, 2);
                                // Update preview if present (the preview panel may be commented out)
                                var previewEl = document.getElementById('jsonPreview');
                                if (previewEl) {
                                    previewEl.textContent = json;
                                }
                                // Always update the hidden input so server receives the config
                                var hidden = document.getElementById('workflowConfigHidden');
                                if (hidden) {
                                    hidden.value = json;
                                }
                            }

                            var statusSelect = document.getElementById('status');
                            function updateStatusHint() {
                                const h = { DRAFT: 'Draft: Not yet active.', ACTIVE: 'Active: Live.', INACTIVE: 'Inactive: Paused.' }[statusSelect.value];
                                document.getElementById('statusHint').innerHTML = h ? `<div class="alert alert-info p-2 small">\${h}</div>` : '';
                            }
                            statusSelect.addEventListener('change', updateStatusHint);
                            updateStatusHint();

                            var descArea = document.getElementById('description');
                            var charCount = document.getElementById('descCharCount');
                            function updateCharCount() {
                                var len = descArea.value.length;
                                charCount.textContent = len;
                                charCount.style.color = len > 480 ? '#ef4444' : '';
                            }
                            descArea.addEventListener('input', updateCharCount);
                            updateCharCount();

                            document.getElementById('workflowForm').addEventListener('submit', function (e) {
                                updateJsonPreview();
                                if (!this.checkValidity()) {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    this.classList.add('was-validated');
                                    return;
                                }
                                var btn = document.getElementById('submitBtn');
                                btn.disabled = true;
                                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
                            });

                            function saveDraft() {
                                document.getElementById('status').value = 'DRAFT';
                                document.getElementById('workflowForm').requestSubmit();
                            }
                            function escHtml(str) {
                                return str ? String(str).replace(/[&<>"']/g, m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m])) : '';
                            }
                        </script>

                        <jsp:include page="/common/admin-layout-bottom.jsp" />