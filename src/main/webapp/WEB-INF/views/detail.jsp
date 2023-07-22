<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
* {
	box-sizing: border-box;
}

.badge {
	background-color: yellow;
}
.msg {
	padding: 4px;
	border: 1px solid #dddddd;
	margin-bottom: 2px;
}
</style>
</head>
<body style="margin: 0px">
	<div style="display: flex">
		<%-- 동물 정보 디스플레이 영역 --%>
		<div style="flex: 3; padding: 4px;">
			<h2>${item.noticeNo }</h2>
			<div style="height: 360px; margin-bottom: 4px">
				<img src="${item.popfile }"
					style="object-fit: cover; height: 100%; width: 100%" />
			</div>
			<div style="margin-bottom: 4px">
				<span class="badge">${item.processState }</span>
			</div>
			<ul>
				<li>발견장소 : ${item.orgNm } ${item.happenPlace }</li>
				<li>특징 : ${item.specialMark }</li>
				<li>특징 : ${item.specialMark }</li>
			</ul>
			<div id="map"
				style="width: 100%; height: 300px; margin: auto; display: flex; justify-content: center; align-items: center; border: 1px solid #dddddd">

				<c:choose>
					<c:when test="${empty address }">
						지도정보를 확보 하지 못해 렌더링에 실패하였습니다.
					</c:when>
					<c:otherwise>
						지도를 불러옵니다.
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<%-- 동물에 대한 코멘트 영역 --%>
		<div style="flex: 1;">
			<div>
				<form action="/write" method="post">
					<input type="hidden" name="target" value="${item.desertionNo }" />
					<textarea style="width: 100%; height: 120px; resize: none"
						name="body"></textarea>
					<input type="password" name="pass" />
					<button type="submit">응원하기</button>
				</form>
			</div>
			<div>
				<h4>
					응원의 한마디 (  <span id="cnt">${fn:length(messages) }</span>   건) <span id="refresh"
						style="cursor: pointer;">5</span>초 후 갱신
				</h4>
				<div id="messages">
					<c:forEach items="${messages}" var="m">
						<div class="msg">
							${m.body }</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<script>
		const getMessages = function() {
			const xhr = new XMLHttpRequest();
			xhr.open("get", "/api/message?no=${item.desertionNo}", true);
			xhr.send();
			xhr.onreadystatechange=function(){
				if(this.readyState===4) {
					const json = JSON.parse(this.responseText);	// 아마 객체 배열일 듯
					if(json.result) {
						const messages = document.querySelector("#messages");
						messages.innerHTML = "";
						console.log(json.result);
						for(let o of json.items) {
							console.log(o);
							messages.innerHTML += "<div class='msg'>"+o.body+"</div>";
						}
						document.querySelector("#cnt").innerHTML = json.total;
					}
				}
			}
		};
			
		setInterval(function(){
			let value = parseInt(document.querySelector("#refresh").innerHTML);
			value--;
			if(value == -1) {
				getMessages();
				value = 5;
			}
			document.querySelector("#refresh").innerHTML = value;
		}, 1000);
		
	</script>
	<c:if test="${!empty address }">
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=22c8baafdc9ecfd56bb68920f8b15e6d"></script>
	<script>
		let pos = new kakao.maps.LatLng(${address.lng}, ${address.lat}); //지도의 중심좌표.
		
		let container = document.querySelector('#map'); //지도를 담을 영역의 DOM 레퍼런스
		let options = { //지도를 생성할 때 필요한 기본 옵션
			center : pos, 
			level : 4
		//지도의 레벨(확대, 축소 정도)
		};

		let map = new kakao.maps.Map(document.querySelector('#map'), options); //지도 생성 및 객체 리턴
		
		let marker = new kakao.maps.Marker({
		    position: pos
		});
		
		marker.setMap(map);
		
		
	</script>
	</c:if>
</body>
</html>