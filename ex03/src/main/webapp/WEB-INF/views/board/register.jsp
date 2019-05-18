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
		<h1 class="page-header">Board Register</h1>
	</div>

</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			<div class="panel-body">
				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title">
					</div>
					
					<div class="form-group">
						<label>Text area</label> <textarea class="form-control" name="content" rows="3"></textarea>
					</div>
					   
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer">
					</div>
					
					<button type="submit" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				
				
				</form>
			
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				
				<div class='uploadResult'>
					<ul>
					
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	$(document).ready(function(e){
		var formObj = $("form[role='form']");
		
		$("button[type='submit']").on("click",function(e){
			e.preventDefault();
			
			console.log("submit clicked");
			
			var str2 = "";
			
			$(".uploadResult ul li").each(function(i,obj){
				var jobj = $(obj);
				
				console.dir(jobj);
				
				str2 += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str2 += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str2 += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str2 += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";

			});
			formObj.append(str2).submit();
		});
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$"); //파일 확장자 정규식 
		var maxSize = 5242880; // 5MB
		
		//삭제 
		$(".uploadResult").on("click","button",function(e){
			
			console.log("delete file");
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			
			var targetLi = $(this).closest("li");
			
			$.ajax({
				url:'/deleteFile',
				data: {fileName: targetFile,type:type},
				dataType:'text',
				type:'POST',
				success:function(result){
					alert(result);
					targetLi.remove();
				}
			});
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
<%@ include file="../includes/footer.jsp" %>