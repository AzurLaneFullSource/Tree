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

local function var1_0(arg0_2)
	local var0_2

	if arg0_2 and arg0_2.getUIName then
		local var1_2, var2_2 = pcall(function()
			return arg0_2:getUIName()
		end)

		if var1_2 then
			var0_2 = var2_2
		end
	end

	if not noEmptyStr(var0_2) and arg0_2 then
		var0_2 = arg0_2.__cname
	end

	return tostring(var0_2 or "Unknown")
end

local function var2_0(arg0_4)
	local var0_4 = string.format("进入界面: BaseSubView - %s", var1_0(arg0_4))

	print(var0_4)

	local var1_4, var2_4 = pcall(function()
		ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "WriteMarkedShortPathLog", ResourceMgr.Inst, {
			typeof("System.String")
		}, {
			var0_4
		})
	end)

	if not var1_4 then
		warning(string.format("Write base sub view load log failed: %s", tostring(var2_4)))
	end
end

function var0_0.RegisterView(arg0_6, arg1_6)
	arg0_6.viewComponent = arg1_6

	for iter0_6, iter1_6 in ipairs(var0_0.InheritFuncs) do
		arg0_6[iter1_6] = arg0_6[iter1_6] or function(arg0_7, ...)
			return arg0_7.viewComponent[iter1_6](arg0_7.viewComponent, ...)
		end
	end
end

function var0_0.Load(arg0_8, arg1_8)
	if arg0_8._state ~= var0_0.STATES.NONE then
		return
	end

	if EDITOR_TOOL then
		var2_0(arg0_8)
	end

	arg0_8._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_8 = PoolMgr.GetInstance()

	seriesAsync({
		function(arg0_9)
			local var0_9 = arg0_8:getResource(arg0_8.contextData)

			SplitPackConst.DownloadByLuaArr(var0_9, arg0_9)
		end,
		function(arg0_10)
			if arg1_8 then
				arg0_8.noReturnPrefab = true

				arg0_10(arg1_8)
			else
				var0_8:GetUI(arg0_8:getUIName(), true, arg0_10)
			end
		end
	}, function(arg0_11)
		if arg0_8._state == var0_0.STATES.DESTROY and not arg0_8.noReturnPrefab then
			pg.UIMgr.GetInstance():LoadingOff()
			var0_8:ReturnUI(arg0_8:getUIName(), arg0_11)
		else
			arg0_8:Loaded(arg0_11)
			arg0_8:Init()
		end
	end)
end

function var0_0.Loaded(arg0_12, arg1_12)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0_12._state ~= var0_0.STATES.LOADING then
		return
	end

	arg0_12._state = var0_0.STATES.LOADED
	arg0_12._go = arg1_12
	arg0_12._tf = tf(arg1_12)

	setActiveViaLayer(arg0_12._tf, true)
	pg.DelegateInfo.New(arg0_12)

	if arg0_12._tf.parent ~= arg0_12._parentTf then
		SetParent(arg0_12._tf, arg0_12._parentTf, false)
	end

	bindComponent(arg0_12, arg0_12._go)
	arg0_12:OnLoaded()
end

function var0_0.Init(arg0_13)
	if arg0_13._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_13._state = var0_0.STATES.INITED

	arg0_13:OnInit()
	arg0_13:HandleFuncQueue()
end

function var0_0.Destroy(arg0_14)
	if arg0_14._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_14:GetLoaded() then
		arg0_14._state = var0_0.STATES.DESTROY

		return
	end

	arg0_14._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_14)
	arg0_14:OnDestroy()
	bindComponent(arg0_14, arg0_14._go, true)
	arg0_14:disposeEvent()
	arg0_14:cleanManagedTween()

	arg0_14._tf = nil

	if arg0_14._go ~= nil and not arg0_14.noReturnPrefab then
		PoolMgr.GetInstance():ReturnUI(arg0_14:getUIName(), arg0_14._go)

		arg0_14._go = nil
	end

	arg0_14.noReturnPrefab = nil
end

