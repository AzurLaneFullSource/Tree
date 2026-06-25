local var0_0 = class("Dorm3dSkinSelectLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dSkinSelectLayer"
end

function var0_0.init(arg0_2)
	arg0_2.btnChange = arg0_2._tf:Find("BG/bottom/btn_change")
	arg0_2.btnBuy = arg0_2._tf:Find("BG/bottom/btn_buy")
	arg0_2.priceText = arg0_2._tf:Find("BG/bottom/btn_buy/Price")
	arg0_2.line = arg0_2._tf:Find("BG/bottom/Line")
	arg0_2.desc = arg0_2._tf:Find("BG/bottom/desc")
	arg0_2.loader = AutoLoader.New()
end

function var0_0.SetApartment(arg0_3, arg1_3)
	arg0_3.apartment = arg1_3
end

function var0_0.didEnter(arg0_4)
	setText(arg0_4._tf:Find("BG/Scroll/Content/Unlock/Title/Text"), i18n("word_unlock"))
	setText(arg0_4._tf:Find("BG/Scroll/Content/Lock/Title/Text"), i18n("word_lock"))
	onButton(arg0_4, arg0_4._tf:Find("btn_back"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("BG/Close"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.btnChange, function()
		if arg0_4.contextData.isPublicRoom then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_skin_unlock"))

			return
		end

		if arg0_4:IsSameSkin() then
			return
		end

		arg0_4:emit(Dorm3dSkinSelectMediator.CHANGE_SKIN, arg0_4.contextData.groupId, arg0_4.selectedSkinId, arg0_4.hiddenList)

		if not arg0_4.contextData.onSwitchSkin then
			local var0_7 = pg.dorm3d_resource[arg0_4.selectedSkinId].wear_anim

			if var0_7 and var0_7 ~= "" then
				arg0_4.contextData.ladyEnv:PlaySingleAction(var0_7)
			end
		end

		arg0_4.sortSkinId = arg0_4.selectedSkinId

		arg0_4:FlushSkinList()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnBuy, function()
		local var0_8 = arg0_4.skinDic[arg0_4.selectedSkinId]
		local var1_8 = var0_8:GetType()

		if var1_8 == 2 then
			local var2_8 = var0_8:GetPublicRoomId()

			if getProxy(ApartmentProxy):getRoom(var2_8) then
				arg0_4:emit(Dorm3dSkinSelectMediator.OPEN_ROOM_UNLOCK_WINDOW, var2_8, arg0_4.contextData.groupId)
			else
				arg0_4:emit(Dorm3dSkinSelectMediator.OPEN_ROOM_UNLOCK_WINDOW, var2_8)
			end
		elseif var1_8 == 3 then
			local var3_8 = var0_8:GetShopId()
			local var4_8 = CommonCommodity.New({
				id = var3_8
			}, Goods.TYPE_SHOPSTREET)
			local var5_8, var6_8, var7_8 = var4_8:GetPrice()
			local var8_8 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var4_8:GetResType(),
				count = var5_8
			})

			arg0_4:emit(Dorm3dSkinSelectMediator.OPEN_SHOP_WINDOW, {
				content = {
					icon = "<icon name=" .. var4_8:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var6_8,
					cost = var8_8.count,
					old = var7_8,
					name = var0_8:GetName()
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var0_8,
				onYes = function()
					arg0_4:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						id = var3_8
					})
				end
			})
		end
	end, SFX_PANEL)

	arg0_4.selectedSkinId = arg0_4.contextData.ladyEnv.skinId
	arg0_4.sortSkinId = arg0_4.selectedSkinId
	arg0_4.skinDic = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.contextData.ladyEnv.skinIdList) do
		arg0_4.skinDic[iter1_4] = Dorm3dSkin.New({
			configId = iter1_4
		})
	end

	arg0_4:FlushSkinList()
end

