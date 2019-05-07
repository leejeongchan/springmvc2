package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{
	
	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;
	//반정규화로 인함
	
	@Setter(onMethod_=@Autowired)
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		// TODO Auto-generated method stub
		log.info("register......"+vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}
	
	
	@Override
	public ReplyVO get(Long rno) {
		// TODO Auto-generated method stub
		log.info("get......."+rno);
		
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		// TODO Auto-generated method stub
		log.info("modify....."+vo);
		
		return mapper.update(vo);
	}
	
	@Transactional
	@Override
	public int remove(Long rno) {
		// TODO Auto-generated method stub
		log.info("remove....."+rno);
		
		ReplyVO vo = mapper.read(rno);
		
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}
	//댓글 전체
	/*@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		// TODO Auto-generated method stub
		log.info("get Reply List of a Board " +bno);
		
		return mapper.getListWithPaging(cri, bno);
	}*/
	//페이징 댓글 처리
	@Override
	public ReplyPageDTO getListPage(Criteria cri,Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno),mapper.getListWithPaging(cri, bno));
	}
	
	
	
}
