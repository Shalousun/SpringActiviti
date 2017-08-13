package com.sunyu.activiti.filter;

import com.sunyu.activiti.constant.GlobConstants;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * 全局session过滤器
 * Created by yu on 2017/7/12.
 */
public class SessionFilter implements Filter {

    private  Set<String> excluded = null;

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        String excludedString = fConfig.getInitParameter("excluded");
        if (excludedString != null) {
            excluded = Collections.unmodifiableSet(
                    new HashSet<>(Arrays.asList(excludedString.split(",", 0))));
        } else {
            excluded = Collections.emptySet();
        }
    }

    @Override
    public void destroy() {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        // Protection against Type 1 Reflected XSS attacks
        res.setHeader("Content-Security-Policy", "frame-ancestors 'self'");
        res.addHeader("X-XSS-Protection", "1; mode=block");
        // Disabling browsers to perform risky mime sniffing
        res.addHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options","sameorigin");
        if (isExcluded(req)){
            chain.doFilter(request, response);
            return;
        }else{
            HttpSession session = ((HttpServletRequest) request).getSession();
            if (session == null || session.getAttribute(GlobConstants.USER_NAME) == null) {
                req.getRequestDispatcher("/login").forward(request,response);
            } else {
                chain.doFilter(request, response);
            }

        }

    }


    private boolean isExcluded(HttpServletRequest request) {
        String path = request.getRequestURI();
        String extension = path.substring(path.indexOf('.', path.lastIndexOf('/')) + 1).toLowerCase();
        return excluded.contains(extension);
    }



}
