local var0_0 = class("IslandShipDressUpPageNew", import("...base.IslandBasePage"))

var0_0.CHANGE_SKIN = "IslandShipDressUpPage:CHANGE_SKIN"

function var0_0.getUIName(arg0_1)
	return "IslandShipDressUI"
end

local var1_0 = {
	IslandShipDressHelperNew.DressType.Hair,
	IslandShipDressHelperNew.DressType.Face,
	IslandShipDressHelperNew.DressType.Body,
	[5] = IslandShipDressHelperNew.DressType.BackDecorate,
	[6] = IslandShipDressHelperNew.DressType.Flotage,
	[7] = IslandShipDressHelperNew.DressType.Footprint
}

var0_0.SORT_DEFAULT = 1
var0_0.SORT_RARITY = 2
var0_0.SORT_CANSEND = 3
var0_0.SORT_LIST = {
	var0_0.SORT_DEFAULT,
	var0_0.SORT_RARITY,
	var0_0.SORT_CANSEND
}
var0_0.SORTCN = {
	[var0_0.SORT_DEFAULT] = i18n("word_default"),
	[var0_0.SORT_RARITY] = i18n("word_rarity"),
	[var0_0.SORT_CANSEND] = i18n("island_word_give")
}

function var0_0.Sort2CN(arg0_2)
	return var0_0.SORTCN[arg0_2]
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.rightPanel = arg0_3._tf:Find("adapt/right_panel")
	arg0_3.togglePanel = arg0_3.rightPanel:Find("toggles/select_toggles")
	arg0_3.saveBtn = arg0_3._tf:Find("adapt/save")
	arg0_3.restBtn = arg0_3._tf:Find("adapt/reset")

	setText(arg0_3.saveBtn:Find("Text"), i18n("word_save"))
	setText(arg0_3.restBtn:Find("Text"), i18n("island_word_reset"))

	arg0_3.toggles = {
		arg0_3.togglePanel:Find("hair"),
		arg0_3.togglePanel:Find("face"),
		arg0_3.togglePanel:Find("body"),
		arg0_3.togglePanel:Find("skin"),
		arg0_3.togglePanel:Find("wing"),
		arg0_3.togglePanel:Find("trailing"),
		arg0_3.togglePanel:Find("footprint")
	}
	arg0_3.dressCards = {}
	arg0_3.skinCards = {}
	arg0_3.dressTF = arg0_3.rightPanel:Find("dress")
	arg0_3.skinTF = arg0_3.rightPanel:Find("skin")
	arg0_3.dressRectTF = arg0_3.dressTF:Find("dress_container")
	arg0_3.dressRect = arg0_3.dressTF:Find("dress_container/dress"):GetComponent("LScrollRect")
	arg0_3.dressEmpty = arg0_3.dressTF:Find("dressEmpty")
	arg0_3.dressEmptyTips = arg0_3.dressEmpty:Find("layout/empty_tips")
	arg0_3.dressList = {}

	function arg0_3.dressRect.onInitItem(arg0_4)
		arg0_3:OnDressInitItem(arg0_4)
	end

	function arg0_3.dressRect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnDressUpdateItem(arg0_5, arg1_5)
	end

	arg0_3.skinRect = arg0_3.skinTF:Find("dress_container/dress"):GetComponent("LScrollRect")
	arg0_3.skinRectTF = arg0_3.skinTF:Find("dress_container")
	arg0_3.skinEmpty = arg0_3.skinTF:Find("skinEmpty")
	arg0_3.skinEmptyTips = arg0_3.skinEmpty:Find("layout/empty_tips")

	function arg0_3.skinRect.onInitItem(arg0_6)
		arg0_3:OnSkinInitItem(arg0_6)
	end

	function arg0_3.skinRect.onUpdateItem(arg0_7, arg1_7)
		arg0_3:OnSkinUpdateItem(arg0_7, arg1_7)
	end

	arg0_3.sortBtn = arg0_3.dressTF:Find("order")
	arg0_3.orderBtn = arg0_3.sortBtn:Find("icon")
	arg0_3.orderTxt = arg0_3.sortBtn:Find("Text_1"):GetComponent(typeof(Text))
	arg0_3.sortPage = IslandShipDressUpSortPage.New(arg0_3._tf)
	arg0_3.dressUpConfireBtn = arg0_3._tf:Find("adapt/confire")
	arg0_3.dressUpConfireText = arg0_3._tf:Find("adapt/confire/Text")

	setText(arg0_3.dressUpConfireText, i18n("island_dress_initial_makesure"))

	arg0_3.colorList = arg0_3._tf:Find("adapt/left_color_panel/colorList")
	arg0_3.colorItem = arg0_3._tf:Find("adapt/left_color_panel/colorList/item")
	arg0_3.color_listPanel = arg0_3._tf:Find("adapt/left_color_panel")
	arg0_3.color_bg_unlock = arg0_3._tf:Find("adapt/left_color_panel/bg1")
	arg0_3.color_bg_locked = arg0_3._tf:Find("adapt/left_color_panel/bglocked")
	arg0_3.color_lockedBtn = arg0_3.color_bg_locked:Find("unlockedBtn")
	arg0_3.color_cost_item_icon = arg0_3.color_bg_locked:Find("itemcost")
	arg0_3.color_cost_item_count = arg0_3.color_bg_locked:Find("cost_num")

	setActive(arg0_3.sortBtn, false)
	setText(arg0_3.color_bg_locked:Find("tips"), i18n("island_dresscolorunlock_tips"))
	setText(arg0_3.color_lockedBtn:Find("Text"), i18n("island_dresscolorunlock"))

	arg0_3.colorItemUIList = UIItemList.New(arg0_3.colorList, arg0_3.colorItem)
	arg0_3.hatTF = arg0_3._tf:Find("adapt/btns/hat")
	arg0_3.hatOn = arg0_3.hatTF:Find("hatOn")
	arg0_3.hatOff = arg0_3.hatTF:Find("hatOff")
	arg0_3.morphTF = arg0_3._tf:Find("adapt/btns/morph")
	arg0_3.morphBtn = arg0_3.morphTF and arg0_3.morphTF:Find("morphBtn")
	arg0_3.morphBlocker = arg0_3._tf:Find("adapt/morph_blocker")

	setActive(arg0_3.morphBlocker, false)

	arg0_3.dressDetailPopup = IslandShipDressDescBox.New(arg0_3._tf, arg0_3.event, arg0_3.contextData)
end

function var0_0.CheckDressIsExclusive(arg0_8, arg1_8)
	local var0_8 = pg.island_dress_template[arg1_8]
	local var1_8 = var0_8.exclusive_skin

	if var1_8 ~= "" then
		for iter0_8, iter1_8 in ipairs(var1_8) do
			if iter1_8 == arg0_8.curSkinId then
				return false, true
			end
		end
	end

	local var2_8 = var0_8.exclusive_default_skin
	local var3_8 = arg0_8.curSkinId == nil or arg0_8.curSkinId == 0

	if var2_8 ~= "" and var3_8 then
		for iter2_8, iter3_8 in ipairs(var2_8) do
			if iter3_8 == arg0_8.shipId then
				return true, false
			end
		end
	end

	return false, false
