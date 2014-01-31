$(document).ready(function() {
$('input[id="#subtotal"]').blur(function() {
    var firstNumber = parseInt($('input[id="#subtotal"]').val());
    $('input[name="price"]').val(Math.round(firstNumber*1.18));
});
});