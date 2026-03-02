    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>${not empty problem ? 'Edit Problem' : 'Create Problem'}</title>
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
                    max-width: 600px;
                    margin: auto;
                }

                h2 {
                    color: #333;
                    margin-top: 0;
                    margin-bottom: 20px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 5px;
                    color: #555;
                }

                input[type="text"],
                textarea,
                select {
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

                .help-text {
                    font-size: 12px;
                    color: #777;
                    margin-top: 5px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h2>${not empty problem ? 'Update Problem Ticket' : 'Create Problem Ticket'}</h2>

                <form
                    action="${pageContext.request.contextPath}/problem?action=${not empty problem ? 'update' : 'insert'}"
                    method="post">
                    <c:if test="${not empty problem}">
                        <input type="hidden" name="id" value="${problem.ticketId}">
                    </c:if>

                    <div class="form-group">
                        <label for="title">Problem Title / Summary *</label>
                        <input type="text" id="title" name="title" value="${problem.title}" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Detailed Description *</label>
                        <textarea id="description" name="description" rows="5"
                            required>${problem.description}</textarea>
                    </div>

                    <c:if test="${not empty problem}">
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status">
                                <option value="NEW" ${problem.status=='NEW' ? 'selected' : '' }>New</option>
                                <option value="IN_PROGRESS" ${problem.status=='IN_PROGRESS' ? 'selected' : '' }>In
                                    Progress</option>
                                <option value="RESOLVED" ${problem.status=='RESOLVED' ? 'selected' : '' }>Resolved
                                </option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="cause">Root Cause</label>
                            <textarea id="cause" name="cause" rows="4">${problem.cause}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="solution">Workaround / Permanent Solution</label>
                            <textarea id="solution" name="solution" rows="4">${problem.solution}</textarea>
                        </div>
                    </c:if>

                    <c:if test="${empty problem}">
                        <div class="form-group">
                            <label for="incidentIds">Link Incidents (Optional)</label>
                            <input type="text" id="incidentIds" name="incidentIds"
                                placeholder="e.g. 101, 102, 105 (Comma separated Incident IDs)">
                            <div class="help-text">Enter the IDs of the incidents caused by this problem.</div>
                        </div>
                    </c:if>

                    <button type="submit" class="btn">${not empty problem ? 'Save Update' : 'Submit Problem'}</button>
                    <a href="${pageContext.request.contextPath}/problem?action=list"
                        class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </body>

        </html>
