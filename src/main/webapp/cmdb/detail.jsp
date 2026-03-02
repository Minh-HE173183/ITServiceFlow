<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>CI Detail - ${ci.ciCode}</title>
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
                    border-bottom: 1px solid #eee;
                    padding-bottom: 10px;
                }

                .grid-container {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                    margin-bottom: 20px;
                }

                .detail-group {
                    margin-bottom: 5px;
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

                .btn-secondary {
                    background-color: #6c757d;
                }

                .status-badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 14px;
                    font-weight: bold;
                    color: white;
                }

                .status-ACTIVE {
                    background-color: #28a745;
                }

                .status-INACTIVE {
                    background-color: #6c757d;
                }

                ul {
                    list-style-type: none;
                    padding: 0;
                    margin: 0;
                }

                li {
                    padding: 10px;
                    border-bottom: 1px solid #eee;
                }

                .impact-box {
                    background-color: #fff3cd;
                    color: #856404;
                    padding: 15px;
                    border-radius: 4px;
                    border: 1px solid #ffeeba;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/cmdb?action=list" class="btn btn-secondary"
                    style="margin-bottom: 20px;">&larr; Back to CMDB</a>

                <h2>Configuration Item: ${ci.ciName} (${ci.ciCode}) <span
                        class="status-badge status-${ci.status}">${ci.status}</span></h2>

                <div class="grid-container">
                    <div>
                        <h3>General Info</h3>
                        <div class="detail-group"><span class="label">Type ID:</span> <span
                                class="value">${ci.ciTypeId}</span></div>
                        <div class="detail-group"><span class="label">Owner ID:</span> <span class="value">${ci.ownerId
                                == null ? 'Unassigned' : ci.ownerId}</span></div>
                        <div class="detail-group"><span class="label">Location:</span> <span class="value">${ci.location
                                == null ? 'N/A' : ci.location}</span></div>
                        <div class="detail-group"><span class="label">Last Updated:</span> <span
                                class="value">${ci.updatedAt}</span></div>
                    </div>
                    <div>
                        <h3>Technical Details</h3>
                        <div class="detail-group"><span class="label">Manufacturer:</span> <span
                                class="value">${ci.manufacturer == null ? 'N/A' : ci.manufacturer}</span></div>
                        <div class="detail-group"><span class="label">Model:</span> <span class="value">${ci.model ==
                                null ? 'N/A' : ci.model}</span></div>
                        <div class="detail-group"><span class="label">Serial Num:</span> <span
                                class="value">${ci.serialNumber == null ? 'N/A' : ci.serialNumber}</span></div>
                        <div class="detail-group"><span class="label">IP Address:</span> <span
                                class="value">${ci.ipAddress == null ? 'N/A' : ci.ipAddress}</span></div>
                    </div>
                </div>

                <div class="detail-group" style="margin-top: 15px;">
                    <span class="label">Description:</span>
                    <p class="value" style="background:#f8f9fa; padding:10px; border-radius:4px;">${ci.description ==
                        null ? 'No description' : ci.description}</p>
                </div>

                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/cmdb?action=edit&id=${ci.ciId}"
                        class="btn btn-warning">Edit Configuration Item</a>
                </div>
            </div>

            <div class="container impact-box">
                <h3>&#9888; Impact Analysis (What happens if this CI fails?)</h3>
                <p>The following configuration items depend on or are hosted by this infrastructure branch. A failure
                    here will potentially cause outages for downstream items:</p>
                <c:if test="${not empty impactedCis}">
                    <ul style="border: 1px solid #ffeeba; background: white; border-radius: 4px;">
                        <c:forEach var="impactCi" items="${impactedCis}">
                            <li><strong>${impactCi.ciCode}</strong>: ${impactCi.ciName} <span style="color:#666;">(IP:
                                    ${impactCi.ipAddress})</span> - Status: ${impactCi.status}</li>
                        </c:forEach>
                    </ul>
                </c:if>
                <c:if test="${empty impactedCis}">
                    <p style="color: #28a745; font-weight: bold;">No downstream dependencies detected. Impact is
                        isolated.</p>
                </c:if>
            </div>

            <div class="container">
                <h3>CI Relationship Map</h3>
                <c:if test="${not empty relationships}">
                    <h4 style="margin-top:20px; color:#555;">Relationship Details</h4>
                    <table style="width: 100%; border-collapse: collapse;">
                        <tr style="background:#f1f1f1;">
                            <th style="padding: 8px; text-align:left; border-bottom: 2px solid #ccc;">Parent CI ID</th>
                            <th style="padding: 8px; text-align:left; border-bottom: 2px solid #ccc;">Relationship Type
                            </th>
                            <th style="padding: 8px; text-align:left; border-bottom: 2px solid #ccc;">Child CI ID</th>
                            <th style="padding: 8px; text-align:left; border-bottom: 2px solid #ccc;">Description</th>
                        </tr>
                        <c:forEach var="rel" items="${relationships}">
                            <tr>
                                <td style="padding: 8px; border-bottom: 1px solid #eee;">
                                    <c:if test="${rel.parentCiId eq ci.ciId}"><strong>[This CI]
                                            (${rel.parentCiId})</strong></c:if>
                                    <c:if test="${rel.parentCiId ne ci.ciId}">${rel.parentCiId}</c:if>
                                </td>
                                <td
                                    style="padding: 8px; border-bottom: 1px solid #eee; color:#0056b3; font-weight:bold;">
                                    ${rel.relationshipType}</td>
                                <td style="padding: 8px; border-bottom: 1px solid #eee;">
                                    <c:if test="${rel.childCiId eq ci.ciId}"><strong>[This CI]
                                            (${rel.childCiId})</strong></c:if>
                                    <c:if test="${rel.childCiId ne ci.ciId}">${rel.childCiId}</c:if>
                                </td>
                                <td style="padding: 8px; border-bottom: 1px solid #eee;">${rel.description}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
                <c:if test="${empty relationships}">
                    <p style="color: #666;">This CI has no recorded relationships with other infrastructure components.
                    </p>
                </c:if>
            </div>
        </body>

        </html>