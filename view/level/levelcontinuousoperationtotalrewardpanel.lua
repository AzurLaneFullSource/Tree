local var0 = class("LevelContinuousOperationTotalRewardPanel", import("view.level.LevelStageTotalRewardPanel"))

function var0.getUIName(arg0)
	return "LevelContinuousOperationTotalRewardPanel"
end

function var0.init(arg0)
	var0.super.init(arg0)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
end

function var0.UpdateView(arg0)
	var0.super.UpdateView(arg0)
	setActive(arg0.boxView, true)
	setActive(arg0.emptyTip, false)

	local var0 = arg0.contextData.continuousData
	local var1 = var0:GetTotalBattleTime()
	local var2 = arg0.contextData.chapter:GetMaxBattleCount()
	local var3 = math.min(var1, var2)
	local var4 = var3 > 0 and var0:IsActive()

	onButton(arg0, arg0.window:Find("Fixed/ButtonGO"), function()
		if arg0.contextData.spItemID and not (PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1) then
			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var0()
				arg0.contextData.spItemID = nil

				arg0:UpdateSPItem()
			end

			arg0:HandleShowMsgBox({
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var0,
				onNo = var0
			})

			return
		end

		local var1 = Chapter.GetSPOperationItemCacheKey(arg0.contextData.chapter.id)

		PlayerPrefs.SetInt(var1, arg0.contextData.spItemID or 0)

		if var4 then
			getProxy(ChapterProxy):InitContinuousTime(SYSTEM_SCENARIO, var3)
		end

		local var2 = true

		arg0:emit(LevelMediator2.ON_RETRACKING, arg0.contextData.chapter, var2)
		arg0:closeView()
	end, SFX_CONFIRM)

	local var5 = {}
	local var6 = var0:IsActive()

	if var6 then
		table.insert(var5, i18n("multiple_sorties_finish"))
	else
		table.insert(var5, i18n("multiple_sorties_stop"))
	end

	setActive(arg0.boxView:Find("Content/TextArea2/Title/Sucess"), var6)
	setActive(arg0.boxView:Find("Content/TextArea2/Title/Failure"), not var6)
	table.insert(var5, i18n("multiple_sorties_main_end", var1, var1 - var0:GetRestBattleTime()))

	if #var5 > 0 then
		setText(arg0.boxView:Find("Content/TextArea2/Title/Text"), var5[1])
		setText(arg0.boxView:Find("Content/TextArea2/Detail"), var5[2])
	end

	if var4 then
		local var7 = arg0.contextData.chapter:GetRestDailyBonus()

		setActive(arg0.spList, go(arg0.spList).activeSelf and var7 < var3)
	end

	setActive(arg0.window:Find("RetryTimes"), var4)
	setText(arg0.window:Find("RetryTimes/Text"), i18n("multiple_sorties_retry_desc", var3))
end

function var0.willExit(arg0)
	var0.super.willExit(arg0)
end

return var0
