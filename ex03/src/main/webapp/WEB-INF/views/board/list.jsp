<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>
<!-- 게시글 리스트 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				Board List Page
				<button id='regBtn' type="button" class="btn btn-xs pull-right">Register
					New Board</button>
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="board">
						<tr>
							<td><c:out value="${board.bno}" /></td>
							<!-- 자바스크립트로 이동 처리하기 페이지 이동후 게시글 조회후 다시 목록으로 이동시 1페이지로 이동하는것을 방지 -->
							<td><a class='move' href='<c:out value="${board.bno}"/>'><c:out
										value="${board.title}" /></a></td>
							<td><c:out value="${board.writer}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${board.regdate}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${board.updateDate}" /></td>
						</tr>
					</c:forEach>

				</table>
				<!-- 검색창 -->
				<div class="row">
					<div class="col-lg-12">
						<form id='searchForm' action='/board/list' method='get'>
							<select name='type'>
								<option value="" <c:out value="${pageMaker.cri.type == null?'selected':''}"/>>--</option>
								<option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
								<option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
								<option value="W" <c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
								<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 or 내용</option>
								<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW'?'selected':''}"/>>제목 or 작성자</option>
								<option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC'?'selected':''}"/>>제목 or 내용 or 작성자</option>
							</select>
							<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
							<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>'>
							<input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>'>
							<button class="btn btn-default">Search</button>
						
						</form>
					
					
					</div>
				</div>
				
				<div class="pull-right">
					<ul class="pagination">
						<!-- href값을 페이지 번호로 대체하여 이를 자바스크립트에서 href값을 통해 form 태그 내 input hidden에 값을 대체하여 form으로 submit -->
						<c:if test="${pageMaker.prev}">
							<li class="paginate_button previous"><a href="${pageMaker.startPage-1}">Previous</a></li>
						</c:if>
						
						<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
							<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' :''}"><a href="${num}">${num}</a></li>
						</c:forEach>
						
						<c:if test="${pageMaker.next}">
							<li class="paginate_button next"><a href="${pageMaker.endPage+1}">Next</a></li>
						</c:if>
					
					</ul>
				</div>
				<!-- 위에서 클래스 id가 move인 것을 통해 해당 페이지 번호와 게시글 번호 amount를 전달 이는 밑 자바스크립트에서 기능 구현
				동적으로 append로 추가하기 -->
				<form id="actionForm" action="/board/list" method="get">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
					<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
					<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
					<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
				
				</form>


				<!-- Modal 등록 -->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
					aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel">Modal title</h4>
							</div>
							<div class="modal-body">처리가 완료되었습니다.</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save
									changes</button>
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				</div>
				<!-- /.modal -->
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
</div>
<!-- /.row -->
<%@ include file="../includes/footer.jsp"%>

<script type="text/javascript">
	$(document).ready(
			function() {
				var result = '<c:out value="${result}"/>';

				checkModal(result);
				
				//list 호출시 모달창 계속 띄우지 않게 하기
				history.replaceState({},null,null);

				//게시글 등록시 모달창 띄우기 함수
				function checkModal(result) {
					if (result === '' || history.state) {
						return;
					}
					if (parseInt(result) > 0) {
						$(".modal-body").html(
								"게시글 " + parseInt(result) + "번이 등록되었습니다.");
					}
					$("#myModal").modal("show");
				}

				$("#regBtn").on("click", function() {
					self.location = "/board/register";
				});
				
				var actionForm=$("#actionForm");
				
				$(".paginate_button a").on("click",function(e){
					e.preventDefault();
					
					console.log("click");
					
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));
					actionForm.submit();
				});
				//게시글 클릭시 pageNum과 amount와 게시글 번호bno를 함께 전달 get방식으로 actionForm action속성을 변형시킴
				$(".move").on("click",function(e){
					e.preventDefault();
					actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
					actionForm.attr("action","/board/get");
					actionForm.submit();
				});
				
				var searchForm = $("#searchForm");
				
				$("#searchForm button").on("click",function(e){
					if(!searchForm.find("option:selected").val()){
						console.log("검색종류x");
						alert("검색종류를 선택하세요!!.");
						return false;
					}
					if(!searchForm.find("input[name='keyword']").val()){
						console.log("키워드x");
						alert("키워드를 입력하세요!!");
						return false;
					}
					
					searchForm.find("input[name='pageNum']").val("1");
					e.preventDefault();
					
					searchForm.submit();
					
				});
				

			});
</script>