function var0_0.HandleFuncQueue(arg0_15)
	if arg0_15._state == var0_0.STATES.INITED then
		while #arg0_15._funcQueue > 0 do
			local var0_15 = table.remove(arg0_15._funcQueue, 1)

			var0_15.func(unpackEx(var0_15.params))
		end
	end
end

function var0_0.Reset(arg0_16)
	arg0_16._state = var0_0.STATES.NONE
end

function var0_0.ActionInvoke(arg0_17, arg1_17, ...)
	assert(arg0_17[arg1_17], "func not exist >>>" .. arg1_17)

	arg0_17._funcQueue[#arg0_17._funcQueue + 1] = {
		funcName = arg1_17,
		func = arg0_17[arg1_17],
		params = packEx(arg0_17, ...)
	}

	arg0_17:HandleFuncQueue()
end

function var0_0.ActionInvokeExclusive(arg0_18, arg1_18, ...)
	local var0_18 = #arg0_18._funcQueue

	while var0_18 > 0 do
		if arg0_18._funcQueue[var0_18].funcName == arg1_18 then
			table.remove(arg0_18._funcQueue, var0_18)
		end

		var0_18 = var0_18 - 1
	end

	arg0_18:ActionInvoke(arg1_18, ...)
end

function var0_0.CallbackInvoke(arg0_19, arg1_19, ...)
	arg0_19._funcQueue[#arg0_19._funcQueue + 1] = {
		func = arg1_19,
		params = packEx(...)
	}

	arg0_19:HandleFuncQueue()
end

function var0_0.ExecuteAction(arg0_20, arg1_20, ...)
	arg0_20:Load()
	arg0_20:ActionInvoke(arg1_20, ...)
end

function var0_0.GetLoaded(arg0_21)
	return arg0_21._state >= var0_0.STATES.LOADED
end

function var0_0.CheckState(arg0_22, arg1_22)
	return arg0_22._state == arg1_22
end

function var0_0.Show(arg0_23)
	setActive(arg0_23._tf, true)
	arg0_23:ShowOrHideResUI(true)
	arg0_23:PlayBGM()
end

function var0_0.Hide(arg0_24)
	setActive(arg0_24._tf, false)
	arg0_24:ShowOrHideResUI(false)
	arg0_24:StopBgm()
end

function var0_0.isShowing(arg0_25)
	return arg0_25._tf and isActive(arg0_25._tf) or false
end

function var0_0.getBGM(arg0_26, arg1_26)
	return getBgm(arg1_26 or arg0_26.__cname)
end

function var0_0.PlayBGM(arg0_27)
	local var0_27 = arg0_27:getBGM()

	if var0_27 then
		pg.BgmMgr.GetInstance():Push(arg0_27.__cname, var0_27)
	end
end

function var0_0.StopBgm(arg0_28)
	pg.BgmMgr.GetInstance():Pop(arg0_28.__cname)
end

function var0_0.getTpl(arg0_29, arg1_29, arg2_29)
	local var0_29 = (arg2_29 or arg0_29._tf):Find(arg1_29)

	var0_29:SetParent(arg0_29._tf, false)
	SetActive(var0_29, false)

	return var0_29
end

function var0_0.getUIName(arg0_30)
	return nil
end

function var0_0.getResource(arg0_31)
	return {
		"ui/" .. arg0_31:getUIName()
	}
end

function var0_0.OnLoaded(arg0_32)
	return
end

function var0_0.OnInit(arg0_33)
	return
end

function var0_0.OnDestroy(arg0_34)
	return
end

function var0_0.ResUISettings(arg0_35)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_36, arg1_36)
	local var0_36 = arg0_36:ResUISettings()

	if not var0_36 then
		return
	end

	if var0_36 == true then
		var0_36 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_36 = arg0_36:getGroupName()

	if arg1_36 then
		pg.playerResUI:SetSettings(var1_36, setmetatable({
			groupName = var1_36
		}, {
			__index = var0_36
		}))
	else
		pg.playerResUI:RemoveSettings(var1_36)
	end
end

function var0_0.getGroupName(arg0_37)
	return arg0_37.contextData.groupName or arg0_37.__cname
end

return var0_0
