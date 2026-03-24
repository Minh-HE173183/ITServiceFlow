package com.itserviceflow.listeners;

import com.itserviceflow.utils.WorkflowService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

@WebListener
public class SlaMonitorListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(SlaMonitorListener.class.getName());
    private ScheduledExecutorService scheduler;
    private final WorkflowService workflowService = new WorkflowService();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("SlaMonitorListener initialized. Starting SLA background thread...");
        scheduler = Executors.newSingleThreadScheduledExecutor();
        // Chạy kiểm tra mỗi 5 phút, bắt đầu sau 1 phút khởi động server
        scheduler.scheduleAtFixedRate(() -> {
            try {
                // LOGGER.info("Running SLA Breach check...");
                workflowService.runSlaBreachCheck();
            } catch (Exception e) {
                LOGGER.severe("Error during SLA check: " + e.getMessage());
            }
        }, 1, 5, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            LOGGER.info("SlaMonitorListener stopped.");
        }
    }
}
