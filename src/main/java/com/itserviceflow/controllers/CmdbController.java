package com.itserviceflow.controllers;

import com.itserviceflow.daos.CmdbDAO;
import com.itserviceflow.models.ConfigurationItem;
import com.itserviceflow.models.CiRelationship;
import com.itserviceflow.models.User;
import com.itserviceflow.utils.AuthUtils;

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

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        User currentUser = AuthUtils.getCurrentUser(request);
        request.setAttribute("currentUser", currentUser);

        switch (action) {
            case "list":
                listConfigurationItems(request, response);
                break;
            case "detail":
                viewConfigurationItemDetail(request, response);
                break;
            case "add":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                showConfigurationItemForm(request, response);
                break;
            case "edit":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
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

        if (!AuthUtils.isLoggedIn(request, response))
            return;

        switch (action) {
            case "insert":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                insertConfigurationItem(request, response);
                break;
            case "update":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                updateConfigurationItem(request, response);
                break;
            case "delete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                deleteConfigurationItem(request, response);
                break;
            case "bulkDelete":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                bulkDeleteConfigurationItem(request, response);
                break;
            case "toggleStatus":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                toggleConfigurationItemStatus(request, response);
                break;
            case "bulkToggleStatus":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                bulkToggleConfigurationItemStatus(request, response);
                break;
            case "addRelationship":
                if (!AuthUtils.hasRole(request, response, AuthUtils.ROLE_ASSET_MANAGER))
                    return;
                addCiRelationship(request, response);
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
        List<ConfigurationItem> allCis = cmdbDAO.getAllConfigurationItemsForDropdown(id);

        request.setAttribute("ci", ci);
        request.setAttribute("relationships", relationships);
        request.setAttribute("impactedCis", impactedCis);
        request.setAttribute("allCis", allCis);

        request.getRequestDispatcher("/cmdb/detail.jsp").forward(request, response);
    }

    private void showConfigurationItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("users", cmdbDAO.getAllUsersForDropdown());
        request.setAttribute("ciTypes", cmdbDAO.getAllCiTypes());
        request.getRequestDispatcher("/cmdb/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ConfigurationItem ci = cmdbDAO.getConfigurationItemById(id);
        request.setAttribute("ci", ci);
        request.setAttribute("users", cmdbDAO.getAllUsersForDropdown());
        request.setAttribute("ciTypes", cmdbDAO.getAllCiTypes());
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

        ConfigurationItem ci = cmdbDAO.getConfigurationItemById(id);
        // UC78: Delete CI only if status = INACTIVE and no relationships/linked tickets
        if (ci != null && "INACTIVE".equals(ci.getStatus())) {
            List<CiRelationship> relationships = cmdbDAO.getCiRelationships(id);
            if (relationships == null || relationships.isEmpty()) {
                cmdbDAO.deleteConfigurationItem(id);
            }
        }
        response.sendRedirect(request.getContextPath() + "/cmdb?action=list");
    }

    private void bulkDeleteConfigurationItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String[] ids = request.getParameterValues("selectedIds");
        if (ids != null) {
            for (String idStr : ids) {
                try {
                    int id = Integer.parseInt(idStr);
                    ConfigurationItem ci = cmdbDAO.getConfigurationItemById(id);
                    if (ci != null && "INACTIVE".equals(ci.getStatus())) {
                        List<CiRelationship> relationships = cmdbDAO.getCiRelationships(id);
                        if (relationships == null || relationships.isEmpty()) {
                            cmdbDAO.deleteConfigurationItem(id);
                        }
                    }
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

    private void addCiRelationship(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int parentId = Integer.parseInt(request.getParameter("parentCiId"));
        int childId = Integer.parseInt(request.getParameter("childCiId"));
        String relationshipType = request.getParameter("relationshipType");
        String description = request.getParameter("description");

        cmdbDAO.addCiRelationship(parentId, childId, relationshipType, description);
        response.sendRedirect(request.getContextPath() + "/cmdb?action=detail&id=" + parentId);
    }
}
