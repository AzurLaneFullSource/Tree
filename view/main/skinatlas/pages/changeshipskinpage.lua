local var0 = class("ChangeShipSkinPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "ChangeShipSkinPage"
end

function var0.OnLoaded(arg0)
	arg0.confirmBtn = arg0:findTF("window/exchange_btn")
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.shipCardTpl = arg0._tf:GetComponent("ItemList").prefabItem[0]
	arg0.shipContent = arg0:findTF("window/sliders/scroll_rect/content")
	arg0.flagShipToggle = arg0:findTF("window/flag_ship")

	setText(arg0:findTF("window/top/title_list/infomation/title"), i18n("chang_ship_skin_window_title"))
	setText(arg0:findTF("window/please"), i18n("choose_ship_to_wear_this_skin"))
	setText(arg0:findTF("window/exchange_btn/Image"), i18n("change"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:OnConfirm()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onToggle(arg0, arg0.flagShipToggle, function(arg0)
		arg0.flagShipMark = arg0
	end, SFX_PANEL)
end

function var0.OnConfirm(arg0)
	if not arg0.selectIds or #arg0.selectIds <= 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("new_skin_no_choose"),
			onYes = function()
				arg0:Hide()
			end
		})

		return
	end

	for iter0, iter1 in ipairs(arg0.selectIds) do
		pg.m02:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = iter1,
			skinId = arg0.skin.id
		})
	end

	local var0 = arg0.flagShipMark

	arg0:SetFlagShip(var0)

	if var0 then
		local var1 = arg0.selectIds[1]

		pg.m02:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			skinPage = true,
			characterId = var1
		})
	end

	arg0:Hide()
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.selectIds = {}
	arg0.skin = arg1
	arg0.ships = arg0:GetShips(arg1)

	local var0 = arg0:GetSetFlagShip()

	triggerToggle(arg0.flagShipToggle, var0)
	arg0:FlushShips()
end

function var0.GetSetFlagShip(arg0)
	return getProxy(SettingsProxy):GetSetFlagShipForSkinAtlas()
end

function var0.SetFlagShip(arg0, arg1)
	getProxy(SettingsProxy):SetFlagShipForSkinAtlas(arg1)
end

function var0.Sort(arg0, arg1, arg2)
	local var0 = arg1.skinId == arg0.skin.id and 0 or 1
	local var1 = arg2.skinId == arg0.skin.id and 0 or 1

	if var0 == var1 then
		if arg1.level == arg2.level then
			local var2 = arg1:getStar()
			local var3 = arg2:getStar()

			if var2 == var3 then
				local var4 = arg1.inFleet and 1 or 0
				local var5 = arg2.inFleet and 1 or 0

				if var4 == var5 then
					return arg1.createTime < arg2.createTime
				else
					return var5 < var4
				end
			else
				return var3 < var2
			end
		else
			return arg1.level > arg2.level
		end
	else
		return var1 < var0
	end
end

function var0.GetShips(arg0, arg1)
	local var0 = arg1:IsTransSkin()
	local var1 = arg1:IsProposeSkin()
	local var2 = getProxy(BayProxy):_findShipsByGroup(arg0.skin:getConfig("ship_group"), var0, var1)

	table.sort(var2, function(arg0, arg1)
		return arg0:Sort(arg0, arg1)
	end)

	return var2
end

function var0.FlushShips(arg0)
	local var0 = arg0.ships

	local function var1(arg0)
		for iter0, iter1 in pairs(arg0.selectIds) do
			if iter1 == arg0.shipVO.id then
				table.remove(arg0.selectIds, iter0)

				break
			end
		end
	end

	removeAllChildren(arg0.shipContent)

	for iter0, iter1 in ipairs(var0) do
		local var2 = Object.Instantiate(arg0.shipCardTpl, arg0.shipContent)
		local var3 = ShipDetailCard.New(var2.gameObject)

		var3:update(iter1, arg0.skin.id)

		local var4 = iter1.skinId == arg0.skin.id

		setActive(var3.maskStatusOb, var4)
		setText(var3.maskStatusOb:Find("Text"), "-  " .. i18n("index_CANTUSE") .. "  -")
		onToggle(arg0, var3.tr, function(arg0)
			if iter1.skinId == arg0.skin.id then
				return
			end

			var3:updateSelected(arg0)

			if arg0 then
				table.insert(arg0.selectIds, var3.shipVO.id)
			else
				var1(var3)
			end
		end, SFX_PANEL)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	arg0.selectIds = {}
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	arg0.shipCards = nil
	arg0.selectIds = nil
end

return var0
