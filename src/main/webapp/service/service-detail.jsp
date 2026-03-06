<%-- Document : service-detail Created on : Feb 23, 2026, 8:18:12?PM Author : ADMIN --%>

    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Service Detail - ${service.serviceName}</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="bg-light">
            <div class="container mt-5">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="service-catalog">Catalog</a></li>
                        <li class="breadcrumb-item active">Detail</li>
                    </ol>
                </nav>

                <div class="card shadow border-0">
                    <div class="card-header bg-primary text-white py-3">
                        <h3 class="mb-0">${service.serviceName}</h3>
                        <small>Code: <strong>${service.serviceCode}</strong></small>
                    </div>
                    <div class="card-body p-4">
                        <div class="row">
                            <div class="col-md-8">
                                <h5>Description</h5>
                                <p class="text-muted">${service.description}</p>

                                <h5 class="mt-4">Service Requirements</h5>
                                <ul class="text-secondary">
                                    <li>User must belong to a valid department.</li>
                                    <li>Justification is required for high-priority requests.</li>
                                </ul>
                            </div>
                            <div class="col-md-4 border-start">
                                <div class="p-2">
                                    <h6 class="text-uppercase text-secondary">Estimated Delivery</h6>
                                    <p class="h4 text-success">${service.estimatedDeliveryDay} Working Days</p>
                                </div>
                                <hr>
                                <div class="p-2">
                                    <h6 class="text-uppercase text-secondary">SLA Policy</h6>
                                    <span class="badge bg-info text-dark">Standard Response: 8h</span>
                                    <span class="badge bg-warning text-dark mt-1">Resolution: 72h</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-white p-3 text-end">
                        <a href="/service-catalog" class="btn btn-secondary me-2">Back to Catalog</a>
                        <a href="${pageContext.request.contextPath}/create-request?serviceId=${service.serviceId}"
               class="btn btn-success px-4">
                Request Service
            </a>
        </div>
    </div>
</div>
</body>

        </html>