end

function var0_0.ClickDressCardItem(arg0_9, arg1_9)
	if arg0_9.shipId ~= 0 then
		if arg1_9.needRedDot then
			local var0_9 = {}

			table.insert(var0_9, arg1_9.id)
			pg.m02:sendNotification(GAME.ISLAND_SEND_ROLE_DRESS_READ, {
				dress_List = var0_9
			})
		end

		local var1_9, var2_9 = arg0_9:CheckDressIsExclusive(arg1_9.id)

		if var2_9 or var1_9 then
			local var3_9 = pg.island_dress_template[arg1_9.id]

			if var1_9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive1", var3_9.name))

				return
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive1", var3_9.name))

				return
			end
		end

		local var4_9 = arg0_9.curShipDressTypeDataDic[arg0_9.dressType]

		if var4_9:CheckIsEqualByShipIdAndDressId(arg1_9.holdedShipId or 0, arg1_9.id) then
			var4_9:SetShipAndDressId(nil, nil)
		else
			var4_9:SetShipAndDressId(arg1_9.holdedShipId or 0, arg1_9.id)
		end

		arg0_9.shipDressHelper:ChangeDressByType(arg0_9.dressType, {
			colorId = 0,
			id = var4_9.dress_id or 0
		})

		local var5_9 = #arg0_9.dressList

		arg0_9.dressRect:SetTotalCount(var5_9)

		return
	end

	if arg1_9.needRedDot then
		local var6_9 = {}

		table.insert(var6_9, arg1_9.id)
		pg.m02:sendNotification(GAME.ISLAND_SEND_COMMANDER_DRESS_READ, {
			dress_List = var6_9
		})
	end

	local var7_9 = arg1_9.id
	local var8_9 = table.contains(IslandShipDressHelperNew.CommanderCustom, arg0_9.dressType)

	if arg0_9.curDressTypeDataDic[arg0_9.dressType] == var7_9 then
		if var8_9 then
			return
		else
			var7_9 = 0
		end
	end

	if arg0_9.dressType == IslandShipDressHelperNew.DressType.Body then
		local var9_9 = arg0_9.dressUpAgency:GetTwinCurId(var7_9)

		if var9_9 and var9_9 ~= 0 then
			var7_9 = var9_9
		end
	end

	arg0_9.curDressTypeDataDic[arg0_9.dressType] = var7_9

	local var10_9 = (function()
		local var0_10 = 0

		if var7_9 ~= 0 and arg0_9.shipId == 0 then
			var0_10 = arg0_9.dressUpAgency:GetCurrentColorByDressId(var7_9)
			arg0_9.dressColorDic[var7_9] = var0_10
		end

		return var0_10
	end)()

	arg0_9.shipDressHelper:ChangeDressByType(arg0_9.dressType, {
		id = var7_9,
		colorId = var10_9
	})

	local var11_9 = #arg0_9.dressList

	arg0_9.dressRect:SetTotalCount(var11_9)
	arg0_9:CheckHatAutoTakeOff(var7_9)
	arg0_9:UpdateHatDisplay()
	arg0_9:UpdateMorphDisplay()
	arg0_9:UpdateColorList(true)
end

function var0_0.CheckHatAutoTakeOff(arg0_11, arg1_11)
	if arg0_11.dressType == IslandShipDressHelperNew.DressType.Body then
		local var0_11 = arg0_11.dressUpAgency:GetBodyHatDressId(arg1_11)

		if not var0_11 or var0_11 == 0 then
			arg0_11.curDressTypeDataDic[IslandShipDressHelperNew.DressType.Hat] = 0

			arg0_11.shipDressHelper:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
				id = 0,
				colorId = 0
			})
		end
	end
end

function var0_0.UpdateHatToggleDisplay(arg0_12, arg1_12)
	setActive(arg0_12.hatOn, not arg1_12)
	setActive(arg0_12.hatOff, arg1_12)
end

function var0_0.UpdateHatDisplay(arg0_13)
	if arg0_13.dressType ~= IslandShipDressHelperNew.DressType.Body then
		setActive(arg0_13.hatTF, false)

		return
	end

	local var0_13 = arg0_13.curDressTypeDataDic[arg0_13.dressType]

	if not var0_13 or var0_13 == 0 then
		setActive(arg0_13.hatTF, false)

		return
	end

	local var1_13 = (pg.island_dress_template.get_id_list_by_related_dress[var0_13] or {})[1]

	if not var1_13 then
		setActive(arg0_13.hatTF, false)

		return
	end

	setActive(arg0_13.hatTF, true)

	local var2_13 = pg.island_dress_template[var1_13].type
	local var3_13 = arg0_13.dressUpAgency:GetBodyHatIsOn(var0_13, var1_13)

	arg0_13.shipDressHelper:ChangeDressByType(var2_13, {
		id = var3_13 and var1_13 or 0
	})

	arg0_13.curDressTypeDataDic[var2_13] = var3_13 and var1_13 or 0

	arg0_13:UpdateHatToggleDisplay(var3_13)

	if pg.island_dress_template[var1_13].takeoff_btn_is_hide == 1 then
		setActive(arg0_13.hatTF, false)
	end

	onButton(arg0_13, arg0_13.hatOn, function()
		if arg0_13.curDressTypeDataDic[var2_13] ~= var1_13 then
			arg0_13.curDressTypeDataDic[var2_13] = var1_13

			arg0_13.shipDressHelper:ChangeDressByType(var2_13, {
				id = var1_13
			})
			arg0_13:UpdateHatToggleDisplay(true)
		end
	end)
	onButton(arg0_13, arg0_13.hatOff, function()
		if arg0_13.curDressTypeDataDic[var2_13] ~= 0 then
			arg0_13.curDressTypeDataDic[var2_13] = 0

			arg0_13.shipDressHelper:ChangeDressByType(var2_13, {
				id = 0
			})
			arg0_13:UpdateHatToggleDisplay(false)
		end
	end)
end

function var0_0.OnDressInitItem(arg0_16, arg1_16)
	local var0_16 = IslandDressCard.New(arg1_16)

	arg0_16.dressCards[arg1_16] = var0_16
end

function var0_0.UpdateMorphDisplay(arg0_17)
	if arg0_17.dressType ~= IslandShipDressHelperNew.DressType.Body then
		setActive(arg0_17.morphTF, false)

		return
	end

	local var0_17 = arg0_17.curDressTypeDataDic[arg0_17.dressType]

	if not var0_17 or var0_17 == 0 then
		setActive(arg0_17.morphTF, false)

		return
	end

	local var1_17 = 0
	local var2_17 = pg.island_dress_template[var0_17].cloth_related

	if var2_17 and var2_17 ~= 0 then
		var1_17 = var2_17
	end

	if var1_17 == 0 then
		setActive(arg0_17.morphTF, false)

		return
	end

	setActive(arg0_17.morphTF, true)
	onButton(arg0_17, arg0_17.morphBtn, function()
		arg0_17:DoMorphSwitch(var0_17, var1_17)
	end)