function var0_0.FlushSkinList(arg0_10)
	local var0_10 = arg0_10.contextData.ladyEnv.skinIdList
	local var1_10 = {}
	local var2_10 = {}

	_.each(var0_10, function(arg0_11)
		if arg0_10.skinDic[arg0_11]:IsShow() then
			if ApartmentProxy.CheckUnlockConfig(arg0_10.skinDic[arg0_11]:GetUnlock()) then
				table.insert(var1_10, arg0_11)
			else
				table.insert(var2_10, arg0_11)
			end
		end
	end)

	local function var3_10(arg0_12, arg1_12)
		return (arg0_12 == arg0_10.sortSkinId and 1 or 0) > (arg1_12 == arg0_10.sortSkinId and 1 or 0)
	end

	table.sort(var1_10, var3_10)
	table.sort(var2_10, var3_10)

	local function var4_10(arg0_13, arg1_13)
		local var0_13 = arg1_13 and var1_10 or var2_10

		UIItemList.StaticAlign(arg0_13, arg0_13:GetChild(0), #var0_13, function(arg0_14, arg1_14, arg2_14)
			if arg0_14 ~= UIItemList.EventUpdate then
				return
			end

			local var0_14 = var0_13[arg1_14 + 1]

			setActive(arg2_14:Find("Selected"), var0_14 == arg0_10.selectedSkinId)
			setActive(arg2_14:Find("Lock"), not arg1_13)

			if not arg1_13 then
				setText(arg2_14:Find("Lock/Bar/Text"), arg0_10.skinDic[var0_14]:GetUnlockText())
			end

			arg0_10.loader:GetSpriteQuiet(string.format("dorm3dselect/apartment_skin_%d", var0_14), "", arg2_14:Find("Icon"))
			onButton(arg0_10, arg2_14, function()
				arg0_10:OnclickSkin(var0_14, arg1_13)
			end, SFX_PANEL)
		end)
	end

	var4_10(arg0_10._tf:Find("BG/Scroll/Content/Unlock/List"), true)
	var4_10(arg0_10._tf:Find("BG/Scroll/Content/Lock/List"), false)
	arg0_10:FlushSkinPartOptions()
	arg0_10:FlushBtns()
end

