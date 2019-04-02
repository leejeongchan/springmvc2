package org.zerock.service;

import java.util.List;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {
	//게시글 등록 서비스
	public void register(BoardVO board);
	
	//게시글 번호로 특정 게시글 조회 서비스
	public BoardVO get(Long bno);
	
	//게시글 수정
	public boolean modify(BoardVO board);
	
	//게시글 제거
	public boolean remove(Long bno);
	
	//게시글 전체 리스트로 받기 
	//public List<BoardVO> getList();
	
	//페이징 게시글 리스트 받기
	public List<BoardVO> getList(Criteria cri);
	
	public int getTotal(Criteria cri);
}
