local var0_0 = class("MapBuilder", import("view.base.BaseSubView"))

var0_0.TYPENORMAL = 1
var0_0.TYPEESCORT = 2
var0_0.TYPESHINANO = 3
var0_0.TYPESKIRMISH = 4
var0_0.TYPEBISMARCK = 5
var0_0.TYPESSSS = 6
var0_0.TYPEATELIER = 7
var0_0.TYPESENRANKAGURA = 8

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1.event, arg2_1.contextData)

	arg0_1.sceneParent = arg2_1
	arg0_1.map = arg1_1:Find("maps")
	arg0_1.float = arg1_1:Find("float")
	arg0_1.tweens = {}
	arg0_1.mapWidth = 1920
	arg0_1.mapHeight = 1440
	arg0_1.buffer = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return function(arg0_3, ...)
				if arg1_2 == "UpdateMapItems" and underscore.any(arg0_1._funcQueue, function(arg0_4)
					return arg0_4.funcName == arg1_2
				end) then
					return
				end

				arg0_1:ActionInvoke(arg1_2, ...)
			end
		end,
		__newindex = function()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
	arg0_1.isFrozen = nil

	arg0_1:bind(LevelUIConst.ON_FROZEN, function()
		arg0_1.isFrozen = true
	end)
	arg0_1:bind(LevelUIConst.ON_UNFROZEN, function()
		arg0_1.isFrozen = nil
	end)
end

function var0_0.Load(arg0_8)
	if arg0_8._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_8._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_8 = PoolMgr.GetInstance()
	local var1_8

	parallelAsync({
		function(arg0_9)
			var0_8:GetUI(arg0_8:getUIName(), true, function(arg0_10)
				if arg0_8._state == var0_0.STATES.DESTROY then
					pg.UIMgr.GetInstance():LoadingOff()
					var0_8:ReturnUI(arg0_8:getUIName(), arg0_10)
				else
					var1_8 = arg0_10

					arg0_9()
				end
			end)
		end,
		function(arg0_11)
			arg0_8:preload(arg0_11)
		end
	}, function()
		arg0_8:Loaded(var1_8)
		arg0_8:Init()
	end)
end

function var0_0.preload(arg0_13, arg1_13)
	arg1_13()
end

function var0_0.isfrozen(arg0_14)
	return arg0_14.isFrozen
end

function var0_0.DoFunction(arg0_15, arg1_15)
	arg1_15()
end

function var0_0.InvokeParent(arg0_16, arg1_16, ...)
	local var0_16 = arg0_16.sceneParent[arg1_16]

	if var0_16 then
		return var0_16(arg0_16.sceneParent, ...)
	end
end

function var0_0.GetType(arg0_17)
	return 0
end

function var0_0.OnLoaded(arg0_18)
	arg0_18._tf:SetParent(arg0_18.float, false)
end

function var0_0.Destroy(arg0_19)
	if arg0_19._state == var0_0.STATES.INITED then
		arg0_19:Hide()
	end

	var0_0.super.Destroy(arg0_19)
end

function var0_0.OnDestroy(arg0_20)
	arg0_20.tweens = nil
end

function var0_0.Show(arg0_21)
	setActive(arg0_21._tf, true)
	arg0_21:OnShow()
end

function var0_0.Hide(arg0_22)
	arg0_22:OnHide()
	setActive(arg0_22._tf, false)
end

function var0_0.OnShow(arg0_23)
	return
end

function var0_0.OnHide(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.tweens) do
		LeanTween.cancel(iter1_24)
	end

	arg0_24.tweens = {}
end

function var0_0.ShowButtons(arg0_25)
	return
end

function var0_0.HideButtons(arg0_26)
	return
end

function var0_0.Update(arg0_27, arg1_27)
	arg0_27.data = arg1_27
end

function var0_0.UpdateButtons(arg0_28)
	return
end

function var0_0.PostUpdateMap(arg0_29, arg1_29)
	return
end

function var0_0.UpdateMapItems(arg0_30)
	return
end

function var0_0.RecordTween(arg0_31, arg1_31, arg2_31)
	arg0_31.tweens[arg1_31] = arg2_31
end

function var0_0.DeleteTween(arg0_32, arg1_32)
	local var0_32 = arg0_32.tweens[arg1_32]

	if var0_32 then
		LeanTween.cancel(var0_32)

		arg0_32.tweens[arg1_32] = nil
	end
end

function var0_0.TryOpenChapter(arg0_33, arg1_33)
	assert(false)
end

return var0_0
