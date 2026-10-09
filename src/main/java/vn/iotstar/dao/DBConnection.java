package vn.iotstar.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

	// Cấu hình thông tin kết nối SQL Server trên Docker
	private final String serverName = "localhost";
	private final String dbName = "InstagramDB";
	private final String portNumber = "14333";              // Cổng Docker (14333) tránh trùng cổng 1433 của Windows
	private final String userID = "sa";                     // Tài khoản sa mặc định
	private final String password = "Password123!";         // Mật khẩu thiết lập trong docker-compose.yml

	/**
	 * Mở kết nối đến Microsoft SQL Server
	 */
	public Connection getConnection() {
		Connection conn = null;
		try {
			// Nạp Driver SQL Server
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			
			// Chuỗi kết nối JDBC (thêm trustServerCertificate=true để tránh lỗi SSL)
			String url = "jdbc:sqlserver://" + serverName + ":" + portNumber 
					+ ";databaseName=" + dbName 
					+ ";encrypt=true;trustServerCertificate=true;";
			
			conn = DriverManager.getConnection(url, userID, password);
		} catch (Exception e) {
			System.err.println("❌ Lỗi kết nối CSDL: " + e.getMessage());
			e.printStackTrace();
		}
		return conn;
	}

	/**
	 * Hàm main dùng để TEST KẾT NỐI trực tiếp trong Eclipse
	 * (Nhấp chuột phải -> Run As -> Java Application)
	 */
	public static void main(String[] args) {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		if (conn != null) {
			System.out.println(" Kết nối CSDL SQL Server (InstagramDB) THÀNH CÔNG!");
			System.out.println("Chi tiết: " + conn);
		} else {
			System.err.println(" Kết nối THẤT BÀI! Vui lòng kiểm tra lại username, password hoặc cổng 1433.");
		}
	}
}