end

function var0_0.DoMorphSwitch(arg0_19, arg1_19, arg2_19)
	if arg0_19.morphing then
		return
	end

	arg0_19:SetMorphBlock(true)

	if not arg0_19.shipDressHelper then
		arg0_19:DoSwitch(arg2_19, function()
			arg0_19:SetMorphBlock(false)
		end)

		return
	end

	arg0_19.shipDressHelper:DoMorphSwitch(arg1_19, arg2_19, function()
		arg0_19:DoSwitch(arg2_19, function()
			arg0_19:SetMorphBlock(false)
		end)
	end)
end

function var0_0.SetMorphBlock(arg0_23, arg1_23)
	arg0_23.morphing = arg1_23

	setActive(arg0_23.morphBlocker, arg1_23)
end

function var0_0.CanEsc(arg0_24)
	if arg0_24.morphing then
		return false
	end

	return true
end

function var0_0.DoSwitch(arg0_25, arg1_25, arg2_25)
	local var0_25 = IslandShipDressHelperNew.DressType.Body

	arg0_25.curDressTypeDataDic[var0_25] = arg1_25

	arg0_25.shipDressHelper:ChangeDressByType(var0_25, {
		colorId = 0,
		id = arg1_25
	}, arg2_25)
	arg0_25:CheckHatAutoTakeOff(arg1_25)
	arg0_25:UpdateHatDisplay()
	arg0_25:UpdateMorphDisplay()
end

function var0_0.AddLongPressListeners(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	arg0_26.isLongPress = false

	local function var0_26()
		if arg0_26.isLongPress then
			arg0_26.dressDetailPopup:ExecuteAction("Hide")

			arg0_26.isLongPress = false
		end
	end

	local var1_26 = GetOrAddComponent(arg2_26, typeof(LongPressTrigger))

	var1_26.onClick:RemoveAllListeners()
	var1_26.onClick:AddListener(function()
		if arg0_26.isLongPress then
			var0_26()

			return
		end

		arg4_26()
	end)
	var1_26.onLongPressed:RemoveAllListeners()
	var1_26.onLongPressed:AddListener(function()
		arg0_26.isLongPress = true

		local var0_29 = arg0_26._tf:InverseTransformPoint(tf(arg2_26).position)
		local var1_29 = Vector2(var0_29.x - tf(arg2_26).sizeDelta.x / 2, var0_29.y + tf(arg2_26).sizeDelta.y / 2)

		arg0_26.dressDetailPopup:ExecuteAction("Show", arg1_26, arg3_26, var1_29)
	end)
	var1_26.onReleased:RemoveAllListeners()
	var1_26.onReleased:AddListener(var0_26)
end

function var0_0.OnDressUpdateItem(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.dressCards[arg2_30]

	if not var0_30 then
		arg0_30:OnDressInitItem(arg2_30)

		var0_30 = arg0_30.dressCards[arg2_30]
	end

	local var1_30 = arg0_30.dressList[arg1_30 + 1]

	setActive(var0_30.canSendTF, false)

	local var2_30 = var1_30.ownCount ~= nil

	setActive(var0_30.ownNumTF, var2_30)

	if var2_30 then
		setText(var0_30.ownNumText, "×" .. var1_30.ownCount)
	end

	local var3_30 = var1_30.holdedShipId ~= nil

	setActive(var0_30.shipHoldTF, var3_30)

	if var3_30 then
		local var4_30 = IslandShip.StaticGetPrefab(var1_30.holdedShipId)

		GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var4_30, "", var0_30.shipIcon)
	end

	setActive(var0_30.redDot, var1_30.needRedDot)

	local var5_30
	local var6_30 = var1_30.id
	local var7_30 = tf(arg2_30)

	arg0_30:AddLongPressListeners(IslandShipDressDescBox.TYPE.DRESS, arg2_30, var6_30, function()
		arg0_30:ClickDressCardItem(var1_30)
	end)

	local var8_30 = false

	if arg0_30.shipId == 0 then
		local var9_30 = arg0_30.curDressTypeDataDic[arg0_30.dressType]
		local var10_30 = var9_30 ~= 0 and var9_30 or nil

		var8_30 = var10_30 == var1_30.id or var10_30 == var1_30:getConfig("cloth_related")

		setActive(var0_30.exclusionTF, false)
	else
		local var11_30, var12_30 = arg0_30:CheckDressIsExclusive(var1_30.id)
		local var13_30 = var11_30 or var12_30

		setActive(var0_30.exclusionTF, var13_30)

		var8_30 = arg0_30.curShipDressTypeDataDic[arg0_30.dressType]:CheckIsEqualByShipIdAndDressId(var1_30.holdedShipId or 0, var1_30.id)
	end

	var0_30:Update(var6_30, var8_30)
end

function var0_0.OnSkinInitItem(arg0_32, arg1_32)
	local var0_32 = IslandSkinCard.New(arg1_32)

	arg0_32.skinCards[arg1_32] = var0_32
end

function var0_0.OnSkinUpdateItem(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.skinCards[arg2_33]

	if not var0_33 then
		arg0_33:OnSkinInitItem(arg2_33)

		var0_33 = arg0_33.skinCards[arg2_33]
	end

	local var1_33 = arg0_33.skinList[arg1_33 + 1]
	local var2_33 = tf(arg2_33)

	setActive(var2_33:Find("changeColor"), true)

	local var3_33 = arg0_33.curSkinId
	local var4_33 = var3_33 ~= 0 and var3_33 or nil

	var0_33:Update(var1_33, var4_33)
	arg0_33:AddLongPressListeners(IslandShipDressDescBox.TYPE.SKIN, arg2_33, var1_33, function()
		arg0_33:ClickSkinCardItem(var1_33)
	end)
end

function var0_0.ChangeModelBySkinAndSkinColor(arg0_35)
	local var0_35 = arg0_35.characterAgency:GetShipById(arg0_35.shipId)
	local var1_35 = {}
	local var2_35 = {
		IslandShipDressHelperNew.DressType.BackDecorate,
		IslandShipDressHelperNew.DressType.Flotage,
		IslandShipDressHelperNew.DressType.Footprint
	}

	for iter0_35, iter1_35 in ipairs(var2_35) do
		local var3_35 = arg0_35.curShipDressTypeDataDic[iter1_35]

		if var3_35 and var3_35.dress_id and var3_35.dress_id ~= 0 then
			if arg0_35.curSkinId ~= 0 then
				local var4_35 = pg.island_dress_template[var3_35.dress_id].exclusive_skin
				local var5_35 = var4_35 == "" and {} or var4_35

				for iter2_35, iter3_35 in ipairs(var5_35) do
					if iter3_35 == arg0_35.curSkinId then
						table.insert(var1_35, var3_35.dress_id)
						var3_35:SetShipAndDressId(nil, nil)
					end
				end
			else
				local var6_35 = pg.island_dress_template[var3_35.dress_id].exclusive_default_skin
				local var7_35 = var6_35 == "" and {} or var6_35

				for iter4_35, iter5_35 in ipairs(var7_35) do
					if iter5_35 == arg0_35.shipId then
						table.insert(var1_35, var3_35.dress_id)
						var3_35:SetShipAndDressId(nil, nil)
					end
				end
			end
		end
	end

	if #var1_35 > 0 then
		local var8_35 = ""

		for iter6_35, iter7_35 in ipairs(var1_35) do
			local var9_35 = pg.island_dress_template[iter7_35].name

			if iter6_35 > 1 then
				var9_35 = "," .. var9_35
			end

			var8_35 = var8_35 .. var9_35
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive", var8_35))
	end

	arg0_35:emit(IslandShipMainPage.CLEAR_ITEM_ANIMATOR)

	local var10_35 = var0_35:GetModelBySkinAndColorId(arg0_35.curSkinId, arg0_35.curskinColorId)

	if #var1_35 > 0 then
		arg0_35.shipDressHelper:ChangeModelTransfromByUnitIdAndChangeDress(var10_35, var1_35, nil, nil, true)
	else
		arg0_35.shipDressHelper:ChangeModelTransfromByUnitId(var10_35, nil, true)
	end
end

function var0_0.ClickSkinCardItem(arg0_36, arg1_36)
	if arg1_36 == arg0_36.curSkinId then
		arg0_36.curSkinId = 0
	else
		arg0_36.curSkinId = arg1_36
	end

	arg0_36:UpdateSkinList()

	if arg0_36.curSkinId ~= 0 then
		arg0_36.curskinColorId = arg0_36.characterAgency:GetCurrentSkinColorByShipId(arg0_36.shipId, arg0_36.curSkinId)
	end

	arg0_36:ChangeModelBySkinAndSkinColor()
	arg0_36:UpdateColorList()
	arg0_36:UpdateHatDisplay()
end

function var0_0.ClearSkinSelected(arg0_37, arg1_37)
	return
end

function var0_0.AddListeners(arg0_38)
	arg0_38:AddListener(GAME.ISLAND_CHANGE_ROLE_DRESS_DONE, arg0_38.OnChangeRoleDressDone)
	arg0_38:AddListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_38.OnSendRoleDressReadDone)
	arg0_38:AddListener(GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE, arg0_38.OnSendRoleDressReadDone)
	arg0_38:AddListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_38.OnBuyRoleSkinColorDone)
	arg0_38:AddListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_38.OnBuyRoleDressColorDone)
	arg0_38:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_38.GetBuySkindDone)
