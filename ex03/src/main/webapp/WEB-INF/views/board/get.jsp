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
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
				
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
					</div>
					
					<div class="form-group">
						<label>Text area</label> <textarea class="form-control" name="content" rows="3" readonly="readonly"><c:out value="${board.content}"/></textarea>
					</div>
					
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>
					<!-- 수정 창 이동 GET 방식으로 컨트롤러에서 modfiy.jsp 보여줌 -->
					<button data-oper="modify" class="btn btn-default">Modify</button>
					<button data-oper="list" class="btn btn-info">List</button>
					
					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="<c:out value="${board.bno }"/>">
						<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
						<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
						<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
						<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
					</form>
	
			</div>
		</div>
	</div>
</div>
<!-- 댓글 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
			</div>
			
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong>
								<small class="pull-right text-muted">2019-04-29 13:13</small>
								
							</div>
							<p>Good job!</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<%@ include file="../includes/footer.jsp" %>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
console.log("============");
console.log("JS TEST");

var bnoValue='<c:out value="${board.bno}"/>';

//for Reply add test
/*replyService.add({reply:"JS Test",replyer:"tester",bno:bnoValue},
		function(result){
			alert("RESULT: "+result); //success가 뜰 것임.
		}
);*/
/*for Reply list test
replyService.getList({bno:bnoValue,page:1},function(list){
	for(var i=0,len=list.length||0; i<len; i++){
		console.log(list[i]);	
	}
});*/
/*for Reply delete test
replyService.remove(5,function(count){
	console.log(count);
	if(count == "success"){
		alert("REMOVED");
	}
},function(err){
	alert("ERROR....");
});*/

/*for 댓글 수정 테스트
replyService.update({rno:21,bno:bnoValue,reply: "Modified Reply...."},
		function(result){
			alert("수정 완료.."+result);
		},function(err){
			alert("댓글이 존재하지않는다.");
		}
);*/
//for 특정 댓글 조회 테스트
replyService.get(10,function(data){
	console.log(data);
});
</script>

<script type="text/javascript">
	$(document).ready(function(){
		var operForm=$("#operForm");
		
		$("button[data-oper='modify']").on("click",function(e){
			operForm.attr("action","/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click",function(e){
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list").submit();
			
		});
	});

</script>
<!-- 댓글 이벤트 처리(댓글 목록가져와서 li 태그구성 -->
<script>
	$(document).ready(function(){
		var bnoValue='<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
		showList(1);
		function showList(page){
			//자바스크립트 getList 함수 호출 => 컨트롤러 내 
			replyService.getList({bno:bnoValue,page:page||1},
					function(list){
						var str="";
						if(list ==null || list.length==0){
							replyUL.html("");
							return ;
						}
						for(var i=0,len=list.length || 0; i<len; i++){
							str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
							str +="  <div><div class='header'><strong class='priamry-font'>"+list[i].replyer+"</strong>";
							str +="		<small class='pull-right text-muted'>"+list[i].replyDate+"</small></div>";
							str +=" 		<p>"+list[i].reply+"</p></div></li>";
						}
						replyUL.html(str);
			}); //end function
		}//end showList
	});

</script>