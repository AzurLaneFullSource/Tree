local var0_0 = class("LevelStageTotalRewardPanel", import("view.level.BaseTotalRewardPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageTotalRewardPanel"
end

local var1_0 = 0.15

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.itemList = arg0_2.boxView:Find("Content/ItemGrid")

	local var0_2 = Instantiate(arg0_2.itemList:GetComponent(typeof(ItemList)).prefabItem[0])

	var0_2.name = "Icon"

	setParent(var0_2, arg0_2.itemList:Find("GridItem/Shell"))

	arg0_2.itemListSub = arg0_2.boxView:Find("Content/ItemGridSub")

	cloneTplTo(var0_2, arg0_2.itemListSub:Find("GridItem/Shell"), var0_2.name)

	arg0_2.spList = arg0_2.window:Find("Fixed/SpList")

	arg0_2.CloneIconTpl(arg0_2.spList:Find("Item/Active/Item"), "Icon")
	setText(arg0_2.boxView:Find("Content/Title/Text"), i18n("battle_end_subtitle1"))
	setText(arg0_2.boxView:Find("Content/TitleSub/Text"), i18n("settle_rewards_text"))
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)

	local var0_3 = arg0_3.contextData.isAutoFight
	local var1_3 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if var0_3 and var1_3 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end

	local var2_3 = getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd()

	if var2_3 and #var2_3 > 0 then
		arg0_3.metaExpView = MetaExpView.New(arg0_3.window:Find("Layout"), arg0_3.event, arg0_3.contextData)

		local var3_3 = arg0_3.metaExpView

		var3_3:setData(var2_3)
		var3_3:Reset()
		var3_3:Load()
		var3_3:ActionInvoke("Show")
	end
end

function var0_0.willExit(arg0_4)
	arg0_4:SkipAnim()

	if arg0_4.metaExpView then
		arg0_4.metaExpView:Destroy()
	end

	var0_0.super.willExit(arg0_4)
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
		if arg0_5.contextData.spItemID and not (PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1) then
			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()

			local function var0_7()
				arg0_5.contextData.spItemID = nil

				arg0_5:UpdateSPItem()
			end

			arg0_5:HandleShowMsgBox({
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = var0_7,
				onNo = var0_7
			})

			return
		end

		local var1_7 = Chapter.GetSPOperationItemCacheKey(arg0_5.contextData.chapter.id)

		PlayerPrefs.SetInt(var1_7, arg0_5.contextData.spItemID or 0)

		local var2_7 = true

		arg0_5:emit(LevelMediator2.ON_RETRACKING, arg0_5.contextData.chapter, var2_7)
		arg0_5:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.window:Find("Fixed/ButtonExit"), function()
		existCall(var0_5.onClose)
		arg0_5:closeView()
	end, SFX_CANCEL)
	arg0_5:UpdateSPItem()

	local var1_5 = var0_5.rewards
	local var2_5 = var0_5.resultRewards
	local var3_5 = var0_5.events
	local var4_5 = var0_5.guildTasks
	local var5_5 = var0_5.guildAutoReceives
	local var6_5 = var1_5 and #var1_5 > 0
	local var7_5 = var2_5 and #var2_5 > 0
	local var8_5 = var3_5 and #var3_5 > 0
	local var9_5 = var4_5 and table.getCount(var4_5) > 0
	local var10_5 = var5_5 and table.getCount(var5_5) > 0
	local var11_5 = true
	local var12_5 = {}

	setActive(arg0_5.boxView:Find("Content/Title"), false)
	setActive(arg0_5.itemList, false)

	if var6_5 then
		var11_5 = false
		arg0_5.hasRewards = true

		table.insert(var12_5, function(arg0_10)
			setActive(arg0_5.boxView:Find("Content/Title"), true)
			setActive(arg0_5.itemList, true)
			arg0_10()
		end)

		local var13_5 = CustomIndexLayer.Clone2Full(arg0_5.itemList, #var1_5)

		for iter0_5, iter1_5 in ipairs(var13_5) do
			local var14_5 = var1_5[iter0_5]
			local var15_5 = var13_5[iter0_5]

			updateDrop(var15_5:Find("Shell/Icon"), var14_5)
			onButton(arg0_5, var15_5:Find("Shell/Icon"), function()
				arg0_5:emit(BaseUI.ON_DROP, var14_5)
			end, SFX_PANEL)
		end

		arg0_5.isRewardAnimating = true

		for iter2_5 = 1, #var1_5 do
			local var16_5 = var13_5[iter2_5]

			setActive(var16_5, false)
			table.insert(var12_5, function(arg0_12)
				if arg0_5.exited then
					return
				end

				setActive(var16_5, true)
				scrollTo(arg0_5.boxView:Find("Content"), {
					y = 0
				})

				arg0_5.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_12)).uniqueId
			end)
		end
	end

	setActive(arg0_5.boxView:Find("Content/TitleSub"), false)
	setActive(arg0_5.itemListSub, false)

	if var7_5 then
		var11_5 = false
		arg0_5.hasResultRewards = true

		table.insert(var12_5, function(arg0_13)
			setActive(arg0_5.boxView:Find("Content/TitleSub"), true)
			setActive(arg0_5.itemListSub, true)
			arg0_13()
		end)

		local var17_5 = CustomIndexLayer.Clone2Full(arg0_5.itemListSub, #var2_5)

		for iter3_5, iter4_5 in ipairs(var17_5) do
			local var18_5 = var2_5[iter3_5]
			local var19_5 = var17_5[iter3_5]

			updateDrop(var19_5:Find("Shell/Icon"), var18_5)
			onButton(arg0_5, var19_5:Find("Shell/Icon"), function()
				arg0_5:emit(BaseUI.ON_DROP, var18_5)
			end, SFX_PANEL)
		end

		arg0_5.isRewardAnimating = true

		local var20_5 = {}

		for iter5_5 = 1, #var2_5 do
			local var21_5 = var17_5[iter5_5]

			setActive(var21_5, false)
			table.insert(var12_5, function(arg0_15)
				if arg0_5.exited then
					return
				end

				setActive(var21_5, true)
				scrollTo(arg0_5.boxView:Find("Content"), {
					y = 0
				})

				arg0_5.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_15)).uniqueId
			end)
		end
	end

	setActive(arg0_5.boxView:Find("Content/TextArea"), false)

	local var22_5 = {}

	if var8_5 then
		for iter6_5, iter7_5 in ipairs(var3_5) do
			local var23_5 = pg.collection_template[iter7_5] and pg.collection_template[iter7_5].title or ""

			table.insert(var22_5, i18n("autofight_entrust", var23_5))
		end
	end

	if var9_5 then
		for iter8_5, iter9_5 in pairs(var4_5) do
			table.insert(var22_5, i18n("autofight_task", iter9_5))
		end
	end

	if var10_5 then
		for iter10_5, iter11_5 in pairs(var5_5) do
			table.insert(var22_5, i18n("guild_task_autoaccept_1", iter11_5))
		end
	end

	if #var22_5 > 0 then
		var11_5 = false
		arg0_5.hasEventMsg = true

		setText(arg0_5.boxView:Find("Content/TextArea/Text"), table.concat(var22_5, "\n"))
		table.insert(var12_5, function(arg0_16)
			setActive(arg0_5.boxView:Find("Content/TextArea"), true)
			arg0_16()
		end)
	end

	setActive(arg0_5.boxView, not var11_5)
	setActive(arg0_5.emptyTip, var11_5)
	seriesAsync(var12_5, function()
		arg0_5:SkipAnim()
	end)
