package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	
	private int pageNum; //페이지 번호
	private int amount; //한페이지당 개수
	
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1,10);
	}
	
	public Criteria(int pageNum,int amount) {
		this.pageNum=pageNum;
		this.amount=amount;
	}
	//검색 조건이 (T,W,C)로 구성되어 검색 조건을 배열로 만듬 Mybatis 동적 태그 활용
	public String[] getTypeArr() {
		return type == null ? new String[] {}: type.split("");
	}
	
	//UriCOmponentsBuilder 여러개의 파라미터를 연결해서 하나의 URL을 제공
	public String getListLink() {
		UriComponentsBuilder builder= UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		return builder.toUriString();
	}
}
