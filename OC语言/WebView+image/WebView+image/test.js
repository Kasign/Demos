/**
 * Created by admin on 2018/3/14.
 */
window.nativeCallJS =function(path) {
    alert("nativeCallJS"+path);
    setImgSrc(path);
}

function setImgSrc(src) {
    alert(src);
    
    var image = new Image();
    image.crossOrigin = "*";
    image.src = src;
    document.body.append(image);
    
}
function click1() {
    var name = "abcd.png";
    alert(name+"------click1");
    window.webkit.messageHandlers.jsCallNative.postMessage(name);
}
function click2() {
    var name = "abcd.png";
    alert(name+"------click2");
    window.webkit.messageHandlers.jsCallNative.postMessage(name);
}