end

function var0_0.UpdateSPItem(arg0_18)
	local var0_18 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var1_18 = arg0_18.contextData.chapter:getConfig("special_operation_list")

	var1_18 = var1_18 == "" and {} or var1_18

	local var2_18 = {}

	for iter0_18, iter1_18 in ipairs(pg.benefit_buff_template.all) do
		local var3_18 = pg.benefit_buff_template[iter1_18]

		if var3_18.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(var1_18, iter1_18) then
			table.insert(var2_18, var3_18)
		end
	end

	local var4_18 = 1

	setActive(arg0_18.spList, #var2_18 ~= 0 and arg0_18.contextData.chapter:GetRestDailyBonus() == 0)

	if #var2_18 == 0 then
		return
	end

	UIItemList.StaticAlign(arg0_18.spList, arg0_18.spList:GetChild(0), var4_18, function(arg0_19, arg1_19, arg2_19)
		if arg0_19 ~= UIItemList.EventUpdate then
			return
		end

		local var0_19 = var2_18[arg1_19 + 1]
		local var1_19 = tonumber(var0_19.benefit_condition)

		setText(arg2_19:Find("Active/Desc"), var0_19.desc)

		local var2_19 = _.detect(var0_18, function(arg0_20)
			return arg0_20.configId == var1_19
		end)
		local var3_19 = var2_19 and var2_19.count > 0

		setActive(arg2_19:Find("Active"), var3_19)
		setActive(arg2_19:Find("Block"), not var3_19)

		if not var3_19 then
			setText(arg2_19:Find("Block"):Find("Desc"), i18n("levelScene_select_noitem"))

			return
		end

		setActive(arg2_19:Find("Active/Item"), true)
		updateDrop(arg2_19:Find("Active/Item/Icon"), Drop.New({
			id = var1_19,
			type = DROP_TYPE_ITEM,
			count = var2_19 and var2_19.count or 0
		}))
		onButton(arg0_18, arg2_19, function()
			arg0_18.contextData.spItemID = not arg0_18.contextData.spItemID and var1_19 or nil

			if arg0_18.contextData.spItemID then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
			end

			arg0_18:UpdateSPItem()
		end, SFX_PANEL)
		onButton(arg0_18, arg2_19:Find("Active/Item/Icon"), function()
			arg0_18:emit(BaseUI.ON_ITEM, var1_19)
		end)
		setActive(arg2_19:Find("Active/Checkbox/Mark"), tobool(arg0_18.contextData.spItemID))
	end)
end

function var0_0.SkipAnim(arg0_23)
	if not arg0_23.isRewardAnimating then
		return
	end

	arg0_23.isRewardAnimating = nil

	if arg0_23.LTid then
		LeanTween.cancel(arg0_23.LTid)

		arg0_23.LTid = nil
	end

	eachChild(arg0_23.itemList, function(arg0_24)
		setActive(arg0_24, true)
	end)
	eachChild(arg0_23.itemListSub, function(arg0_25)
		setActive(arg0_25, true)
	end)
	setActive(arg0_23.boxView:Find("Content/Title"), arg0_23.hasRewards)
	setActive(arg0_23.itemList, arg0_23.hasRewards)
	setActive(arg0_23.boxView:Find("Content/TitleSub"), arg0_23.hasResultRewards)
	setActive(arg0_23.itemListSub, arg0_23.hasResultRewards)
	setActive(arg0_23.boxView:Find("Content/TextArea"), arg0_23.hasEventMsg)
end

return var0_0
