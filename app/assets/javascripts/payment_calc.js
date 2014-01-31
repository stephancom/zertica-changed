$(document).ready(function() {
$('input["#subtotal"]').blur(function() {
    var firstNumber = parseInt($('input["#subtotal"]').val());
    $('input[name="price"]').val(Math.round(firstNumber*1.18));
});
});