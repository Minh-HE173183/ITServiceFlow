<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>ITServiceFlow - Create New Service</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-dark text-white">
                    <h4 class="mb-0">Define New Service Offering</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form action="create-service" method="post">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <label class="form-label font-weight-bold">Service Name</label>
                                <input type="text" name="serviceName" class="form-control" required placeholder="e.g., Cloud Storage Expansion">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Service Code</label>
                                <input type="text" name="serviceCode" class="form-control" required placeholder="SR-CLOUD-01">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Detailed Description</label>
                            <textarea name="description" class="form-control" rows="4" required></textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Estimated Delivery (Days)</label>
                                <input type="number" name="deliveryDay" class="form-control" min="1" value="1">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Initial Status</label>
                                <input type="text" class="form-control" value="ACTIVE" readonly>
                            </div>
                        </div>

                        <hr>
                        <div class="d-flex justify-content-between">
                            <a href="/admin/service-management" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary px-5">Publish Service</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>