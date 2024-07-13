local var0_0 = class("ActivityBossTotalRewardPanel", import("view.level.BaseTotalRewardPanel"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossTotalRewardPanel"
end

local var1_0 = 0.15

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.itemList = arg0_2.boxView:Find("Content/ItemGrid2")

	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {
		lockGlobalBlur = true,
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0_3:UpdateView()

	local var0_3 = arg0_3.contextData.isAutoFight
	local var1_3 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if var0_3 and var1_3 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end
end

function var0_0.willExit(arg0_4)
	arg0_4:SkipAnim()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.UpdateView(arg0_5)
	local var0_5 = arg0_5.contextData

	onButton(arg0_5, arg0_5._tf:Find("BG"), function()
		if arg0_5.isRewardAnimating then
			arg0_5:SkipAnim()

			return
		end

		existCall(var0_5.onClose)
		arg0_5:closeView()
	end)
	onButton(arg0_5, arg0_5.window:Find("Fixed/ButtonGO"), function()
		existCall(var0_5.onClose)
		arg0_5:closeView()
	end, SFX_CONFIRM)

	local var1_5 = var0_5.rewards
	local var2_5 = {}
	local var3_5 = var1_5 and #var1_5 > 0
	local var4_5 = CustomIndexLayer.Clone2Full(arg0_5.itemList, #var1_5)

	for iter0_5, iter1_5 in ipairs(var4_5) do
		local var5_5 = var1_5[iter0_5]
		local var6_5 = var4_5[iter0_5]

		updateDrop(var6_5:Find("Icon"), var5_5)
		onButton(arg0_5, var6_5:Find("Icon"), function()
			arg0_5:emit(BaseUI.ON_DROP, var5_5)
		end, SFX_PANEL)
	end

	if var3_5 then
		arg0_5.isRewardAnimating = true

		for iter2_5 = 1, #var1_5 do
			local var7_5 = var4_5[iter2_5]

			setActive(var7_5, false)
			table.insert(var2_5, function(arg0_9)
				if arg0_5.exited then
					return
				end

				setActive(var7_5, true)
				scrollTo(arg0_5.boxView:Find("Content"), {
					y = 0
				})

				arg0_5.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_9)).uniqueId
			end)
		end
	end

	local var8_5 = {}
	local var9_5 = arg0_5.contextData.stopReason

	if not var9_5 then
		if arg0_5.contextData.isAutoFight then
			table.insert(var8_5, i18n("multiple_sorties_finish"))
		else
			table.insert(var8_5, i18n("multiple_sorties_stop"))
		end
	else
		table.insert(var8_5, var9_5 .. i18n("multiple_sorties_stop_tip_end"))
	end

	table.insert(var8_5, i18n("multiple_sorties_end_status", arg0_5.contextData.totalBattleTimes, arg0_5.contextData.totalBattleTimes - arg0_5.contextData.continuousBattleTimes))

	if #var8_5 > 0 then
		setText(arg0_5.boxView:Find("Content/TextArea2/Text"), table.concat(var8_5, "\n"))
	end

	seriesAsync(var2_5, function()
		arg0_5:SkipAnim()
	end)
end

function var0_0.SkipAnim(arg0_11)
	if not arg0_11.isRewardAnimating then
		return
	end

	arg0_11.isRewardAnimating = nil

	if arg0_11.LTid then
		LeanTween.cancel(arg0_11.LTid)

		arg0_11.LTid = nil
	end

	eachChild(arg0_11.itemList, function(arg0_12)
		setActive(arg0_12, true)
	end)
end

function var0_0.onBackPressed(arg0_13)
	existCall(arg0_13.contextData.onClose)
	arg0_13:closeView()
end

return var0_0
