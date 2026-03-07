<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/admin-layout-top.jsp" %>
<c:set var="pageTitle" value="Chỉnh sửa dịch vụ" scope="request"/>


<div class="container-fluid">
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-bold text-primary">Update Service: ${service.serviceName}</h5>
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/admin/update-service" method="post">
                <input type="hidden" name="serviceId" value="${service.serviceId}">
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Service Name</label>
                        <input type="text" name="serviceName" class="form-control" value="${service.serviceName}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Code</label>
                        <input type="text" name="serviceCode" class="form-control" value="${service.serviceCode}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="4">${service.description}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Estimated Delivery</label>
                        <input type="number" name="estimatedDeliveryDay" class="form-control" value="${service.estimatedDeliveryDay}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Status</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" ${service.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${service.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        </select>
                    </div>
                </div>

                <div class="mt-4 text-end">
                    <a href="service-management" class="btn btn-light border px-4 me-2">Cancel</a>
                    <button type="submit" class="btn btn-primary px-4">Save Change</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/admin-layout-bottom.jsp" %>