var date = new Date();
var year = date.getFullYear();
var mon = date.getMonth() + 1;
var day = date.getDate();
var hours = date.getHours();
var minutes = date.getMinutes();
var seconds = date.getSeconds();
if (mon < 10) {
    mon = "0" + mon;
}
if (day < 10) {
    day = "0" + day;
}
if (hours < 10) {
    hours = "0" + hours;
}
if (minutes < 10) {
    minutes = "0" + minutes;
}
if (seconds < 10) {
    seconds = "0" + seconds;
}
function getOrderDate() {
    var orderDate = year + "/" + mon + "/" + day;
    return orderDate;

}
function getOrderTime() {
    var orderTime = hours + ":" + minutes + ":" + seconds;
    return orderTime;
}
function getOrderNo(){
    var timesStamp=year + mon + day+hours + minutes + seconds;
    var randomNum=Math.random().toString().slice(-6);
    return "No"+timesStamp+randomNum;
}