ys = ys or {}

local var0 = class("ISeqNode")

ys.ISeqNode = var0
var0.Finish = false
var0._init = false
var0._data = nil
var0._cfg = nil

function var0.Ctor(arg0, arg1, arg2)
	arg0._data = arg1
	arg0._cfg = arg2
end

function var0.UpdateNode(arg0)
	if arg0.Finish then
		return
	end

	if not arg0._init then
		arg0._init = true

		arg0:Init()
	end

	if arg0.Finish then
		return
	end

	arg0:Update()
end

function var0.Init(arg0)
	return
end

function var0.Update(arg0)
	return
end

function var0.Dispose(arg0)
	arg0.Finish = true

	arg0:Clear()
end

function var0.Clear(arg0)
	return
end
