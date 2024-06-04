ys = ys or {}

local var0 = ys

var0.MVC = var0.MVC or {}
var0.MVC.Command = class("MVC.Command")
var0.MVC.Command.__name = "MVC.Command"

function var0.MVC.Command.Ctor(arg0)
	return
end

function var0.MVC.Command.Initialize(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.EventListener.AttachEventListener(arg0)
end

function var0.MVC.Command.Update(arg0)
	return
end

function var0.MVC.Command.Dispose(arg0)
	var0.EventListener.DetachEventListener(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var0.MVC.Command.GetState(arg0)
	return arg0._state
end
