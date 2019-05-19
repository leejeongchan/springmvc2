package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor =>자동 주입 설정
public class BoardServiceImpl implements BoardService{
	
	@Setter(onMethod_=@Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		// TODO Auto-generated method stub
		log.info("register......."+board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList()==null || board.getAttachList().size()<=0) {
			return;
		}
		
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		// TODO Auto-generated method stub
		log.info("get......."+bno);
		
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		// TODO Auto-generated method stub
		log.info("modify......."+board);
		
		return mapper.update(board)==1;
	}

	@Override
	public boolean remove(Long bno) {
		// TODO Auto-generated method stub
		log.info("remove......."+bno);
		
		return mapper.delete(bno)==1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		log.info("getList with criteria: "+cri);
		
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get Total Count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		
		// TODO Auto-generated method stub
		
		log.info("get Attach List by bno: "+bno);
		
		
		return attachMapper.findByBno(bno);
	}

}
