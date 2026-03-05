<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>ITServiceFlow - Service Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-tasks me-2"></i>Service Management</h2>
                <a href="${pageContext.request.contextPath}/admin/create-service" class="btn btn-success">
                    <i class="fas fa-plus"></i> Create New Service
                </a>
            </div>

            <div class="row mb-4">
                <div class="col-md-8">
                    <form action="service-management" method="get" class="d-flex">
                        <input type="text" name="search" class="form-control me-2" 
                               placeholder="Search all services..." value="${lastSearch}">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/admin/delete-service" method="post" id="bulkDeleteForm">
                <div class="row">
                    <c:forEach var="svc" items="${allServices}">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm border-0">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <input type="checkbox" name="serviceIds" value="${svc.serviceId}" class="form-check-input">
                                    <span class="badge ${svc.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        ${svc.status}
                                    </span>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title text-primary">${svc.serviceName}</h5>
                                    <p class="card-text small text-muted text-truncate-2">${svc.description}</p>
                                    <small class="text-secondary">Code: ${svc.serviceCode}</small>
                                </div>
                                <div class="card-footer bg-transparent border-top-0 pb-3">
                                    <div class="d-flex gap-2">
                                        <a href="/admin/service-managedetail?id=${svc.serviceId}" class="btn btn-sm btn-outline-primary flex-grow-1">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <a href="update-service?id=${svc.serviceId}" class="btn btn-sm btn-outline-warning flex-grow-1">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger flex-grow-1" 
                                                onclick="confirmDeleteOne('${svc.serviceId}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="fixed-bottom p-3 bg-white border-top shadow-lg" id="adminActions" style="display:none;">
                    <div class="container d-flex justify-content-between align-items-center">
                        <span id="selectedCount" class="fw-bold">0 items selected</span>
                        <button type="submit" class="btn btn-danger px-4" 
                                onclick="return confirm('Delete selected services? This only works for services with no requests.')">
                            Delete Selected Items
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <script>
            const checkboxes = document.querySelectorAll('input[name="serviceIds"]');
            checkboxes.forEach(cb => {
                cb.addEventListener('change', () => {
                    const checked = document.querySelectorAll('input[name="serviceIds"]:checked');
                    document.getElementById('adminActions').style.display = checked.length > 0 ? 'block' : 'none';
                    document.getElementById('selectedCount').innerText = checked.length + ' items selected';
                });
            });

            function confirmDeleteOne(id) {
                if (confirm('Delete this service? (Only if no requests exist for it)')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/delete-service';
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'serviceIds';
                    input.value = id;
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        </script>
    </body>
</html>