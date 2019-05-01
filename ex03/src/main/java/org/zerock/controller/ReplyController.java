package org.zerock.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
//보통 ajax시 사용
@RequestMapping("/replies/")
@RestController
@Log4j
public class ReplyController {
	//REST방식 처리 댓글
	@Setter(onMethod_=@Autowired)
	private ReplyService service;
	
	//consumes와 produces를 통해 JSON 방식의 데이터만 처리하도록 
	@PostMapping(value="/new",consumes="application/json",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){ //@RequestBody는 JSON 타입을 ReplyVO 타입으로 전환하게 만듬
		log.info("ReplyVO: "+vo);
		int insertCount=service.register(vo);
		log.info("REply INSERT COUNT: "+insertCount);
		
		return insertCount==1? new ResponseEntity<>("success",HttpStatus.OK): new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	//특정 게시글의 댓글 리스트 뽑기 /pages/10/1 형식
	@GetMapping(value="/pages/{bno}/{page}",produces= {MediaType.APPLICATION_ATOM_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page,@PathVariable("bno") Long bno){
		log.info("getList............");
		Criteria cri=new Criteria(page,10);
		log.info(cri);
		return new ResponseEntity<>(service.getListPage(cri, bno),HttpStatus.OK);
	}
	
	//특정 댓글 얻기
	@GetMapping(value="/{rno}",produces= {MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get: "+rno);
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);
	}
	
	//특정 댓글 삭제
	@DeleteMapping(value="/{rno}",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("remove: "+rno);
		return service.remove(rno)==1
				?new ResponseEntity<>("success",HttpStatus.OK)
						:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//댓글 수정 (PUT & PATCH) 제이슨과 댓글번호를 파라미터로 받아서 처리
	@RequestMapping(method= {RequestMethod.PUT,RequestMethod.PATCH},value="/{rno}",
			consumes="application/json",
			produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo,@PathVariable("rno") Long rno){
		vo.setRno(rno);
		log.info("rno: "+rno);
		log.info("modify: "+vo);
		return service.modify(vo)==1
				?new ResponseEntity<>("success",HttpStatus.OK)
						:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
