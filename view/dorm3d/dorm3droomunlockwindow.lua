local var0_0 = class("Dorm3dRoomUnlockWindow", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dRoomUnlockWindow"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg1_2 or arg0_2.contextData or {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local var3_2 = var1_2.roomId and ApartmentRoom.New({
		id = var1_2.roomId
	})

	if var1_2.groupId then
		var2_2("ui/shoptip_atlas")

		local var4_2 = var3_2 and Apartment.getGroupConfig(var1_2.groupId, var3_2:getConfig("invite_banner")) or {}

		for iter0_2, iter1_2 in ipairs(var4_2) do
			var2_2("dorm3dbanner/" .. iter1_2)
		end
	elseif var3_2 then
		var2_2("dorm3dbanner/" .. string.lower(var3_2:getConfig("assets_prefix")))
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_4)
	arg0_4.bubbleContent = arg0_4._tf:Find("Window/Bubbles/content")
	arg0_4.bubbleTpl = arg0_4._tf:Find("Window/Bubbles/tpl")
	arg0_4.bubbleList = UIItemList.New(arg0_4.bubbleContent, arg0_4.bubbleTpl)
	arg0_4.scrollSnap = BannerScrollRect4Dorm.New(arg0_4._tf:Find("Window/banner/mask/content"), arg0_4._tf:Find("Window/banner/dots"))

	setActive(arg0_4.bubbleTpl, false)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("Window/Confirm"), function()
		if arg0_5.contextData.groupId then
			arg0_5:emit(Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_ROOM_INVITE, arg0_5.contextData.roomId, arg0_5.contextData.groupId)
		else
			arg0_5:emit(Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_DORM_ROOM, arg0_5.contextData.roomId)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Window/Cancel"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("bg"), function()
		arg0_5:closeView()
	end)
	setActive(arg0_5._tf:Find("Window/Title/unlock"), not arg0_5.contextData.groupId)
	setActive(arg0_5._tf:Find("Window/Title/invite"), arg0_5.contextData.groupId)

	if arg0_5.contextData.groupId then
		local var0_5 = getProxy(ApartmentProxy):getRoom(arg0_5.contextData.roomId)
		local var1_5 = Apartment.getGroupConfig(arg0_5.contextData.groupId, var0_5:getConfig("invite_cost"))
		local var2_5 = CommonCommodity.New({
			id = var1_5
		}, Goods.TYPE_SHOPSTREET)
		local var3_5, var4_5, var5_5 = var2_5:GetPrice()
		local var6_5 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_5:GetResType(),
			count = var3_5
		})

		if var6_5.count == 0 then
			setText(arg0_5._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_free", "<icon name=" .. var2_5:GetResIcon() .. " w=1.1 h=1.1/>", var5_5, ShipGroup.getDefaultShipNameByGroupID(arg0_5.contextData.groupId), var0_5:getConfig("room")))
		elseif var4_5 > 0 then
			setText(arg0_5._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_discount", "<icon name=" .. var2_5:GetResIcon() .. " w=1.1 h=1.1/>", var6_5.count, var5_5, ShipGroup.getDefaultShipNameByGroupID(arg0_5.contextData.groupId), var0_5:getConfig("room")))
		else
			setText(arg0_5._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_original", "<icon name=" .. var2_5:GetResIcon() .. " w=1.1 h=1.1/>", var6_5.count, ShipGroup.getDefaultShipNameByGroupID(arg0_5.contextData.groupId), var0_5:getConfig("room")))
		end

		setText(arg0_5._tf:Find("Window/Download"), "")
		setActive(arg0_5._tf:Find("Window/Preview"), false)

		arg0_5.bannerConfig = Apartment.getGroupConfig(arg0_5.contextData.groupId, var0_5:getConfig("invite_banner"))
		arg0_5.markConfig = Apartment.getGroupConfig(arg0_5.contextData.groupId, var0_5:getConfig("invite_mark"))

		arg0_5:InitBanner()
		arg0_5:InitUIList()
	else
		local var7_5 = ApartmentRoom.New({
			id = arg0_5.contextData.roomId
		})

		setText(arg0_5._tf:Find("Window/Content"), i18n("dorm3d_beach_buy", table.concat(underscore.map(var7_5:getConfig("unlock_item"), function(arg0_9)
			local var0_9 = Drop.Create(arg0_9)

			return string.format("%s*%d", var0_9:getName(), var0_9.count)
		end)), var7_5:getConfig("room")))

		if var7_5:needDownload() then
			local var8_5, var9_5 = var7_5:getDownloadNeedSize()

			setText(arg0_5._tf:Find("Window/Download"), i18n("dorm3d_beach_download", var9_5))
		else
			setText(arg0_5._tf:Find("Window/Download"), "")
		end

		GetImageSpriteFromAtlasAsync("dorm3dbanner/" .. string.lower(var7_5:getConfig("assets_prefix")), "", arg0_5._tf:Find("Window/Preview/Image"))
	end

	setText(arg0_5._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_5._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf)
end

function var0_0.InitBanner(arg0_10)
	for iter0_10 = 1, #arg0_10.bannerConfig do
		local var0_10 = arg0_10.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_10.bannerConfig[iter0_10], var0_10)
	end

	arg0_10.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_11)
	arg0_11.bubbleList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventInit then
			local var0_12 = arg1_12 + 1
			local var1_12 = arg0_11.markConfig[var0_12]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_12, arg2_12:Find("icon/icon"), true)
			setText(arg2_12:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_12))
			setActive(arg2_12:Find("bubble"), false)
			onToggle(arg0_11, arg2_12, function(arg0_13)
				setActive(arg2_12:Find("icon/select"), arg0_13)
				setActive(arg2_12:Find("icon/unselect"), not arg0_13)
				setActive(arg2_12:Find("bubble"), arg0_13)
			end)
		end
	end)
	arg0_11.bubbleList:align(#arg0_11.markConfig)
end

function var0_0.willExit(arg0_14)
	arg0_14.scrollSnap:Dispose()

	arg0_14.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
end

return var0_0
