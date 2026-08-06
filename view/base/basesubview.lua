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
			arg0_4:Loaded(arg0_6)
			arg0_4:Init()
		end
	end)
end

function var0_0.Loaded(arg0_7, arg1_7)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0_7._state ~= var0_0.STATES.LOADING then
		return
	end

	arg0_7._state = var0_0.STATES.LOADED
	arg0_7._go = arg1_7
	arg0_7._tf = tf(arg1_7)

	setActiveViaLayer(arg0_7._tf, true)
	pg.DelegateInfo.New(arg0_7)

	if arg0_7._tf.parent ~= arg0_7._parentTf then
		SetParent(arg0_7._tf, arg0_7._parentTf, false)
	end

	bindComponent(arg0_7, arg0_7._go)
	arg0_7:OnLoaded()
end

function var0_0.Init(arg0_8)
	if arg0_8._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_8._state = var0_0.STATES.INITED

	arg0_8:OnInit()
	arg0_8:HandleFuncQueue()
end

function var0_0.Destroy(arg0_9)
	if arg0_9._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_9:GetLoaded() then
		arg0_9._state = var0_0.STATES.DESTROY

		return
	end

	arg0_9._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_9)
	arg0_9:OnDestroy()
	bindComponent(arg0_9, arg0_9._go, true)
	arg0_9:disposeEvent()
	arg0_9:cleanManagedTween()

	arg0_9._tf = nil

	if arg0_9._go ~= nil and not arg0_9.noReturnPrefab then
		PoolMgr.GetInstance():ReturnUI(arg0_9:getUIName(), arg0_9._go)

		arg0_9._go = nil
	end

	arg0_9.noReturnPrefab = nil
end

function var0_0.HandleFuncQueue(arg0_10)
	if arg0_10._state == var0_0.STATES.INITED then
		while #arg0_10._funcQueue > 0 do
			local var0_10 = table.remove(arg0_10._funcQueue, 1)

			var0_10.func(unpackEx(var0_10.params))
		end
	end
end

function var0_0.Reset(arg0_11)
	arg0_11._state = var0_0.STATES.NONE
end

function var0_0.ActionInvoke(arg0_12, arg1_12, ...)
	assert(arg0_12[arg1_12], "func not exist >>>" .. arg1_12)

	arg0_12._funcQueue[#arg0_12._funcQueue + 1] = {
		funcName = arg1_12,
		func = arg0_12[arg1_12],
		params = packEx(arg0_12, ...)
	}

	arg0_12:HandleFuncQueue()
end

function var0_0.ActionInvokeExclusive(arg0_13, arg1_13, ...)
	local var0_13 = #arg0_13._funcQueue

	while var0_13 > 0 do
		if arg0_13._funcQueue[var0_13].funcName == arg1_13 then
			table.remove(arg0_13._funcQueue, var0_13)
		end

		var0_13 = var0_13 - 1
	end

	arg0_13:ActionInvoke(arg1_13, ...)
end

function var0_0.CallbackInvoke(arg0_14, arg1_14, ...)
	arg0_14._funcQueue[#arg0_14._funcQueue + 1] = {
		func = arg1_14,
		params = packEx(...)
	}

	arg0_14:HandleFuncQueue()
end

function var0_0.ExecuteAction(arg0_15, arg1_15, ...)
	arg0_15:Load()
	arg0_15:ActionInvoke(arg1_15, ...)
end

function var0_0.GetLoaded(arg0_16)
	return arg0_16._state >= var0_0.STATES.LOADED
end

function var0_0.CheckState(arg0_17, arg1_17)
	return arg0_17._state == arg1_17
end

function var0_0.Show(arg0_18)
	setActive(arg0_18._tf, true)
	arg0_18:ShowOrHideResUI(true)
	arg0_18:PlayBGM()
end

function var0_0.Hide(arg0_19)
	setActive(arg0_19._tf, false)
	arg0_19:ShowOrHideResUI(false)
	arg0_19:StopBgm()
end

function var0_0.isShowing(arg0_20)
	return arg0_20._tf and isActive(arg0_20._tf) or false
end

function var0_0.getBGM(arg0_21, arg1_21)
	return getBgm(arg1_21 or arg0_21.__cname)
end

function var0_0.PlayBGM(arg0_22)
	local var0_22 = arg0_22:getBGM()

	if var0_22 then
		pg.BgmMgr.GetInstance():Push(arg0_22.__cname, var0_22)
	end
end

function var0_0.StopBgm(arg0_23)
	pg.BgmMgr.GetInstance():Pop(arg0_23.__cname)
end

function var0_0.getTpl(arg0_24, arg1_24, arg2_24)
	local var0_24 = (arg2_24 or arg0_24._tf):Find(arg1_24)

	var0_24:SetParent(arg0_24._tf, false)
	SetActive(var0_24, false)

	return var0_24
end

function var0_0.getUIName(arg0_25)
	return nil
end

function var0_0.OnLoaded(arg0_26)
	return
end

function var0_0.OnInit(arg0_27)
	return
end

function var0_0.OnDestroy(arg0_28)
	return
end

function var0_0.ResUISettings(arg0_29)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_30, arg1_30)
	local var0_30 = arg0_30:ResUISettings()

	if not var0_30 then
		return
	end

	if var0_30 == true then
		var0_30 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_30 = arg0_30:getGroupName()

	if arg1_30 then
		pg.playerResUI:SetSettings(var1_30, setmetatable({
			groupName = var1_30
		}, {
			__index = var0_30
		}))
	else
		pg.playerResUI:RemoveSettings(var1_30)
	end
end

function var0_0.getGroupName(arg0_31)
	return arg0_31.contextData.groupName or arg0_31.__cname
end

return var0_0
