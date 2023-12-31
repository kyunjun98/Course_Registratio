<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var ="context"><%=request.getContextPath()%></c:set>
<!DOCTYPE html>
<html>
<head>
		<meta name="description" content="userU.jsp">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>수강신청프로그램</title>
	<link href="${context}/css/bootstrap.min.css" rel="stylesheet">
	<link href="${context}/css/bootstrap-theme.css" rel="stylesheet">
	<link href="${context}/css/plugins/metisMenu/metisMenu.min.css" rel="stylesheet">
	<link href="${context}/css/plugins/social-buttons.css" rel="stylesheet">
	<link href="${context}/font-awesome-4.4.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="//code.jquery.com/ui/1.11.3/themes/smoothness/jquery-ui.css" rel="stylesheet" >
		<link href="${context}/css/plugins/dataTables.bootstrap.css" rel="stylesheet">
    <link href="${context}/css/process.css" rel="stylesheet">

	<script src="${context}/js/jquery-1.9.1.js"></script>
	<script src="${context}/js/jquery.form.js"></script>
    <script src="${context}/js/plugins/metisMenu/metisMenu.min.js"></script>

	<script src="${context}/js/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="${context}/js/plugins/dataTables/dataTables.bootstrap.js"></script>

    <script src="//code.jquery.com/ui/1.11.3/jquery-ui.js"></script>
	<script type="text/javascript">

	var dong;

	$(document).ready(function(){
		fn_init();

		$( "#birth" ).datepicker({
	    	dateFormat: 'yy-mm-dd',
	    	changeMonth: true,
	        changeYear: true,
	        yearRange: "1980:2015"
	    });

		$("#dong").keydown(function (key){
			if(key.keyCode == 13){
				fn_postCheck();
			}

		});

		//U페이지 해당
		fn_setDetailInfo();
	});

	function fn_setDetailInfo(){
		$("#id").val('${dsUser.id}');
		$("#pw").val('${dsUser.pw}');
		$("#email").val('${dsUser.email}');

		$("#name").val('${dsUser.name}');
		$("#birth").val('${dsUser.birth}');

		var phoneArr = '${dsUser.phoneNum}'.split("-");
		var postNumArr = '${dsUser.postNum}'.split("-");
		var addressArr = '${dsUser.address}'.split("/");

		var userImage = '${dsUser.userImage}';
		userImage = userImage.replace(/"/gi, "");

		$("#phone1").val(phoneArr[0]);
		$("#phone2").val(phoneArr[1]);

		$("#phoneCd").val('${dsUser.phoneCd}');

		$("#postNum1").val(postNumArr[0]);
		$("#postNum2").val(postNumArr[1]);

		$("#address1").val(addressArr[0]);
		$("#address2").val(addressArr[1]);

		$("#pic").attr("src", '${context}/userImg/' + userImage);
		$("#userImage").val(userImage);

	}

	function fn_setData(self){
		var postAllData = self.children().text();

		var postSplit = postAllData.split(" ");

		var zipcode = postSplit[0].split("-");
		var postNum1 = zipcode[0];
		var postNum2 = zipcode[1];
		var sido = postSplit[1];
		var gugun = postSplit[2];
		var dong = postSplit[3];
		var subDong = postSplit[4];

		if(subDong == null) subDong = "";

		var detailAddress = sido + " " + gugun + " " + dong + " " + subDong;

		$("#postNum1").val(postNum1);
		$("#postNum2").val(postNum2);

		$("#address1").val(detailAddress);

		$("#searchPost").modal('hide');
	}

	function fn_postCheck(){
		dong = $("#dong").val();

		if(dong == ""){
			alert("동을 입력하세요.");
			return;
		}
		$("#postBody").children().remove();

		var aheadHtml = "<tr><td style='text-align: center;'><a onclick=javascript:fn_setData($(this))><b>";
		var backHtml = "</b></a></td></tr>";
		var appendHtml = "";
		var param = {};


		param["dong"] = dong;

		$.ajax({
   			url:"${context}/work/applicant/retrievePostByDong.do",
			contentType:"application/json",
			dataType:"json",
			data:param,
   			success:function(result){
   				for(var i = 0; i < result.length; i++){
   					appendHtml
   					   += aheadHtml
   					   + result[i].zipcode + " "
					   + result[i].sido    + " "
				       + result[i].gugun   + " "
					   + result[i].dong    + " "
					   + backHtml;
   				}
   					$("#postBody").append(appendHtml);
   			}
   		});
	}

	function fn_save(){
		if(!fn_validation()) return;

		if(confirm("수정하시겠습니까?")){
			$("#phoneNum").val($("#phone1").val() + "-" + $("#phone2").val());
	 		$("#postNum").val($("#postNum1").val() + "-" + $("#postNum2").val());
	 		$("#address").val($("#address1").val() + "/" + $("#address2").val());

	 		$("#joinFrm").submit();
		}
	}

	function fn_upload(){
		$("#ajaxform").ajaxSubmit({
	        type: "POST",
	        dataType: 'text',
	        url: $("#ajaxform").attr("action"),
	        data: $("#ajaxform").serialize(),
	        success: function (data) {
	        	data2 = data.replace(/"/gi, "");
	        	var imageUrl = "${context}/userImg/" + data2;
	        	$("#pic").attr("src", imageUrl);
	        	$("#userImage").val(data2);
	        },
	        error: function (xhr, status, error) {
	            alert(error);
	        }
	    });
	}

</script>
</head>
<body>
<jsp:include page="../common/top.jsp"></jsp:include>
	<div class="container">
		<div class="jumbotron jumbotron-info" style="background-color: lightgray;">
			<h1><font color="black"><strong>정보수정</strong>&nbsp;<span class="glyphicon glyphicon glyphicon-pencil"></span></font></h1>
		</div>
	</div>
	<div class="container">
	<form id="joinFrm" method="post" action="${context}/work/user/updateUser.do" role="form">
		<div class="form-horizontal">
			<hr/>
			<div class="form-group" style="margin-top: 5%;">
				<label for="id" class="control-label col-md-2"><b>아이디</b></label>
				<div class="col-md-4">
					<input class="form-control" type="text" name="id" id="id" disabled="disabled" required="required" autofocus="autofocus" onkeyup="idCheck();"/>
				</div>
				<p id="message"></p>
			</div>

			<div class="form-group">
				<label for="pw" class="control-label col-md-2"><b>비밀번호</b></label>
				<div class="col-md-4">
					<input class="form-control" type="password" name="pw" id="pw" disabled="disabled" required="required"/>
				</div>
			</div>

			<div class="form-group">
				<label for="email" class="control-label col-md-2"><b>이메일</b></label>
				<div class="col-md-4">
					<input class="form-control" type="email" name="email" id="email" required="required"/>
				</div>
			</div>
			<div class="form-group">
				<label for="name" class="control-label col-md-2"><b>성명</b></label>
				<div class="col-md-6">
					<input class="form-control" type="text" id="name" name="name" autofocus="autofocus" required="required"/>
				</div>
			</div>

			<div class="form-group">
				<label for="birth" class="control-label col-md-2"><b>생년월일</b></label>
				<div class="col-md-6">
					<input class="form-control" type="text" id="birth" name="birth" required="required" maxlength="10"/>
				</div>
			</div>

			<div class="form-group">
				<label for="phoneCd" class="control-label col-md-2"><b>연락처</b></label>
				<div class="col-md-2">
		        	<select class="form-control" id="phoneCd" name="phoneCd" required="required">
						<c:forEach items="${dsCode1}" var="code1">
							<option value="${code1.commCd}">${code1.commCdNm}</option>
						</c:forEach>
		     		</select>
	     		</div>
				<div class="col-md-2">
					<input class="form-control" type="text" id="phone1" maxlength="4" required="required" onkeydown="return fn_showKeyCode(event)"/>
				</div>
				<div class="col-md-2">
					<input class="form-control" type="text" id="phone2" maxlength="4" required="required" onkeydown="return fn_showKeyCode(event)"/>
				</div>
				<input type="hidden" id="phoneNum" name="phoneNum">
			</div>

			<div class="form-group">
				<label for="postnum1" class="control-label col-md-2"><b>주소</b></label>
				<div class="col-md-2">
					<input class="form-control" type="text" id="postNum1" disabled="disabled" required="required"/>
	     		</div>
				<div class="col-md-2">
					<input class="form-control" type="text" id="postNum2" disabled="disabled" required="required"/>
				</div>
				<span class="col-md-1">
					<button type="button" class="btn btn-info" data-toggle="modal" data-target="#searchPost"><b>주소검색</b></button>
				</span>
				<input type="hidden" id="postNum" name="postNum">
			</div>

			<div class="form-group">
				<label for="address1" class="control-label col-md-2"><b>상세주소</b></label>
				<div class="col-md-6">
					<input class="form-control" type="text" id="address1" disabled="disabled" required="required"/>
				</div>
			</div>

			<div class="form-group">
				<label for="address2" class="control-label col-md-2"></label>
				<div class="col-md-6">
					<input class="form-control" type="text" id="address2"/>
				</div>
				<input type="hidden" id="address" name="address">
			</div>
			<div class="form-group">
				<label class="control-label col-md-2"><b>사진</b></label>
				<img id="pic" style="margin-left: 15px;" height="180px" width="150px" src="${context}/backgroundImage/defaultpic.png"><br/>
				<div class="col-md-6">
					<input type="hidden" id="userImage" name="userImage" required="required">
				</div>
			</div>
			<input type="hidden" id="flag" name="flag" value="false">
		</div>
	</form>
		<form id="ajaxform" action="${context}/work/product/saveFile.do" method="post" enctype="multipart/form-data" role="form">
		<div class="form-group">
		<label class="control-label col-md-2"></label>
			<div class="col-md-6">
				<input class="form-control" type="file" id="imageFile" name="imageFile" onchange="fn_upload()"/>
				<input type="hidden" id="imageFolder" name="imageFolder" value="userImg">
			</div>
		</div>
		<br><br><br>
		<div class="form-group">
			<div class="col-md-offset-6 col-md-1">
				<button type="button" class="btn btn-success" onclick="fn_back()">뒤로가기</button>
			</div>
			<div class="col-md-1">
				<button class="btn btn-primary" type="button" name="btnSubmit" id="btnSubmit" onclick="fn_save()">등록하기</button>
			</div>
		</div>
	</form>
	</div>
		<div class="container">
		<!-- Modal -->
		<div class="modal fade" id="searchPost" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">주소검색</h4>
					</div>
						<div class="modal-body" style="height: 50px;">
							<div class="col-md-6">
								<input class="form-control" type="text" id="dong" name="dong" placeholder="동을 입력하세요.ex)역삼1동"/>
							</div>
							<div class="col-md-1">
								<button id="postCheck" type="button" class="btn btn-primary" onclick = "fn_postCheck()">확인</button>
							</div>
						</div>

					<div class="modal-footer">
						<div class="col-md-12">
			            <div class="table-responsive">
			                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
			                    <thead>
			                        <tr>
			                        	<th style="text-align: center; vertical-align: middle; ">주소</th>
			                        </tr>
			                    </thead>
			                    <tbody id="postBody">
			                    </tbody>
			                </table>
			            </div>
			            <!-- /.table-responsive -->
			        </div>
			        <!-- /.panel-body -->
			        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			    </div>
			    <!-- /.panel -->
			</div>
		</div>
			    <!-- /.panel -->
			</div>

					</div>

	<jsp:include page="../common/foot.jsp"></jsp:include>
</body>
</html>