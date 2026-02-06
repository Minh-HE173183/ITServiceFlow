<%-- 
    Document   : header
    Created on : Feb 5, 2026, 11:24:47 PM
    Author     : Lo Pc
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My JSP Website</title>
     <!-- Bootstrap CSS -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
    <!-- CSS embedded in header.jsp -->
    <style>
        /* RESET */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            color: #333;
        }

        /* HEADER */
        .header {
            background: linear-gradient(90deg, #1e3c72, #2a5298);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .container {
            width: 85%;
            margin: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
        }

        .logo a {
            color: #fff;
            font-size: 26px;
            font-weight: bold;
            text-decoration: none;
            letter-spacing: 1px;
        }

        /* NAV */
        .nav ul {
            list-style: none;
            display: flex;
            gap: 25px;
        }

        .nav a {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            position: relative;
            padding-bottom: 5px;
            transition: 0.3s;
        }

        .nav a::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            width: 0;
            height: 2px;
            background-color: #ffcc00;
            transition: width 0.3s ease;
        }

        .nav a:hover::after {
            width: 100%;
        }

        /* MAIN CONTENT */
        .content {
            width: 85%;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            min-height: 60vh;
            box-shadow: 0 8px 25px rgba(0,0,0,0.06);
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="index.jsp">MyWebsite</a>
        </div>

        <nav class="nav">
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Contact</a></li>
                    <c:if test = "${sessionScope.dalogin != null}">
                <li><a href="#">Welcome ${sessionScope.dalogin.username} </a></li>
                <li><a href="auth?action=logout">Logout</a></li>
                </c:if>
                <c:if test = "${sessionScope.dalogin == null}">
                <li><a href="#">Welcome,${sessionScope.dalogin.username} </a></li>
                <li><a href="auth?action=login">Login</a></li>
                </c:if>
            </ul>
        </nav>
    </div>
</header>

</html>
