<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>ITServiceFlow - Create Service Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!--    <style>
                .form-label { fw-bold; color: #495057; }
                .card-header-green { background-color: #198754; color: white; }
            </style>-->
    </head>
    <body class="bg-light">

        <div class="container mt-5 mb-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/service-catalog">Service Catalog</a></li>
                            <li class="breadcrumb-item active">New Request</li>
                        </ol>
                    </nav>

                    <div class="card shadow-sm border-0">
                        <div class="card-header card-header-green py-3">
                            <h4 class="mb-0"><i class="fas fa-file-medical me-2"></i> Create Service Request</h4>
                            <small>Selected Service: <strong>${service.serviceName}</strong></small>
                        </div>

                        <div class="card-body p-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/create-request" method="post">
                                <input type="hidden" name="serviceId" value="${service.serviceId}">

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Request Title</label>
                                    <input type="text" name="title" class="form-control" 
                                           value="Request for ${service.serviceName}" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold">Priority </label>
                                        <select name="priority" class="form-select" required>
                                            <option value="LOW">Low - Standard requests</option>
                                            <option value="MEDIUM" selected>Medium - Normal business needs</option>
                                            <option value="HIGH">High - Urgent requirements</option>
                                            <option value="CRITICAL">Critical - Immediate attention required</option>
                                        </select>
                                        <div class="form-text">Mức độ ưu tiên sẽ ảnh hưởng đến thời gian phản hồi theo SLA[cite: 45].</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Justification (Lý do cần dịch vụ)</label>
                                    <textarea name="justification" class="form-control" rows="3" 
                                              placeholder="Vui lòng cho biết lý do bạn cần yêu cầu dịch vụ này..." required></textarea>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">Additional Information / Requirements</label>
                                    <textarea name="description" class="form-control" rows="4" 
                                              placeholder="Cung cấp thêm chi tiết (ví dụ: cấu hình máy tính, loại phần mềm...)"></textarea>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-muted small">
                                        <i class="fas fa-info-circle"></i> Trạng thái ban đầu: <strong>New</strong> [cite: 17]
                                    </span>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/service-catalog" class="btn btn-light border px-4 me-2">Cancel</a>
                                        <button type="submit" class="btn btn-success px-5 fw-bold">
                                            Submit Request <i class="fas fa-paper-plane ms-2"></i>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>