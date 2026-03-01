<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.itserviceflow.models.Ticket" %>
<%@ page import="com.itserviceflow.models.User" %>

<%
    User user = (User) session.getAttribute("user");
    List<Ticket> list = (List<Ticket>) request.getAttribute("incidentList");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Incident List</title>

        <style>
            body {
                font-family: "Segoe UI", Arial;
                background-color: #f5f7fa;
                margin: 0;
            }

            .header {
                background-color: #1f2937;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .container {
                padding: 30px;
            }

            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0px 2px 8px rgba(0,0,0,0.08);
                padding: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th {
                text-align: left;
                padding: 12px;
                background-color: #f3f4f6;
                font-weight: 600;
            }

            td {
                padding: 12px;
                border-top: 1px solid #eee;
            }

            tr:hover {
                background-color: #f9fafb;
            }

            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }

            .status-open {
                background-color: #e0f2fe;
                color: #0369a1;
            }

            .status-resolved {
                background-color: #dcfce7;
                color: #166534;
            }

            .priority-low {
                background-color: #e5e7eb;
                color: #374151;
            }

            .priority-medium {
                background-color: #fef3c7;
                color: #92400e;
            }

            .priority-high {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .view-btn {
                text-decoration: none;
                color: white;
                background-color: #2563eb;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 13px;
            }

            .view-btn:hover {
                background-color: #1d4ed8;
            }

            .role-label {
                font-size: 14px;
                opacity: 0.8;
            }
        </style>
    </head>

    <body>

        <div class="header">
            <div>
                <h2>ITServiceFlow - Incident Management</h2>
            </div>
            <div>
                <strong><%= user.getFullName() %></strong>
                <div class="role-label">Role: <%= user.getRoleName() %></div>
            </div>
        </div>

        <div class="container">
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3>Incident List</h3>
                    <a class="view-btn" href="${pageContext.request.contextPath}/incident?action=add">New Incident</a>
                </div>
                <br>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Ticket Number</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Priority</th>
                        <th>Action</th>
                    </tr>

                    <%
                        if (list != null) {
                            for (Ticket t : list) {

                                String statusClass = t.getStatus().equalsIgnoreCase("RESOLVED")
                                        ? "status-resolved"
                                        : "status-open";

                                String priorityClass = "";
                                if (t.getPriority().equalsIgnoreCase("LOW")) {
                                    priorityClass = "priority-low";
                                } else if (t.getPriority().equalsIgnoreCase("MEDIUM")) {
                                    priorityClass = "priority-medium";
                                } else {
                                    priorityClass = "priority-high";
                                }
                    %>

                    <tr>
                        <td><%= t.getTicketId() %></td>
                        <td><%= t.getTicketNumber() %></td>
                        <td><%= t.getTitle() %></td>

                        <td>
                            <span class="badge <%= statusClass %>">
                                <%= t.getStatus() %>
                            </span>
                        </td>

                        <td>
                            <span class="badge <%= priorityClass %>">
                                <%= t.getPriority() %>
                            </span>
                        </td>

                        <td>
                            <a class="view-btn"
                               href="${pageContext.request.contextPath}/incident?action=detail&id=<%= t.getTicketId() %>">
                                View
                            </a>
                        </td>
                    </tr>

                    <%
                            }
                        }
                    %>
                </table>

            </div>
        </div>

    </body>
</html>