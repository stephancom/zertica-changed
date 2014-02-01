$(document).ready(function() {
      
    $("#rate").blur(function() {
        if($("#rate_type3 :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $("#subtotal").val(firstNumber);
        }
        
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $("#subtotal").val(firstNumber*secNumber);
        }

        
        });
    
    $("#hours").blur(function() {
        if($("#rate_type3 :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $("#subtotal").val(firstNumber);
        }
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $("#subtotal").val(firstNumber*secNumber);
        }
        });
    
    $("#type").blur(function() {
        if($("#rate_type3 :selected").text() == "fixed"){
            var firstNumber = parseInt($("#rate").val());
            $("#price").val(Math.round(firstNumber*1.18));
            $("#subtotal").val(firstNumber);
        }
        else {
            var firstNumber = parseInt($("#rate").val());
            var secNumber = parseInt($("#hours").val());
            $("#price").val(Math.round(firstNumber*secNumber*1.18));
            $("#subtotal").val(firstNumber*secNumber);
        }
        });

});
