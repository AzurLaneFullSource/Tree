local var0_0 = class("Dorm3dShoppingConfirmWindow", import("view.base.BaseUI"))

var0_0.SELECTED_WIDTH = 52
var0_0.UNSELECTED_WIDTH = 12
var0_0.LOOP_DURATION = 5

function var0_0.getUIName(arg0_1)
	return "Dorm3dShopWindow"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"ui/shoptip_atlas"
	}
	local var1_2 = (arg1_2 or arg0_2.contextData or {}).drop

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local function var3_2(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4 or {}) do
			var2_2("dorm3dbanner/" .. iter1_4)
		end
	end

	if var1_2 then
		var2_2(var1_2:GetIcon())

		if var1_2.__cname == "Dorm3dGift" then
			local var4_2 = pg.dorm3d_gift[var1_2.configId]

			if var4_2 then
				for iter0_2, iter1_2 in ipairs(var4_2.unlock_banners or {}) do
					var3_2(iter1_2[2])
				end
			end
		elseif var1_2.__cname == "Dorm3dFurniture" then
			local var5_2 = pg.dorm3d_furniture_template[var1_2.configId]

			var3_2(var5_2 and var5_2.unlock_banners)
		elseif var1_2.__cname == "Dorm3dSkin" then
			local var6_2 = pg.dorm3d_resource[var1_2.configId]

			var3_2(var6_2 and var6_2.unlock_banners)
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_5)
	arg0_5.previewTf = arg0_5._tf:Find("Window/Preview")
	arg0_5.bubbleContent = arg0_5._tf:Find("Window/Bubbles/content")
	arg0_5.bubbleTpl = arg0_5._tf:Find("Window/Bubbles/tpl")
	arg0_5.bubbleList = UIItemList.New(arg0_5.bubbleContent, arg0_5.bubbleTpl)
	arg0_5.scrollSnap = BannerScrollRect4Dorm.New(arg0_5._tf:Find("Window/banner/mask/content"), arg0_5._tf:Find("Window/banner/dots"))

	setActive(arg0_5.bubbleTpl, false)
	switch(arg0_5.contextData.drop.__cname, {
		Dorm3dGift = function()
			arg0_5.unlockTips = pg.dorm3d_gift[arg0_5.contextData.drop.configId].unlock_tips or {}

			local var0_6 = arg0_5.contextData.groupId
			local var1_6 = pg.dorm3d_gift[arg0_5.contextData.drop.configId].unlock_banners or {}
			local var2_6 = table.Find(var1_6, function(arg0_7, arg1_7)
				if var0_6 == nil or arg1_7[1] == var0_6 then
					return true
				end
			end) or table.Find(var1_6, function(arg0_8)
				if arg0_8[1] == 0 then
					return true
				end
			end)

			arg0_5.unlockBanners = var2_6 and var2_6[2]
			arg0_5.isExclusive = pg.dorm3d_gift[arg0_5.contextData.drop.configId].ship_group_id ~= 0
			arg0_5.addFavor = pg.dorm3d_favor_trigger[pg.dorm3d_gift[arg0_5.contextData.drop.configId].favor_trigger_id].num

			setActive(arg0_5._tf:Find("Window/Title/gift"), true)
		end,
		Dorm3dFurniture = function()
			arg0_5.unlockTips = pg.dorm3d_furniture_template[arg0_5.contextData.drop.configId].unlock_tips or {}
			arg0_5.unlockBanners = pg.dorm3d_furniture_template[arg0_5.contextData.drop.configId].unlock_banners or {}
			arg0_5.isExclusive = pg.dorm3d_furniture_template[arg0_5.contextData.drop.configId].is_exclusive == 1
			arg0_5.isSpecial = pg.dorm3d_furniture_template[arg0_5.contextData.drop.configId].is_special == 1

			setActive(arg0_5._tf:Find("Window/Title/furniture"), true)
		end,
		Dorm3dSkin = function()
			arg0_5.unlockTips = pg.dorm3d_resource[arg0_5.contextData.drop.configId].unlock_tips or {}
			arg0_5.unlockBanners = pg.dorm3d_resource[arg0_5.contextData.drop.configId].unlock_banners or {}

			setActive(arg0_5._tf:Find("Window/Title/skin"), true)
		end
	})
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11._tf:Find("Window/Confirm"), function()
		local var0_12 = arg0_11.contextData.onYes

		arg0_11:closeView()
		existCall(var0_12)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11._tf:Find("Window/Cancel"), function()
		local var0_13 = arg0_11.contextData.onNo

		arg0_11:closeView()
		existCall(var0_13)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11._tf:Find("Mask"), function()
		local var0_14 = arg0_11.contextData.onClose

		arg0_11:closeView()
		existCall(var0_14)
	end)
	arg0_11:InitUIList()
	arg0_11:InitDropIcon()
	arg0_11:InitBanner()

	local var0_11

	if arg0_11.contextData.content.cost == 0 then
		var0_11 = i18n("dorm3d_purchase_confirm_free", arg0_11.contextData.content.icon, "x" .. arg0_11.contextData.content.cost, arg0_11.contextData.content.name)
	elseif arg0_11.contextData.content.off > 0 then
		var0_11 = i18n("dorm3d_purchase_confirm_discount", arg0_11.contextData.content.icon, "x" .. arg0_11.contextData.content.cost, arg0_11.contextData.content.old, arg0_11.contextData.content.name)
	else
		var0_11 = i18n("dorm3d_purchase_confirm_original", arg0_11.contextData.content.icon, "x" .. arg0_11.contextData.content.cost, arg0_11.contextData.content.name)
	end

	switch(arg0_11.contextData.drop.__cname, {
		Dorm3dGift = function()
			local var0_15 = arg0_11.contextData.content.weekLimit

			if var0_15 then
				var0_11 = var0_11 .. i18n("dorm3d_purchase_weekly_limit", var0_15[1], var0_15[2])
			end
		end,
		Dorm3dFurniture = function()
			local var0_16 = arg0_11.contextData.endTime

			if var0_16 and var0_16 > 0 then
				local function var1_16(arg0_17)
					local var0_17 = pg.TimeMgr.GetInstance():GetServerTime()
					local var1_17 = math.max(arg0_17 - var0_17, 0)
					local var2_17 = math.floor(var1_17 / 86400)

					if var2_17 > 0 then
						return var2_17 .. i18n("word_date")
					else
						local var3_17 = math.floor(var1_17 / 3600)

						if var3_17 > 0 then
							return var3_17 .. i18n("word_hour")
						else
							local var4_17 = math.floor(var1_17 / 60)

							if var4_17 > 0 then
								return var4_17 .. i18n("word_minute")
							else
								return var1_17 .. i18n("word_second")
							end
						end
					end
				end

				local var2_16 = var0_11

				arg0_11.timerRefreshTime = Timer.New(function()
					local var0_18 = var2_16 .. string.format("\n<size=28><color=#7c7e81>%s</color><color=#169fff>%s</color></size>", i18n("time_remaining_tip"), var1_16(var0_16))

					setText(arg0_11._tf:Find("Window/Content"), var0_18)
				end, 1, -1)

				arg0_11.timerRefreshTime:Start()

				var0_11 = var0_11 .. string.format("\n<size=28><color=#7c7e81>%s</color><color=#169fff>%s</color></size>", i18n("time_remaining_tip"), var1_16(var0_16))
			end
		end
	})
	setText(arg0_11._tf:Find("Window/Content"), var0_11)
	setText(arg0_11._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_11._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11._tf)
