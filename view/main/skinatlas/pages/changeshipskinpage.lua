local var0_0 = class("ChangeShipSkinPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ChangeShipSkinPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2:findTF("window/exchange_btn")
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.shipCardTpl = arg0_2._tf:GetComponent("ItemList").prefabItem[0]
	arg0_2.shipContent = arg0_2:findTF("window/sliders/scroll_rect/content")
	arg0_2.flagShipToggle = arg0_2:findTF("window/flag_ship")

	setText(arg0_2:findTF("window/top/title_list/infomation/title"), i18n("chang_ship_skin_window_title"))
	setText(arg0_2:findTF("window/please"), i18n("choose_ship_to_wear_this_skin"))
	setText(arg0_2:findTF("window/exchange_btn/Image"), i18n("change"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:OnConfirm()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.flagShipToggle, function(arg0_7)
		arg0_3.flagShipMark = arg0_7
	end, SFX_PANEL)
end

function var0_0.OnConfirm(arg0_8)
	if not arg0_8.selectIds or #arg0_8.selectIds <= 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("new_skin_no_choose"),
			onYes = function()
				arg0_8:Hide()
			end
		})

		return
	end

	for iter0_8, iter1_8 in ipairs(arg0_8.selectIds) do
		pg.m02:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = iter1_8,
			skinId = arg0_8.skin.id
		})
	end

	local var0_8 = arg0_8.flagShipMark

	arg0_8:SetFlagShip(var0_8)

	if var0_8 then
		local var1_8 = arg0_8.selectIds[1]

		pg.m02:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			skinPage = true,
			characterId = var1_8
		})
	end

	arg0_8:Hide()
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)

	arg0_10.selectIds = {}
	arg0_10.skin = arg1_10
	arg0_10.ships = arg0_10:GetShips(arg1_10)

	local var0_10 = arg0_10:GetSetFlagShip()

	triggerToggle(arg0_10.flagShipToggle, var0_10)
	arg0_10:FlushShips()
end

function var0_0.GetSetFlagShip(arg0_11)
	return getProxy(SettingsProxy):GetSetFlagShipForSkinAtlas()
end

function var0_0.SetFlagShip(arg0_12, arg1_12)
	getProxy(SettingsProxy):SetFlagShipForSkinAtlas(arg1_12)
end

function var0_0.Sort(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13.skinId == arg0_13.skin.id and 0 or 1
	local var1_13 = arg2_13.skinId == arg0_13.skin.id and 0 or 1

	if var0_13 == var1_13 then
		if arg1_13.level == arg2_13.level then
			local var2_13 = arg1_13:getStar()
			local var3_13 = arg2_13:getStar()

			if var2_13 == var3_13 then
				local var4_13 = arg1_13.inFleet and 1 or 0
				local var5_13 = arg2_13.inFleet and 1 or 0

				if var4_13 == var5_13 then
					return arg1_13.createTime < arg2_13.createTime
				else
					return var5_13 < var4_13
				end
			else
				return var3_13 < var2_13
			end
		else
			return arg1_13.level > arg2_13.level
		end
	else
		return var1_13 < var0_13
	end
end

function var0_0.GetShips(arg0_14, arg1_14)
	local var0_14 = arg1_14:IsTransSkin()
	local var1_14 = arg1_14:IsProposeSkin()
	local var2_14 = getProxy(BayProxy):_findShipsByGroup(arg0_14.skin:getConfig("ship_group"), var0_14, var1_14)

	table.sort(var2_14, function(arg0_15, arg1_15)
		return arg0_14:Sort(arg0_15, arg1_15)
	end)

	return var2_14
end

function var0_0.FlushShips(arg0_16)
	local var0_16 = arg0_16.ships

	local function var1_16(arg0_17)
		for iter0_17, iter1_17 in pairs(arg0_16.selectIds) do
			if iter1_17 == arg0_17.shipVO.id then
				table.remove(arg0_16.selectIds, iter0_17)

				break
			end
		end
	end

	removeAllChildren(arg0_16.shipContent)

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var2_16 = Object.Instantiate(arg0_16.shipCardTpl, arg0_16.shipContent)
		local var3_16 = ShipDetailCard.New(var2_16.gameObject)

		var3_16:update(iter1_16, arg0_16.skin.id)

		local var4_16 = iter1_16.skinId == arg0_16.skin.id

		setActive(var3_16.maskStatusOb, var4_16)
		setText(var3_16.maskStatusOb:Find("Text"), "-  " .. i18n("index_CANTUSE") .. "  -")
		onToggle(arg0_16, var3_16.tr, function(arg0_18)
			if iter1_16.skinId == arg0_16.skin.id then
				return
			end

			var3_16:updateSelected(arg0_18)

			if arg0_18 then
				table.insert(arg0_16.selectIds, var3_16.shipVO.id)
			else
				var1_16(var3_16)
			end
		end, SFX_PANEL)
	end
end

function var0_0.Hide(arg0_19)
	var0_0.super.Hide(arg0_19)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf, arg0_19._parentTf)

	arg0_19.selectIds = {}
end

function var0_0.OnDestroy(arg0_20)
	if arg0_20:isShowing() then
		arg0_20:Hide()
	end

	arg0_20.shipCards = nil
	arg0_20.selectIds = nil
end

return var0_0
