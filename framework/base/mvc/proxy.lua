ys = ys or {}

local var0_0 = ys

var0_0.MVC = var0_0.MVC or {}
var0_0.MVC.Proxy = singletonClass("MVC.Proxy")
var0_0.MVC.Proxy.__name = "MVC.Proxy"

function var0_0.MVC.Proxy.Ctor(arg0_1)
	return
end

function var0_0.MVC.Proxy.ActiveProxy(arg0_2)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_2)
end

function var0_0.MVC.Proxy.DeactiveProxy(arg0_3)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_3)
end