end

function var0_0.InitBanner(arg0_19)
	for iter0_19 = 1, #arg0_19.unlockBanners do
		local var0_19 = arg0_19.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_19.unlockBanners[iter0_19], var0_19)
	end

	arg0_19.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_20)
	arg0_20.bubbleList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventInit then
			local var0_21 = arg1_21 + 1
			local var1_21 = arg0_20.unlockTips[var0_21]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_21, arg2_21:Find("icon/icon"), true)
			setText(arg2_21:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_21))
			setActive(arg2_21:Find("bubble"), false)
			onToggle(arg0_20, arg2_21, function(arg0_22)
				setActive(arg2_21:Find("icon/select"), arg0_22)
				setActive(arg2_21:Find("icon/unselect"), not arg0_22)
				setActive(arg2_21:Find("bubble"), arg0_22)
			end)
		end
	end)
	arg0_20.bubbleList:align(#arg0_20.unlockTips)
end

function var0_0.InitDropIcon(arg0_23)
	LoadImageSpriteAtlasAsync(arg0_23.contextData.drop:GetIcon(), "", arg0_23._tf:Find("Window/Item/Dorm3dIconTpl/icon"), true)
	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(arg0_23.contextData.drop:GetRarity()), arg0_23._tf:Find("Window/Item/Dorm3dIconTpl"))
	setActive(arg0_23._tf:Find("Window/Item/sp"), arg0_23.isExclusive or arg0_23.isSpecial)

	if arg0_23.isSpecial then
		setText(arg0_23._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_label_special"))
	elseif arg0_23.isExclusive then
		setText(arg0_23._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_confirm_tip"))
	end

	if arg0_23.addFavor then
		setActive(arg0_23._tf:Find("Window/Item/gift"), true)
		setText(arg0_23._tf:Find("Window/Item/gift/Text"), "+" .. arg0_23.addFavor)
	end
end

function var0_0.willExit(arg0_24)
	if arg0_24.timerRefreshTime then
		arg0_24.timerRefreshTime:Stop()

		arg0_24.timerRefreshTime = nil
	end

	arg0_24.scrollSnap:Dispose()

	arg0_24.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf)
end

return var0_0
