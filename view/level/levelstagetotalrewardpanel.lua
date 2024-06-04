local var0 = class("LevelStageTotalRewardPanel", import("view.level.BaseTotalRewardPanel"))

function var0.getUIName(arg0)
	return "LevelStageTotalRewardPanel"
end

local var1 = 0.15

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.itemList = arg0.boxView:Find("Content/ItemGrid")

	local var0 = Instantiate(arg0.itemList:GetComponent(typeof(ItemList)).prefabItem[0])

	var0.name = "Icon"

	setParent(var0, arg0.itemList:Find("GridItem/Shell"))

	arg0.itemListSub = arg0.boxView:Find("Content/ItemGridSub")

	cloneTplTo(var0, arg0.itemListSub:Find("GridItem/Shell"), var0.name)

	arg0.spList = arg0.window:Find("Fixed/SpList")

	arg0.CloneIconTpl(arg0.spList:Find("Item/Active/Item"), "Icon")
	setText(arg0.boxView:Find("Content/Title/Text"), i18n("battle_end_subtitle1"))
	setText(arg0.boxView:Find("Content/TitleSub/Text"), i18n("settle_rewards_text"))
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)

	local var0 = arg0.contextData.isAutoFight
	local var1 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if var0 and var1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end

	local var2 = getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd()

	if var2 and #var2 > 0 then
		arg0.metaExpView = MetaExpView.New(arg0.window:Find("Layout"), arg0.event, arg0.contextData)

		local var3 = arg0.metaExpView

		var3:Reset()
		var3:Load()
		var3:setData(var2)
		var3:ActionInvoke("Show")
	end
end

