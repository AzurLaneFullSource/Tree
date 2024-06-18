ys = ys or {}

local var0_0 = ys

var0_0.MVC = var0_0.MVC or {}
var0_0.MVC.Mediator = class("MVC.Mediator")
var0_0.MVC.Mediator.__name = "MVC.Mediator"

function var0_0.MVC.Mediator.Ctor(arg0_1)
	return
end

function var0_0.MVC.Mediator.Initialize(arg0_2)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_2)
	var0_0.EventListener.AttachEventListener(arg0_2)
end

function var0_0.MVC.Mediator.Update(arg0_3)
	return
end

function var0_0.MVC.Mediator.UpdatePause(arg0_4)
	return
end

function var0_0.MVC.Mediator.Dispose(arg0_5)
	var0_0.EventListener.DetachEventListener(arg0_5)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_5)
end

function var0_0.MVC.Mediator.GetState(arg0_6)
	return arg0_6._state
end
