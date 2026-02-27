<%@page import="java.util.List"%>
<%@page import="com.itserviceflow.models.Ticket"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Incident List</title>

        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: #f5f7fa;
            }

            /* HEADER */
            .header {
                background-color: #1f2937;
                color: white;
                padding: 15px 30px;
                font-size: 20px;
                font-weight: bold;
            }

            /* CONTAINER */
            .container {
                padding: 30px;
            }

            /* CARD */
            .card {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            /* TABLE */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            thead {
                background-color: #f3f4f6;
            }

            th {
                text-align: left;
                padding: 12px;
                font-size: 14px;
                color: #374151;
            }

            td {
                padding: 12px;
                border-top: 1px solid #e5e7eb;
                font-size: 14px;
            }

            tr:hover {
                background-color: #f9fafb;
            }

            /* BADGE */
            .badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                color: white;
            }

            .NEW {
                background-color: #3b82f6;
            }

            .IN_PROGRESS {
                background-color: #f59e0b;
            }

            .RESOLVED {
                background-color: #10b981;
            }

            .CLOSED {
                background-color: #6b7280;
            }

            .HIGH {
                color: #dc2626;
                font-weight: bold;
            }

            .CRITICAL {
                color: red;
                font-weight: bold;
            }

        </style>
    </head>

    <body>

        <div class="header">
            ITServiceFlow - Incident Management
        </div>

        <div class="container">

            <div class="card">

                <h2>Incident List</h2>

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ticket Number</th>
                            <th>Title</th>
                            <th>Status</th>
                            <th>Priority</th>
                        </tr>
                    </thead>

                    <tbody>

                        <%
                            List<Ticket> list = (List<Ticket>) request.getAttribute("incidentList");
                            if(list != null){
                                for(Ticket t : list){
                        %>

                        <tr>
                            <td><%=t.getTicketId()%></td>
                            <td>
                                <a href="incident-detail?id=<%=t.getTicketId()%>">
                                    <%=t.getTicketNumber()%>
                                </a>
                            </td>
                            <td><%=t.getTitle()%></td>

                            <td>
                                <span class="badge <%=t.getStatus()%>">
                                    <%=t.getStatus()%>
                                </span>
                            </td>

                            <td class="<%=t.getPriority()%>">
                                <%=t.getPriority()%>
                            </td>
                        </tr>

                        <%
                                }
                            }
                        %>

                    </tbody>

                </table>

            </div>

        </div>

    </body>
</html>