local var0 = class("BossRushTotalRewardPanel", import("view.activity.worldboss.ActivityBossTotalRewardPanel"))

function var0.getUIName(arg0)
	return "BossRushTotalRewardPanel"
end

local var1 = 0.15

function var0.init(arg0)
	var0.super.init(arg0)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		lockGlobalBlur = true,
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = arg0.contextData

	onButton(arg0, arg0._tf:Find("BG"), function()
		if arg0.isRewardAnimating then
			arg0:SkipAnim()

			return
		end

		existCall(var0.onClose)
		arg0:closeView()
	end)
	setText(arg0.window:Find("Fixed/ButtonGO/pic"), i18n("text_confirm"))
	onButton(arg0, arg0.window:Find("Fixed/ButtonGO"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end, SFX_CONFIRM)
	setText(arg0.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(arg0, arg0.window:Find("Fixed/ButtonExit"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end, SFX_CANCEL)

	local var1 = var0.rewards
	local var2 = {}
	local var3 = var1 and #var1 > 0

	arg0.itemList = arg0.boxView:Find("Content/ItemGrid")

	setActive(arg0.boxView:Find("Content/TextArea2"), false)
	setActive(arg0.boxView:Find("Content/ItemGrid2"), false)
	setActive(arg0.boxView:Find("Content/Title"), false)
	setActive(arg0.itemList, false)

	if var3 then
		arg0.hasRewards = true

		table.insert(var2, function(arg0)
			setActive(arg0.boxView:Find("Content/Title"), true)
			setActive(arg0.itemList, true)
			arg0()
		end)

		local var4 = CustomIndexLayer.Clone2Full(arg0.itemList, #var1)

		for iter0, iter1 in ipairs(var4) do
			local var5 = var1[iter0]
			local var6 = var4[iter0]

			updateDrop(var6:Find("Shell/Icon"), var5)
			onButton(arg0, var6:Find("Shell/Icon"), function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)
		end

		arg0.isRewardAnimating = true

		local var7 = {}

		for iter2 = 1, #var1 do
			local var8 = var4[iter2]

			setActive(var8, false)
			table.insert(var2, function(arg0)
				if arg0.exited then
					return
				end

				setActive(var8, true)
				scrollTo(arg0.boxView:Find("Content"), {
					y = 0
				})

				arg0.LTid = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
			end)
		end
	end

	local var9 = {}
	local var10 = arg0.contextData.stopReason

	if not var10 then
		if arg0.contextData.isAutoFight then
			table.insert(var9, i18n("multiple_sorties_finish"))
		else
			table.insert(var9, i18n("multiple_sorties_stop"))
		end
	else
		table.insert(var9, var10 .. i18n("multiple_sorties_stop_tip_end"))
	end

	if arg0.contextData.totalBattleTimes then
		table.insert(var9, i18n("multiple_sorties_end_status", arg0.contextData.totalBattleTimes, arg0.contextData.totalBattleTimes - arg0.contextData.continuousBattleTimes))

		if #var9 > 0 then
			setText(arg0.boxView:Find("Content/TextArea2/Text"), table.concat(var9, "\n"))
		end
	end

	seriesAsync(var2, function()
		arg0:SkipAnim()
	end)
end

function var0.willExit(arg0)
	pg.m02:sendNotification(BossRushTotalRewardPanelMediator.ON_WILL_EXIT)
end

return var0
