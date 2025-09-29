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

var0_0.InheritFuncs = {
	"getGroupName",
	"Add2Overlay",
	"DelFromOverlay",
	"OverlayPanel",
	"UnOverlayPanel",
	"BlurPanel",
	"TempOverlayPanelPB",
	"TempUnOverlayPanelPB"
}

function var0_0.RegisterView(arg0_2, arg1_2)
	arg0_2.viewComponent = arg1_2

	for iter0_2, iter1_2 in ipairs(var0_0.InheritFuncs) do
		arg0_2[iter1_2] = arg0_2[iter1_2] or function(arg0_3, ...)
			return arg0_3.viewComponent[iter1_2](arg0_3.viewComponent, ...)
		end
	end
end

function var0_0.Load(arg0_4, arg1_4)
	if arg0_4._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_4._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_4 = PoolMgr.GetInstance()

	seriesAsync({
		function(arg0_5)
			if arg1_4 then
				arg0_4.noReturnPrefab = true

				arg0_5(arg1_4)
			else
				var0_4:GetUI(arg0_4:getUIName(), true, arg0_5)
			end
		end
	}, function(arg0_6)
		if arg0_4._state == var0_0.STATES.DESTROY and not arg0_4.noReturnPrefab then
			pg.UIMgr.GetInstance():LoadingOff()
			var0_4:ReturnUI(arg0_4:getUIName(), arg0_6)
		else
			onNextTick(function()
				arg0_4:Loaded(arg0_6)
				arg0_4:Init()
			end)
		end
	end)
end

function var0_0.Loaded(arg0_8, arg1_8)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0_8._state ~= var0_0.STATES.LOADING then
		return
	end

	arg0_8._state = var0_0.STATES.LOADED
	arg0_8._go = arg1_8
	arg0_8._tf = tf(arg1_8)

	setActiveViaLayer(arg0_8._tf, true)
	pg.DelegateInfo.New(arg0_8)

	if arg0_8._tf.parent ~= arg0_8._parentTf then
		SetParent(arg0_8._tf, arg0_8._parentTf, false)
	end

	arg0_8:OnLoaded()
end

function var0_0.Init(arg0_9)
	if arg0_9._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_9._state = var0_0.STATES.INITED

	bindComponent(arg0_9, arg0_9._go)
	arg0_9:OnInit()
	arg0_9:HandleFuncQueue()
end

function var0_0.Destroy(arg0_10)
	if arg0_10._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_10:GetLoaded() then
		arg0_10._state = var0_0.STATES.DESTROY

		return
	end

	arg0_10._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_10)
	arg0_10:OnDestroy()
	arg0_10:disposeEvent()
	arg0_10:cleanManagedTween()

	arg0_10._tf = nil

	if arg0_10._go ~= nil and not arg0_10.noReturnPrefab then
		PoolMgr.GetInstance():ReturnUI(arg0_10:getUIName(), arg0_10._go)

		arg0_10._go = nil
	end

	arg0_10.noReturnPrefab = nil
end

function var0_0.HandleFuncQueue(arg0_11)
	if arg0_11._state == var0_0.STATES.INITED then
		while #arg0_11._funcQueue > 0 do
			local var0_11 = table.remove(arg0_11._funcQueue, 1)

			var0_11.func(unpackEx(var0_11.params))
		end
	end
end

function var0_0.Reset(arg0_12)
	arg0_12._state = var0_0.STATES.NONE
end

function var0_0.ActionInvoke(arg0_13, arg1_13, ...)
	assert(arg0_13[arg1_13], "func not exist >>>" .. arg1_13)

	arg0_13._funcQueue[#arg0_13._funcQueue + 1] = {
		funcName = arg1_13,
		func = arg0_13[arg1_13],
		params = packEx(arg0_13, ...)
	}

	arg0_13:HandleFuncQueue()
end

function var0_0.ActionInvokeExclusive(arg0_14, arg1_14, ...)
	local var0_14 = #arg0_14._funcQueue

	while var0_14 > 0 do
		if arg0_14._funcQueue[var0_14].funcName == arg1_14 then
			table.remove(arg0_14._funcQueue, var0_14)
		end

		var0_14 = var0_14 - 1
	end

	arg0_14:ActionInvoke(arg1_14, ...)
end

function var0_0.CallbackInvoke(arg0_15, arg1_15, ...)
	arg0_15._funcQueue[#arg0_15._funcQueue + 1] = {
		func = arg1_15,
		params = packEx(...)
	}

	arg0_15:HandleFuncQueue()
end

function var0_0.ExecuteAction(arg0_16, arg1_16, ...)
	arg0_16:Load()
	arg0_16:ActionInvoke(arg1_16, ...)
end

function var0_0.GetLoaded(arg0_17)
	return arg0_17._state >= var0_0.STATES.LOADED
end

function var0_0.CheckState(arg0_18, arg1_18)
	return arg0_18._state == arg1_18
end

function var0_0.Show(arg0_19)
	setActive(arg0_19._tf, true)
	arg0_19:ShowOrHideResUI(true)
	arg0_19:PlayBGM()
end

function var0_0.Hide(arg0_20)
	setActive(arg0_20._tf, false)
	arg0_20:ShowOrHideResUI(false)
	arg0_20:StopBgm()
end

function var0_0.isShowing(arg0_21)
	return arg0_21._tf and isActive(arg0_21._tf)
end

function var0_0.getBGM(arg0_22, arg1_22)
	return getBgm(arg1_22 or arg0_22.__cname)
end

function var0_0.PlayBGM(arg0_23)
	local var0_23 = arg0_23:getBGM()

	if var0_23 then
		pg.BgmMgr.GetInstance():Push(arg0_23.__cname, var0_23)
	end
end

function var0_0.StopBgm(arg0_24)
	pg.BgmMgr.GetInstance():Pop(arg0_24.__cname)
end

function var0_0.findTF(arg0_25, arg1_25, arg2_25)
	assert(arg0_25._tf, "transform should exist")

	return findTF(arg2_25 or arg0_25._tf, arg1_25)
end

function var0_0.getTpl(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26:findTF(arg1_26, arg2_26)

	var0_26:SetParent(arg0_26._tf, false)
	SetActive(var0_26, false)

	return var0_26
end

function var0_0.getUIName(arg0_27)
	return nil
end

function var0_0.OnLoaded(arg0_28)
	return
end

function var0_0.OnInit(arg0_29)
	return
end

function var0_0.OnDestroy(arg0_30)
	return
end

function var0_0.ResUISettings(arg0_31)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_32, arg1_32)
	local var0_32 = arg0_32:ResUISettings()

	if not var0_32 then
		return
	end

	if var0_32 == true then
		var0_32 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_32 = arg0_32:getGroupName()

	if arg1_32 then
		pg.playerResUI:SetSettings(var1_32, setmetatable({
			groupName = var1_32
		}, {
			__index = var0_32
		}))
	else
		pg.playerResUI:RemoveSettings(var1_32)
	end
end

function var0_0.getGroupName(arg0_33)
	return arg0_33.contextData.groupName or arg0_33.__cname
end

return var0_0
