$(document).ready(function() {
      
    $("#rate").blur(function() {
        if($("#bid_pay_schedule :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $(".subtotal").val(firstNumber);
        }
        
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $(".subtotal").val(firstNumber*secNumber);
        }

        
        });
    
    $("#hours").blur(function() {
        if($("#bid_pay_schedule :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $(".subtotal").val(firstNumber);
        }
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $(".subtotal").val(firstNumber*secNumber);
        }
        });
    
    $("#bid_pay_schedule").blur(function() {
        if($("#bid_pay_schedule :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $(".subtotal").val(firstNumber);
        }
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $(".subtotal").val(firstNumber*secNumber);
        }
        });

});
