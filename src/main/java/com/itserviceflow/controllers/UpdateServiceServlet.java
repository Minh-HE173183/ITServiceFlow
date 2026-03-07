/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.itserviceflow.controllers;

import com.itserviceflow.daos.ServiceDAO;
import com.itserviceflow.models.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author ADMIN
 */
@WebServlet("/admin/update-service")
public class UpdateServiceServlet extends HttpServlet {
    private ServiceDAO serviceDAO = new ServiceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(id);
        request.setAttribute("service", service);
        request.getRequestDispatcher("/admin/update-service.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Service service = new Service();
        service.setServiceId(Integer.parseInt(request.getParameter("serviceId")));
        service.setServiceName(request.getParameter("serviceName"));
        service.setServiceCode(request.getParameter("serviceCode"));
        service.setDescription(request.getParameter("description"));
        service.setEstimatedDeliveryDay(Integer.parseInt(request.getParameter("estimatedDeliveryDay")));
        service.setStatus(request.getParameter("status"));

        if (serviceDAO.updateService(service)) {
            request.getSession().setAttribute("message", "Update service success!");
            response.sendRedirect(request.getContextPath() + "/admin/service-management");
        } else {
            request.setAttribute("error", "Error update service.");
            doGet(request, response);
        }
    }
}
