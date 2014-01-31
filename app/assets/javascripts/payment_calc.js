$(document).ready( {
$('input[name="subtotal"]').blur(function() {
    var firstNumber = parseInt($('input[name="subtotal"]').val());
    $('input[name="price"]').val(Math.round(firstNumber*1.18));
});
});