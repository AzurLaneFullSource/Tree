local var0_0 = class("WorldChapterAutoRewardLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "WorldChapterAutoRewardUI"
end

local var1_0 = 0.1

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2._tf:Find("Window")
	arg0_2.boxView = arg0_2.window:Find("Layout/Box/ScrollView")

	setActive(arg0_2.boxView, true)

	arg0_2.emptyTip = arg0_2.window:Find("Layout/Box/EmptyTip")
	arg0_2.itemList = arg0_2.boxView:Find("Content/ItemGrid")

	setText(arg0_2.emptyTip, i18n("autofight_rewards_none"))
	setActive(arg0_2.emptyTip, false)
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(arg0_2.boxView:Find("Content/Title/Text"), i18n("battle_end_subtitle1"))

	arg0_2.buffTF = arg0_2.boxView:Find("Content/TextArea")
	arg0_2.eventTF = arg0_2.boxView:Find("Content/TextArea_1")
	arg0_2.proficiencyTF = arg0_2.boxView:Find("Content/TextArea_2")
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:UpdateView()

	local var0_3 = getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd()

	if var0_3 and #var0_3 > 0 then
		arg0_3.metaExpView = MetaExpView.New(arg0_3.window:Find("Layout"), arg0_3.event, arg0_3.contextData)

		local var1_3 = arg0_3.metaExpView

		var1_3:setData(var0_3)
		var1_3:Reset()
		var1_3:Load()
		var1_3:ActionInvoke("Show")
	end
end

function var0_0.willExit(arg0_4)
	arg0_4:SkipAnim()

	if arg0_4.metaExpView then
		arg0_4.metaExpView:Destroy()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
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
	setText(arg0_5.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(arg0_5, arg0_5.window:Find("Fixed/ButtonExit"), function()
		existCall(var0_5.onClose)
		arg0_5:closeView()
	end, SFX_CANCEL)

	local var1_5 = {}

	setActive(arg0_5.boxView:Find("Content/Title"), false)
	setActive(arg0_5.itemList, false)
	setActive(arg0_5.buffTF, false)
	setActive(arg0_5.eventTF, false)
	setActive(arg0_5.proficiencyTF, false)

	arg0_5.hasRewards = #var0_5.awards > 0

	if arg0_5.hasRewards then
		isEmpty = false

		table.insert(var1_5, function(arg0_8)
			setActive(arg0_5.boxView:Find("Content/Title"), true)
			setActive(arg0_5.itemList, true)
			arg0_8()
		end)

		local var2_5 = CustomIndexLayer.Clone2Full(arg0_5.itemList, #var0_5.awards)

		for iter0_5, iter1_5 in ipairs(var0_5.awards) do
			local var3_5 = var2_5[iter0_5]

			updateDrop(var3_5:Find("Shell/Icon"), iter1_5)
			onButton(arg0_5, var3_5:Find("Shell/Icon"), function()
				arg0_5:emit(BaseUI.ON_DROP, iter1_5)
			end, SFX_PANEL)
		end

		arg0_5.isRewardAnimating = true

		local var4_5 = {}

		for iter2_5 = 1, #var0_5.awards do
			local var5_5 = var2_5[iter2_5]

			setActive(var5_5, false)
			table.insert(var1_5, function(arg0_10)
				if arg0_5.exited then
					return
				end

				setActive(var5_5, true)
				scrollTo(arg0_5.boxView:Find("Content"), {
					y = 0
				})

				arg0_5.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_10)).uniqueId
			end)
		end
	end

	arg0_5.hasBuffMsg = false

	local var6_5 = nowWorld()
	local var7_5 = {}

	for iter3_5, iter4_5 in ipairs(var0_5.buffInfos) do
		if var7_5[iter4_5.id] then
			-- block empty
		else
			var7_5[iter4_5.id] = iter4_5.before
		end
	end

	local var8_5 = pg.gameset.world_mapbuff_list.description
	local var9_5 = underscore.map(var8_5, function(arg0_11)
		if not var7_5[arg0_11] then
			return 0
		else
			return var6_5:GetGlobalBuff(arg0_11):GetFloor() - var7_5[arg0_11]
		end
	end)

	if underscore.any(var9_5, function(arg0_12)
		return arg0_12 ~= 0
	end) then
		arg0_5.hasBuffMsg = true
		arg0_5.buffMsg = i18n("autofight_effect", unpack(var9_5))
	end

	if arg0_5.hasBuffMsg then
		setText(arg0_5.buffTF:Find("Text"), arg0_5.buffMsg)
		table.insert(var1_5, function(arg0_13)
			setActive(arg0_5.buffTF, true)
			arg0_13()
		end)
	end

	seriesAsync(var1_5, function()
		arg0_5:SkipAnim()
	end)
end

function var0_0.SkipAnim(arg0_15)
	if not arg0_15.isRewardAnimating then
		return
	end

	arg0_15.isRewardAnimating = nil

	if arg0_15.LTid then
		LeanTween.cancel(arg0_15.LTid)

		arg0_15.LTid = nil
	end

	eachChild(arg0_15.itemList, function(arg0_16)
		setActive(arg0_16, true)
	end)
	setActive(arg0_15.boxView:Find("Content/Title"), arg0_15.hasRewards)
	setActive(arg0_15.itemList, arg0_15.hasRewards)
	setActive(arg0_15.buffTF, arg0_15.hasBuffMsg)
	arg0_15:UpdateEvent()
	setActive(arg0_15.proficiencyTF, arg0_15.contextData.proficiency > 0)

	if arg0_15.contextData.proficiency > 0 then
		setText(arg0_15.proficiencyTF:Find("Text"), i18n("auto_battle_end_exp", arg0_15.contextData.proficiency))
	end
end

function var0_0.UpdateEvent(arg0_17)
	local var0_17 = getProxy(ChapterAutoProxy):GetNewEventIds()

	setActive(arg0_17.eventTF, #var0_17 > 0)

	if #var0_17 <= 0 then
		return
	end

	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var2_17 = pg.collection_template[iter1_17] and pg.collection_template[iter1_17].title or ""

		table.insert(var1_17, i18n("autofight_entrust", var2_17))
	end

	setText(arg0_17.eventTF:Find("Text"), table.concat(var1_17, "\n"))
end

return var0_0
