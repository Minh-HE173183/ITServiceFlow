<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>${not empty ci ? 'Edit CI' : 'Register CI'} - CMDB</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f7f6;
                    padding: 20px;
                }

                .container {
                    background-color: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    max-width: 800px;
                    margin: auto;
                }

                h2 {
                    color: #333;
                    margin-top: 0;
                    margin-bottom: 20px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 10px;
                }

                .form-row {
                    display: flex;
                    gap: 20px;
                    margin-bottom: 15px;
                }

                .form-group {
                    flex: 1;
                }

                label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 5px;
                    color: #555;
                }

                input[type="text"],
                input[type="number"],
                select,
                textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                    font-family: Arial, sans-serif;
                }

                .btn {
                    padding: 10px 15px;
                    background-color: #28a745;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    width: 100%;
                }

                .btn:hover {
                    background-color: #218838;
                }

                .btn-secondary {
                    background-color: #6c757d;
                    display: block;
                    text-align: center;
                    text-decoration: none;
                    margin-top: 10px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h2>${not empty ci ? 'Update Configuration Item' : 'Register New Configuration Item'}</h2>

                <form action="${pageContext.request.contextPath}/cmdb?action=${not empty ci ? 'update' : 'insert'}"
                    method="post">
                    <c:if test="${not empty ci}">
                        <input type="hidden" name="id" value="${ci.ciId}">
                    </c:if>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ciName">CI Name / Hostname *</label>
                            <input type="text" id="ciName" name="ciName" value="${ci.ciName}" required>
                        </div>
                        <div class="form-group">
                            <!-- Giả lập type ID select. Backend DAOs check foreign key vs ci_type table -->
                            <label for="ciTypeId">CI Type ID *</label>
                            <input type="number" id="ciTypeId" name="ciTypeId"
                                value="${ci.ciTypeId == 0 ? 3 : ci.ciTypeId}" required min="1" max="8">
                            <small style="color:#777;">(1: Desktop, 2: Laptop, 3: Server, 4: Switch, etc.)</small>
                        </div>
                    </div>

                    <c:if test="${not empty ci}">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="status">Lifecyle Status</label>
                                <select id="status" name="status">
                                    <option value="ACTIVE" ${ci.status=='ACTIVE' ? 'selected' : '' }>Active</option>
                                    <option value="INACTIVE" ${ci.status=='INACTIVE' ? 'selected' : '' }>Inactive
                                    </option>
                                    <option value="RETIRED" ${ci.status=='RETIRED' ? 'selected' : '' }>Retired</option>
                                    <option value="UNDER_MAINTENANCE" ${ci.status=='UNDER_MAINTENANCE' ? 'selected' : ''
                                        }>Under Maintenance</option>
                                </select>
                            </div>
                        </div>
                    </c:if>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ipAddress">IP Address</label>
                            <input type="text" id="ipAddress" name="ipAddress" value="${ci.ipAddress}"
                                placeholder="192.168.1.xxx">
                        </div>
                        <div class="form-group">
                            <label for="location">Datacenter / Location</label>
                            <input type="text" id="location" name="location" value="${ci.location}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="manufacturer">Manufacturer</label>
                            <input type="text" id="manufacturer" name="manufacturer" value="${ci.manufacturer}"
                                placeholder="Dell, Cisco, VMware...">
                        </div>
                        <div class="form-group">
                            <label for="model">Model</label>
                            <input type="text" id="model" name="model" value="${ci.model}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="serialNumber">Serial Number / Service Tag</label>
                            <input type="text" id="serialNumber" name="serialNumber" value="${ci.serialNumber}">
                        </div>
                        <div class="form-group">
                            <label for="ownerId">Owner User ID</label>
                            <input type="number" id="ownerId" name="ownerId" value="${ci.ownerId}"
                                placeholder="Leave blank if unassigned">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label for="description">Notes & Description</label>
                        <textarea id="description" name="description" rows="3">${ci.description}</textarea>
                    </div>

                    <button type="submit" class="btn">${not empty ci ? 'Save Updates' : 'Register CI to
                        Database'}</button>
                    <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </body>

        </html>
