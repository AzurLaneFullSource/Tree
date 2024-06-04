local var0 = class("LevelStageAutoFightPanel", BaseSubView)

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.buffer = setmetatable({}, {
		__index = function(arg0, arg1)
			return function(arg0, ...)
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

	arg0.loader = AutoLoader.New()
	arg0.isCO = false
end

function var0.getUIName(arg0)
	return "LevelStageAutoFightPanel"
end

function var0.OnInit(arg0)
	arg0.btnOn = arg0._tf:Find("On")
	arg0.btnOff = arg0._tf:Find("Off")

	onButton(arg0, arg0.btnOn, function()
		local var0 = getProxy(ChapterProxy)
		local var1 = "chapter_autofight_flag_" .. arg0.contextData.chapterVO.id

		var0:SetChapterAutoFlag(arg0.contextData.chapterVO.id, false, ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL)
		PlayerPrefs.SetInt(var1, 0)
		PlayerPrefs.Save()
		arg0:UpdateAutoFightMark()
	end, SFX_PANEL)
	onButton(arg0, arg0.btnOff, function()
		local var0 = getProxy(ChapterProxy)
		local var1 = "chapter_autofight_flag_" .. arg0.contextData.chapterVO.id

		var0:SetChapterAutoFlag(arg0.contextData.chapterVO.id, true)
		PlayerPrefs.SetInt(var1, 1)
		PlayerPrefs.Save()
		arg0:UpdateAutoFightMark()

		if not arg0.isFrozen then
			arg0:emit(LevelUIConst.TRIGGER_ACTION)
		end
	end, SFX_PANEL)

	arg0.restTime = arg0.btnOn:Find("Rest")

	local var0 = i18n("multiple_sorties_rest_time")
	local var1 = string.split(var0, "$1/$2")

	setText(arg0.restTime:Find("Text"), var1[1])
	setText(arg0.restTime:Find("Text (2)"), var1[2])
	arg0.loader:LoadBundle("ui/levelstageview_atlas")
end

function var0.UpdateAutoFightMark(arg0)
	local var0 = getProxy(ChapterProxy):GetChapterAutoFlag(arg0.contextData.chapterVO.id) == 1

	setActive(arg0.btnOn, var0)
	setActive(arg0.btnOff, not var0)
	arg0:UpdateContinuousOperation()
	arg0:emit(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, var0)
end

function var0.UpdateContinuousOperation(arg0)
	local var0 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

	if var0 and var0:IsActive() then
		local var1 = var0:GetTotalBattleTime() - var0:GetRestBattleTime() + 1
		local var2 = "$1/$2"

		for iter0, iter1 in ipairs({
			var1,
			var0:GetTotalBattleTime()
		}) do
			var2 = string.gsub(var2, "$" .. iter0, iter1)
		end

		setText(arg0.restTime:Find("Count"), var2)
		setActive(arg0.restTime, true)

		if not arg0.isCO then
			setImageSprite(arg0.btnOn, LoadSprite("ui/levelstageview_atlas", "continuous_operation_on"))

			arg0.isCO = true
		end
	else
		setActive(arg0.restTime, false)

		if arg0.isCO then
			setImageSprite(arg0.btnOn, LoadSprite("ui/levelstageview_atlas", "auto_fight_on"))

			arg0.isCO = false
		end
	end
end

function var0.OnDestroy(arg0)
	arg0.loader:Clear()
	var0.super.OnDestroy(arg0)
end

return var0