end

function var0_0.RemoveListeners(arg0_39)
	arg0_39:RemoveListener(GAME.ISLAND_CHANGE_ROLE_DRESS_DONE, arg0_39.OnChangeRoleDressDone)
	arg0_39:RemoveListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_39.OnSendRoleDressReadDone)
	arg0_39:RemoveListener(GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE, arg0_39.OnSendRoleDressReadDone)
	arg0_39:RemoveListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_39.OnBuyRoleSkinColorDone)
	arg0_39:RemoveListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_39.OnBuyRoleDressColorDone)
	arg0_39:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_39.GetBuySkindDone)
end

function var0_0.OnClosePage(arg0_40, arg1_40)
	return
end

function var0_0.OnInit(arg0_41)
	onButton(arg0_41, arg0_41.saveBtn, function()
		if not arg0_41:CheckDressIsDirty() then
			if arg0_41.changeDressType then
				pg.m02:sendNotification(GAME.ISLAND_CHEATER_CHANGE_VIEW_DRESSID, {
					type = arg0_41.changeDressType,
					game_type = PlayRoomTools.GetGameTypeID(),
					ship_id = arg0_41.shipId
				})
				pg.m02:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_INFO)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))

			return
		end

		arg0_41:SaveDressUpDataHandle()
	end, SFX_PANEL)
	onButton(arg0_41, arg0_41.dressUpConfireBtn, function()
		arg0_41:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_dressup_tip"),
			onYes = function()
				arg0_41:SaveDressUpDataHandle()
			end,
			onNo = function()
				return
			end
		})
	end, SFX_PANEL)
	onButton(arg0_41, arg0_41.restBtn, function()
		arg0_41:ResetDressUp()
	end, SFX_PANEL)

	for iter0_41, iter1_41 in ipairs(arg0_41.toggles) do
		onToggle(arg0_41, iter1_41, function(arg0_47)
			if arg0_47 then
				arg0_41:SwitchPage(iter0_41)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_41, arg0_41.sortBtn, function()
		arg0_41.sortPage:ExecuteAction("Show", arg0_41.indexData, function(arg0_49)
			arg0_41:OnSort(arg0_49)
		end)
	end, SFX_PANEL)
	onButton(arg0_41, arg0_41.orderBtn, function()
		local var0_50 = 1 - arg0_41.indexData.order

		arg0_41:OnOrder(var0_50)
	end, SFX_PANEL)
end

function var0_0.OnSort(arg0_51, arg1_51)
	arg0_51.indexData.sortKey = arg1_51

	arg0_51:UpdateOrderTxt()
	arg0_51:UpdateDressUpList()
end

function var0_0.OnOrder(arg0_52, arg1_52)
	arg0_52.indexData.order = arg1_52
	arg0_52.orderBtn.localScale = Vector3(1, arg1_52 == 1 and 1 or -1, 1)

	arg0_52:UpdateDressUpList()
end

function var0_0.UpdateOrderTxt(arg0_53)
	arg0_53.orderTxt.text = var0_0.SORTCN[arg0_53.indexData.sortKey]
end

function var0_0.SwitchPage(arg0_54, arg1_54)
	arg0_54.currentToggleIndex = arg1_54

	if arg0_54.currentToggleIndex == 4 then
		setActive(arg0_54.dressTF, false)
		setActive(arg0_54.skinTF, true)
		setActive(arg0_54.hatTF, false)
		arg0_54:GetSkinList()
		arg0_54:UpdateSkinList()
		arg0_54:UpdateColorList()
	else
		arg0_54.dressType = var1_0[arg0_54.currentToggleIndex]

		if arg0_54.SmoothFunc then
			if arg0_54.dressType == IslandShipDressHelperNew.DressType.BackDecorate then
				arg0_54.SmoothFunc(Quaternion.Euler(0, 0, 0))
			else
				arg0_54.SmoothFunc(Quaternion.Euler(0, 180, 0))
			end
		end

		setActive(arg0_54.dressTF, true)
		setActive(arg0_54.skinTF, false)
		arg0_54:GetDressUpList()
		arg0_54:UpdateDressUpList()
		arg0_54:UpdateHatDisplay()
		arg0_54:UpdateMorphDisplay()
		arg0_54:UpdateOrderTxt()
		arg0_54:UpdateColorList(true)
	end
end

