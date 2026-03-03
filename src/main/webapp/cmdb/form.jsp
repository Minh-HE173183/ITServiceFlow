<jsp:include page="/includes/header.jsp" />

<div class="container-fluid bg-white p-4 rounded shadow-sm" style="max-width: 900px; margin: auto;">
    <h2 class="h4 text-primary mb-4 border-bottom pb-2">${not empty ci ? 'Update Configuration Item' : 'Register New
        Configuration Item'}</h2>

    <form action="${pageContext.request.contextPath}/cmdb?action=${not empty ci ? 'update' : 'insert'}" method="post">
        <c:if test="${not empty ci}">
            <input type="hidden" name="id" value="${ci.ciId}">
        </c:if>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="ciName" class="form-label fw-bold">CI Name / Hostname <span
                        class="text-danger">*</span></label>
                <input type="text" class="form-control" id="ciName" name="ciName" value="${ci.ciName}" required>
            </div>
            <div class="col-md-6">
                <label for="ciTypeId" class="form-label fw-bold">CI Type ID <span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="ciTypeId" name="ciTypeId"
                    value="${ci.ciTypeId == 0 ? 3 : ci.ciTypeId}" required min="1" max="8">
                <div class="form-text">(1: Desktop, 2: Laptop, 3: Server, 4: Switch, etc.)</div>
            </div>
        </div>

        <c:if test="${not empty ci}">
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="status" class="form-label fw-bold">Lifecycle Status</label>
                    <select class="form-select" id="status" name="status">
                        <option value="ACTIVE" ${ci.status=='ACTIVE' ? 'selected' : '' }>Active</option>
                        <option value="INACTIVE" ${ci.status=='INACTIVE' ? 'selected' : '' }>Inactive</option>
                        <option value="RETIRED" ${ci.status=='RETIRED' ? 'selected' : '' }>Retired</option>
                        <option value="UNDER_MAINTENANCE" ${ci.status=='UNDER_MAINTENANCE' ? 'selected' : '' }>Under
                            Maintenance</option>
                    </select>
                </div>
            </div>
        </c:if>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="ipAddress" class="form-label fw-bold">IP Address</label>
                <input type="text" class="form-control" id="ipAddress" name="ipAddress" value="${ci.ipAddress}"
                    placeholder="192.168.1.xxx">
            </div>
            <div class="col-md-6">
                <label for="location" class="form-label fw-bold">Datacenter / Location</label>
                <input type="text" class="form-control" id="location" name="location" value="${ci.location}">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="manufacturer" class="form-label fw-bold">Manufacturer</label>
                <input type="text" class="form-control" id="manufacturer" name="manufacturer" value="${ci.manufacturer}"
                    placeholder="Dell, Cisco, VMware...">
            </div>
            <div class="col-md-6">
                <label for="model" class="form-label fw-bold">Model</label>
                <input type="text" class="form-control" id="model" name="model" value="${ci.model}">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="serialNumber" class="form-label fw-bold">Serial Number / Service Tag</label>
                <input type="text" class="form-control" id="serialNumber" name="serialNumber"
                    value="${ci.serialNumber}">
            </div>
            <div class="col-md-6">
                <label for="ownerId" class="form-label fw-bold">Owner User ID</label>
                <input type="number" class="form-control" id="ownerId" name="ownerId" value="${ci.ownerId}"
                    placeholder="Leave blank if unassigned">
            </div>
        </div>

        <div class="mb-4">
            <label for="description" class="form-label fw-bold">Notes & Description</label>
            <textarea class="form-control" id="description" name="description" rows="3">${ci.description}</textarea>
        </div>

        <div class="d-grid gap-2 mt-4">
            <button type="submit" class="btn btn-primary btn-lg">
                <i class="bi bi-save"></i> ${not empty ci ? 'Save Updates' : 'Register CI to Database'}
            </button>
            <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn btn-outline-secondary">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />