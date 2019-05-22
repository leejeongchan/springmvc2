package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
//새벽마다 2시마다 파일 목록과 디비를 체크해서 존재하지 안흔 파일들을 삭제해준다.
@Log4j
@Component
public class FileCheckTask {
	@Setter(onMethod_= {@Autowired})
	private BoardAttachMapper attachMapper;
	
	//어제 폴더명 얻기
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
		
	}
	
	@Scheduled(cron="0 0 2 * * *") //매 새벽 2시마다 실행
	public void checkFiles() throws Exception{
		
		
		
		log.warn("File Check Task run...............");
		
		log.warn("==================================");
		// 1. DB안에 어제 파일 목록 리스트 얻어오기
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// 디렉토리에 파일 채크를 위한 준비 예상 목록 파일 생성
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload",vo.getUploadPath(),vo.getUuid()+"_"+vo.getFileName())).collect(Collectors.toList());
		
		//이미지파일일경우 썸네일 
		fileList.stream().filter(vo -> vo.isFileType()==true).map(vo ->Paths.get("C:\\upload",vo.getUploadPath(),"s_"+vo.getUuid()+"_"+vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		
		log.warn("============================================");
		
		fileListPaths.forEach(p->log.warn(p));
		
		//어제 디렉토리
		File targetDir = Paths.get("C:\\upload",getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath())==false);
		log.warn("============================================");
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
		
	}
}
