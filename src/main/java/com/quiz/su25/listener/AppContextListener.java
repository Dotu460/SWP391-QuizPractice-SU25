/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.listener;

import com.quiz.su25.dal.impl.SettingDAO;
import com.quiz.su25.entity.Setting;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Application Context Listener for loading configuration settings at startup
 * @author LENOVO
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(AppContextListener.class.getName());
    private static final String SETTINGS = "SETTINGS";
    
    // Common setting keys (add your own here)
    public static final String EMAIL_NOTIFICATION = "email_notification";
    public static final String MAX_LOGIN_ATTEMPTS = "max_login_attempts";
    public static final String SESSION_TIMEOUT = "session_timeout";
    public static final String HOMEPAGE_POSTS_LIMIT = "homepage_posts_limit";
    public static final String MAINTENANCE_MODE = "maintenance_mode";
    public static final String DEFAULT_QUIZ_TIME = "default_quiz_time";
    public static final String MAX_QUESTIONS_PER_QUIZ = "max_questions_per_quiz";
    public static final String ADMIN_EMAIL = "admin_email";
    public static final String SYSTEM_NAME = "system_name";
    public static final String MIN_PASS_SCORE = "min_pass_score";
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Starting application - loading settings...");
        loadApplicationSettings(sce.getServletContext());
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        
        // Clean up stored settings
        context.removeAttribute(SETTINGS);
        
        logger.info("Application context destroyed - settings cleared");
    }
    
    /**
     * Load application settings from database and store in ServletContext
     * @param context ServletContext
     */
    private void loadApplicationSettings(ServletContext context) {
        try {
            // Tạo một instance của SettingDAO
            SettingDAO settingDAO = new SettingDAO();
            
            // Lấy tất cả cài đặt từ cơ sở dữ liệu
            List<Setting> settings = settingDAO.findAll();
            
            // Lưu các cài đặt vào một Map với key-value tương ứng
            Map<String, String> settingsMap = new HashMap<>();
            for (Setting setting : settings) {
                settingsMap.put(setting.getKey(), setting.getValue());
            }
            
            // Lưu Map này vào ServletContext với tên "SETTINGS"
            context.setAttribute(SETTINGS, settingsMap);
            
            // Ghi log thông tin về quá trình tải cài đặt
            logger.info("Successfully loaded " + settings.size() + " application settings");
            
            // Debug output
            System.out.println("=== Application Settings Loaded ===");
            for (Setting setting : settings) {
                System.out.println("Key: " + setting.getKey() + " = " + setting.getValue());
            }
            System.out.println("=== End Settings ===");
            
        } catch (Exception e) {
            // Log error but don't prevent application startup
            logger.severe("Error loading application settings: " + e.getMessage());
            e.printStackTrace();
            
            // Store empty map to prevent null pointer exceptions
            context.setAttribute(SETTINGS, new HashMap<String, String>());
        }
    }
    
    /**
     * Get setting value by key from ServletContext
     * @param context ServletContext
     * @param key Setting key
     * @return Setting value or null if not found
     */
    public static String getSettingValue(ServletContext context, String key) {
        @SuppressWarnings("unchecked")
        Map<String, String> settingsMap = (Map<String, String>) context.getAttribute(SETTINGS);
        return settingsMap != null ? settingsMap.get(key) : null;
    }
    
    /**
     * Get setting value by key with default value from ServletContext
     * @param context ServletContext
     * @param key Setting key
     * @param defaultValue Default value if setting not found
     * @return Setting value or default value if not found
     */
    public static String getSettingValue(ServletContext context, String key, String defaultValue) {
        String value = getSettingValue(context, key);
        return value != null ? value : defaultValue;
    }
    
    /**
     * Get settings map from ServletContext
     * @param context ServletContext
     * @return Map of all settings (key -> value)
     */
    @SuppressWarnings("unchecked")
    public static Map<String, String> getSettingsMap(ServletContext context) {
        Map<String, String> settingsMap = (Map<String, String>) context.getAttribute(SETTINGS);
        return settingsMap != null ? settingsMap : new HashMap<>();
    }
    
    /**
     * Refresh settings from database (call this after settings are updated)
     * @param context ServletContext
     * @return true if refresh successful, false otherwise
     */
    public static boolean refreshSettings(ServletContext context) {
        try {
            SettingDAO settingDAO = new SettingDAO();
            List<Setting> settings = settingDAO.findAll();
            
            // Create new map
            Map<String, String> settingsMap = new HashMap<>();
            for (Setting setting : settings) {
                settingsMap.put(setting.getKey(), setting.getValue());
            }
            
            // Update ServletContext
            context.setAttribute(SETTINGS, settingsMap);
            
            logger.info("Settings refreshed successfully - " + settings.size() + " settings loaded");
            return true;
            
        } catch (Exception e) {
            logger.severe("Error refreshing settings: " + e.getMessage());
            return false;
        }
    }
    
    // ========== UTILITY METHODS FOR ACCESSING SETTINGS ==========
    
    /**
     * Get setting value by key from HttpServletRequest
     * @param request HttpServletRequest
     * @param key Setting key
     * @return Setting value or null if not found
     */
    public static String getSetting(HttpServletRequest request, String key) {
        ServletContext context = request.getServletContext();
        return getSettingValue(context, key);
    }
    
    /**
     * Get setting value by key with default value from HttpServletRequest
     * @param request HttpServletRequest
     * @param key Setting key
     * @param defaultValue Default value if setting not found
     * @return Setting value or default value if not found
     */
    public static String getSetting(HttpServletRequest request, String key, String defaultValue) {
        ServletContext context = request.getServletContext();
        return getSettingValue(context, key, defaultValue);
    }
    
    /**
     * Get setting value by key from ServletContext
     * @param context ServletContext
     * @param key Setting key
     * @return Setting value or null if not found
     */
    public static String getSetting(ServletContext context, String key) {
        return getSettingValue(context, key);
    }
    
    /**
     * Get setting value by key with default value from ServletContext
     * @param context ServletContext
     * @param key Setting key
     * @param defaultValue Default value if setting not found
     * @return Setting value or default value if not found
     */
    public static String getSetting(ServletContext context, String key, String defaultValue) {
        return getSettingValue(context, key, defaultValue);
    }
    
    /**
     * Get boolean setting value
     * @param request HttpServletRequest
     * @param key Setting key
     * @param defaultValue Default boolean value
     * @return Boolean value of setting
     */
    public static boolean getBooleanSetting(HttpServletRequest request, String key, boolean defaultValue) {
        String value = getSetting(request, key);
        if (value == null) return defaultValue;
        return "true".equalsIgnoreCase(value.trim()) || "1".equals(value.trim());
    }
    
    /**
     * Get integer setting value
     * @param request HttpServletRequest
     * @param key Setting key
     * @param defaultValue Default integer value
     * @return Integer value of setting
     */
    public static int getIntSetting(HttpServletRequest request, String key, int defaultValue) {
        String value = getSetting(request, key);
        if (value == null) return defaultValue;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Get long setting value
     * @param request HttpServletRequest
     * @param key Setting key
     * @param defaultValue Default long value
     * @return Long value of setting
     */
    public static long getLongSetting(HttpServletRequest request, String key, long defaultValue) {
        String value = getSetting(request, key);
        if (value == null) return defaultValue;
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Get double setting value
     * @param request HttpServletRequest
     * @param key Setting key
     * @param defaultValue Default double value
     * @return Double value of setting
     */
    public static double getDoubleSetting(HttpServletRequest request, String key, double defaultValue) {
        String value = getSetting(request, key);
        if (value == null) return defaultValue;
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Check if maintenance mode is enabled
     * @param request HttpServletRequest
     * @return true if maintenance mode is enabled
     */
    public static boolean isMaintenanceMode(HttpServletRequest request) {
        return getBooleanSetting(request, MAINTENANCE_MODE, false);
    }
    
    /**
     * Check if email notifications are enabled
     * @param request HttpServletRequest
     * @return true if email notifications are enabled
     */
    public static boolean isEmailNotificationEnabled(HttpServletRequest request) {
        return getBooleanSetting(request, EMAIL_NOTIFICATION, true);
    }
    
    /**
     * Get maximum login attempts allowed
     * @param request HttpServletRequest
     * @return Maximum login attempts (default: 5)
     */
    public static int getMaxLoginAttempts(HttpServletRequest request) {
        return getIntSetting(request, MAX_LOGIN_ATTEMPTS, 5);
    }
    
    /**
     * Get session timeout in minutes
     * @param request HttpServletRequest
     * @return Session timeout in minutes (default: 30)
     */
    public static int getSessionTimeout(HttpServletRequest request) {
        return getIntSetting(request, SESSION_TIMEOUT, 30);
    }
    
    /**
     * Get homepage posts limit
     * @param request HttpServletRequest
     * @return Number of posts to show on homepage (default: 6)
     */
    public static int getHomepagePostsLimit(HttpServletRequest request) {
        return getIntSetting(request, HOMEPAGE_POSTS_LIMIT, 6);
    }
    
    /**
     * Get default quiz time in minutes
     * @param request HttpServletRequest
     * @return Default quiz time in minutes (default: 60)
     */
    public static int getDefaultQuizTime(HttpServletRequest request) {
        return getIntSetting(request, DEFAULT_QUIZ_TIME, 60);
    }
    
    /**
     * Get maximum questions per quiz
     * @param request HttpServletRequest
     * @return Maximum questions per quiz (default: 50)
     */
    public static int getMaxQuestionsPerQuiz(HttpServletRequest request) {
        return getIntSetting(request, MAX_QUESTIONS_PER_QUIZ, 50);
    }
    
    /**
     * Get admin email address
     * @param request HttpServletRequest
     * @return Admin email address
     */
    public static String getAdminEmail(HttpServletRequest request) {
        return getSetting(request, ADMIN_EMAIL, "admin@quizpractice.com");
    }
    
    /**
     * Get system name
     * @param request HttpServletRequest
     * @return System name
     */
    public static String getSystemName(HttpServletRequest request) {
        return getSetting(request, SYSTEM_NAME, "Quiz Practice System");
    }
    
    /**
     * Get minimum passing score
     * @param request HttpServletRequest
     * @return Minimum passing score (default: 70)
     */
    public static int getMinPassScore(HttpServletRequest request) {
        return getIntSetting(request, MIN_PASS_SCORE, 70);
    }
    
    /**
     * Refresh settings cache (useful after manual database changes)
     * @param context ServletContext
     * @return true if refresh successful
     */
    public static boolean refreshCache(ServletContext context) {
        return refreshSettings(context);
    }
    
    /* 
     * ==================== USAGE EXAMPLES ====================
     * 
     * 1. In Controllers/Servlets:
     * 
     *    String systemName = AppContextListener.getSystemName(request);
     *    boolean maintenanceMode = AppContextListener.isMaintenanceMode(request);
     *    int maxAttempts = AppContextListener.getMaxLoginAttempts(request);
     *    String customValue = AppContextListener.getSetting(request, "custom_key", "default");
     * 
     * 2. In JSP Pages:
     * 
     *    <%@ page import="com.quiz.su25.listener.AppContextListener" %>
     *    <%
     *        String systemName = AppContextListener.getSystemName(request);
     *        boolean maintenanceMode = AppContextListener.isMaintenanceMode(request);
     *    %>
     *    <h1><%= systemName %></h1>
     *    <% if (maintenanceMode) { %>
     *        <div class="alert">System is under maintenance</div>
     *    <% } %>
     * 
     * 3. Common Settings Available:
     * 
     *    - EMAIL_NOTIFICATION: "email_notification"
     *    - MAX_LOGIN_ATTEMPTS: "max_login_attempts"  
     *    - SESSION_TIMEOUT: "session_timeout"
     *    - MAINTENANCE_MODE: "maintenance_mode"
     *    - DEFAULT_QUIZ_TIME: "default_quiz_time"
     *    - SYSTEM_NAME: "system_name"
     *    - And more...
     * 
     * 4. Auto-refresh:
     * 
     *    Settings are automatically refreshed when you create/update/delete
     *    through ManageSettingController. For manual refresh:
     *    
     *    AppContextListener.refreshCache(getServletContext());
     * 
     */
}
