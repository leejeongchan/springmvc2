<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>
<style>
	.uploadResult {
		width:100%;
		background-color:gray;
	}
	
	.uploadResult ul{
		display:flex;
		flex-flow:row;
		justify-content:center;
		align-items:center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding:10px;
		align-context:center;
		text-align:center;
	}
	
	.uploadResult ul li img{
		width:200px;
	}
	
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top:0%;
		width:100%;
		height:100%;
		background-color: gray;
		z-index: 100;
		background:rgba(255,255,255,0.5);
	}
	.bigPicture{
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img{
		width: 600px;
	}
</style>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>

</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<div class="panel-body">
			
			<form role="form" action="/board/modify" method="post">
			<!-- list이동시 페이지 유지하기 위함 -->
			<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
			<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
			<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
			<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
				<div class="form-group">
					<label>Bno</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Title</label> <input class="form-control" name="title"
						value='<c:out value="${board.title}"/>'>
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" name="content" rows="3">
					<c:out value="${board.content}"/></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				
				<div class="form-group">
					<label>RegDate</label>
					<input class="form-control" name="regdate" value="<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>" readonly="readonly"> 
				</div>
				
				<div class="form-group">
					<label>Update Date</label>
					<input class="form-control" name="updateDate" value="<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>" readonly="readonly"> 
				</div>
				<!-- 자바스크립트에 의해서 action 속성부분을 버튼에 따라 수정돼서 사용됨 -->
				<button type="submit" data-oper="modify" class="btn btn-default">
					Modify
				</button>
				
				<button type="submit" data-oper="remove" class="btn btn-default">
					Remove
				</button>
				
				<button type="submit" data-oper="list" class="btn btn-info">
					List
				</button>
				
				
				
			</form>
			

			</div>
		</div>
	</div>
</div>
<!-- 첨부파일 -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div> 
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
			
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple="multiple">
				</div>

				<div class='uploadResult'>
					<ul>
					</ul>
				</div>
			
			</div>
		</div>
	</div>
</div>
<%@ include file="../includes/footer.jsp"%>
<!-- 첨부파일 조회 -->
<script>
$(document).ready(function(){
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$"); //파일 확장자 정규식 
	var maxSize = 5242880; // 5MB
	
	//게시글 수정 에서 첨부파일 보여주기
	(function(){
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList",{bno:bno},function(arr){
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i,attach){
				
				//image Type
				if(attach.fileType){
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
					
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str += "<span> " + attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				}else{//일반파일
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str += "<span> "+attach.fileName+"</span><br/>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.jpg'>";
					str += "</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});
	})();
	//우선 첨부파일 삭제를 누르면 폴더 내에 삭제가 되기 때문에 사용자가 수정 버튼 안눌렀을 때 문제가 발생하여 우선 뷰를 삭제시켜준다. 그 후 수정 버튼 누르면 그때 
	//폴더 내에서 삭제되도록 구현
	$(".uploadResult").on("click","button",function(e){
		console.log("delete file");
		
		if(confirm("Remmove this file?")){
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	});
	
	//업로드 파일 보여주기
	function showUploadFile(uploadResultArr){
		
		if(!uploadResultArr || uploadResultArr.length==0){return;}
		
		var uploadResult = $(".uploadResult ul");
		
		var str = "";
		
		$(uploadResultArr).each(function(i,obj){
			if(!obj.fileType){
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				console.log("일반파일");
				console.log("data-filename: "+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'";
				str += "><div>";
				str += "<span> "+obj.fileName+"</span>";
				str += "<button data-file=\'"+fileCallPath+"\' data-type='file' type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.jpg'>";
				str += "</div>";
				str += "</li>";

			}else{
				//str +="<li>" + obj.fileName + "</li>";
				//썸네일 처리(Get방식)
				console.log("이미지파일");
				console.log("data-filename: "+obj.fileName);
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				//이미지를 클릭시 원본 이미지 보여주기 위해서 /s 경로를 /로 바꿔준다.생성된 문자열 \때문에 일반문자열과 다르기 때문에 정규화 이용
				
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'";
				str += "><div>";
				str += "<span> "+obj.fileName+"</span>";
				str += "<button data-file='\'"+fileCallPath+"'\' data-type='image' type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str += "</li>";
			
			}
		});
		uploadResult.append(str);
	}
	
	//파일 체크
	function checkExtension(fileName,fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	

	//파일 업로드 시 
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name,files[i].size)){
				return false;
			}
			formData.append("uploadFile",files[i]);
		}
		
		$.ajax({
			url: '/uploadAjax',
			processData:false,
			contentType:false,
			data:formData,
			type:'POST',
			dataType:'json',
			success:function(result){
				console.log(result);
				showUploadFile(result); //업로드 결과 처리 함수
				
			}
		});
		
	});
	
	
});

</script>
<script type="text/javascript">
//버튼에 따라 form action을 달리 하게 하는 자바스크립트 POST방식일때는 action속성 GET일 때는 self.location으로 지정 
//이떄 첨부파일 정보도 함께 전송 (수정)
	$(document).ready(function(){
		
		var formObj=$("form"); //form 태그 얻어오기
		
		$('button').on("click",function(e){ //버튼 클릭시 
			e.preventDefault();
			
			var operation = $(this).data("oper"); //data-oper 값 operation에 넣어주기
			
			console.log(operation);
			
			if(operation==='remove'){ //제거 버튼 일 경우 
				formObj.attr("action","/board/remove");//action을 /board/remove로 바꾼다.
				
			}else if(operation === 'list'){ 
				//move to list GET이기 때문에
				formObj.attr("action","/board/list").attr("method","get");
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag= $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			}else if(operation == 'modify'){
				var str2 ="";
				$(".uploadResult ul li").each(function(i,obj){
					var jobj = $(obj);
					
					console.dir(jobj);
					
					str2 += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str2 += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str2 += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str2 += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";

				});
				formObj.append(str2).submit();
			}
			formObj.submit(); //e.preventDefault로 기본 기능 막았으므로 누르기 를 통해 적용
		});
	});

</script>