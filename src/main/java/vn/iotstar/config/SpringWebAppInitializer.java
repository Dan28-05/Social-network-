package vn.iotstar.config;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.Filter;

public class SpringWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

	@Override
	public void onStartup(javax.servlet.ServletContext servletContext) throws javax.servlet.ServletException {
		java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
		servletContext.setInitParameter("javax.servlet.jsp.jstl.fmt.timeZone", "Asia/Ho_Chi_Minh");
		super.onStartup(servletContext);
	}

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class<?>[] { ApplicationContextConfig.class };
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[] { WebMvcConfig.class };
	}

	@Override
	protected String[] getServletMappings() {
		return new String[] { "/" };
	}

	@Override
	protected Filter[] getServletFilters() {
		// Bộ lọc mã hóa tiếng Việt UTF-8
		CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
		encodingFilter.setEncoding("UTF-8");
		encodingFilter.setForceEncoding(true);
		return new Filter[] { encodingFilter };
	}

	@Override
	protected void customizeRegistration(javax.servlet.ServletRegistration.Dynamic registration) {
		// Cấu hình Multipart hỗ trợ upload ảnh và video từ máy tính (tối đa 100MB)
		javax.servlet.MultipartConfigElement multipartConfigElement =
				new javax.servlet.MultipartConfigElement("", 100 * 1024 * 1024, 200 * 1024 * 1024, 0);
		registration.setMultipartConfig(multipartConfigElement);
	}
}
