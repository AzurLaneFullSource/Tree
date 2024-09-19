local var0_0 = class("MapBuilder", import("view.base.BaseSubView"))

var0_0.TYPENORMAL = 1
var0_0.TYPEESCORT = 2
var0_0.TYPESHINANO = 3
var0_0.TYPESKIRMISH = 4
var0_0.TYPEBISMARCK = 5
var0_0.TYPESSSS = 6
var0_0.TYPEATELIER = 7
var0_0.TYPESENRANKAGURA = 8
var0_0.TYPESP = 9
var0_0.TYPESPFULL = 10

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
					errorMsg("Multiple Calls of function 'UpdateMapItems' in Mapbuilder")

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
	PoolMgr.GetInstance():GetUI(arg0_8:getUIName(), true, function(arg0_9)
		arg0_8:Loaded(arg0_9)
		arg0_8:Init()
	end)
end

function var0_0.isfrozen(arg0_10)
	return arg0_10.isFrozen
end

function var0_0.GetType(arg0_11)
	return 0
end

function var0_0.Destroy(arg0_12)
	if arg0_12._state == var0_0.STATES.INITED then
		arg0_12:Hide()
	end

	var0_0.super.Destroy(arg0_12)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13.tweens = nil
end

function var0_0.Show(arg0_14)
	var0_0.super.Show(arg0_14)
	arg0_14:OnShow()
end

function var0_0.Hide(arg0_15)
	arg0_15:OnHide()
	var0_0.super.Hide(arg0_15)
end

function var0_0.OnShow(arg0_16)
	return
end

function var0_0.OnHide(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.tweens) do
		LeanTween.cancel(iter1_17)
	end

	arg0_17.tweens = {}
end

function var0_0.UpdateMapVO(arg0_18, arg1_18)
	arg0_18.data = arg1_18
end

function var0_0.UpdateView(arg0_19)
	arg0_19:UpdateButtons()
end

function var0_0.UpdateButtons(arg0_20)
	return
end

function var0_0.UpdateMapItems(arg0_21)
	return
end

function var0_0.HideFloat(arg0_22)
	return
end

function var0_0.ShowFloat(arg0_23)
	return
end

function var0_0.RecordTween(arg0_24, arg1_24, arg2_24)
	arg0_24.tweens[arg1_24] = arg2_24
end

function var0_0.DeleteTween(arg0_25, arg1_25)
	local var0_25 = arg0_25.tweens[arg1_25]

	if var0_25 then
		LeanTween.cancel(var0_25)

		arg0_25.tweens[arg1_25] = nil
	end
end

function var0_0.UpdateChapterTF(arg0_26, arg1_26)
	return
end

function var0_0.TryOpenChapter(arg0_27, arg1_27)
	errorMsg("Not Implent TryOpenChapter in " .. arg0_27.__cname)
end

function var0_0.TryOpenChapterInfo(arg0_28, arg1_28, arg2_28, arg3_28)
	if arg0_28:isfrozen() then
		return
	end

	local var0_28 = getProxy(ChapterProxy):getChapterById(arg1_28, true)

	if var0_28.active then
		arg0_28.sceneParent:switchToChapter(var0_28)

		return
	end

	if not var0_28:isUnlock() then
		local var1_28 = var0_28:GetPrevChapterNames()

		if #var1_28 == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1_28[1]))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre_2", var1_28[1], var1_28[2]))
		end

		return
	end

	if not getProxy(ChapterProxy):getMapById(var0_28:getConfig("map")):isRemaster() and not var0_28:inActTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))

		return
	end

	local var2_28 = var0_28:getConfig("unlocklevel")

	if var2_28 > getProxy(PlayerProxy):getRawData().level then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2_28))

		return
	end

	local var3_28 = getProxy(ChapterProxy):getActiveChapter(true)

	if var3_28 and var3_28.id ~= arg1_28 then
		arg0_28:emit(LevelMediator2.ON_STRATEGYING_CHAPTER)

		return
	end

	if var0_28:IsSpChapter() then
		SettingsProxy.SetActivityMapSPTip()
		arg0_28:UpdateChapterTF(arg1_28)
	end

	if not arg3_28 then
		arg0_28.sceneParent:DisplayLevelInfoPanel(arg1_28, arg2_28)
	else
		arg0_28.sceneParent:DisplayLevelInfoSPPanel(arg1_28, arg3_28, arg2_28)
	end
end

function var0_0.OnSubmitTaskDone(arg0_29)
	return
end

return var0_0
