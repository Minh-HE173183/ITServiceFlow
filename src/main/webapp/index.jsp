<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <jsp:include page="/WEB-INF/views/layout/header.jsp">
        <jsp:param name="pageTitle" value="Dashboard" />
        <jsp:param name="activeNav" value="dashboard" />
    </jsp:include>

    <!-- Topbar -->
    <div class="topbar d-flex align-items-center px-4">
        <div class="flex-grow-1">
            <div class="topbar-title">Dashboard</div>
            <div class="topbar-sub">Welcome back, <span class="bc-current">Administrator</span></div>
        </div>
        <span class="text-secondary" style="font-size:13px;">
            <i class="bi bi-calendar3 me-1"></i>
            <span id="todayDate"></span>
        </span>
    </div>

    <div class="flex-grow-1 p-4">

        <!-- Hero banner -->
        <div class="rounded-4 p-4 mb-4 d-flex align-items-center gap-4" style="background:linear-gradient(135deg,rgba(124,58,237,.25),rgba(79,70,229,.15));
                border:1px solid rgba(124,58,237,.3);">
            <div class="d-none d-md-flex align-items-center justify-content-center rounded-3 flex-shrink-0"
                style="width:64px;height:64px;background:rgba(124,58,237,.3);font-size:30px;">
                ⚡
            </div>
            <div>
                <h2 class="fw-bold text-white mb-1" style="font-size:20px;">ITServiceFlow ITSM Platform</h2>
                <p class="text-secondary mb-3" style="font-size:13.5px;">
                    ITIL-compliant service management — manage incidents, service requests, problems,
                    changes and workflows from one place.
                </p>
                <a href="${pageContext.request.contextPath}/workflows"
                    class="btn btn-primary btn-sm d-inline-flex align-items-center gap-2">
                    <i class="bi bi-diagram-3-fill"></i> Manage Workflows
                </a>
            </div>
        </div>

        <!-- Quick-nav cards -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-4 col-lg-3">
                <a href="${pageContext.request.contextPath}/workflows"
                    class="stat-card p-3 d-flex flex-column gap-2 text-decoration-none" style="height:100%;">
                    <div class="stat-icon-wrap bg-primary bg-opacity-10" style="font-size:22px;">
                        <i class="bi bi-diagram-3-fill text-primary"></i>
                    </div>
                    <div class="fw-semibold text-white" style="font-size:14px;">Workflows</div>
                    <div class="text-secondary" style="font-size:12px;">Design &amp; manage approval flows</div>
                </a>
            </div>
            <div class="col-6 col-md-4 col-lg-3">
                <div class="stat-card p-3 d-flex flex-column gap-2" style="height:100%;cursor:default;">
                    <div class="stat-icon-wrap" style="background:rgba(16,185,129,.15);font-size:22px;">
                        <i class="bi bi-ticket-perforated-fill text-success"></i>
                    </div>
                    <div class="fw-semibold text-white" style="font-size:14px;">Tickets</div>
                    <div class="text-secondary" style="font-size:12px;">Incidents &amp; service requests</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-3">
                <div class="stat-card p-3 d-flex flex-column gap-2" style="height:100%;cursor:default;">
                    <div class="stat-icon-wrap" style="background:rgba(245,158,11,.15);font-size:22px;">
                        <i class="bi bi-clock-history text-warning"></i>
                    </div>
                    <div class="fw-semibold text-white" style="font-size:14px;">SLA Policies</div>
                    <div class="text-secondary" style="font-size:12px;">Response &amp; resolution targets</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-3">
                <div class="stat-card p-3 d-flex flex-column gap-2" style="height:100%;cursor:default;">
                    <div class="stat-icon-wrap" style="background:rgba(59,130,246,.15);font-size:22px;">
                        <i class="bi bi-book-fill text-info"></i>
                    </div>
                    <div class="fw-semibold text-white" style="font-size:14px;">Knowledge Base</div>
                    <div class="text-secondary" style="font-size:12px;">Articles &amp; known errors</div>
                </div>
            </div>
        </div>

        <!-- Module status -->
        <div class="workflow-card">
            <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom border-secondary-subtle">
                <i class="bi bi-check2-all text-success"></i>
                <span class="fw-bold">Implemented Modules</span>
            </div>
            <div class="table-responsive">
                <table class="table table-dark table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Module</th>
                            <th>Features</th>
                            <th>Status</th>
                            <th>Link</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="fw-semibold"><i class="bi bi-diagram-3-fill text-primary me-2"></i>Workflow
                                Management</td>
                            <td class="text-secondary" style="font-size:12.5px;">List · Detail · Create · Edit · Delete
                                · Enable/Disable</td>
                            <td><span class="badge-status badge-active">ACTIVE</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/workflows"
                                    class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1">
                                    <i class="bi bi-arrow-right-circle"></i> Open
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td class="fw-semibold text-secondary"><i
                                    class="bi bi-ticket-perforated text-secondary me-2"></i>Ticket Management</td>
                            <td class="text-secondary" style="font-size:12.5px;">Create · Assign · Resolve · Close</td>
                            <td><span class="badge-status badge-draft">PLANNED</span></td>
                            <td><span class="text-secondary" style="font-size:12px;">Coming soon</span></td>
                        </tr>
                        <tr>
                            <td class="fw-semibold text-secondary"><i
                                    class="bi bi-shield-check text-secondary me-2"></i>SLA Management</td>
                            <td class="text-secondary" style="font-size:12.5px;">Policies · Breach alerts · Escalation
                            </td>
                            <td><span class="badge-status badge-draft">PLANNED</span></td>
                            <td><span class="text-secondary" style="font-size:12px;">Coming soon</span></td>
                        </tr>
                        <tr>
                            <td class="fw-semibold text-secondary"><i
                                    class="bi bi-hdd-network text-secondary me-2"></i>CMDB</td>
                            <td class="text-secondary" style="font-size:12.5px;">CI registry · Relationships · Impact
                                maps</td>
                            <td><span class="badge-status badge-draft">PLANNED</span></td>
                            <td><span class="text-secondary" style="font-size:12px;">Coming soon</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div><%-- /.page-body --%>

        <script>
            document.getElementById('todayDate').textContent = new Date().toLocaleDateString('en-GB', {
                weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
            });
        </script>

        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />