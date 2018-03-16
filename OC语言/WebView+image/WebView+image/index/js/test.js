/**
 * Created by admin on 2018/3/14.
 */
window.onload=function () {
    window.postMessage.iosMethod({
        "key":"getUrl",
        "path":"grafics/ui/1.png",
        "guid":"xxxxx",
        "callBack":"getUrlComplete"
    })
}
var host = null;
function setImgSrc(src) {
    var image = new Image();
    image.crossOrigin = "";
    image.src = src;
    document.body.append(image);
}
function click1() {
    var url = host+"document/dfadfa/dfadfa/1.png";
    alert(url+"------click1");
    setImgSrc(url);
}
function click2() {
    var url = host+"document/dfadfa/dfadfa/2.png";
    alert(url+"------click2");
    setImgSrc(url);
}
function getUrlComplete(_host) {
    host = _host;
}