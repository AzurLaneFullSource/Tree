local var0_0 = class("IslandPostEventWindow", import(".IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandPostEventboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2._tf:Find("title/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2._tf:Find("title/desc"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2._tf:Find("title/icon_bg/icon"):GetComponent(typeof(Image))
	arg0_2.bigIcon = arg0_2._tf:Find("frame/ico"):GetComponent(typeof(Image))
	arg0_2.itemsList = UIItemList.New(arg0_2._tf:Find("frame/items"), arg0_2._tf:Find("frame/items/tpl"))
	arg0_2.additionList = UIItemList.New(arg0_2._tf:Find("frame/addition"), arg0_2._tf:Find("frame/addition/tpl"))
	arg0_2.closeBtn = arg0_2._tf:Find("frame/btns/close")
	arg0_2.openBtn = arg0_2._tf:Find("frame/btns/open")

	setText(arg0_2._tf:Find("title/event/Text"), i18n("island_post_event_label"))
	setText(arg0_2._tf:Find("frame/btns/close/Text"), i18n("island_post_event_close_label"))
	setText(arg0_2._tf:Find("frame/btns/open/Text"), i18n("island_post_event_open_label"))
	setText(arg0_2._tf:Find("frame/title/Text"), i18n("island_post_event_addition_label"))

	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		if not arg0_3.isSwitch then
			arg0_3:Switch()

			return
		end

		triggerButton(arg0_3.closeBtn)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.openBtn, function()
		local var0_6 = arg0_3.settings.onYes

		arg0_3:Hide()

		if var0_6 then
			var0_6()
		end
	end, SFX_PANEL)
end

function var0_0.Switch(arg0_7)
	if arg0_7.isAnimating then
		return
	end

	arg0_7.isAnimating = true

	arg0_7.animation:Play("switch")
end

function var0_0.OnShow(arg0_8)
	arg0_8.dftAniEvent:SetEndEvent(function()
		arg0_8.isSwitch = true
		arg0_8.isAnimating = false
	end)

	arg0_8.isSwitch = false
	arg0_8.isAnimating = false

	local var0_8 = arg0_8.settings.rest
	local var1_8 = var0_8:GetEventInfo()

	arg0_8.config = pg.island_manage_event[var1_8]

	arg0_8:UpdateTitle(var0_8)
	arg0_8:UpdateMainView(var0_8)

	if not arg0_8.settings.isNew then
		triggerButton(arg0_8._tf)
	end

	if arg0_8.settings.blur then
		arg0_8:BlurPanel()
	end

	if arg0_8.settings.isNew then
		getProxy(SettingsProxy):RecordIslandRestEvet()
	end
end

function var0_0.BlurPanel(arg0_10)
	arg0_10.view.viewComponent:BlurPanel(arg0_10.view._tf)
end

function var0_0.UnBlurPanel(arg0_11)
	arg0_11.view.viewComponent:UnOverlayPanel(arg0_11.view._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0_0.UpdateTitle(arg0_12, arg1_12)
	arg0_12.titleTxt.text = arg0_12.config.name
	arg0_12.descTxt.text = string.gsub(arg0_12.config.desc, "$1", arg1_12:getConfig("name"))

	local var0_12 = "icon" .. arg0_12.config.id
	local var1_12 = GetSpriteFromAtlas("ui/islandpostmsgboxui_atlas", var0_12)

	arg0_12.icon.sprite = var1_12
end

function var0_0.UpdateMainView(arg0_13, arg1_13)
	local var0_13 = arg0_13:WarpItemInfo(arg1_13)

	arg0_13.itemsList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]
			local var1_14 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var0_14.id
			})

			updateCustomDrop(arg2_14, var1_14)
		end
	end)
	arg0_13.itemsList:align(#var0_13)

	local var1_13 = arg0_13:WarpAdditionInfo()

	arg0_13.additionList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			setText(arg2_15:Find("Text"), var1_13[arg1_15 + 1][1])
			setText(arg2_15:Find("value"), "+" .. var1_13[arg1_15 + 1][2] .. "%")
		end
	end)
	arg0_13.additionList:align(#var1_13)

	local var2_13 = (arg1_13:getConfig("aera_group") or 1) .. arg0_13.config.id

	LoadSpriteAsync("island/islandrestevent/" .. var2_13, function(arg0_16)
		if IsNil(arg0_13.bigIcon) then
			return
		end

		arg0_13.bigIcon.sprite = arg0_16
	end)
end

function var0_0.WarpItemInfo(arg0_17, arg1_17)
	local var0_17 = {}
	local var1_17, var2_17 = arg1_17:GetEventInfo()
	local var3_17 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_17, iter1_17 in ipairs(arg1_17:getConfig("item_id")) do
		local var4_17 = var3_17:GetItemById(iter1_17[1]) or IslandItem.New({
			id = iter1_17[1]
		})

		if var4_17 and var2_17[var4_17.id] then
			table.insert(var0_17, var4_17)
		end
	end

	return var0_17
end

function var0_0.WarpAdditionInfo(arg0_18)
	local var0_18 = {}

	table.insert(var0_18, {
		i18n("island_addition_influence"),
		arg0_18.config.influence_bonus
	})
	table.insert(var0_18, {
		i18n("island_addition_sale"),
		arg0_18.config.event_effect[1][1]
	})

	return var0_18
end

function var0_0.OnHide(arg0_19)
	if arg0_19.settings.onHide then
		arg0_19.settings.onHide()

		arg0_19.settings.onHide = nil
	end

	if arg0_19.dftAniEvent then
		arg0_19.dftAniEvent:SetEndEvent(nil)
	end

	if arg0_19.settings.blur then
		arg0_19:UnBlurPanel()
	end
end

return var0_0
