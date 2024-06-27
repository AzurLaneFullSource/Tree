local var0_0 = class("BossRushTotalRewardPanel", import("view.activity.worldboss.ActivityBossTotalRewardPanel"))

function var0_0.getUIName(arg0_1)
	return "BossRushTotalRewardPanel"
end

local var1_0 = 0.15

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {
		lockGlobalBlur = true,
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0_3:UpdateView()

	local var0_3 = arg0_3.contextData.isAutoFight
	local var1_3 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if var0_3 and var1_3 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end
end

function var0_0.UpdateView(arg0_4)
	local var0_4 = arg0_4.contextData

	onButton(arg0_4, arg0_4._tf:Find("BG"), function()
		if arg0_4.isRewardAnimating then
			arg0_4:SkipAnim()

			return
		end

		existCall(var0_4.onClose)
		arg0_4:closeView()
	end)
	setText(arg0_4.window:Find("Fixed/ButtonGO/pic"), i18n("text_confirm"))
	onButton(arg0_4, arg0_4.window:Find("Fixed/ButtonGO"), function()
		existCall(var0_4.onClose)
		arg0_4:closeView()
	end, SFX_CONFIRM)
	setText(arg0_4.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(arg0_4, arg0_4.window:Find("Fixed/ButtonExit"), function()
		existCall(var0_4.onClose)
		arg0_4:closeView()
	end, SFX_CANCEL)

	local var1_4 = var0_4.rewards
	local var2_4 = {}

	setActive(arg0_4.boxView:Find("Content/TextArea2"), arg0_4.contextData.totalBattleTimes)

	local var3_4 = var1_4 and #var1_4 > 0
	local var4_4 = CustomIndexLayer.Clone2Full(arg0_4.itemList, #var1_4)

	for iter0_4, iter1_4 in ipairs(var4_4) do
		local var5_4 = var1_4[iter0_4]
		local var6_4 = var4_4[iter0_4]

		updateDrop(var6_4:Find("Icon"), var5_4)
		onButton(arg0_4, var6_4:Find("Icon"), function()
			arg0_4:emit(BaseUI.ON_DROP, var5_4)
		end, SFX_PANEL)
	end

	if var3_4 then
		arg0_4.isRewardAnimating = true

		for iter2_4 = 1, #var1_4 do
			local var7_4 = var4_4[iter2_4]

			setActive(var7_4, false)
			table.insert(var2_4, function(arg0_9)
				if arg0_4.exited then
					return
				end

				setActive(var7_4, true)
				scrollTo(arg0_4.boxView:Find("Content"), {
					y = 0
				})

				arg0_4.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_9)).uniqueId
			end)
		end
	end

	local var8_4 = {}
	local var9_4 = arg0_4.contextData.stopReason

	if not var9_4 then
		if arg0_4.contextData.isAutoFight then
			table.insert(var8_4, i18n("multiple_sorties_finish"))
		else
			table.insert(var8_4, i18n("multiple_sorties_stop"))
		end
	else
		table.insert(var8_4, var9_4 .. i18n("multiple_sorties_stop_tip_end"))
	end

	if arg0_4.contextData.totalBattleTimes then
		table.insert(var8_4, i18n("multiple_sorties_end_status", arg0_4.contextData.totalBattleTimes, arg0_4.contextData.totalBattleTimes - arg0_4.contextData.continuousBattleTimes))

		if #var8_4 > 0 then
			setText(arg0_4.boxView:Find("Content/TextArea2/Text"), table.concat(var8_4, "\n"))
		end
	end

	seriesAsync(var2_4, function()
		arg0_4:SkipAnim()
	end)
end

function var0_0.willExit(arg0_11)
	pg.m02:sendNotification(BossRushTotalRewardPanelMediator.ON_WILL_EXIT)
end

return var0_0
