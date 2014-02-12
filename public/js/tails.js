function TailsCtrl($scope) {
  $scope.lines = [];
  
  $scope.setFile = function() {
    var ws = new WebSocket("ws://localhost:9001/");
    ws.onopen = function(){
      ws.send($scope.filePath);
    };

    ws.onmessage = function(message){
      console.log(message['data']);
      $scope.lines.push(message['data']);
      $scope.$apply();
    };
  }
}