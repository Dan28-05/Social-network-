package vn.iotstar.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Posts")
public class Post implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "post_id")
	private Integer postId;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	@Column(name = "image_url", nullable = false, columnDefinition = "VARCHAR(MAX)")
	private String imageUrl;

	@Column(name = "caption", length = 1000)
	private String caption;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "created_at")
	private Date createdAt = new Date();

	public Post() {
	}

	public Post(User user, String imageUrl, String caption) {
		this.user = user;
		this.imageUrl = imageUrl;
		this.caption = caption;
	}

	public Integer getPostId() {
		return postId;
	}

	public void setPostId(Integer postId) {
		this.postId = postId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getCaption() {
		return caption;
	}

	public void setCaption(String caption) {
		this.caption = caption;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	@Transient
	public boolean isVideo() {
		if (imageUrl == null) {
			return false;
		}
		String lower = imageUrl.toLowerCase().trim();
		return lower.startsWith("data:video/") || lower.endsWith(".mp4") || lower.endsWith(".webm") || lower.endsWith(".mov")
				|| lower.endsWith(".ogg") || lower.endsWith(".mkv");
	}
}