function var0.willExit(arg0)
	arg0:SkipAnim()

	if arg0.metaExpView then
		arg0.metaExpView:Destroy()
	end

	var0.super.willExit(arg0)
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

		local var2 = true

		arg0:emit(LevelMediator2.ON_RETRACKING, arg0.contextData.chapter, var2)
		arg0:closeView()
	end, SFX_CONFIRM)
	onButton(arg0, arg0.window:Find("Fixed/ButtonExit"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end, SFX_CANCEL)
	arg0:UpdateSPItem()

	local var1 = var0.rewards
	local var2 = var0.resultRewards
	local var3 = var0.events
	local var4 = var0.guildTasks
	local var5 = var0.guildAutoReceives
	local var6 = var1 and #var1 > 0
	local var7 = var2 and #var2 > 0
	local var8 = var3 and #var3 > 0
	local var9 = var4 and table.getCount(var4) > 0
	local var10 = var5 and table.getCount(var5) > 0
	local var11 = true
	local var12 = {}

	setActive(arg0.boxView:Find("Content/Title"), false)
	setActive(arg0.itemList, false)

	if var6 then
		var11 = false
		arg0.hasRewards = true

		table.insert(var12, function(arg0)
			setActive(arg0.boxView:Find("Content/Title"), true)
			setActive(arg0.itemList, true)
			arg0()
		end)

		local var13 = CustomIndexLayer.Clone2Full(arg0.itemList, #var1)

		for iter0, iter1 in ipairs(var13) do
			local var14 = var1[iter0]
			local var15 = var13[iter0]

			updateDrop(var15:Find("Shell/Icon"), var14)
			onButton(arg0, var15:Find("Shell/Icon"), function()
				arg0:emit(BaseUI.ON_DROP, var14)
			end, SFX_PANEL)
		end

		arg0.isRewardAnimating = true

		for iter2 = 1, #var1 do
			local var16 = var13[iter2]

			setActive(var16, false)
			table.insert(var12, function(arg0)
				if arg0.exited then
					return
				end

				setActive(var16, true)
				scrollTo(arg0.boxView:Find("Content"), {
					y = 0
				})

				arg0.LTid = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
			end)
		end
	end

	setActive(arg0.boxView:Find("Content/TitleSub"), false)
	setActive(arg0.itemListSub, false)

	if var7 then
		var11 = false
		arg0.hasResultRewards = true

		table.insert(var12, function(arg0)
			setActive(arg0.boxView:Find("Content/TitleSub"), true)
			setActive(arg0.itemListSub, true)
			arg0()
		end)

		local var17 = CustomIndexLayer.Clone2Full(arg0.itemListSub, #var2)

		for iter3, iter4 in ipairs(var17) do
			local var18 = var2[iter3]
			local var19 = var17[iter3]

			updateDrop(var19:Find("Shell/Icon"), var18)
			onButton(arg0, var19:Find("Shell/Icon"), function()
				arg0:emit(BaseUI.ON_DROP, var18)
			end, SFX_PANEL)
		end

		arg0.isRewardAnimating = true

		local var20 = {}

		for iter5 = 1, #var2 do
			local var21 = var17[iter5]

			setActive(var21, false)
			table.insert(var12, function(arg0)
				if arg0.exited then
					return
				end

				setActive(var21, true)
				scrollTo(arg0.boxView:Find("Content"), {
					y = 0
				})

				arg0.LTid = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
			end)
		end
	end

	setActive(arg0.boxView:Find("Content/TextArea"), false)

	local var22 = {}

	if var8 then
		for iter6, iter7 in ipairs(var3) do
			local var23 = pg.collection_template[iter7] and pg.collection_template[iter7].title or ""

			table.insert(var22, i18n("autofight_entrust", var23))
		end
	end

	if var9 then
		for iter8, iter9 in pairs(var4) do
			table.insert(var22, i18n("autofight_task", iter9))
		end
	end

	if var10 then
		for iter10, iter11 in pairs(var5) do
			table.insert(var22, i18n("guild_task_autoaccept_1", iter11))
		end
	end

	if #var22 > 0 then
		var11 = false
		arg0.hasEventMsg = true

		setText(arg0.boxView:Find("Content/TextArea/Text"), table.concat(var22, "\n"))
		table.insert(var12, function(arg0)
			setActive(arg0.boxView:Find("Content/TextArea"), true)
			arg0()
		end)
	end

	setActive(arg0.boxView, not var11)
	setActive(arg0.emptyTip, var11)
	seriesAsync(var12, function()
		arg0:SkipAnim()
	end)
end

function var0.UpdateSPItem(arg0)
	local var0 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)
	local var1 = arg0.contextData.chapter:getConfig("special_operation_list")

	var1 = var1 == "" and {} or var1

	local var2 = {}

	for iter0, iter1 in ipairs(pg.benefit_buff_template.all) do
		local var3 = pg.benefit_buff_template[iter1]

		if var3.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(var1, iter1) then
			table.insert(var2, var3)
		end
	end

	local var4 = 1

	setActive(arg0.spList, #var2 ~= 0 and arg0.contextData.chapter:GetRestDailyBonus() == 0)

	if #var2 == 0 then
		return
	end

	UIItemList.StaticAlign(arg0.spList, arg0.spList:GetChild(0), var4, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var2[arg1 + 1]
		local var1 = tonumber(var0.benefit_condition)

		setText(arg2:Find("Active/Desc"), var0.desc)

		local var2 = _.detect(var0, function(arg0)
			return arg0.configId == var1
		end)
		local var3 = var2 and var2.count > 0

		setActive(arg2:Find("Active"), var3)
		setActive(arg2:Find("Block"), not var3)

		if not var3 then
			setText(arg2:Find("Block"):Find("Desc"), i18n("levelScene_select_noitem"))

			return
		end

		setActive(arg2:Find("Active/Item"), true)
		updateDrop(arg2:Find("Active/Item/Icon"), Drop.New({
			id = var1,
			type = DROP_TYPE_ITEM,
			count = var2 and var2.count or 0
		}))
		onButton(arg0, arg2, function()
			arg0.contextData.spItemID = not arg0.contextData.spItemID and var1 or nil

			if arg0.contextData.spItemID then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
			end

			arg0:UpdateSPItem()
		end, SFX_PANEL)
		onButton(arg0, arg2:Find("Active/Item/Icon"), function()
			arg0:emit(BaseUI.ON_ITEM, var1)
		end)
		setActive(arg2:Find("Active/Checkbox/Mark"), tobool(arg0.contextData.spItemID))
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
	eachChild(arg0.itemListSub, function(arg0)
		setActive(arg0, true)
	end)
	setActive(arg0.boxView:Find("Content/Title"), arg0.hasRewards)
	setActive(arg0.itemList, arg0.hasRewards)
	setActive(arg0.boxView:Find("Content/TitleSub"), arg0.hasResultRewards)
	setActive(arg0.itemListSub, arg0.hasResultRewards)
	setActive(arg0.boxView:Find("Content/TextArea"), arg0.hasEventMsg)
end

return var0
