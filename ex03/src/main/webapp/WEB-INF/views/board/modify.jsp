<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

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
<%@ include file="../includes/footer.jsp"%>
<script type="text/javascript">
//버튼에 따라 form action을 달리 하게 하는 자바스크립트 POST방식일때는 action속성 GET일 때는 self.location으로 지정
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
			}
			formObj.submit(); //e.preventDefault로 기본 기능 막았으므로 누르기 를 통해 적용
		});
	});

</script>