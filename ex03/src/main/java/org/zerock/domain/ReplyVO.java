package org.zerock.domain;

import lombok.Data;
import java.util.Date;
@Data
public class ReplyVO {
	
	private Long rno; //댓글 번호 기본키 자동증가
	private Long bno; //게시글 번호 외래키
	
	private String reply;
	private String replyer;
	private Date replyDate; 
	private Date updateDate;
}
