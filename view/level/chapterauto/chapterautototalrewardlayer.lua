local var0_0 = class("ChapterAutoTotalRewardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChapterAutoTotalRewardPanel"
end

local var1_0 = 0.15

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2._tf:Find("Window")
	arg0_2.boxView = arg0_2.window:Find("Layout/Box/ScrollView")
	arg0_2.TextTF = arg0_2.boxView:Find("Content/TextArea2/Text")
	arg0_2.eventTF = arg0_2.boxView:Find("Content/TextArea")

	setActive(arg0_2.eventTF, false)

	arg0_2.emptyTip = arg0_2.window:Find("Layout/Box/EmptyTip")

	setText(arg0_2.emptyTip, i18n("autofight_rewards_none"))
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title/title_en"), i18n("total_rewards_subtitle"))
	setText(arg0_2.window:Find("Fixed/ButtonGO/pic"), i18n("text_confirm"))
	setText(arg0_2.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))

	arg0_2.itemList = arg0_2.boxView:Find("Content/ItemGrid2")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("BG"), function()
		if arg0_3.isRewardAnimating then
			arg0_3:SkipAnim()

			return
		end

		existCall(arg0_3.contextData.onClose)
		arg0_3:closeView()
	end)
	onButton(arg0_3, arg0_3.window:Find("Fixed/ButtonGO"), function()
		existCall(arg0_3.contextData.onClose)
		arg0_3:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.window:Find("Fixed/ButtonExit"), function()
		existCall(arg0_3.contextData.onClose)
		arg0_3:closeView()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, {
		lockGlobalBlur = true
	})
	getProxy(ChapterAutoProxy):SetSkipBatchBuildFlag(false)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_7)
	local var0_7 = {}
	local var1_7 = arg0_7.contextData.rewards
	local var2_7 = var1_7 and #var1_7 > 0
	local var3_7 = CustomIndexLayer.Clone2Full(arg0_7.itemList, #var1_7)

	for iter0_7, iter1_7 in ipairs(var3_7) do
		local var4_7 = var1_7[iter0_7]
		local var5_7 = var3_7[iter0_7]

		updateDrop(var5_7:Find("Icon"), var4_7)
		onButton(arg0_7, var5_7:Find("Icon"), function()
			arg0_7:emit(BaseUI.ON_DROP, var4_7)
		end, SFX_PANEL)
	end

	if var2_7 then
		arg0_7.isRewardAnimating = true

		for iter2_7 = 1, #var1_7 do
			local var6_7 = var3_7[iter2_7]

			setActive(var6_7, false)
			table.insert(var0_7, function(arg0_9)
				if not arg0_7:isLoaded() then
					return
				end

				setActive(var6_7, true)
				scrollTo(arg0_7.boxView:Find("Content"), {
					y = 0
				})

				arg0_7.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_9)).uniqueId
			end)
		end
	end

	local var7_7 = {}

	if arg0_7.contextData.isFinished then
		table.insert(var7_7, i18n("auto_battle_finish"))
	else
		table.insert(var7_7, i18n("auto_battle_stop"))
	end

	table.insert(var7_7, i18n("auto_battle_end_exp", arg0_7.contextData.proficiency))
	table.insert(var7_7, i18n("auto_battle_end_status", arg0_7.contextData.totalTimes, arg0_7.contextData.finishTimes))

	if #var7_7 > 0 then
		setText(arg0_7.TextTF, table.concat(var7_7, "\n"))
	end

	arg0_7:ShowShips(var1_7)
	seriesAsync(var0_7, function()
		arg0_7:SkipAnim()
		arg0_7:UpdateEvent()
	end)
end

function var0_0.ShowShips(arg0_11, arg1_11, arg2_11)
	local var0_11 = #_.filter(arg1_11, function(arg0_12)
		return arg0_12.type == DROP_TYPE_SHIP
	end)
	local var1_11 = getProxy(BayProxy):getNewShip(true)
	local var2_11 = {}

	for iter0_11 = math.max(1, #var1_11 - var0_11 + 1), #var1_11 do
		local var3_11 = iter0_11 == #var1_11
		local var4_11 = var1_11[iter0_11]

		if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var4_11.virgin or var4_11:getRarity() >= ShipRarity.Purple then
			table.insert(var2_11, function(arg0_13)
				if getProxy(ChapterAutoProxy):GetSkipBatchBuildFlag() then
					arg0_13()
				else
					arg0_11:emit(ChapterAutoTotalRewardMediator.GET_NEW_SHIP, var4_11, var3_11, arg0_13)
				end
			end)
		end
	end

	seriesAsync(var2_11, arg2_11)
end

function var0_0.SkipAnim(arg0_14)
	if not arg0_14.isRewardAnimating then
		return
	end

	arg0_14.isRewardAnimating = nil

	if arg0_14.LTid then
		LeanTween.cancel(arg0_14.LTid)

		arg0_14.LTid = nil
	end

	eachChild(arg0_14.itemList, function(arg0_15)
		setActive(arg0_15, true)
	end)
end

function var0_0.UpdateEvent(arg0_16)
	local var0_16 = getProxy(ChapterAutoProxy):GetNewEventIds()

	arg0_16.eventTF = arg0_16.boxView:Find("Content/TextArea")

	setActive(arg0_16.eventTF, #var0_16 > 0)

	if #var0_16 <= 0 then
		return
	end

	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var2_16 = pg.collection_template[iter1_16] and pg.collection_template[iter1_16].title or ""

		table.insert(var1_16, i18n("autofight_entrust", var2_16))
	end

	setText(arg0_16.eventTF:Find("Text"), table.concat(var1_16, "\n"))
end

function var0_0.onBackPressed(arg0_17)
	existCall(arg0_17.contextData.onClose)
	arg0_17:closeView()
end

function var0_0.willExit(arg0_18)
	getProxy(ChapterAutoProxy):ClearEventIds()

	arg0_18.contextData.onClose = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18._tf)
end

return var0_0
