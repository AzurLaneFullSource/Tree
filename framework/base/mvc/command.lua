ys = ys or {}

local var0_0 = ys

var0_0.MVC = var0_0.MVC or {}
var0_0.MVC.Command = class("MVC.Command")
var0_0.MVC.Command.__name = "MVC.Command"

function var0_0.MVC.Command.Ctor(arg0_1)
	return
end

function var0_0.MVC.Command.Initialize(arg0_2)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_2)
	var0_0.EventListener.AttachEventListener(arg0_2)
end

function var0_0.MVC.Command.Update(arg0_3)
	return
end

function var0_0.MVC.Command.Dispose(arg0_4)
	var0_0.EventListener.DetachEventListener(arg0_4)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_4)
end

function var0_0.MVC.Command.GetState(arg0_5)
	return arg0_5._state
end
