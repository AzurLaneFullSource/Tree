local var0_0 = class("LevelContinuousOperationTotalRewardPanel", import("view.level.LevelStageTotalRewardPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelContinuousOperationTotalRewardPanel"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)
end

function var0_0.UpdateView(arg0_4)
	var0_0.super.UpdateView(arg0_4)
	setActive(arg0_4.boxView, true)
	setActive(arg0_4.emptyTip, false)

	local var0_4 = arg0_4.contextData.continuousData
	local var1_4 = var0_4:GetTotalBattleTime()
	local var2_4 = arg0_4.contextData.chapter:GetMaxBattleCount()
	local var3_4 = math.min(var1_4, var2_4)
	local var4_4 = var3_4 > 0 and var0_4:IsActive()

	onButton(arg0_4, arg0_4.window:Find("Fixed/ButtonGO"), function()
		if arg0_4.contextData.spItemID and not (PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1) then
			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var0_5()
				arg0_4.contextData.spItemID = nil

				arg0_4:UpdateSPItem()
			end

			arg0_4:HandleShowMsgBox({
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var0_5,
				onNo = var0_5
			})

			return
		end

		local var1_5 = Chapter.GetSPOperationItemCacheKey(arg0_4.contextData.chapter.id)

		PlayerPrefs.SetInt(var1_5, arg0_4.contextData.spItemID or 0)

		if var4_4 then
			getProxy(ChapterProxy):InitContinuousTime(SYSTEM_SCENARIO, var3_4)
		end

		local var2_5 = true

		arg0_4:emit(LevelMediator2.ON_RETRACKING, arg0_4.contextData.chapter, var2_5)
		arg0_4:closeView()
	end, SFX_CONFIRM)

	local var5_4 = {}
	local var6_4 = var0_4:IsActive()

	if var6_4 then
		table.insert(var5_4, i18n("multiple_sorties_finish"))
	else
		table.insert(var5_4, i18n("multiple_sorties_stop"))
	end

	setActive(arg0_4.boxView:Find("Content/TextArea2/Title/Sucess"), var6_4)
	setActive(arg0_4.boxView:Find("Content/TextArea2/Title/Failure"), not var6_4)
	table.insert(var5_4, i18n("multiple_sorties_main_end", var1_4, var1_4 - var0_4:GetRestBattleTime()))

	if #var5_4 > 0 then
		setText(arg0_4.boxView:Find("Content/TextArea2/Title/Text"), var5_4[1])
		setText(arg0_4.boxView:Find("Content/TextArea2/Detail"), var5_4[2])
	end

	if var4_4 then
		local var7_4 = arg0_4.contextData.chapter:GetRestDailyBonus()

		setActive(arg0_4.spList, go(arg0_4.spList).activeSelf and var7_4 < var3_4)
	end

	setActive(arg0_4.window:Find("RetryTimes"), var4_4)
	setText(arg0_4.window:Find("RetryTimes/Text"), i18n("multiple_sorties_retry_desc", var3_4))
end

function var0_0.willExit(arg0_7)
	var0_0.super.willExit(arg0_7)
end

return var0_0
