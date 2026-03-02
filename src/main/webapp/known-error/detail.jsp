<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>Known Error Detail - ${knownError.articleNumber}</title>
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
                    display: block;
                    margin-bottom: 5px;
                }

                .value {
                    color: #000;
                    padding: 10px;
                    background-color: #f8f9fa;
                    border-radius: 4px;
                    border: 1px solid #e9ecef;
                    white-space: pre-wrap;
                }

                .inline-val {
                    display: inline;
                    background: none;
                    border: none;
                    padding: 0;
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

                .btn-success {
                    background-color: #28a745;
                }

                .btn-secondary {
                    background-color: #6c757d;
                }

                .btn-group {
                    margin-top: 20px;
                    display: flex;
                    gap: 10px;
                }

                .status-badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 14px;
                    font-weight: bold;
                    color: white;
                }

                .status-PENDING {
                    background-color: #ffc107;
                    color: #212529;
                }

                .status-APPROVED {
                    background-color: #28a745;
                }

                .status-REJECTED {
                    background-color: #dc3545;
                }

                .status-INACTIVE {
                    background-color: #6c757d;
                }

                .review-panel {
                    border: 1px solid #ffc107;
                    padding: 15px;
                    border-radius: 4px;
                    background-color: #fffdf5;
                    margin-top: 20px;
                }

                .form-group {
                    margin-bottom: 10px;
                }

                textarea {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/known-error?action=list" class="btn btn-secondary"
                    style="margin-bottom: 20px;">&larr; Back to List</a>

                <h2>Known Error: ${knownError.articleNumber} <span
                        class="status-badge status-${knownError.status}">${knownError.status}</span></h2>

                <div style="display: flex; gap: 20px; margin-bottom: 20px;">
                    <div><strong>Author ID:</strong> ${knownError.authorId}</div>
                    <div><strong>Last Updated:</strong> ${knownError.updatedAt}</div>
                </div>

                <div class="detail-group">
                    <span class="label">Title:</span>
                    <div class="value">${knownError.title}</div>
                </div>
                <div class="detail-group">
                    <span class="label">Summary:</span>
                    <div class="value">${knownError.summary}</div>
                </div>

                <h3>Technical Details</h3>
                <div class="detail-group">
                    <span class="label">Symptom:</span>
                    <div class="value">${knownError.symptom}</div>
                </div>
                <div class="detail-group">
                    <span class="label">Root Cause:</span>
                    <div class="value">${knownError.cause}</div>
                </div>
                <div class="detail-group">
                    <span class="label">Workaround & Solution:</span>
                    <div class="value">${knownError.solution}</div>
                </div>
                <div class="detail-group">
                    <span class="label">Detailed Content:</span>
                    <div class="value">${knownError.content}</div>
                </div>

                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/known-error?action=edit&id=${knownError.articleId}"
                        class="btn btn-warning">Edit Article</a>
                </div>

                <c:if test="${knownError.status eq 'PENDING'}">
                    <div class="review-panel">
                        <h3>Admin Review Panel</h3>
                        <p>Please review the details above to approve or reject this article to make it available for
                            Support Agents.</p>
                        <form action="${pageContext.request.contextPath}/known-error?action=review" method="post">
                            <input type="hidden" name="id" value="${knownError.articleId}">

                            <div class="form-group">
                                <label>Rejection Reason (Optional):</label>
                                <textarea name="rejectionReason" rows="3"
                                    placeholder="If rejecting, please state the reason..."></textarea>
                            </div>

                            <button type="submit" name="status" value="APPROVED" class="btn btn-success">Approve
                                Article</button>
                            <button type="submit" name="status" value="REJECTED" class="btn btn-danger">Reject
                                Article</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </body>

        </html>