function var0_0.OnclickSkin(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.contextData.ladyEnv
	local var1_16 = arg0_16.contextData.groupId
	local var2_16 = var0_16.skinId

	arg0_16.selectedSkinId = arg1_16

	arg0_16:FlushBtns()
	arg0_16:FlushSkinPartOptions()

	if arg1_16 ~= var2_16 then
		if arg0_16.contextData.onSwitchSkin then
			arg0_16.contextData.onSwitchSkin(var0_16, var1_16, arg0_16.selectedSkinId)
		else
			var0_16:SwitchCharacterSkin(var1_16, arg0_16.selectedSkinId, function()
				Dorm3dHxHelper.HideCharacterPart(var0_16.lady, arg0_16.hiddenList)

				local var0_17 = arg0_16.skinDic[arg0_16.selectedSkinId]:GetSwitchAnim()

				if var0_17 and var0_17 ~= "" then
					var0_16:PlaySingleAction(var0_17)
				end
			end)
		end
	end

	arg0_16:FlushSkinList()
end

function var0_0.FlushBtns(arg0_18)
	local var0_18 = arg0_18.skinDic[arg0_18.selectedSkinId]
	local var1_18 = ApartmentProxy.CheckUnlockConfig(var0_18:GetUnlock())

	setActive(arg0_18.btnChange, var1_18)
	setActive(arg0_18.btnBuy, not var1_18)

	if not var1_18 then
		local var2_18 = var0_18:GetShopId()

		if not var2_18 then
			return
		end

		local var3_18 = CommonCommodity.New({
			id = var2_18
		}, Goods.TYPE_SHOPSTREET)
		local var4_18 = var3_18:GetPrice()

		setText(arg0_18.priceText, "<icon name=" .. var3_18:GetResIcon() .. " w=1.1 h=1.1/> " .. var4_18)

		local var5_18 = var0_18:GetUnlock()[1]
		local var6_18 = var0_18:GetRemarks()

		if var6_18 and var6_18 ~= "" then
			setActive(arg0_18.line, false)
			setActive(arg0_18.desc, true)
			setText(arg0_18.desc, var6_18)
		else
			setActive(arg0_18.line, true)
			setActive(arg0_18.desc, false)
		end
	else
		setActive(arg0_18.desc, false)

		if arg0_18:IsSameSkin() then
			setText(arg0_18.btnChange:Find("text"), i18n("dorm3d_skin_already"))
		else
			setText(arg0_18.btnChange:Find("text"), i18n("dorm3d_skin_confirm"))
		end
	end
end

function var0_0.FlushSkinPartOptions(arg0_19)
	local var0_19 = pg.dorm3d_resource[arg0_19.selectedSkinId].hidden_part

	arg0_19.hiddenList = Clone(arg0_19.apartment:GetHiddenParts(arg0_19.selectedSkinId))

	UIItemList.StaticAlign(arg0_19._tf:Find("BG/parts"), arg0_19._tf:Find("BG/parts/tpl"), #var0_19, function(arg0_20, arg1_20, arg2_20)
		local var0_20 = var0_19[arg1_20 + 1]

		if arg0_20 == UIItemList.EventInit then
			arg0_19.loader:GetSpriteQuiet("dorm3dskinpart/" .. var0_20[2], "", arg2_20:Find("open"))
			arg0_19.loader:GetSpriteQuiet("dorm3dskinpart/" .. var0_20[2] .. "_close", "", arg2_20:Find("close"))

			local var1_20 = table.contains(arg0_19.hiddenList, var0_20[1])

			setActive(arg2_20:Find("open"), not var1_20)
			setActive(arg2_20:Find("close"), var1_20)
			onButton(arg0_19, arg2_20, function()
				local var0_21 = table.contains(arg0_19.hiddenList, var0_20[1])

				if var0_21 then
					table.removebyvalue(arg0_19.hiddenList, var0_20[1])
				else
					table.insert(arg0_19.hiddenList, var0_20[1])
				end

				local var1_21 = not var0_21

				setActive(arg2_20:Find("open"), not var1_21)
				setActive(arg2_20:Find("close"), var1_21)
				Dorm3dHxHelper.HideCharacterPart(arg0_19.contextData.ladyEnv.lady, arg0_19.hiddenList)
				arg0_19:FlushBtns()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.IsSameSkin(arg0_22)
	if arg0_22.selectedSkinId ~= arg0_22.apartment:GetCurSkinId() then
		return false
	end

	local var0_22 = arg0_22.apartment:GetHiddenParts(arg0_22.selectedSkinId)
	local var1_22, var2_22, var3_22 = table.Diff(arg0_22.hiddenList, var0_22)

	return #var2_22 == 0 and #var3_22 == 0
end

function var0_0.ConfirmCurrentSkin(arg0_23)
	arg0_23:OnclickSkin(arg0_23.selectedSkinId, true)
end

function var0_0.CancelCurrentSkin(arg0_24)
	arg0_24:OnclickSkin(arg0_24.contextData.ladyEnv.skinId, true)
end

function var0_0.willExit(arg0_25)
	arg0_25.loader:Clear()

	if arg0_25.contextData.isPublicRoom then
		return
	end

	local var0_25 = arg0_25.apartment:GetCurSkinId()

	if arg0_25.contextData.ladyEnv.skinId ~= var0_25 then
		arg0_25.contextData.ladyEnv:SwitchCharacterSkin(arg0_25.contextData.groupId, var0_25, function()
			Dorm3dHxHelper.HideCharacterPart(arg0_25.contextData.ladyEnv.lady, arg0_25.apartment:GetHiddenParts(var0_25))
		end)
	else
		Dorm3dHxHelper.HideCharacterPart(arg0_25.contextData.ladyEnv.lady, arg0_25.apartment:GetHiddenParts(var0_25))
	end
end

return var0_0
