<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>

    <head>

        <title>ITServiceFlow - Service Catalog</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>

    <body class="bg-light">

        <div class="container mt-5">

            <h2 class="mb-4">Service Catalog</h2>



            <div class="row mb-4">

                <div class="col-md-8">

                    <form action="service-catalog" method="get" class="d-flex">

                        <input type="text" name="search" class="form-control me-2" 

                               placeholder="Search for services (e.g. Laptop, Software)..." 

                               value="${lastSearch}">

                        <button type="submit" class="btn btn-primary">Search</button>

                    </form>

                </div>

            </div>



            <form action="admin/delete-service" method="post" id="bulkDeleteForm">

                <div class="row">

                    <c:forEach var="svc" items="${listService}">

                        <div class="col-md-4 mb-3">

                            <div class="card h-100 shadow-sm">

                                <div class="card-header bg-white">

                                    <input type="checkbox" name="serviceIds" value="${svc.serviceId}" class="form-check-input">

                                    <small class="text-muted ms-2">${svc.serviceCode}</small>

                                </div>

                                <div class="card-body">

                                    <h5 class="card-title text-primary">${svc.serviceName}</h5>

                                    <p class="card-text small">${svc.description}</p>

                                </div>

                                <div class="card-footer bg-transparent border-top-0 pb-3">

                                    <div class="d-flex gap-2">

                                        <a href="service-detail?id=${svc.serviceId}" class="btn btn-outline-primary px-4 flex-grow-1">

                                            View

                                        </a>



                                        <button type="button" class="btn btn-outline-danger px-4 flex-grow-1" 

                                                onclick="confirmDeleteOne('${svc.serviceId}')">

                                            Delete

                                        </button>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </div>



                <div class="fixed-bottom p-4 bg-white border-top shadow" id="adminActions" style="display:none;">

                    <div class="container d-flex justify-content-between align-items-center">

                        <span id="selectedCount">0 items selected</span>

                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete selected items?')">

                            Delete All

                        </button>

                    </div>

                </div>

            </form>



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

                    if (confirm('Delete this service? (Only works if no requests exist)')) {

                        const form = document.createElement('form');

                        form.method = 'POST';

                        form.action = 'admin/delete-service';

                        const input = document.createElement('input');

                        input.name = 'serviceIds';

                        input.value = id;

                        form.appendChild(input);

                        document.body.appendChild(form);

                        form.submit();

                    }

                }

            </script>



            <c:if test="${empty listService}">

                <div class="col-12">

                    <div class="alert alert-warning">No services found matching your search.</div>

                </div>

            </c:if>

        </div>

    </div>

</body>

</html>