function var0_0.GetDressUpList(arg0_55)
	arg0_55.dressList = {}

	if arg0_55.shipId == 0 then
		for iter0_55, iter1_55 in ipairs(arg0_55.dressUpAgency:GetHasDressByType(arg0_55.dressType)) do
			local var0_55 = pg.island_dress_template[iter1_55.id]

			if var0_55.is_hide ~= 1 then
				local var1_55 = var0_55.quality

				table.insert(arg0_55.dressList, IslandDressItem.New({
					id = iter1_55.id,
					quality = var1_55,
					needRedDot = iter1_55.state == 0
				}))
			end
		end
	else
		for iter2_55, iter3_55 in pairs(arg0_55.characterAgency:GetAllOwnDressDic()) do
			if iter3_55:getConfigTable().type == arg0_55.dressType and iter3_55.num > 0 and iter3_55:getConfigTable().is_hide ~= 1 then
				local var2_55 = pg.island_dress_template[iter3_55.id].quality

				table.insert(arg0_55.dressList, IslandDressItem.New({
					id = iter3_55.id,
					ownCount = iter3_55.num,
					needRedDot = iter3_55.read == 0,
					quality = var2_55
				}))
			end
		end

		for iter4_55, iter5_55 in pairs(arg0_55.characterAgency:GetShipHoldedDressDic()) do
			for iter6_55, iter7_55 in ipairs(iter5_55) do
				if iter7_55:getConfigTable().type == arg0_55.dressType and iter7_55:getConfigTable().is_hide ~= 1 then
					local var3_55 = pg.island_dress_template[iter7_55.dress_id].quality

					table.insert(arg0_55.dressList, IslandDressItem.New({
						id = iter7_55.dress_id,
						holdedShipId = iter7_55.ship_id,
						quality = var3_55
					}))
				end
			end
		end
	end

	local var4_55

	if arg0_55.indexData.sortKey == var0_0.SORT_DEFAULT then
		var4_55 = {
			function(arg0_56)
				return arg0_56.holdedShipId and 0 or 1
			end,
			function(arg0_57)
				return arg0_57.needRedDot and 0 or 1
			end,
			function(arg0_58)
				return -arg0_58.quality
			end,
			function(arg0_59)
				return -arg0_59.id
			end
		}
	end

	table.sort(arg0_55.dressList, CompareFuncs(var4_55))
end

function var0_0.GetSkinList(arg0_60)
	if arg0_60.shipId ~= 0 then
		arg0_60.skinList = {}

		for iter0_60, iter1_60 in ipairs(pg.island_skin_template.get_id_list_by_ship_group[arg0_60.shipId] or {}) do
			if arg0_60.characterAgency:CheckSkinIsOwned(iter1_60) then
				table.insert(arg0_60.skinList, iter1_60)
			end
		end
	end
end

function var0_0.UpdateSkinList(arg0_61)
	local var0_61 = #arg0_61.skinList

	setActive(arg0_61.skinRectTF, var0_61 ~= 0)
	setActive(arg0_61.skinEmpty, var0_61 == 0)
	arg0_61.skinRect:SetTotalCount(var0_61)
	setText(arg0_61.skinEmptyTips, i18n("island_dress_no_item"))
end

function var0_0.UpdateDressUpList(arg0_62)
	if arg0_62.currentToggleIndex == 4 then
		return
	end

	local var0_62 = #arg0_62.dressList

	setActive(arg0_62.dressRectTF, var0_62 ~= 0)
	setActive(arg0_62.dressEmpty, var0_62 == 0)
	setText(arg0_62.dressEmptyTips, i18n("island_dress_no_item"))
	setActive(arg0_62.sortBtn, false)

	if var0_62 ~= 0 then
		arg0_62.dressRect:SetTotalCount(var0_62)
	end
end

function var0_0.OnShow(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63, arg5_63)
	arg0_63.changeDressType = arg5_63
	arg0_63.SmoothFunc = arg4_63
	arg0_63.isFirstDressUp = arg2_63

	setActive(arg0_63.color_listPanel, false)
	setActive(arg0_63.saveBtn, not arg2_63)
	setActive(arg0_63.restBtn, not arg2_63)

	arg0_63.shipDressHelper = arg3_63
	arg0_63.island = getProxy(IslandProxy):GetIsland()
	arg0_63.characterAgency = arg0_63.island:GetCharacterAgency()
	arg0_63.dressUpAgency = arg0_63.island:GetDressUpAgency()
	arg0_63.shipId = arg1_63
	arg0_63.indexData = {
		order = 1,
		sortKey = var0_0.SORT_DEFAULT
	}
	arg0_63.smothObj = smothObj

	arg0_63:InitCurDressData()
	setActive(arg0_63.dressUpConfireBtn, arg2_63)

	if arg1_63 == 0 then
		setActive(arg0_63.toggles[4], false)
		setActive(arg0_63.toggles[5], not arg2_63)
		setActive(arg0_63.toggles[6], not arg2_63)
		setActive(arg0_63.toggles[7], not arg2_63)
		triggerToggle(arg0_63.toggles[1], true)
	else
		setActive(arg0_63.toggles[4], true)
		triggerToggle(arg0_63.toggles[4], true)
	end

	if arg0_63.changeDressType then
		for iter0_63, iter1_63 in ipairs(pg.gameset.bar_not_display_dress_type.description) do
			for iter2_63, iter3_63 in pairs(var1_0) do
				if iter3_63 == iter1_63 then
					setActive(arg0_63.toggles[iter2_63], false)
				end
			end
		end
	end

	setActive(arg0_63.toggles[1], arg1_63 == 0)
	setActive(arg0_63.toggles[2], arg1_63 == 0)
	setActive(arg0_63.toggles[3], arg1_63 == 0)
	arg0_63:UpdateRightReddot()
end

function var0_0.InitCurDressData(arg0_64)
	arg0_64.curDressTypeDataDic = {}
	arg0_64.curShipDressTypeDataDic = {}
	arg0_64.dressColorDic = {}

	if arg0_64.shipId == 0 then
		local var0_64 = arg0_64.isFirstDressUp and IslandShipDressHelperNew.CommanderCustom or IslandShipDressHelperNew.DressType

		for iter0_64, iter1_64 in pairs(var0_64) do
			local var1_64 = arg0_64.isFirstDressUp and IslandShipDressHelperNew.GetInitDressByType(iter1_64) or arg0_64.dressUpAgency:GetDressByType(iter1_64)

			arg0_64.curDressTypeDataDic[iter1_64] = var1_64

			if var1_64 then
				arg0_64.dressColorDic[var1_64] = arg0_64.dressUpAgency:GetCurrentColorByDressId(var1_64)
			end
		end
	else
		arg0_64.curSkinId = arg0_64.characterAgency:GetShipById(arg0_64.shipId):GetCurSkinId()

		if arg0_64.curSkinId == 0 then
			arg0_64.curskinColorId = 0
		else
			arg0_64.curskinColorId = arg0_64.characterAgency:GetCurrentSkinColorByShipId(arg0_64.shipId, arg0_64.curSkinId)
		end

		for iter2_64, iter3_64 in pairs(IslandShipDressHelperNew.ExtraDressType) do
			local var2_64 = arg0_64.characterAgency:GetCurDressIdByShipId(arg0_64.shipId, iter3_64) or {}

			arg0_64.curShipDressTypeDataDic[iter3_64] = IslandShipDressItem.New(var2_64)
		end
	end
