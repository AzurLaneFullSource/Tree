ys = ys or {}

local var0 = ys

var0.MVC = var0.MVC or {}
var0.MVC.Mediator = class("MVC.Mediator")
var0.MVC.Mediator.__name = "MVC.Mediator"

function var0.MVC.Mediator.Ctor(arg0)
	return
end

function var0.MVC.Mediator.Initialize(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.EventListener.AttachEventListener(arg0)
end

function var0.MVC.Mediator.Update(arg0)
	return
end

function var0.MVC.Mediator.UpdatePause(arg0)
	return
end

function var0.MVC.Mediator.Dispose(arg0)
	var0.EventListener.DetachEventListener(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var0.MVC.Mediator.GetState(arg0)
	return arg0._state
end
