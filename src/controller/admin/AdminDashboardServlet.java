package controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String[]> patients = new ArrayList<>();
        patients.add(new String[]{"BN001", "Trần Văn Khá", "115"});
        patients.add(new String[]{"BN002", "Nguyễn Thị Lành", "150"});
        patients.add(new String[]{"BN003", "Lê Minh Tâm", "98"});

        request.setAttribute("patientData", patients);
        request.setAttribute("totalPatients", 3);
        request.setAttribute("alertsCount", 1);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}