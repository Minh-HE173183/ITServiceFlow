<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>${not empty knownError ? 'Edit Known Error' : 'Create Known Error'}</title>
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
                    max-width: 700px;
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
                <h2>${not empty knownError ? 'Update Known Error' : 'Create Known Error'}</h2>

                <form
                    action="${pageContext.request.contextPath}/known-error?action=${not empty knownError ? 'update' : 'insert'}"
                    method="post">
                    <c:if test="${not empty knownError}">
                        <input type="hidden" name="id" value="${knownError.articleId}">

                        <c:if test="${not empty knownError.rejectionReason && knownError.status eq 'REJECTED'}">
                            <div
                                style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
                                <strong>Rejection Reason:</strong> ${knownError.rejectionReason}
                            </div>
                        </c:if>
                    </c:if>

                    <div class="form-group">
                        <label for="title">Article Title *</label>
                        <input type="text" id="title" name="title" value="${knownError.title}" required>
                    </div>

                    <div class="form-group">
                        <label for="summary">Short Summary *</label>
                        <textarea id="summary" name="summary" rows="2" required>${knownError.summary}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="symptom">Symptoms & Errors *</label>
                        <textarea id="symptom" name="symptom" rows="4" required
                            placeholder="What error messages appear? What does the user see?">${knownError.symptom}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="cause">Root Cause</label>
                        <textarea id="cause" name="cause" rows="4"
                            placeholder="Why is this happening? (Optional if not fully root caused yet)">${knownError.cause}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="solution">Workaround / Permanent Solution *</label>
                        <textarea id="solution" name="solution" rows="5" required
                            placeholder="Step-by-step instructions to fix it.">${knownError.solution}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="content">Additional References / Content</label>
                        <textarea id="content" name="content" rows="4">${knownError.content}</textarea>
                    </div>

                    <button type="submit" class="btn">${not empty knownError ? 'Save Updates' : 'Submit for
                        Review'}</button>
                    <a href="${pageContext.request.contextPath}/known-error?action=list"
                        class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </body>

        </html>
