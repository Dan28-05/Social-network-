package vn.iotstar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "vn.iotstar")
public class WebMvcConfig implements WebMvcConfigurer {

	@Bean
	public ViewResolver viewResolver() {
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setViewClass(JstlView.class);
		resolver.setPrefix("/WEB-INF/views/");
		resolver.setSuffix(".jsp");
		return resolver;
	}

	@Bean
	public org.springframework.web.multipart.MultipartResolver multipartResolver() {
		return new org.springframework.web.multipart.support.StandardServletMultipartResolver();
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/templates/**")
				.addResourceLocations("/WEB-INF/templates/", "/templates/");

		// Cấu hình đường dẫn phục vụ file ảnh/video upload từ máy tính
		String userHome = System.getProperty("user.home").replace("\\", "/");
		String persistentUploadLocation = "file:///" + userHome + "/instagram_uploads/";
		registry.addResourceHandler("/uploads/**")
				.addResourceLocations("/uploads/", persistentUploadLocation);
	}
}
