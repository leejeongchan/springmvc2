package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	// /board/list 에의한 전체 테이블 목록 보여주기 GET 방식으로 요청이 들어온다.
	/*@GetMapping("/list")
	public void list(Model model)
	{
		log.info("list");
		model.addAttribute("list",service.getList());
	}*/
	
	@GetMapping("/list")
	public void list(Criteria cri,Model model) {
		log.info("list: " +cri);
		model.addAttribute("list",service.getList(cri));
		model.addAttribute("pageMaker",new PageDTO(cri,service.getTotal(cri)));
	}
	
	// /board/register GET 방식일 때 버튼을 눌러서 등록 폼을 사용자에게 보여준다.
	@GetMapping("/register")
	public void register() {
		
	}
	
	// /board/register POST 방식이면 넘어온 파라미터를 통해 게시글을 등록한다.
	@PostMapping("/register")
	public String register(BoardVO board,RedirectAttributes rttr)
	{
		log.info("=====================================");
		
		log.info("register: "+board);
		if(board.getAttachList()!=null) {
			board.getAttachList().forEach(attach ->log.info(attach));
		}
		log.info("=====================================");

		service.register(board);
		//등록 글 번호 모달 창 띄우기 위함
		rttr.addFlashAttribute("result",board.getBno());
		return "redirect:/board/list";
	}
	
	// /board/get or /board/modify 으로 GET방식으로 조회할 게시글 번호를 bno로 넘겨서 해당 게시글 조회,수정하기
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno,@ModelAttribute("cri") Criteria cri,Model model) {
		log.info("/get or modify");
		model.addAttribute("board",service.get(bno));
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board,@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify:"+board);
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");
		}
		
		/*rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());*/
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno,@ModelAttribute("cri") Criteria cri,RedirectAttributes rttr) {
		log.info("remove...."+bno);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			
			//파일 삭제
			deleteFiles(attachList);
			rttr.addFlashAttribute("result","success");
		}
		/*rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());*/
		return "redirect:/board/list" + cri.getListLink();
	}
	
	//Ajax형식으로 GET방식으로 첨부파일 조회할 때 사용
	@GetMapping(value="/getAttachList",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno)
	{
		log.info("getAttachList "+bno);
		
		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
	}
	
	
	//파일 삭제 처리 메서드 이는 remove 에서 사용
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size()==0) {
			return ;
		}
		log.info("delete attach Files.....................");
		log.info("attachList");
		
		attachList.forEach(attach->{
			try {
				Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.deleteIfExists(thumbnail);
					
				}
			}catch(Exception e)
			{
				log.error("delete file error"+e.getMessage());
			}
		});
	}
}
