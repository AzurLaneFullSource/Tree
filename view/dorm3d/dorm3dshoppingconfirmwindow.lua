local var0_0 = class("Dorm3dShoppingConfirmWindow", import("view.base.BaseUI"))

var0_0.SELECTED_WIDTH = 52
var0_0.UNSELECTED_WIDTH = 12
var0_0.LOOP_DURATION = 5

function var0_0.getUIName(arg0_1)
	return "Dorm3dShopWindow"
end

function var0_0.init(arg0_2)
	arg0_2.previewTf = arg0_2._tf:Find("Window/Preview")
	arg0_2.bubbleContent = arg0_2._tf:Find("Window/Bubbles/content")
	arg0_2.bubbleTpl = arg0_2._tf:Find("Window/Bubbles/tpl")
	arg0_2.bubbleList = UIItemList.New(arg0_2.bubbleContent, arg0_2.bubbleTpl)
	arg0_2.scrollSnap = BannerScrollRect4Dorm.New(arg0_2._tf:Find("Window/banner/mask/content"), arg0_2._tf:Find("Window/banner/dots"))

	setActive(arg0_2.bubbleTpl, false)
	switch(arg0_2.contextData.drop.__cname, {
		Dorm3dGift = function()
			arg0_2.unlockTips = pg.dorm3d_gift[arg0_2.contextData.drop.configId].unlock_tips or {}
			arg0_2.unlockBanners = pg.dorm3d_gift[arg0_2.contextData.drop.configId].unlock_banners or {}
			arg0_2.isSP = pg.dorm3d_gift[arg0_2.contextData.drop.configId].ship_group_id ~= 0
			arg0_2.addFavor = pg.dorm3d_favor_trigger[pg.dorm3d_gift[arg0_2.contextData.drop.configId].favor_trigger_id].num

			setActive(arg0_2._tf:Find("Window/Title/gift"), true)
		end,
		Dorm3dFurniture = function()
			arg0_2.unlockTips = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].unlock_tips or {}
			arg0_2.unlockBanners = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].unlock_banners or {}
			arg0_2.isSP = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].is_exclusive == 1

			setActive(arg0_2._tf:Find("Window/Title/furniture"), true)
		end
	})
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("Window/Confirm"), function()
		local var0_6 = arg0_5.contextData.onYes

		arg0_5:closeView()
		existCall(var0_6)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Window/Cancel"), function()
		local var0_7 = arg0_5.contextData.onNo

		arg0_5:closeView()
		existCall(var0_7)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("Mask"), function()
		local var0_8 = arg0_5.contextData.onClose

		arg0_5:closeView()
		existCall(var0_8)
	end)
	arg0_5:InitUIList()
	arg0_5:InitDropIcon()
	arg0_5:InitBanner()

	local var0_5

	if arg0_5.contextData.content.cost == 0 then
		var0_5 = i18n("dorm3d_purchase_confirm_free", arg0_5.contextData.content.icon, arg0_5.contextData.content.cost, arg0_5.contextData.content.name)
	elseif arg0_5.contextData.content.off > 0 then
		var0_5 = i18n("dorm3d_purchase_confirm_discount", arg0_5.contextData.content.icon, arg0_5.contextData.content.cost, arg0_5.contextData.content.old, arg0_5.contextData.content.name)
	else
		var0_5 = i18n("dorm3d_purchase_confirm_original", arg0_5.contextData.content.icon, arg0_5.contextData.content.cost, arg0_5.contextData.content.name)
	end

	setText(arg0_5._tf:Find("Window/Content"), var0_5)
	setText(arg0_5._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_5._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.InitBanner(arg0_9)
	for iter0_9 = 1, #arg0_9.unlockBanners do
		local var0_9 = arg0_9.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_9.unlockBanners[iter0_9], var0_9)
	end

	arg0_9.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_10)
	arg0_10.bubbleList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			local var0_11 = arg1_11 + 1
			local var1_11 = arg0_10.unlockTips[var0_11]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_11, arg2_11:Find("icon/icon"), true)
			setText(arg2_11:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_11))
			setActive(arg2_11:Find("bubble"), false)
			onToggle(arg0_10, arg2_11, function(arg0_12)
				setActive(arg2_11:Find("icon/select"), arg0_12)
				setActive(arg2_11:Find("icon/unselect"), not arg0_12)
				setActive(arg2_11:Find("bubble"), arg0_12)
			end)
		end
	end)
	arg0_10.bubbleList:align(#arg0_10.unlockTips)
end

function var0_0.InitDropIcon(arg0_13)
	LoadImageSpriteAtlasAsync(arg0_13.contextData.drop:GetIcon(), "", arg0_13._tf:Find("Window/Item/Dorm3dIconTpl/icon"), true)
	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(arg0_13.contextData.drop:GetRarity()), arg0_13._tf:Find("Window/Item/Dorm3dIconTpl"))
	setActive(arg0_13._tf:Find("Window/Item/sp"), arg0_13.isSP)
	setText(arg0_13._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_confirm_tip"))

	if arg0_13.addFavor then
		setActive(arg0_13._tf:Find("Window/Item/gift"), true)
		setText(arg0_13._tf:Find("Window/Item/gift/Text"), "+" .. arg0_13.addFavor)
	end
end

function var0_0.willExit(arg0_14)
	arg0_14.scrollSnap:Dispose()

	arg0_14.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
end

return var0_0
