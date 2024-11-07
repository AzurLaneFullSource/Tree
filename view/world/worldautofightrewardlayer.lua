local var0_0 = class("WorldAutoFightRewardLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "WorldAutoFightRewardUI"
end

local var1_0 = 0.1

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2._tf:Find("Window")
	arg0_2.boxView = arg0_2.window:Find("Layout/Box/ScrollView")
	arg0_2.emptyTip = arg0_2.window:Find("Layout/Box/EmptyTip")
	arg0_2.itemList = arg0_2.boxView:Find("Content/ItemGrid")

	local var0_2 = Instantiate(arg0_2.itemList:GetComponent(typeof(ItemList)).prefabItem[0])

	var0_2.name = "Icon"

	setParent(var0_2, arg0_2.itemList:Find("GridItem/Shell"))
	setText(arg0_2.emptyTip, i18n("autofight_rewards_none"))
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(arg0_2.boxView:Find("Content/Title/Text"), i18n("battle_end_subtitle1"))
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
	setText(arg0_5.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(arg0_5, arg0_5.window:Find("Fixed/ButtonExit"), function()
		existCall(var0_5.onClose)
		arg0_5:closeView()
	end, SFX_CANCEL)

	local var1_5 = nowWorld()
	local var2_5 = var1_5.autoInfos

	var1_5:InitAutoInfos()
	DropResultIntegration(var2_5.drops)

	local var3_5 = underscore.map(var2_5.drops, function(arg0_8)
		if arg0_8.type == DROP_TYPE_WORLD_COLLECTION then
			assert(WorldCollectionProxy.GetCollectionType(arg0_8.id) == WorldCollectionProxy.WorldCollectionType.FILE, string.format("collection drop type error#%d", arg0_8.id))
			table.insert(var2_5.message, i18n("autofight_file", WorldCollectionProxy.GetCollectionTemplate(arg0_8.id).name))
		else
			return {
				drop = arg0_8
			}
		end
	end)

	for iter0_5, iter1_5 in ipairs(var2_5.salvage) do
		DropResultIntegration(iter1_5)
		underscore.each(iter1_5, function(arg0_9)
			table.insert(var3_5, {
				drop = arg0_9,
				salvage = iter0_5
			})
		end)
	end

	local var4_5 = true
	local var5_5 = {}

	setActive(arg0_5.boxView:Find("Content/Title"), false)
	setActive(arg0_5.itemList, false)

	arg0_5.hasRewards = #var3_5 > 0

	if arg0_5.hasRewards then
		var4_5 = false

		table.insert(var5_5, function(arg0_10)
			setActive(arg0_5.boxView:Find("Content/Title"), true)
			setActive(arg0_5.itemList, true)
			arg0_10()
		end)

		local var6_5 = CustomIndexLayer.Clone2Full(arg0_5.itemList, #var3_5)

		for iter2_5, iter3_5 in ipairs(var3_5) do
			local var7_5 = iter3_5.drop
			local var8_5 = var6_5[iter2_5]

			updateDrop(var8_5:Find("Shell/Icon"), var7_5)
			onButton(arg0_5, var8_5:Find("Shell/Icon"), function()
				arg0_5:emit(BaseUI.ON_DROP, var7_5)
			end, SFX_PANEL)
			setActive(var8_5:Find("salvage"), iter3_5.salvage)

			if iter3_5.salvage then
				eachChild(var8_5:Find("salvage"), function(arg0_12)
					setActive(arg0_12, arg0_12.name == tostring(iter3_5.salvage))
				end)
			end
		end

		arg0_5.isRewardAnimating = true

		local var9_5 = {}

		for iter4_5 = 1, #var3_5 do
			local var10_5 = var6_5[iter4_5]

			setActive(var10_5, false)
			table.insert(var5_5, function(arg0_13)
				if arg0_5.exited then
					return
				end

				setActive(var10_5, true)
				scrollTo(arg0_5.boxView:Find("Content"), {
					y = 0
				})

				arg0_5.LTid = LeanTween.delayedCall(var1_0, System.Action(arg0_13)).uniqueId
			end)
		end
	end

	setActive(arg0_5.boxView:Find("Content/TextArea"), false)

	local var11_5 = {}

	for iter5_5, iter6_5 in ipairs(var2_5.buffs) do
		if var11_5[iter6_5.id] then
			-- block empty
		else
			var11_5[iter6_5.id] = iter6_5.before
		end
	end

	local var12_5 = pg.gameset.world_mapbuff_list.description
	local var13_5 = underscore.map(var12_5, function(arg0_14)
		if not var11_5[arg0_14] then
			return 0
		else
			return var1_5:GetGlobalBuff(arg0_14):GetFloor() - var11_5[arg0_14]
		end
	end)

	if underscore.any(var13_5, function(arg0_15)
		return arg0_15 ~= 0
	end) then
		table.insert(var2_5.message, i18n("autofight_effect", unpack(var13_5)))
	end

	arg0_5.hasEventMsg = #var2_5.message > 0

	if arg0_5.hasEventMsg then
		var4_5 = false

		setText(arg0_5.boxView:Find("Content/TextArea/Text"), table.concat(var2_5.message, "\n"))
		table.insert(var5_5, function(arg0_16)
			setActive(arg0_5.boxView:Find("Content/TextArea"), true)
			arg0_16()
		end)
	end

	setActive(arg0_5.boxView, not var4_5)
	setActive(arg0_5.emptyTip, var4_5)
	seriesAsync(var5_5, function()
		arg0_5:SkipAnim()
	end)
end

function var0_0.CloneIconTpl(arg0_18, arg1_18)
	local var0_18 = arg0_18:GetComponent(typeof(ItemList))

	assert(var0_18, "Need a Itemlist Component for " .. (arg0_18 and arg0_18.name or "NIL"))

	local var1_18 = Instantiate(var0_18.prefabItem[0])

	if arg1_18 then
		var1_18.name = arg1_18
	end

	setParent(var1_18, arg0_18)

	return var1_18
end

function var0_0.SkipAnim(arg0_19)
	if not arg0_19.isRewardAnimating then
		return
	end

	arg0_19.isRewardAnimating = nil

	if arg0_19.LTid then
		LeanTween.cancel(arg0_19.LTid)

		arg0_19.LTid = nil
	end

	eachChild(arg0_19.itemList, function(arg0_20)
		setActive(arg0_20, true)
	end)
	setActive(arg0_19.boxView:Find("Content/Title"), arg0_19.hasRewards)
	setActive(arg0_19.itemList, arg0_19.hasRewards)
	setActive(arg0_19.boxView:Find("Content/TextArea"), arg0_19.hasEventMsg)
end

return var0_0
