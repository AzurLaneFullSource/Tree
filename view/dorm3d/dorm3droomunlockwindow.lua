local var0_0 = class("Dorm3dRoomUnlockWindow", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dRoomUnlockWindow"
end

function var0_0.init(arg0_2)
	arg0_2.bubbleContent = arg0_2._tf:Find("Window/Bubbles/content")
	arg0_2.bubbleTpl = arg0_2._tf:Find("Window/Bubbles/tpl")
	arg0_2.bubbleList = UIItemList.New(arg0_2.bubbleContent, arg0_2.bubbleTpl)
	arg0_2.scrollSnap = BannerScrollRect4Dorm.New(arg0_2._tf:Find("Window/banner/mask/content"), arg0_2._tf:Find("Window/banner/dots"))

	setActive(arg0_2.bubbleTpl, false)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("Window/Confirm"), function()
		if arg0_3.contextData.groupId then
			arg0_3:emit(Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_ROOM_INVITE, arg0_3.contextData.roomId, arg0_3.contextData.groupId)
		else
			arg0_3:emit(Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_DORM_ROOM, arg0_3.contextData.roomId)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Window/Cancel"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:closeView()
	end)
	setActive(arg0_3._tf:Find("Window/Title/unlock"), not arg0_3.contextData.groupId)
	setActive(arg0_3._tf:Find("Window/Title/invite"), arg0_3.contextData.groupId)

	if arg0_3.contextData.groupId then
		local var0_3 = getProxy(ApartmentProxy):getRoom(arg0_3.contextData.roomId)
		local var1_3 = Apartment.getGroupConfig(arg0_3.contextData.groupId, var0_3:getConfig("invite_cost"))
		local var2_3 = CommonCommodity.New({
			id = var1_3
		}, Goods.TYPE_SHOPSTREET)
		local var3_3, var4_3, var5_3 = var2_3:GetPrice()
		local var6_3 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_3:GetResType(),
			count = var3_3
		})

		if var6_3.count == 0 then
			setText(arg0_3._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_free", "<icon name=" .. var2_3:GetResIcon() .. " w=1.1 h=1.1/>", var5_3, ShipGroup.getDefaultShipNameByGroupID(arg0_3.contextData.groupId), var0_3:getConfig("room")))
		elseif var4_3 > 0 then
			setText(arg0_3._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_discount", "<icon name=" .. var2_3:GetResIcon() .. " w=1.1 h=1.1/>", var6_3.count, var5_3, ShipGroup.getDefaultShipNameByGroupID(arg0_3.contextData.groupId), var0_3:getConfig("room")))
		else
			setText(arg0_3._tf:Find("Window/Content"), i18n("dorm3d_invite_confirm_original", "<icon name=" .. var2_3:GetResIcon() .. " w=1.1 h=1.1/>", var6_3.count, ShipGroup.getDefaultShipNameByGroupID(arg0_3.contextData.groupId), var0_3:getConfig("room")))
		end

		setText(arg0_3._tf:Find("Window/Download"), "")
		setActive(arg0_3._tf:Find("Window/Preview"), false)

		arg0_3.bannerConfig = Apartment.getGroupConfig(arg0_3.contextData.groupId, var0_3:getConfig("invite_banner"))
		arg0_3.markConfig = Apartment.getGroupConfig(arg0_3.contextData.groupId, var0_3:getConfig("invite_mark"))

		arg0_3:InitBanner()
		arg0_3:InitUIList()
	else
		local var7_3 = ApartmentRoom.New({
			id = arg0_3.contextData.roomId
		})

		setText(arg0_3._tf:Find("Window/Content"), i18n("dorm3d_beach_buy", table.concat(underscore.map(var7_3:getConfig("unlock_item"), function(arg0_7)
			local var0_7 = Drop.Create(arg0_7)

			return string.format("%s*%d", var0_7:getName(), var0_7.count)
		end)), "、"))

		if var7_3:needDownload() then
			local var8_3, var9_3 = var7_3:getDownloadNeedSize()

			setText(arg0_3._tf:Find("Window/Download"), i18n("dorm3d_beach_download", var9_3))
		else
			setText(arg0_3._tf:Find("Window/Download"), "")
		end

		GetImageSpriteFromAtlasAsync("dorm3dbanner/" .. string.lower(var7_3:getConfig("assets_prefix")), "", arg0_3._tf:Find("Window/Preview/Image"))
	end

	setText(arg0_3._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_3._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.InitBanner(arg0_8)
	for iter0_8 = 1, #arg0_8.bannerConfig do
		local var0_8 = arg0_8.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_8.bannerConfig[iter0_8], var0_8)
	end

	arg0_8.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_9)
	arg0_9.bubbleList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			local var0_10 = arg1_10 + 1
			local var1_10 = arg0_9.markConfig[var0_10]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_10, arg2_10:Find("icon/icon"), true)
			setText(arg2_10:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_10))
			setActive(arg2_10:Find("bubble"), false)
			onToggle(arg0_9, arg2_10, function(arg0_11)
				setActive(arg2_10:Find("icon/select"), arg0_11)
				setActive(arg2_10:Find("icon/unselect"), not arg0_11)
				setActive(arg2_10:Find("bubble"), arg0_11)
			end)
		end
	end)
	arg0_9.bubbleList:align(#arg0_9.markConfig)
end

function var0_0.willExit(arg0_12)
	arg0_12.scrollSnap:Dispose()

	arg0_12.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
