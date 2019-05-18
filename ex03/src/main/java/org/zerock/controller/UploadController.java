package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.BoardAttachVO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	/*@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}*/
	
	/*@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax");
		
	}*/
	//날짜명 폴더 생성을 위한 함수
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		
		String str = sdf.format(date);
		
		
		return str.replace("-",File.separator);
	}
	//이미지 파일 판단 함수(썸네일 생성을 위한 기초단계)
	private boolean checkImageType(File file)
	{
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
			
		}catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	//다운로드를 위함
	@GetMapping(value="/download",produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent,String fileName){
		log.info("download File: "+fileName);
		
		Resource resource = new FileSystemResource("c:\\upload\\"+fileName);
		if(resource.exists()==false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		log.info("resource: "+resource);
		
		String resourceName = resource.getFilename();
		
		//remove UUID 다운로드시 제거
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		HttpHeaders headers = new HttpHeaders();
		try {
			
			String downloadName = null;
			
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8").replaceAll("\\+"," ");
			}else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			}
			else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
			}
			//한글 깨짐 방지를 위함 
			log.info("downloadName: "+downloadName);
			headers.add("Content-Disposition","attachment; filename="+downloadName);
			
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
	}
	//이미지 섬네일 추가를 위해 GET방식으로 jsp에서 src get경로 지정시 섬네일 데이터를 전송하여 이를 표시
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName: "+fileName);
		
		File file = new File("c:\\upload\\"+fileName);
		
		log.info("file: "+file);
		
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			//파일의 종류에따라 MIME 타입이 달라지는것을 해결 MIME타입 데이터를 헤더에 포함
			header.add("Content-Type",Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
			
			
		}catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	//브라우저에도 추가적으로 업로드하고나서 json 형태로 결과를 넘겨줘야함 AttachFileDTO를 이용하여 객체시켜서 json형태로 넘겨줌
	@PostMapping(value="/uploadAjax",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> uploadAjaxPost(MultipartFile[] uploadFile)
	{
		List<BoardAttachVO> list = new ArrayList<>();
		
		
		log.info("update Ajax post....");
		String uploadFolder = "C:\\upload";
		String uploadFolderPath = getFolder();
		//make folder
		File uploadPath = new File(uploadFolder,uploadFolderPath);
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		//make yyyy/mm/dd 폴더 생성
		
		for(MultipartFile multipartFile : uploadFile) {
			
			BoardAttachVO attachDTO = new BoardAttachVO();
			
			
			String uploadFileName = multipartFile.getOriginalFilename();
			//파일이름 DTO에 넣어주기
			attachDTO.setFileName(uploadFileName);
			attachDTO.setUploadPath(uploadFolderPath);
			
			
			
			UUID uuid = UUID.randomUUID();
			
			
			//iE has file path
			//uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			
			log.info("only file name(for IE): "+uploadFileName);
	
			
			
			try {
				//File saveFile = new File(uploadFolder,uploadFileName);
				File saveFile = new File(uploadPath,uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				
				if(checkImageType(saveFile)) {
					attachDTO.setFileType(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					thumbnail.close();
					
					
				}
				list.add(attachDTO);
				
			}catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName,String type){
		log.info("deleteFile: "+fileName);
		
		File file;
		
		try {
			file = new File("c:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_","");
				
				log.info("largeFileName: "+largeFileName);
				
				file =new File(largeFileName);
				
				file.delete(); 
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<>("deleted",HttpStatus.OK);
	}
	
}
