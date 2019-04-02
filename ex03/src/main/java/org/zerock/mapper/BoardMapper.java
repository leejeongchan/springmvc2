package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
/*
 * 마이바티스 인터페이스 게시글 관련
 *
 *
 * getList(): 게시글 테이블 모든 정보 
 * getListWithPaging(Criteria cri): 게시글 페이징 처리 
 * insert(BoardVO board): 게시글 테이블에 삽입
 * insertSelectKey(BoardVO board): 게시글 테이블에 삽입 하돼 시퀀스 넘버를 알고 삽입
 * read(Long bno): 게시글 번호로 조회
 * delete(Long bno): 게시글 번호로 해당 게시글 삭제
 * update(BoardVO board): 해당 게시글 수정
 * getTotalCount(Criteria cri): 게시글 총 개수 구하기
 */
public interface BoardMapper {
	
	public List<BoardVO> getList();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);
}
