local var0 = class("ActivityBossTotalRewardPanel", import("view.level.BaseTotalRewardPanel"))

function var0.getUIName(arg0)
	return "ActivityBossTotalRewardPanel"
end

local var1 = 0.15

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.itemList = arg0.boxView:Find("Content/ItemGrid2")

	setText(arg0.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		lockGlobalBlur = true,
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0:UpdateView()

	local var0 = arg0.contextData.isAutoFight
	local var1 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if var0 and var1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end
end

function var0.willExit(arg0)
	arg0:SkipAnim()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
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
	onButton(arg0, arg0.window:Find("Fixed/ButtonGO"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end, SFX_CONFIRM)

	local var1 = var0.rewards
	local var2 = {}
	local var3 = var1 and #var1 > 0
	local var4 = CustomIndexLayer.Clone2Full(arg0.itemList, #var1)

	for iter0, iter1 in ipairs(var4) do
		local var5 = var1[iter0]
		local var6 = var4[iter0]

		updateDrop(var6:Find("Icon"), var5)
		onButton(arg0, var6:Find("Icon"), function()
			arg0:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
	end

	if var3 then
		arg0.isRewardAnimating = true

		for iter2 = 1, #var1 do
			local var7 = var4[iter2]

			setActive(var7, false)
			table.insert(var2, function(arg0)
				if arg0.exited then
					return
				end

				setActive(var7, true)
				scrollTo(arg0.boxView:Find("Content"), {
					y = 0
				})

				arg0.LTid = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
			end)
		end
	end

	local var8 = {}
	local var9 = arg0.contextData.stopReason

	if not var9 then
		if arg0.contextData.isAutoFight then
			table.insert(var8, i18n("multiple_sorties_finish"))
		else
			table.insert(var8, i18n("multiple_sorties_stop"))
		end
	else
		table.insert(var8, var9 .. i18n("multiple_sorties_stop_tip_end"))
	end

	table.insert(var8, i18n("multiple_sorties_end_status", arg0.contextData.totalBattleTimes, arg0.contextData.totalBattleTimes - arg0.contextData.continuousBattleTimes))

	if #var8 > 0 then
		setText(arg0.boxView:Find("Content/TextArea2/Text"), table.concat(var8, "\n"))
	end

	seriesAsync(var2, function()
		arg0:SkipAnim()
	end)
end

function var0.SkipAnim(arg0)
	if not arg0.isRewardAnimating then
		return
	end

	arg0.isRewardAnimating = nil

	if arg0.LTid then
		LeanTween.cancel(arg0.LTid)

		arg0.LTid = nil
	end

	eachChild(arg0.itemList, function(arg0)
		setActive(arg0, true)
	end)
end

function var0.onBackPressed(arg0)
	existCall(arg0.contextData.onClose)
	arg0:closeView()
end

return var0
