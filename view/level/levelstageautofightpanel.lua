local var0_0 = class("LevelStageAutoFightPanel", BaseSubView)

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.buffer = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return function(arg0_3, ...)
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

	arg0_1.loader = AutoLoader.New()
	arg0_1.isCO = false
end

function var0_0.getUIName(arg0_7)
	return "LevelStageAutoFightPanel"
end

function var0_0.OnInit(arg0_8)
	arg0_8.btnOn = arg0_8._tf:Find("On")
	arg0_8.btnOff = arg0_8._tf:Find("Off")

	onButton(arg0_8, arg0_8.btnOn, function()
		local var0_9 = getProxy(ChapterProxy)
		local var1_9 = "chapter_autofight_flag_" .. arg0_8.contextData.chapterVO.id

		var0_9:SetChapterAutoFlag(arg0_8.contextData.chapterVO.id, false, ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL)
		PlayerPrefs.SetInt(var1_9, 0)
		PlayerPrefs.Save()
		arg0_8:UpdateAutoFightMark()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.btnOff, function()
		local var0_10 = getProxy(ChapterProxy)
		local var1_10 = "chapter_autofight_flag_" .. arg0_8.contextData.chapterVO.id

		var0_10:SetChapterAutoFlag(arg0_8.contextData.chapterVO.id, true)
		PlayerPrefs.SetInt(var1_10, 1)
		PlayerPrefs.Save()
		arg0_8:UpdateAutoFightMark()

		if not arg0_8.isFrozen then
			arg0_8:emit(LevelUIConst.TRIGGER_ACTION)
		end
	end, SFX_PANEL)

	arg0_8.restTime = arg0_8.btnOn:Find("Rest")

	local var0_8 = i18n("multiple_sorties_rest_time")
	local var1_8 = string.split(var0_8, "$1/$2")

	setText(arg0_8.restTime:Find("Text"), var1_8[1])
	setText(arg0_8.restTime:Find("Text (2)"), var1_8[2])
	arg0_8.loader:LoadBundle("ui/levelstageview_atlas")
end

function var0_0.UpdateAutoFightMark(arg0_11)
	local var0_11 = getProxy(ChapterProxy):GetChapterAutoFlag(arg0_11.contextData.chapterVO.id) == 1

	setActive(arg0_11.btnOn, var0_11)
	setActive(arg0_11.btnOff, not var0_11)
	arg0_11:UpdateContinuousOperation()
	arg0_11:emit(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, var0_11)
end

function var0_0.UpdateContinuousOperation(arg0_12)
	local var0_12 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

	if var0_12 and var0_12:IsActive() then
		local var1_12 = var0_12:GetTotalBattleTime() - var0_12:GetRestBattleTime() + 1
		local var2_12 = "$1/$2"

		for iter0_12, iter1_12 in ipairs({
			var1_12,
			var0_12:GetTotalBattleTime()
		}) do
			var2_12 = string.gsub(var2_12, "$" .. iter0_12, iter1_12)
		end

		setText(arg0_12.restTime:Find("Count"), var2_12)
		setActive(arg0_12.restTime, true)

		if not arg0_12.isCO then
			setImageSprite(arg0_12.btnOn, LoadSprite("ui/levelstageview_atlas", "continuous_operation_on"))

			arg0_12.isCO = true
		end
	else
		setActive(arg0_12.restTime, false)

		if arg0_12.isCO then
			setImageSprite(arg0_12.btnOn, LoadSprite("ui/levelstageview_atlas", "auto_fight_on"))

			arg0_12.isCO = false
		end
	end
end

function var0_0.OnDestroy(arg0_13)
	arg0_13.loader:Clear()
	var0_0.super.OnDestroy(arg0_13)
end

return var0_0
