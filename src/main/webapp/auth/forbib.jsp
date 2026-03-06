<%-- 
    Document   : forbib
    Created on : Feb 15, 2026, 2:20:52 PM
    Author     : Lo Pc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Access Denied</title>
    <style>
        .access-denied {
            min-height: 60vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .access-denied h1 {
            font-size: 60px;
            color: #e74c3c;
            margin-bottom: 10px;
        }

        .access-denied h2 {
            margin-bottom: 15px;
        }

        .access-denied p {
            color: #555;
            margin-bottom: 20px;
        }

        .access-denied a {
            text-decoration: none;
            padding: 10px 20px;
            background-color: #2ecc71;
            color: white;
            border-radius: 5px;
        }

        .access-denied a:hover {
            background-color: #27ae60;
        }
    </style>
</head>

<body>
    <section class="access-denied">
        <h1>403</h1>
        <h2>Access Denied</h2>
        <p>Bạn không có quyền truy cập trang này</p>

        <a href="../home">Quay về trang chủ</a>
    </section>
</body>
</html>
