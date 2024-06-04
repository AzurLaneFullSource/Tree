local var0 = class("WorldAutoFightRewardLayer", BaseUI)

function var0.getUIName(arg0)
	return "WorldAutoFightRewardUI"
end

local var1 = 0.1

function var0.init(arg0)
	arg0.window = arg0._tf:Find("Window")
	arg0.boxView = arg0.window:Find("Layout/Box/ScrollView")
	arg0.emptyTip = arg0.window:Find("Layout/Box/EmptyTip")
	arg0.itemList = arg0.boxView:Find("Content/ItemGrid")

	local var0 = Instantiate(arg0.itemList:GetComponent(typeof(ItemList)).prefabItem[0])

	var0.name = "Icon"

	setParent(var0, arg0.itemList:Find("GridItem/Shell"))
	setText(arg0.emptyTip, i18n("autofight_rewards_none"))
	setText(arg0.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(arg0.boxView:Find("Content/Title/Text"), i18n("battle_end_subtitle1"))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:UpdateView()

	local var0 = getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd()

	if var0 and #var0 > 0 then
		arg0.metaExpView = MetaExpView.New(arg0.window:Find("Layout"), arg0.event, arg0.contextData)

		local var1 = arg0.metaExpView

		var1:Reset()
		var1:Load()
		var1:setData(var0)
		var1:ActionInvoke("Show")
	end
end

function var0.willExit(arg0)
	arg0:SkipAnim()

	if arg0.metaExpView then
		arg0.metaExpView:Destroy()
	end

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
	setText(arg0.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(arg0, arg0.window:Find("Fixed/ButtonExit"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end, SFX_CANCEL)

	local var1 = nowWorld()
	local var2 = var1.autoInfos

	var1:InitAutoInfos()
	DropResultIntegration(var2.drops)

	local var3 = underscore.map(var2.drops, function(arg0)
		if arg0.type == DROP_TYPE_WORLD_COLLECTION then
			assert(WorldCollectionProxy.GetCollectionType(arg0.id) == WorldCollectionProxy.WorldCollectionType.FILE, string.format("collection drop type error#%d", arg0.id))
			table.insert(var2.message, i18n("autofight_file", WorldCollectionProxy.GetCollectionTemplate(arg0.id).name))
		else
			return {
				drop = arg0
			}
		end
	end)

	for iter0, iter1 in ipairs(var2.salvage) do
		DropResultIntegration(iter1)
		underscore.each(iter1, function(arg0)
			table.insert(var3, {
				drop = arg0,
				salvage = iter0
			})
		end)
	end

	local var4 = true
	local var5 = {}

	setActive(arg0.boxView:Find("Content/Title"), false)
	setActive(arg0.itemList, false)

	arg0.hasRewards = #var3 > 0

	if arg0.hasRewards then
		var4 = false

		table.insert(var5, function(arg0)
			setActive(arg0.boxView:Find("Content/Title"), true)
			setActive(arg0.itemList, true)
			arg0()
		end)

		local var6 = CustomIndexLayer.Clone2Full(arg0.itemList, #var3)

		for iter2, iter3 in ipairs(var3) do
			local var7 = iter3.drop
			local var8 = var6[iter2]

			updateDrop(var8:Find("Shell/Icon"), var7)
			onButton(arg0, var8:Find("Shell/Icon"), function()
				arg0:emit(BaseUI.ON_DROP, var7)
			end, SFX_PANEL)
			setActive(var8:Find("salvage"), iter3.salvage)

			if iter3.salvage then
				eachChild(var8:Find("salvage"), function(arg0)
					setActive(arg0, arg0.name == tostring(iter3.salvage))
				end)
			end
		end

		arg0.isRewardAnimating = true

		local var9 = {}

		for iter4 = 1, #var3 do
			local var10 = var6[iter4]

			setActive(var10, false)
			table.insert(var5, function(arg0)
				if arg0.exited then
					return
				end

				setActive(var10, true)
				scrollTo(arg0.boxView:Find("Content"), {
					y = 0
				})

				arg0.LTid = LeanTween.delayedCall(var1, System.Action(arg0)).uniqueId
			end)
		end
	end

	setActive(arg0.boxView:Find("Content/TextArea"), false)

	local var11 = {}

	for iter5, iter6 in ipairs(var2.buffs) do
		if var11[iter6.id] then
			-- block empty
		else
			var11[iter6.id] = iter6.before
		end
	end

	local var12 = pg.gameset.world_mapbuff_list.description
	local var13 = underscore.map(var12, function(arg0)
		if not var11[arg0] then
			return 0
		else
			return var1:GetGlobalBuff(arg0):GetFloor() - var11[arg0]
		end
	end)

	if underscore.any(var13, function(arg0)
		return arg0 ~= 0
	end) then
		table.insert(var2.message, i18n("autofight_effect", unpack(var13)))
	end

	arg0.hasEventMsg = #var2.message > 0

	if arg0.hasEventMsg then
		var4 = false

		setText(arg0.boxView:Find("Content/TextArea/Text"), table.concat(var2.message, "\n"))
		table.insert(var5, function(arg0)
			setActive(arg0.boxView:Find("Content/TextArea"), true)
			arg0()
		end)
	end

	setActive(arg0.boxView, not var4)
	setActive(arg0.emptyTip, var4)
	seriesAsync(var5, function()
		arg0:SkipAnim()
	end)
end

function var0.CloneIconTpl(arg0, arg1)
	local var0 = arg0:GetComponent(typeof(ItemList))

	assert(var0, "Need a Itemlist Component for " .. (arg0 and arg0.name or "NIL"))

	local var1 = Instantiate(var0.prefabItem[0])

	if arg1 then
		var1.name = arg1
	end

	setParent(var1, arg0)

	return var1
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
	setActive(arg0.boxView:Find("Content/Title"), arg0.hasRewards)
	setActive(arg0.itemList, arg0.hasRewards)
	setActive(arg0.boxView:Find("Content/TextArea"), arg0.hasEventMsg)
end

return var0
