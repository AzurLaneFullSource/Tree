local var0_0 = class("BaseSubView", import("view.base.BaseEventLogic"))

var0_0.STATES = {
	DESTROY = 5,
	NONE = 1,
	LOADING = 2,
	INITED = 4,
	LOADED = 3
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.contextData = arg3_1
	arg0_1._parentTf = arg1_1
	arg0_1.event = arg2_1
	arg0_1._go = nil
	arg0_1._tf = nil
	arg0_1._state = var0_0.STATES.NONE
	arg0_1._funcQueue = {}
end

function var0_0.SetExtra(arg0_2, arg1_2)
	arg0_2.extraGameObject = go(arg1_2)
	arg0_2._parentTf = arg1_2.parent
end

function var0_0.Load(arg0_3)
	if arg0_3._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_3._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_3 = PoolMgr.GetInstance()

	seriesAsync({
		function(arg0_4)
			if arg0_3.extraGameObject then
				arg0_4(arg0_3.extraGameObject)
			else
				var0_3:GetUI(arg0_3:getUIName(), true, arg0_4)
			end
		end
	}, function(arg0_5)
		if arg0_3._state == var0_0.STATES.DESTROY and arg0_3:getUIName() then
			pg.UIMgr.GetInstance():LoadingOff()
			var0_3:ReturnUI(arg0_3:getUIName(), arg0_5)
		else
			arg0_3:Loaded(arg0_5)
			arg0_3:Init()
		end
	end)
end

function var0_0.Loaded(arg0_6, arg1_6)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0_6._state ~= var0_0.STATES.LOADING then
		return
	end

	arg0_6._state = var0_0.STATES.LOADED
	arg0_6._go = arg1_6
	arg0_6._tf = tf(arg1_6)

	setActiveViaLayer(arg0_6._tf, true)
	pg.DelegateInfo.New(arg0_6)
	SetParent(arg0_6._tf, arg0_6._parentTf, false)
	arg0_6:OnLoaded()
end

function var0_0.Init(arg0_7)
	if arg0_7._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_7._state = var0_0.STATES.INITED

	arg0_7:OnInit()
	arg0_7:HandleFuncQueue()
end

function var0_0.Destroy(arg0_8)
	if arg0_8._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_8:GetLoaded() then
		arg0_8._state = var0_0.STATES.DESTROY

		return
	end

	arg0_8._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_8)
	arg0_8:OnDestroy()
	arg0_8:disposeEvent()
	arg0_8:cleanManagedTween()

	arg0_8._tf = nil

	local var0_8 = arg0_8:getUIName()

	if arg0_8._go ~= nil and var0_8 then
		PoolMgr.GetInstance():ReturnUI(var0_8, arg0_8._go)

		arg0_8._go = nil
	end
end

function var0_0.HandleFuncQueue(arg0_9)
	if arg0_9._state == var0_0.STATES.INITED then
		while #arg0_9._funcQueue > 0 do
			local var0_9 = table.remove(arg0_9._funcQueue, 1)

			var0_9.func(unpack(var0_9.params, 1, var0_9.params.len))
		end
	end
end

function var0_0.Reset(arg0_10)
	arg0_10._state = var0_0.STATES.NONE
end

function var0_0.ActionInvoke(arg0_11, arg1_11, ...)
	assert(arg0_11[arg1_11], "func not exist >>>" .. arg1_11)

	arg0_11._funcQueue[#arg0_11._funcQueue + 1] = {
		funcName = arg1_11,
		func = arg0_11[arg1_11],
		params = {
			len = 1 + select("#", ...),
			arg0_11,
			...
		}
	}

	arg0_11:HandleFuncQueue()
end

function var0_0.CallbackInvoke(arg0_12, arg1_12, ...)
	arg0_12._funcQueue[#arg0_12._funcQueue + 1] = {
		func = arg1_12,
		params = packEx(...)
	}

	arg0_12:HandleFuncQueue()
end

function var0_0.ExecuteAction(arg0_13, arg1_13, ...)
	arg0_13:Load()
	arg0_13:ActionInvoke(arg1_13, ...)
end

function var0_0.GetLoaded(arg0_14)
	return arg0_14._state >= var0_0.STATES.LOADED
end

function var0_0.CheckState(arg0_15, arg1_15)
	return arg0_15._state == arg1_15
end

function var0_0.Show(arg0_16)
	setActive(arg0_16._tf, true)
	arg0_16:ShowOrHideResUI(true)
	arg0_16:PlayBGM()
end

function var0_0.Hide(arg0_17)
	setActive(arg0_17._tf, false)
	arg0_17:ShowOrHideResUI(false)
	arg0_17:StopBgm()
end

function var0_0.isShowing(arg0_18)
	return arg0_18._tf and isActive(arg0_18._tf)
end

function var0_0.getBGM(arg0_19, arg1_19)
	return getBgm(arg1_19 or arg0_19.__cname)
end

function var0_0.PlayBGM(arg0_20)
	local var0_20 = arg0_20:getBGM()

	if var0_20 then
		pg.BgmMgr.GetInstance():Push(arg0_20.__cname, var0_20)
	end
end

function var0_0.StopBgm(arg0_21)
	pg.BgmMgr.GetInstance():Pop(arg0_21.__cname)
end

function var0_0.findTF(arg0_22, arg1_22, arg2_22)
	assert(arg0_22._tf, "transform should exist")

	return findTF(arg2_22 or arg0_22._tf, arg1_22)
end

function var0_0.getTpl(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23:findTF(arg1_23, arg2_23)

	var0_23:SetParent(arg0_23._tf, false)
	SetActive(var0_23, false)

	return var0_23
end

function var0_0.getUIName(arg0_24)
	return nil
end

function var0_0.OnLoaded(arg0_25)
	return
end

function var0_0.OnInit(arg0_26)
	return
end

function var0_0.OnDestroy(arg0_27)
	return
end

function var0_0.ResUISettings(arg0_28)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_29, arg1_29)
	local var0_29 = arg0_29:ResUISettings()

	if not var0_29 then
		return
	end

	if var0_29 == true then
		var0_29 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1_29,
		weight = var0_29.weight,
		groupName = var0_29.groupName,
		canvasOrder = var0_29.order or false
	}, {
		__index = var0_29
	}))
end

return var0_0
