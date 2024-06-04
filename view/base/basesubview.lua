local var0 = class("BaseSubView", import("view.base.BaseEventLogic"))

var0.STATES = {
	DESTROY = 5,
	NONE = 1,
	LOADING = 2,
	INITED = 4,
	LOADED = 3
}

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg2)

	arg0.contextData = arg3
	arg0._parentTf = arg1
	arg0.event = arg2
	arg0._go = nil
	arg0._tf = nil
	arg0._state = var0.STATES.NONE
	arg0._funcQueue = {}
end

function var0.SetExtra(arg0, arg1)
	arg0.extraGameObject = go(arg1)
	arg0._parentTf = arg1.parent
end

function var0.Load(arg0)
	if arg0._state ~= var0.STATES.NONE then
		return
	end

	arg0._state = var0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0 = PoolMgr.GetInstance()

	seriesAsync({
		function(arg0)
			if arg0.extraGameObject then
				arg0(arg0.extraGameObject)
			else
				var0:GetUI(arg0:getUIName(), true, arg0)
			end
		end
	}, function(arg0)
		if arg0._state == var0.STATES.DESTROY and arg0:getUIName() then
			pg.UIMgr.GetInstance():LoadingOff()
			var0:ReturnUI(arg0:getUIName(), arg0)
		else
			arg0:Loaded(arg0)
			arg0:Init()
		end
	end)
end

function var0.Loaded(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOff()

	if arg0._state ~= var0.STATES.LOADING then
		return
	end

	arg0._state = var0.STATES.LOADED
	arg0._go = arg1
	arg0._tf = tf(arg1)

	setActiveViaLayer(arg0._tf, true)
	pg.DelegateInfo.New(arg0)
	SetParent(arg0._tf, arg0._parentTf, false)
	arg0:OnLoaded()
end

function var0.Init(arg0)
	if arg0._state ~= var0.STATES.LOADED then
		return
	end

	arg0._state = var0.STATES.INITED

	arg0:OnInit()
	arg0:HandleFuncQueue()
end

function var0.Destroy(arg0)
	if arg0._state == var0.STATES.DESTROY then
		return
	end

	if not arg0:GetLoaded() then
		arg0._state = var0.STATES.DESTROY

		return
	end

	arg0._state = var0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0)
	arg0:OnDestroy()
	arg0:disposeEvent()
	arg0:cleanManagedTween()

	arg0._tf = nil

	local var0 = arg0:getUIName()

	if arg0._go ~= nil and var0 then
		PoolMgr.GetInstance():ReturnUI(var0, arg0._go)

		arg0._go = nil
	end
end

function var0.HandleFuncQueue(arg0)
	if arg0._state == var0.STATES.INITED then
		while #arg0._funcQueue > 0 do
			local var0 = table.remove(arg0._funcQueue, 1)

			var0.func(unpack(var0.params, 1, var0.params.len))
		end
	end
end

function var0.Reset(arg0)
	arg0._state = var0.STATES.NONE
end

function var0.ActionInvoke(arg0, arg1, ...)
	assert(arg0[arg1], "func not exist >>>" .. arg1)

	arg0._funcQueue[#arg0._funcQueue + 1] = {
		funcName = arg1,
		func = arg0[arg1],
		params = {
			len = 1 + select("#", ...),
			arg0,
			...
		}
	}

	arg0:HandleFuncQueue()
end

function var0.CallbackInvoke(arg0, arg1, ...)
	arg0._funcQueue[#arg0._funcQueue + 1] = {
		func = arg1,
		params = packEx(...)
	}

	arg0:HandleFuncQueue()
end

function var0.ExecuteAction(arg0, arg1, ...)
	arg0:Load()
	arg0:ActionInvoke(arg1, ...)
end

function var0.GetLoaded(arg0)
	return arg0._state >= var0.STATES.LOADED
end

function var0.CheckState(arg0, arg1)
	return arg0._state == arg1
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	arg0:ShowOrHideResUI(true)
	arg0:PlayBGM()
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)
	arg0:ShowOrHideResUI(false)
	arg0:StopBgm()
end

function var0.isShowing(arg0)
	return arg0._tf and isActive(arg0._tf)
end

function var0.getBGM(arg0, arg1)
	return getBgm(arg1 or arg0.__cname)
end

function var0.PlayBGM(arg0)
	local var0 = arg0:getBGM()

	if var0 then
		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.StopBgm(arg0)
	pg.BgmMgr.GetInstance():Pop(arg0.__cname)
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.getTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1, arg2)

	var0:SetParent(arg0._tf, false)
	SetActive(var0, false)

	return var0
end

function var0.getUIName(arg0)
	return nil
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

function var0.ResUISettings(arg0)
	return nil
end

function var0.ShowOrHideResUI(arg0, arg1)
	local var0 = arg0:ResUISettings()

	if not var0 then
		return
	end

	if var0 == true then
		var0 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1,
		weight = var0.weight,
		groupName = var0.groupName,
		canvasOrder = var0.order or false
	}, {
		__index = var0
	}))
end

return var0
