<%-- 
    Document   : index
    Created on : Jan 19, 2026, 11:55:31 PM
    Author     : Lo Pc
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../component/header.jsp" %>
<!DOCTYPE html>
<section>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
        <c:if test="${message != null}">
             <div>
                 ${message}
             </div>
        </c:if>
        
        <form action="auth?action=login" method="POST">
            <div class ="nb-3">
                <label>Username</label>
                <input class="form-control" name ="username"/>
            <div/>
            <div class ="nb-3">
                <label>Password</label>
                <input class="form-control" name ="password_hash" type ="password_hash"/>
            <div/>
            <div class ="nb-3">
                <button class="btn btn-primary">Login<button/>
            <div/>
        </form>
</section>
<%@include file="../component/footer.jsp" %>
