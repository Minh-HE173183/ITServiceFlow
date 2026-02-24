<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>Problem Detail - ${problem.ticketNumber}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f7f6;
                    padding: 20px;
                }

                .container {
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                h2,
                h3 {
                    color: #333;
                    margin-top: 0;
                }

                .detail-group {
                    margin-bottom: 15px;
                }

                .label {
                    font-weight: bold;
                    color: #555;
                }

                .value {
                    color: #000;
                }

                .btn {
                    padding: 8px 12px;
                    background-color: #007bff;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                    border: none;
                    cursor: pointer;
                    display: inline-block;
                    font-size: 14px;
                }

                .btn-warning {
                    background-color: #ffc107;
                    color: #212529;
                }

                .btn-danger {
                    background-color: #dc3545;
                }

                .btn-secondary {
                    background-color: #6c757d;
                }

                .btn-group {
                    margin-top: 20px;
                    display: flex;
                    gap: 10px;
                }

                ul {
                    list-style-type: none;
                    padding: 0;
                }

                li {
                    padding: 10px;
                    background: #eaeff5;
                    margin-bottom: 5px;
                    border-radius: 4px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                textarea,
                input[type="text"],
                input[type="number"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/problem?action=list" class="btn btn-secondary"
                    style="margin-bottom: 20px;">&larr; Back to List</a>

                <h2>Problem Detail: ${problem.ticketNumber}</h2>
                <div class="detail-group">
                    <span class="label">Title:</span> <span class="value">${problem.title}</span>
                </div>
                <div class="detail-group">
                    <span class="label">Description:</span> <span class="value">${problem.description}</span>
                </div>
                <div class="detail-group">
                    <span class="label">Status:</span> <span class="value">${problem.status}</span>
                </div>
                <div class="detail-group">
                    <span class="label">Reported By:</span> <span class="value">${problem.reportedBy}</span>
                </div>
                <div class="detail-group">
                    <span class="label">Assigned To:</span> <span class="value">${problem.assignedTo == null ?
                        'Unassigned' : problem.assignedTo}</span>
                </div>

                <hr>
                <h3>Root Cause Analysis (RCA)</h3>
                <div class="detail-group">
                    <span class="label">Root Cause:</span> <span class="value">${problem.cause == null ? 'Not identified
                        yet' : problem.cause}</span>
                </div>
                <div class="detail-group">
                    <span class="label">Workaround/Solution:</span> <span class="value">${problem.solution == null ? 'No
                        solution provided' : problem.solution}</span>
                </div>

                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/problem?action=edit&id=${problem.ticketId}"
                        class="btn btn-warning">Edit/Update RCA</a>

                    <c:if test="${problem.status ne 'CANCELLED'}">
                        <form action="${pageContext.request.contextPath}/problem?action=cancel" method="post"
                            onsubmit="return confirm('Cancel this Problem investigation?');">
                            <input type="hidden" name="id" value="${problem.ticketId}">
                            <button type="submit" class="btn btn-danger">Cancel Ticket</button>
                        </form>
                    </c:if>

                    <c:if test="${problem.assignedTo == null && problem.status ne 'CANCELLED'}">
                        <form action="${pageContext.request.contextPath}/problem?action=assign" method="post"
                            style="display:flex; gap: 5px; align-items:center;">
                            <input type="hidden" name="id" value="${problem.ticketId}">
                            <!-- Giả lập assign cho Expert ID 5 -->
                            <input type="hidden" name="assignedTo" value="5">
                            <button type="submit" class="btn">Assign to Me (ID:5)</button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="container">
                <h3>Linked Incidents</h3>
                <c:if test="${not empty linkedIncidents}">
                    <ul>
                        <c:forEach var="inc" items="${linkedIncidents}">
                            <li><strong>${inc.ticketNumber}</strong> - ${inc.title} <span
                                    style="float:right; color:#666;">[${inc.status}]</span></li>
                        </c:forEach>
                    </ul>
                </c:if>
                <c:if test="${empty linkedIncidents}">
                    <p style="color: #666;">No incidents linked to this problem.</p>
                </c:if>
            </div>

            <div class="container">
                <h3>Investigation Comments</h3>
                <form action="${pageContext.request.contextPath}/problem?action=addComment" method="post">
                    <input type="hidden" name="id" value="${problem.ticketId}">
                    <div class="form-group">
                        <textarea name="commentText" rows="4" placeholder="Add a new finding, note, or update..."
                            required></textarea>
                    </div>
                    <button type="submit" class="btn">Add Comment</button>
                </form>
            </div>
        </body>

        </html>
