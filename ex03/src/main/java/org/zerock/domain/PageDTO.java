package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	private int startPage;//시작 페이지
	private int endPage; //끝 페이지 
	private boolean prev,next; // 왼쪽 오른쪽 링크 여부
	
	private int total; //전체 게시글 수
	private Criteria cri;
	
	public PageDTO(Criteria cri,int total) {
		this.cri=cri;
		this.total=total;
		
		this.endPage=(int)(Math.ceil(cri.getPageNum()/10.0))*10; //끝페이지 번호 구하기
		this.startPage = this.endPage-9; //시작 페이지 번호 구하기
		
		int realEnd= (int)(Math.ceil((total*1.0)/cri.getAmount())); //실제 끝 페이지 번호 이는 토탈로 여부를 지정
		
		if(realEnd<this.endPage) {
			this.endPage=realEnd;
		}
		
		this.prev=this.startPage>1; //true
		this.next=this.endPage<realEnd; // true
		
	}
}
