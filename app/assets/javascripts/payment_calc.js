$(document).ready(function() {
$("#subtotal").blur(function() {
    var firstNumber = parseInt($("#subtotal").val());
    $('input[name="price"]').val(Math.round(firstNumber*1.18));
});
});