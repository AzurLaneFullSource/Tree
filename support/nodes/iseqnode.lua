ys = ys or {}

local var0_0 = class("ISeqNode")

ys.ISeqNode = var0_0
var0_0.Finish = false
var0_0._init = false
var0_0._data = nil
var0_0._cfg = nil

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._data = arg1_1
	arg0_1._cfg = arg2_1
end

function var0_0.UpdateNode(arg0_2)
	if arg0_2.Finish then
		return
	end

	if not arg0_2._init then
		arg0_2._init = true

		arg0_2:Init()
	end

	if arg0_2.Finish then
		return
	end

	arg0_2:Update()
end

function var0_0.Init(arg0_3)
	return
end

function var0_0.Update(arg0_4)
	return
end

function var0_0.Dispose(arg0_5)
	arg0_5.Finish = true

	arg0_5:Clear()
end

function var0_0.Clear(arg0_6)
	return
end