end

function var0_0.CheckDressIsDirty(arg0_65)
	if arg0_65.shipId == 0 then
		for iter0_65, iter1_65 in pairs(arg0_65.curDressTypeDataDic) do
			if (arg0_65.dressUpAgency:GetDressByType(iter0_65) or 0) ~= iter1_65 then
				return true
			end

			if iter1_65 ~= 0 and arg0_65.dressUpAgency:GetCurrentColorByDressId(iter1_65) ~= (arg0_65.dressColorDic[iter1_65] or 0) then
				return true
			end
		end

		return false
	else
		local var0_65 = arg0_65.characterAgency:GetShipById(arg0_65.shipId):GetCurSkinId()
		local var1_65 = arg0_65.characterAgency:GetCurrentSkinColorByShipId(arg0_65.shipId, var0_65)

		if var0_65 ~= arg0_65.curSkinId or var1_65 ~= arg0_65.curskinColorId then
			return true
		end

		for iter2_65, iter3_65 in pairs(arg0_65.curShipDressTypeDataDic) do
			local var2_65 = arg0_65.characterAgency:GetCurDressIdByShipId(arg0_65.shipId, iter2_65) or {}

			if not iter3_65:CheckIsEqualByShipDressItem(var2_65) then
				return true
			end
		end

		return false
	end
end

function var0_0.ResetDressUp(arg0_66)
	if arg0_66.shipId == 0 then
		for iter0_66, iter1_66 in pairs(IslandShipDressHelperNew.DressType) do
			local var0_66 = arg0_66.dressUpAgency:GetDressByType(iter1_66) or 0
			local var1_66 = arg0_66.dressUpAgency:GetCurrentColorByDressId(var0_66)
			local var2_66 = arg0_66.curDressTypeDataDic[iter1_66]
			local var3_66 = arg0_66.dressColorDic[var2_66]

			if var0_66 == var2_66 and var3_66 ~= var1_66 then
				arg0_66.shipDressHelper:ChangeCommanderPartColor(iter1_66, var1_66)

				return
			end

			arg0_66.shipDressHelper:ChangeDressByType(iter1_66, {
				id = var0_66,
				colorId = var1_66
			})

			arg0_66.curDressTypeDataDic[iter1_66] = var0_66
			arg0_66.dressColorDic[var0_66] = var1_66
		end

		arg0_66:UpdateDressUpList()
		arg0_66:UpdateHatDisplay()
		arg0_66:UpdateMorphDisplay()
	else
		local var4_66 = arg0_66.characterAgency:GetShipById(arg0_66.shipId)

		if (function()
			local var0_67 = var4_66:GetCurSkinId()
			local var1_67 = arg0_66.characterAgency:GetCurrentSkinColorByShipId(arg0_66.shipId, var0_67)

			if var0_67 ~= arg0_66.curSkinId or var1_67 ~= arg0_66.curskinColorId then
				arg0_66.curSkinId = var0_67
				arg0_66.curskinColorId = var1_67

				return true
			end

			return false
		end)() then
			local var5_66 = var4_66:GetModelBySkinAndColorId(arg0_66.curSkinId, arg0_66.curskinColorId)

			arg0_66.shipDressHelper:ChangeModelTransfromByUnitId(var5_66)
			arg0_66:UpdateSkinList()
			arg0_66:UpdateColorList()
		end

		local var6_66 = {
			IslandShipDressHelperNew.DressType.BackDecorate,
			IslandShipDressHelperNew.DressType.Flotage,
			IslandShipDressHelperNew.DressType.Footprint
		}

		for iter2_66, iter3_66 in ipairs(var6_66) do
			local var7_66 = arg0_66.characterAgency:GetCurDressIdByShipId(arg0_66.shipId, iter3_66) or {}

			arg0_66.shipDressHelper:ChangeDressByType(iter3_66, {
				colorId = 0,
				id = var7_66.dress_id or 0
			})

			arg0_66.curShipDressTypeDataDic[iter3_66] = IslandShipDressItem.New(var7_66)
		end

		arg0_66:UpdateDressUpList()
	end
end

function var0_0.CheckShipCanSave(arg0_68)
	local var0_68 = true

	if not arg0_68.characterAgency:CheckSkinIsOwned(arg0_68.curSkinId) then
		arg0_68.curSkinId = arg0_68.characterAgency:GetShipById(arg0_68.shipId):GetCurSkinId()
		var0_68 = false
	end

	if arg0_68.curSkinId ~= 0 and not arg0_68.characterAgency:CheckSkinColorIsOwned(arg0_68.curSkinId, arg0_68.curskinColorId) then
		arg0_68.curskinColorId = arg0_68.characterAgency:GetCurrentSkinColorByShipId(arg0_68.shipId, arg0_68.curSkinId)
		var0_68 = false
	end

	return var0_68
end

function var0_0.SaveDressUpDataHandle(arg0_69, arg1_69)
	if arg0_69.shipId == 0 then
		arg0_69:SaveDressUpData(arg1_69)
	else
		if not arg0_69:CheckShipCanSave() then
			local var0_69 = arg0_69.characterAgency:GetShipById(arg0_69.shipId):GetModelBySkinAndColorId(arg0_69.curSkinId, arg0_69.curskinColorId)

			arg0_69.shipDressHelper:ChangeModelTransfromByUnitId(var0_69)
			arg0_69:UpdateSkinList()
			arg0_69:UpdateColorList()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save2"))
			existCall(arg1_69)

			return
		end

		arg0_69:SaveDressUpData(arg1_69)
	end
end

