package com.itserviceflow.controllers;

import com.itserviceflow.daos.CmdbDAO;
import com.itserviceflow.models.ConfigurationItem;
import com.itserviceflow.models.CiRelationship;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/cmdb")
public class CmdbController extends HttpServlet {
    private CmdbDAO cmdbDAO;

    @Override
    public void init() throws ServletException {
        cmdbDAO = new CmdbDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listConfigurationItems(request, response);
                break;
            case "detail":
                viewConfigurationItemDetail(request, response);
                break;
            case "add":
                showConfigurationItemForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listConfigurationItems(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
            return;
        }

        switch (action) {
            case "insert":
                insertConfigurationItem(request, response);
                break;
            case "update":
                updateConfigurationItem(request, response);
                break;
            case "delete":
                deleteConfigurationItem(request, response);
                break;
            case "bulkDelete":
                bulkDeleteConfigurationItem(request, response);
                break;
            case "toggleStatus":
                toggleConfigurationItemStatus(request, response);
                break;
            case "bulkToggleStatus":
                bulkToggleConfigurationItemStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
                break;
        }
    }

    private void listConfigurationItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<ConfigurationItem> items = cmdbDAO.searchConfigurationItems(keyword, status);

        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", status);
        request.setAttribute("configurationItems", items);
        request.getRequestDispatcher("/cmdb/list.jsp").forward(request, response);
    }

    private void viewConfigurationItemDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ConfigurationItem ci = cmdbDAO.getConfigurationItemById(id);
        List<CiRelationship> relationships = cmdbDAO.getCiRelationships(id);
        List<ConfigurationItem> impactedCis = cmdbDAO.getImpactedCis(id);

        request.setAttribute("ci", ci);
        request.setAttribute("relationships", relationships);
        request.setAttribute("impactedCis", impactedCis);

        request.getRequestDispatcher("/cmdb/detail.jsp").forward(request, response);
    }

    private void showConfigurationItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/cmdb/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ConfigurationItem ci = cmdbDAO.getConfigurationItemById(id);
        request.setAttribute("ci", ci);
        request.getRequestDispatcher("/cmdb/form.jsp").forward(request, response);
    }

    private void insertConfigurationItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("ciName");
        int typeId = Integer.parseInt(request.getParameter("ciTypeId"));
        String location = request.getParameter("location");
        String manufacturer = request.getParameter("manufacturer");
        String model = request.getParameter("model");
        String serial = request.getParameter("serialNumber");
        String ip = request.getParameter("ipAddress");
        String description = request.getParameter("description");
        String ownerIdStr = request.getParameter("ownerId");

        ConfigurationItem ci = new ConfigurationItem();
        ci.setCiName(name);
        ci.setCiTypeId(typeId);
        ci.setLocation(location);
        ci.setManufacturer(manufacturer);
        ci.setModel(model);
        ci.setSerialNumber(serial);
        ci.setIpAddress(ip);
        ci.setDescription(description);

        if (ownerIdStr != null && !ownerIdStr.trim().isEmpty()) {
            ci.setOwnerId(Integer.parseInt(ownerIdStr));
        }

        cmdbDAO.createConfigurationItem(ci);
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }

    private void updateConfigurationItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("ciName");
        String location = request.getParameter("location");
        String manufacturer = request.getParameter("manufacturer");
        String model = request.getParameter("model");
        String serial = request.getParameter("serialNumber");
        String ip = request.getParameter("ipAddress");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String ownerIdStr = request.getParameter("ownerId");

        ConfigurationItem ci = new ConfigurationItem();
        ci.setCiId(id);
        ci.setCiName(name);
        ci.setLocation(location);
        ci.setManufacturer(manufacturer);
        ci.setModel(model);
        ci.setSerialNumber(serial);
        ci.setIpAddress(ip);
        ci.setDescription(description);
        ci.setStatus(status);

        if (ownerIdStr != null && !ownerIdStr.trim().isEmpty()) {
            ci.setOwnerId(Integer.parseInt(ownerIdStr));
        }

        cmdbDAO.updateConfigurationItem(ci);
        response.sendRedirect(request.getContextPath() + "/cmdb?action=detail&id=" + id);
    }

    private void deleteConfigurationItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        cmdbDAO.deleteConfigurationItem(id);
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }

    private void bulkDeleteConfigurationItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        if (ids != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    cmdbDAO.deleteConfigurationItem(id);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }

    private void toggleConfigurationItemStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("currentStatus");
        cmdbDAO.toggleConfigurationItemStatus(id, currentStatus);
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }

    private void bulkToggleConfigurationItemStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        String toggleTo = request.getParameter("toggleTo"); 
        if (ids != null && toggleTo != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    String mockCurrentStatus = toggleTo.equals("INACTIVE") ? "ACTIVE" : "INACTIVE";
                    cmdbDAO.toggleConfigurationItemStatus(id, mockCurrentStatus);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }
}
