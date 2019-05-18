package org.zerock.domain;

import lombok.Data;
//파일 
@Data
public class BoardAttachVO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private Long bno;
}