function var0_0.SaveDressUpData(arg0_70, arg1_70)
	if arg0_70.shipId == 0 then
		local var0_70, var1_70 = (function()
			local var0_71 = {}
			local var1_71 = {}

			for iter0_71, iter1_71 in pairs(arg0_70.curDressTypeDataDic) do
				local var2_71 = arg0_70.dressUpAgency:GetDressByType(iter0_71)
				local var3_71 = false

				if iter1_71 ~= var2_71 then
					var3_71 = true
				end

				if iter0_71 == IslandShipDressHelperNew.DressType.Hat and iter1_71 == 0 then
					var3_71 = true
				end

				if var3_71 then
					table.insert(var0_71, {
						type = iter0_71,
						id = iter1_71
					})
				end

				local var4_71 = arg0_70.dressColorDic[iter1_71] or 0

				if arg0_70.dressUpAgency:GetCurrentColorByDressId(iter1_71) ~= var4_71 then
					table.insert(var1_71, {
						id = iter1_71,
						color = var4_71
					})
				end
			end

			return var0_71, var1_71
		end)()

		pg.m02:sendNotification(GAME.ISLAND_CHANGE_COMMANDER_DRESS, {
			dress_List = var0_70,
			color_list = var1_70,
			island_id = arg0_70.island.id
		})
		existCall(arg1_70)
	else
		local var2_70 = {}
		local var3_70 = {}
		local var4_70 = {}
		local var5_70 = {}

		for iter0_70, iter1_70 in pairs(arg0_70.curShipDressTypeDataDic) do
			local var6_70 = arg0_70.characterAgency:GetCurDressIdByShipId(arg0_70.shipId, iter0_70) or {}

			if not iter1_70:CheckIsEqualByShipDressItem(var6_70) then
				if not iter1_70.dress_id then
					table.insert(var3_70, var6_70.dress_id)
				elseif iter1_70.ship_id ~= 0 then
					if var6_70.dress_id then
						table.insert(var5_70, var6_70.dress_id)
					end

					table.insert(var4_70, {
						ship_id = iter1_70.ship_id,
						dress_id = iter1_70.dress_id
					})
				else
					if var6_70.dress_id then
						table.insert(var3_70, var6_70.dress_id)
					end

					table.insert(var2_70, {
						ship_id = iter1_70.ship_id,
						dress_id = iter1_70.dress_id
					})
				end
			end
		end

		local function var7_70()
			pg.m02:sendNotification(GAME.ISLAND_CHANGE_DRESS, {
				dress_List = var2_70,
				unload_dress = var3_70,
				ship_id = arg0_70.shipId,
				skin_id = arg0_70.curSkinId,
				color_id = arg0_70.curskinColorId
			})

			if arg0_70.changeDressType then
				pg.m02:sendNotification(GAME.ISLAND_CHEATER_CHANGE_VIEW_DRESSID, {
					type = arg0_70.changeDressType,
					game_type = PlayRoomTools.GetGameTypeID(),
					ship_id = arg0_70.shipId
				})
			end
		end

		if #var4_70 == 0 then
			var7_70()
			existCall(arg1_70)

			return
		end

		arg0_70:ShowMsgBox({
			type = IslandMsgBox.TYPE_DRESS_WEAR_CONFIRE,
			content = i18n("island_dress_replace_tip"),
			needconfirmDressList = var4_70,
			onYes = function()
				for iter0_73, iter1_73 in ipairs(var4_70) do
					table.insert(var2_70, iter1_73)
				end

				for iter2_73, iter3_73 in ipairs(var5_70) do
					table.insert(var3_70, iter3_73)
				end

				var7_70()
				existCall(arg1_70)
			end,
			onNo = function()
				existCall(arg1_70)
			end
		})
	end
end

function var0_0.CheckInReturn(arg0_75, arg1_75)
	if arg0_75.morphing then
		return
	end

	if not arg0_75:CheckDressIsDirty() then
		existCall(arg1_75)

		return
	end

	if not arg0_75:CheckShipCanSave() then
		existCall(arg1_75)
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_exit2"))

		return
	end

	arg0_75:ShowMsgBox({
		type = IslandMsgBox.TYPE_COMMON,
		content = i18n("island_dressup_tip_1"),
		onYes = function()
			arg0_75:SaveDressUpDataHandle(arg1_75)
		end,
		onNo = function()
			existCall(arg1_75)
		end
	})
end

function var0_0.OnChangeRoleDressDone(arg0_78)
	for iter0_78, iter1_78 in pairs(arg0_78.curShipDressTypeDataDic) do
		local var0_78 = arg0_78.characterAgency:GetCurDressIdByShipId(arg0_78.shipId, iter0_78) or {}

		arg0_78.curShipDressTypeDataDic[iter0_78] = IslandShipDressItem.New(var0_78)
	end

	arg0_78:GetDressUpList()
	arg0_78:UpdateDressUpList()
end

function var0_0.OnSendRoleDressReadDone(arg0_79, arg1_79)
	for iter0_79, iter1_79 in ipairs(arg1_79) do
		for iter2_79, iter3_79 in ipairs(arg0_79.dressList) do
			if iter3_79.id == iter1_79 and iter3_79.needRedDot then
				iter3_79.needRedDot = false
			end
		end
	end

	arg0_79:UpdateDressUpList()
	arg0_79:UpdateRightReddot()
end

function var0_0.OnBuyRoleSkinColorDone(arg0_80)
	arg0_80:UpdateColorList()
end

function var0_0.OnBuyRoleDressColorDone(arg0_81)
	arg0_81:UpdateColorList(true)
end

function var0_0.GetBuySkindDone(arg0_82)
	arg0_82:UpdateSkinList()
end

function var0_0.UpdateRightReddot(arg0_83)
	local var0_83 = arg0_83.shipId == 0 and {
		1,
		2,
		3,
		5,
		6,
		7
	} or {
		5,
		6,
		7
	}

	for iter0_83, iter1_83 in ipairs(var0_83) do
		local var1_83 = arg0_83.toggles[iter1_83]:Find("red_dot")
		local var2_83 = false
		local var3_83 = var1_0[iter1_83]

		if arg0_83.shipId == 0 then
			var2_83 = arg0_83.dressUpAgency:CheckRedDotByDressType(var3_83)
		else
			var2_83 = arg0_83.characterAgency:CheckRedDotByDressType(var3_83)
		end

		setActive(var1_83, var2_83)
	end
end

function var0_0.UpdateColorPanel(arg0_84)
	if not (function()
		if arg0_84.isDressColor then
			local var0_85 = arg0_84.curDressTypeDataDic[arg0_84.dressType]

			if not var0_85 or var0_85 == 0 then
				return false
			end

			return #(pg.island_dress_colordiff_template.get_id_list_by_belongto_dress[var0_85] or {}) > 0
		end

		if not (arg0_84.curSkinId ~= 0 and arg0_84.curSkinId or nil) then
			return false
		end

		return true
	end)() then
		setActive(arg0_84.color_listPanel, false)

		return
	end

	setActive(arg0_84.color_listPanel, true)
end

