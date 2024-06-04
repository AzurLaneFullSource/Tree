local var0 = class("MapBuilder", import("view.base.BaseSubView"))

var0.TYPENORMAL = 1
var0.TYPEESCORT = 2
var0.TYPESHINANO = 3
var0.TYPESKIRMISH = 4
var0.TYPEBISMARCK = 5
var0.TYPESSSS = 6
var0.TYPEATELIER = 7
var0.TYPESENRANKAGURA = 8

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2.event, arg2.contextData)

	arg0.sceneParent = arg2
	arg0.map = arg1:Find("maps")
	arg0.float = arg1:Find("float")
	arg0.tweens = {}
	arg0.mapWidth = 1920
	arg0.mapHeight = 1440
	arg0.buffer = setmetatable({}, {
		__index = function(arg0, arg1)
			return function(arg0, ...)
				if arg1 == "UpdateMapItems" and underscore.any(arg0._funcQueue, function(arg0)
					return arg0.funcName == arg1
				end) then
					return
				end

				arg0:ActionInvoke(arg1, ...)
			end
		end,
		__newindex = function()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
	arg0.isFrozen = nil

	arg0:bind(LevelUIConst.ON_FROZEN, function()
		arg0.isFrozen = true
	end)
	arg0:bind(LevelUIConst.ON_UNFROZEN, function()
		arg0.isFrozen = nil
	end)
end

function var0.Load(arg0)
	if arg0._state ~= var0.STATES.NONE then
		return
	end

	arg0._state = var0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0 = PoolMgr.GetInstance()
	local var1

	parallelAsync({
		function(arg0)
			var0:GetUI(arg0:getUIName(), true, function(arg0)
				if arg0._state == var0.STATES.DESTROY then
					pg.UIMgr.GetInstance():LoadingOff()
					var0:ReturnUI(arg0:getUIName(), arg0)
				else
					var1 = arg0

					arg0()
				end
			end)
		end,
		function(arg0)
			arg0:preload(arg0)
		end
	}, function()
		arg0:Loaded(var1)
		arg0:Init()
	end)
end

function var0.preload(arg0, arg1)
	arg1()
end

function var0.isfrozen(arg0)
	return arg0.isFrozen
end

function var0.DoFunction(arg0, arg1)
	arg1()
end

function var0.InvokeParent(arg0, arg1, ...)
	local var0 = arg0.sceneParent[arg1]

	if var0 then
		return var0(arg0.sceneParent, ...)
	end
end

function var0.GetType(arg0)
	return 0
end

function var0.OnLoaded(arg0)
	arg0._tf:SetParent(arg0.float, false)
end

function var0.Destroy(arg0)
	if arg0._state == var0.STATES.INITED then
		arg0:Hide()
	end

	var0.super.Destroy(arg0)
end

function var0.OnDestroy(arg0)
	arg0.tweens = nil
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	arg0:OnShow()
end

function var0.Hide(arg0)
	arg0:OnHide()
	setActive(arg0._tf, false)
end

function var0.OnShow(arg0)
	return
end

function var0.OnHide(arg0)
	for iter0, iter1 in pairs(arg0.tweens) do
		LeanTween.cancel(iter1)
	end

	arg0.tweens = {}
end

function var0.ShowButtons(arg0)
	return
end

function var0.HideButtons(arg0)
	return
end

function var0.Update(arg0, arg1)
	arg0.data = arg1
end

function var0.UpdateButtons(arg0)
	return
end

function var0.PostUpdateMap(arg0, arg1)
	return
end

function var0.UpdateMapItems(arg0)
	return
end

function var0.RecordTween(arg0, arg1, arg2)
	arg0.tweens[arg1] = arg2
end

function var0.DeleteTween(arg0, arg1)
	local var0 = arg0.tweens[arg1]

	if var0 then
		LeanTween.cancel(var0)

		arg0.tweens[arg1] = nil
	end
end

function var0.TryOpenChapter(arg0, arg1)
	assert(false)
end

return var0
