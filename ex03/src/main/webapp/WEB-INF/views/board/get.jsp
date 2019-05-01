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
					<label>Bno</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Title</label> <input class="form-control" name="title"
						value='<c:out value="${board.title}"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" name="content" rows="3"
						readonly="readonly"><c:out value="${board.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				<!-- 수정 창 이동 GET 방식으로 컨트롤러에서 modfiy.jsp 보여줌 -->
				<button data-oper="modify" class="btn btn-default">Modify</button>
				<button data-oper="list" class="btn btn-info">List</button>

				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno"
						value="<c:out value="${board.bno }"/>"> <input
						type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum}"/>'> <input
						type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
					<input type="hidden" name="type"
						value='<c:out value="${cri.type}"/>'> <input type="hidden"
						name="keyword" value='<c:out value="${cri.keyword}"/>'>
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
				<button id='addReplyBtn' class="btn btn-primary btn-xs pull-right">New
					Reply</button>
			</div>

			<div class="panel-body">
				<ul class="chat">
					
				</ul>
			</div>
			<div class="panel-footer">
			</div>
		</div>
	</div>
</div>
<%@ include file="../includes/footer.jsp"%>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name='reply' value='New Reply!!!'>
				</div>
				
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name='replyer' value='replyer'>
				</div>
				
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name='replyDate' value=''>
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
	console.log("============");
	console.log("JS TEST");

	var bnoValue = '<c:out value="${board.bno}"/>';

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
	replyService.get(10, function(data) {
		console.log(data);
	});
</script>

<script type="text/javascript">
	$(document).ready(function() {
		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});

		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();

		});
	});
</script>
<!-- 댓글 이벤트 처리(댓글 목록가져와서 li 태그구성+모달창 댓글 등록 , 모달창 띄우기 등등) -->
<script>
	$(document)
			.ready(
					function() {
						var bnoValue = '<c:out value="${board.bno}"/>';
						var replyUL = $(".chat");

						showList(1);
						function showList(page) {
							//자바스크립트 getList 함수 호출 => 컨트롤러 내 
							replyService
									.getList(
											{
												bno : bnoValue,
												page : page || 1
											},
											function(replyCnt,list) {
												//처음 댓글 등록시 -1을 주어서 전체 댓글 수를 파악후 마지막으로 이동
												if(page == -1){
													pageNum = Math.ceil(replyCnt/10.0);
													showList(pageNum);
												}
												
												var str = "";
												if (list == null
														|| list.length == 0) {
													//replyUL.html("");
													return;
												}
												for (var i = 0, len = list.length || 0; i < len; i++) {
													str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
													str += "  <div><div class='header'><strong class='priamry-font'>["+list[i].rno+"]"
															+ list[i].replyer
															+ "</strong>";
													str += "		<small class='pull-right text-muted'>"
															+ replyService
																	.displayTime(list[i].replyDate)
															+ "</small></div>";
													str += " 		<p>"
															+ list[i].reply
															+ "</p></div></li>";
												}
												replyUL.html(str);
												
												showReplyPage(replyCnt);
											}); //end function
						}//end showList
						
						var modal = $(".modal");
						var modalInputReply = modal.find("input[name='reply']");
						var modalInputReplyer = modal.find("input[name='replyer']");
						var modalInputReplyDate = modal.find("input[name='replyDate']");
						
						var modalModBtn = $("#modalModBtn");
						var modalRemoveBtn = $("#modalRemoveBtn");
						var modalRegisterBtn = $("#modalRegisterBtn");
						
						//새로운 댓글 등록 시 에는 필요없는 input창을 없애고 필요없는 버튼도 없앤다.
						$("#addReplyBtn").on("click",function(e){
							
							modal.find("input").val(""); //비우기
							modalInputReplyDate.closest("div").hide(); //날짜 칸 숨기기
							modal.find("button[id!='modalCloseBtn']").hide(); //취소 버튼 제외하고 버튼 숨기기
							modalRegisterBtn.show(); // 등록 취소만 남김
							
							$(".modal").modal("show"); // 모달 창 보여주기
							
						});
						//댓글 등록 버튼 클릭시 이벤트
						modalRegisterBtn.on("click",function(e){
							
							var reply = {
									reply: modalInputReply.val(),
									replyer: modalInputReplyer.val(),
									bno: bnoValue
							};
							//callback
							replyService.add(reply,function(result){
								alert(result);
								
								modal.find("input").val(""); //댓글 등록 후 다시 비우기
								modal.modal("hide"); //그 다음 모달창 숨기기
								
								showList(-1); // 다시 목록 갱신 해주기 
							});
							
						});
						
						//특정 댓글조회 이벤트 처리 동적 자바스크립트 이기 때문
						$(".chat").on("click","li",function(e){
							
							var rno = $(this).data("rno");
							
							//console.log(rno);
							
							replyService.get(rno,function(reply){
								modalInputReply.val(reply.reply);
								modalInputReplyer.val(reply.replyer);
								modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
								.attr("readonly","readonly");
								modal.data("rno",reply.rno); //삭제 수정을 위해서
								
								//취소 버튼과 수정 삭제 버튼만 남기기
								modal.find("button[id !='modalCloseBtn']").hide();
								modalModBtn.show();
								modalRemoveBtn.show();
								
								$(".modal").modal("show"); //모달창 띄우기
								
							});
						});
						
						//댓글 수정
						modalModBtn.on("click",function(e){
							
							var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
							
							replyService.update(reply,function(result){
								alert(result);
								modal.modal("hide");
								showList(pageNum);
							});
						});
						
						//댓글 삭제
						modalRemoveBtn.on("click",function(e){
							
							var rno = modal.data("rno");
							
							replyService.remove(rno,function(result){
								alert(result);
								modal.modal("hide");
								showList(pageNum);
							});
						});
						
						var pageNum =1;
						var replyPageFooter = $(".panel-footer");
						//페이지네이션
						function showReplyPage(replyCnt){
							var endNum = Math.ceil(pageNum/10.0)*10; 
							var startNum = endNum-9; // 시작페이지 번호
							
							var prev = startNum !=1;
							var next = false;
							
							if(endNum*10 >= replyCnt){
								endNum = Math.ceil(replyCnt/10.0);
							}
							if(endNum*10 < replyCnt){
								next=true;
							}
							
							var str="<ul class='pagination pull-right'>";
							
							if(prev){
								str+="<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>";
							}
							
							for(var i=startNum; i<=endNum; i++){
								var active = pageNum == i?"active":"";
								
								str+="<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
								
							}
							
							if(next){
								str+="<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
								
							}
							
							str +="</ul></div>";
							
							console.log(str);
							
							replyPageFooter.html(str);
							
						}
						
						replyPageFooter.on("click","li a",function(e){
							e.preventDefault();
							console.log("page click");
							
							var targetPageNum = $(this).attr("href");
							
							console.log("targetPageNum: "+targetPageNum);
							
							pageNum = targetPageNum;
							showList(pageNum);
						});
					});
</script>