function var0_0.UpdateColorUnlockState(arg0_86)
	local var0_86
	local var1_86
	local var2_86

	if arg0_86.isDressColor then
		var2_86 = arg0_86.curDressTypeDataDic[arg0_86.dressType]

		if not var2_86 or var2_86 == 0 then
			return true
		end

		var1_86 = arg0_86.dressColorDic[var2_86] or 0
		var0_86 = pg.island_dress_colordiff_template[var1_86]
	else
		var0_86 = pg.island_skin_colordiff_template[arg0_86.curskinColorId]
	end

	local var3_86, var4_86 = (function()
		if arg0_86.isDressColor then
			if arg0_86.shipId == 0 then
				if arg0_86.dressUpAgency:CheckDressColorIsOwned(var2_86, var1_86) then
					return true
				end
			else
				return true
			end

			return false, true
		else
			if not arg0_86.curskinColorId or arg0_86.curskinColorId == 0 then
				return true
			end

			if arg0_86.characterAgency:CheckSkinColorIsOwned(arg0_86.curSkinId, arg0_86.curskinColorId) then
				return true
			end

			local var0_87 = arg0_86.characterAgency:CheckSkinIsOwned(arg0_86.curSkinId)

			return false, var0_87
		end
	end)()

	if var3_86 then
		setActive(arg0_86.color_bg_unlock, true)
		setActive(arg0_86.color_bg_locked, false)
	else
		setActive(arg0_86.color_bg_unlock, false)
		setActive(arg0_86.color_bg_locked, true)

		local var5_86 = pg.island_item_data_template[var0_86.cost[1][1]]

		GetImageSpriteFromAtlasAsync("island/" .. var5_86.icon, "", arg0_86.color_cost_item_icon)

		local var6_86 = var0_86.cost[1][2]

		setText(arg0_86.color_cost_item_count, "×" .. var6_86)
		setActive(arg0_86.color_lockedBtn, var4_86)
	end

	onButton(arg0_86, arg0_86.color_lockedBtn, function()
		local function var0_88()
			if arg0_86.isDressColor then
				pg.m02:sendNotification(GAME.ISLAND_BUY_ROLE_DRESS_COLOR, {
					id = arg0_86.shipId,
					dress_id = var2_86,
					color_id = var1_86
				})
			else
				pg.m02:sendNotification(GAME.ISLAND_BUY_ROLE_SKIN_COLOR, {
					ship_id = arg0_86.shipId,
					skin_id = arg0_86.curSkinId,
					color_id = arg0_86.curskinColorId
				})
			end
		end

		local var1_88 = pg.island_item_data_template[var0_86.cost[1][1]]
		local var2_88 = i18n("island_dress_color_buy", var1_88.name .. "x" .. var0_86.cost[1][2])

		arg0_86:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = var2_88,
			onYes = function()
				if not (function(arg0_91)
					local var0_91 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

					for iter0_91, iter1_91 in ipairs(arg0_91) do
						local var1_91 = iter1_91[1]

						if iter1_91[2] > var0_91:GetOwnCount(var1_91) then
							return false
						end
					end

					return true
				end)(var0_86.cost) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				end

				var0_88()
			end,
			onNo = function()
				return
			end
		})
	end)
end

function var0_0.UpdateColorItemList(arg0_93)
	(function()
		arg0_93.colorItemList = {}

		if arg0_93.isDressColor then
			local var0_94 = arg0_93.curDressTypeDataDic[arg0_93.dressType]
			local var1_94 = arg0_93.dressColorDic[var0_94]
			local var2_94 = pg.island_dress_colordiff_template.get_id_list_by_belongto_dress[var0_94] or {}

			if #var2_94 > 0 then
				local var3_94 = var1_94 == 0
				local var4_94 = true

				table.insert(arg0_93.colorItemList, {
					itemId = 0,
					selected = var3_94,
					owned = var4_94
				})

				for iter0_94, iter1_94 in ipairs(var2_94) do
					local var5_94 = var1_94 == iter1_94
					local var6_94 = arg0_93.dressUpAgency:CheckDressColorIsOwned(var0_94, iter1_94)

					table.insert(arg0_93.colorItemList, {
						itemId = iter1_94,
						selected = var5_94,
						owned = var6_94,
						costItemIcon = pg.island_dress_colordiff_template[iter1_94].color_icon
					})
				end
			end
		else
			local var7_94 = pg.island_skin_colordiff_template.get_id_list_by_skin_group[arg0_93.curSkinId] or {}
			local var8_94 = arg0_93.curskinColorId == 0
			local var9_94 = arg0_93.characterAgency:CheckSkinIsOwned(arg0_93.curSkinId)

			table.insert(arg0_93.colorItemList, {
				itemId = 0,
				selected = var8_94,
				owned = var9_94
			})

			for iter2_94, iter3_94 in ipairs(var7_94) do
				local var10_94 = arg0_93.curskinColorId == iter3_94
				local var11_94 = arg0_93.characterAgency:CheckSkinColorIsOwned(arg0_93.curSkinId, iter3_94)

				table.insert(arg0_93.colorItemList, {
					itemId = iter3_94,
					selected = var10_94,
					owned = var11_94,
					costItemIcon = pg.island_skin_colordiff_template[iter3_94].color_icon
				})
			end
		end
	end)()
	arg0_93.colorItemUIList:make(function(arg0_95, arg1_95, arg2_95)
		if arg0_95 == UIItemList.EventUpdate then
			arg1_95 = arg1_95 + 1

			local var0_95 = arg0_93.colorItemList[arg1_95]

			setActive(arg2_95:Find("select"), var0_95.selected)

			local var1_95 = var0_95.itemId

			setActive(arg2_95:Find("orginName"), var1_95 == 0)
			setActive(arg2_95:Find("locked"), var1_95 == 0)
			setActive(arg2_95:Find("icon"), false)

			if var0_95.costItemIcon then
				setActive(arg2_95:Find("icon"), true)
				GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. var0_95.costItemIcon, "", arg2_95:Find("icon"))
			end

			setActive(arg2_95:Find("locked"), not var0_95.owned)
			onButton(arg0_93, arg2_95, function()
				if arg0_93.isDressColor then
					local var0_96 = arg0_93.curDressTypeDataDic[arg0_93.dressType]
					local var1_96 = arg0_93.dressColorDic[var0_96]

					if var1_95 == var1_96 then
						return
					end

					arg0_93.dressColorDic[var0_96] = var1_95

					arg0_93.shipDressHelper:ChangeCommanderPartColor(arg0_93.dressType, var1_95)
				else
					if var1_95 == arg0_93.curskinColorId then
						return
					end

					arg0_93.curskinColorId = var1_95

					arg0_93:ChangeModelBySkinAndSkinColor()
				end

				arg0_93:UpdateColorList(arg0_93.isDressColor)
			end)
		end
	end)
	arg0_93.colorItemUIList:align(#arg0_93.colorItemList)
end

function var0_0.UpdateColorList(arg0_97, arg1_97)
	arg0_97.isDressColor = arg1_97

	arg0_97:UpdateColorPanel()
	arg0_97:UpdateColorUnlockState()
	arg0_97:UpdateColorItemList()
end

function var0_0.OnHide(arg0_98)
	return
end

function var0_0.OnDestroy(arg0_99)
	if arg0_99.shipDressHelper then
		arg0_99.shipDressHelper:StopMorphSwitch()
	end

	arg0_99:SetMorphBlock(false)
	ClearLScrollrect(arg0_99.dressRect)
	ClearLScrollrect(arg0_99.skinRect)

	for iter0_99, iter1_99 in pairs(arg0_99.dressCards or {}) do
		iter1_99:Dispose()
	end

	arg0_99.dressCards = nil

	for iter2_99, iter3_99 in pairs(arg0_99.skinCards or {}) do
		iter3_99:Dispose()
	end

	arg0_99.skinCards = nil

	if arg0_99.dressDetailPopup then
		arg0_99.dressDetailPopup:Destroy()

		arg0_99.dressDetailPopup = nil
	end
end

return var0_0
