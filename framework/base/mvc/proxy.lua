ys = ys or {}

local var0 = ys

var0.MVC = var0.MVC or {}
var0.MVC.Proxy = singletonClass("MVC.Proxy")
var0.MVC.Proxy.__name = "MVC.Proxy"

function var0.MVC.Proxy.Ctor(arg0)
	return
end

function var0.MVC.Proxy.ActiveProxy(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)
end

function var0.MVC.Proxy.DeactiveProxy(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end
