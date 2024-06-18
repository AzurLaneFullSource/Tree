local var0_0 = class("CourtYardBaseSubPage")

var0_0.STATES = {
	DESTROY = 5,
	NONE = 1,
	LOADING = 2,
	INITED = 4,
	LOADED = 3
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.contextData = arg2_1
	arg0_1.parent = arg1_1
	arg0_1._parentTf = arg1_1._tf
	arg0_1._go = nil
	arg0_1._tf = nil
	arg0_1._state = var0_0.STATES.NONE
	arg0_1._funcQueue = {}
end

function var0_0.Load(arg0_2)
	if arg0_2._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_2._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_2 = PoolMgr.GetInstance()

	var0_2:GetUI(arg0_2:getUIName(), true, function(arg0_3)
		if arg0_2._state == var0_0.STATES.DESTROY then
			pg.UIMgr.GetInstance():LoadingOff()
			var0_2:ReturnUI(arg0_2:getUIName(), arg0_3)
		else
			arg0_2:Loaded(arg0_3)
			arg0_2:Init()
		end
	end)
end

function var0_0.Loaded(arg0_4, arg1_4)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0_4._state ~= var0_0.STATES.LOADING then
		return
	end

	arg0_4._state = var0_0.STATES.LOADED
	arg0_4._go = arg1_4
	arg0_4._tf = tf(arg1_4)

	pg.DelegateInfo.New(arg0_4)
	SetParent(arg0_4._tf, arg0_4._parentTf, false)
	arg0_4:OnLoaded()
end

function var0_0.Init(arg0_5)
	if arg0_5._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_5._state = var0_0.STATES.INITED

	arg0_5:OnInit()
	arg0_5:HandleFuncQueue()
end

function var0_0.Destroy(arg0_6)
	if arg0_6._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_6:GetLoaded() then
		arg0_6._state = var0_0.STATES.DESTROY

		return
	end

	arg0_6._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_6)
	arg0_6:OnDestroy()

	arg0_6._tf = nil

	local var0_6 = PoolMgr.GetInstance()
	local var1_6 = arg0_6:getUIName()

	if arg0_6._go ~= nil and var1_6 then
		var0_6:ReturnUI(var1_6, arg0_6._go)

		arg0_6._go = nil
	end
end

function var0_0.HandleFuncQueue(arg0_7)
	if arg0_7._state == var0_0.STATES.INITED then
		while #arg0_7._funcQueue > 0 do
			local var0_7 = table.remove(arg0_7._funcQueue, 1)

			var0_7.func(unpack(var0_7.params, 1, var0_7.params.len))
		end
	end
end

function var0_0.Reset(arg0_8)
	arg0_8._state = var0_0.STATES.NONE
end

function var0_0.ActionInvoke(arg0_9, arg1_9, ...)
	assert(arg0_9[arg1_9], "func not exist >>>" .. arg1_9)

	arg0_9._funcQueue[#arg0_9._funcQueue + 1] = {
		funcName = arg1_9,
		func = arg0_9[arg1_9],
		params = {
			len = 1 + select("#", ...),
			arg0_9,
			...
		}
	}

	arg0_9:HandleFuncQueue()
end

function var0_0.CallbackInvoke(arg0_10, arg1_10, ...)
	arg0_10._funcQueue[#arg0_10._funcQueue + 1] = {
		func = arg1_10,
		params = packEx(...)
	}

	arg0_10:HandleFuncQueue()
end

function var0_0.ExecuteAction(arg0_11, arg1_11, ...)
	arg0_11:Load()
	arg0_11:ActionInvoke(arg1_11, ...)
end

function var0_0.GetLoaded(arg0_12)
	return arg0_12._state >= var0_0.STATES.LOADED
end

function var0_0.CheckState(arg0_13, arg1_13)
	return arg0_13._state == arg1_13
end

function var0_0.Show(arg0_14)
	setActive(arg0_14._tf, true)
end

function var0_0.Hide(arg0_15)
	setActive(arg0_15._tf, false)
end

function var0_0.isShowing(arg0_16)
	return arg0_16._tf and isActive(arg0_16._tf)
end

function var0_0.Emit(arg0_17, arg1_17, ...)
	arg0_17.parent:Emit(arg1_17, ...)
end

function var0_0.findTF(arg0_18, arg1_18, arg2_18)
	assert(arg0_18._tf, "transform should exist")

	return findTF(arg2_18 or arg0_18._tf, arg1_18)
end

function var0_0.getTpl(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:findTF(arg1_19, arg2_19)

	var0_19:SetParent(arg0_19._tf, false)
	SetActive(var0_19, false)

	return var0_19
end

function var0_0.getUIName(arg0_20)
	return nil
end

function var0_0.OnLoaded(arg0_21)
	return
end

function var0_0.OnInit(arg0_22)
	return
end

function var0_0.OnDestroy(arg0_23)
	return
end

return var0_0
