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

			local var0_3 = arg0_2.contextData.groupId
			local var1_3 = pg.dorm3d_gift[arg0_2.contextData.drop.configId].unlock_banners or {}
			local var2_3 = table.Find(var1_3, function(arg0_4, arg1_4)
				if var0_3 == nil or arg1_4[1] == var0_3 then
					return true
				end
			end) or table.Find(var1_3, function(arg0_5)
				if arg0_5[1] == 0 then
					return true
				end
			end)

			arg0_2.unlockBanners = var2_3 and var2_3[2]
			arg0_2.isExclusive = pg.dorm3d_gift[arg0_2.contextData.drop.configId].ship_group_id ~= 0
			arg0_2.addFavor = pg.dorm3d_favor_trigger[pg.dorm3d_gift[arg0_2.contextData.drop.configId].favor_trigger_id].num

			setActive(arg0_2._tf:Find("Window/Title/gift"), true)
		end,
		Dorm3dFurniture = function()
			arg0_2.unlockTips = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].unlock_tips or {}
			arg0_2.unlockBanners = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].unlock_banners or {}
			arg0_2.isExclusive = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].is_exclusive == 1
			arg0_2.isSpecial = pg.dorm3d_furniture_template[arg0_2.contextData.drop.configId].is_special == 1

			setActive(arg0_2._tf:Find("Window/Title/furniture"), true)
		end,
		Dorm3dSkin = function()
			arg0_2.unlockTips = pg.dorm3d_resource[arg0_2.contextData.drop.configId].unlock_tips or {}
			arg0_2.unlockBanners = pg.dorm3d_resource[arg0_2.contextData.drop.configId].unlock_banners or {}

			setActive(arg0_2._tf:Find("Window/Title/skin"), true)
		end
	})
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8._tf:Find("Window/Confirm"), function()
		local var0_9 = arg0_8.contextData.onYes

		arg0_8:closeView()
		existCall(var0_9)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("Window/Cancel"), function()
		local var0_10 = arg0_8.contextData.onNo

		arg0_8:closeView()
		existCall(var0_10)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._tf:Find("Mask"), function()
		local var0_11 = arg0_8.contextData.onClose

		arg0_8:closeView()
		existCall(var0_11)
	end)
	arg0_8:InitUIList()
	arg0_8:InitDropIcon()
	arg0_8:InitBanner()

	local var0_8

	if arg0_8.contextData.content.cost == 0 then
		var0_8 = i18n("dorm3d_purchase_confirm_free", arg0_8.contextData.content.icon, "x" .. arg0_8.contextData.content.cost, arg0_8.contextData.content.name)
	elseif arg0_8.contextData.content.off > 0 then
		var0_8 = i18n("dorm3d_purchase_confirm_discount", arg0_8.contextData.content.icon, "x" .. arg0_8.contextData.content.cost, arg0_8.contextData.content.old, arg0_8.contextData.content.name)
	else
		var0_8 = i18n("dorm3d_purchase_confirm_original", arg0_8.contextData.content.icon, "x" .. arg0_8.contextData.content.cost, arg0_8.contextData.content.name)
	end

	switch(arg0_8.contextData.drop.__cname, {
		Dorm3dGift = function()
			local var0_12 = arg0_8.contextData.content.weekLimit

			if var0_12 then
				var0_8 = var0_8 .. i18n("dorm3d_purchase_weekly_limit", var0_12[1], var0_12[2])
			end
		end,
		Dorm3dFurniture = function()
			local var0_13 = arg0_8.contextData.endTime

			if var0_13 and var0_13 > 0 then
				local function var1_13(arg0_14)
					local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_14 = math.max(arg0_14 - var0_14, 0)
					local var2_14 = math.floor(var1_14 / 86400)

					if var2_14 > 0 then
						return var2_14 .. i18n("word_date")
					else
						local var3_14 = math.floor(var1_14 / 3600)

						if var3_14 > 0 then
							return var3_14 .. i18n("word_hour")
						else
							local var4_14 = math.floor(var1_14 / 60)

							if var4_14 > 0 then
								return var4_14 .. i18n("word_minute")
							else
								return var1_14 .. i18n("word_second")
							end
						end
					end
				end

				local var2_13 = var0_8

				arg0_8.timerRefreshTime = Timer.New(function()
					local var0_15 = var2_13 .. string.format("\n<size=28><color=#7c7e81>%s</color><color=#169fff>%s</color></size>", i18n("time_remaining_tip"), var1_13(var0_13))

					setText(arg0_8._tf:Find("Window/Content"), var0_15)
				end, 1, -1)

				arg0_8.timerRefreshTime:Start()

				var0_8 = var0_8 .. string.format("\n<size=28><color=#7c7e81>%s</color><color=#169fff>%s</color></size>", i18n("time_remaining_tip"), var1_13(var0_13))
			end
		end
	})
	setText(arg0_8._tf:Find("Window/Content"), var0_8)
	setText(arg0_8._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_8._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.InitBanner(arg0_16)
	for iter0_16 = 1, #arg0_16.unlockBanners do
		local var0_16 = arg0_16.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_16.unlockBanners[iter0_16], var0_16)
	end

	arg0_16.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_17)
	arg0_17.bubbleList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventInit then
			local var0_18 = arg1_18 + 1
			local var1_18 = arg0_17.unlockTips[var0_18]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_18, arg2_18:Find("icon/icon"), true)
			setText(arg2_18:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_18))
			setActive(arg2_18:Find("bubble"), false)
			onToggle(arg0_17, arg2_18, function(arg0_19)
				setActive(arg2_18:Find("icon/select"), arg0_19)
				setActive(arg2_18:Find("icon/unselect"), not arg0_19)
				setActive(arg2_18:Find("bubble"), arg0_19)
			end)
		end
	end)
	arg0_17.bubbleList:align(#arg0_17.unlockTips)
end

function var0_0.InitDropIcon(arg0_20)
	LoadImageSpriteAtlasAsync(arg0_20.contextData.drop:GetIcon(), "", arg0_20._tf:Find("Window/Item/Dorm3dIconTpl/icon"), true)
	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(arg0_20.contextData.drop:GetRarity()), arg0_20._tf:Find("Window/Item/Dorm3dIconTpl"))
	setActive(arg0_20._tf:Find("Window/Item/sp"), arg0_20.isExclusive or arg0_20.isSpecial)

	if arg0_20.isSpecial then
		setText(arg0_20._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_label_special"))
	elseif arg0_20.isExclusive then
		setText(arg0_20._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_confirm_tip"))
	end

	if arg0_20.addFavor then
		setActive(arg0_20._tf:Find("Window/Item/gift"), true)
		setText(arg0_20._tf:Find("Window/Item/gift/Text"), "+" .. arg0_20.addFavor)
	end
end

function var0_0.willExit(arg0_21)
	if arg0_21.timerRefreshTime then
		arg0_21.timerRefreshTime:Stop()

		arg0_21.timerRefreshTime = nil
	end

	arg0_21.scrollSnap:Dispose()

	arg0_21.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._tf)
end

return var0_0
