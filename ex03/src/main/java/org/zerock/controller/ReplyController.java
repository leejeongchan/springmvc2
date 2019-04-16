package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

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
	
}
