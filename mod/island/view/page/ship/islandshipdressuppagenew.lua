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
	arg0_3.rightPanel = arg0_3:findTF("adapt/right_panel")
	arg0_3.togglePanel = arg0_3.rightPanel:Find("toggles/select_toggles")
	arg0_3.saveBtn = arg0_3:findTF("adapt/save")
	arg0_3.restBtn = arg0_3:findTF("adapt/reset")

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
	arg0_3.dressUpConfireBtn = arg0_3:findTF("adapt/confire")
	arg0_3.dressUpConfireText = arg0_3:findTF("adapt/confire/Text")

	setText(arg0_3.dressUpConfireText, i18n("island_dress_initial_makesure"))

	arg0_3.colorList = arg0_3:findTF("adapt/left_color_panel/colorList")
	arg0_3.colorItem = arg0_3:findTF("adapt/left_color_panel/colorList/item")
	arg0_3.color_listPanel = arg0_3:findTF("adapt/left_color_panel")
	arg0_3.color_bg_unlock = arg0_3:findTF("adapt/left_color_panel/bg1")
	arg0_3.color_bg_locked = arg0_3:findTF("adapt/left_color_panel/bglocked")
	arg0_3.color_lockedBtn = arg0_3.color_bg_locked:Find("unlockedBtn")
	arg0_3.color_cost_item_icon = arg0_3.color_bg_locked:Find("itemcost")
	arg0_3.color_cost_item_count = arg0_3.color_bg_locked:Find("cost_num")

	setActive(arg0_3.sortBtn, false)

	arg0_3.colorItemUIList = UIItemList.New(arg0_3.colorList, arg0_3.colorItem)
	arg0_3.hatTF = arg0_3:findTF("adapt/hat")
	arg0_3.hatOn = arg0_3.hatTF:Find("hatOn")
	arg0_3.hatOff = arg0_3.hatTF:Find("hatOff")
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

		arg0_9.dressRect:SetTotalCount(var5_9, 0)

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

	arg0_9.curDressTypeDataDic[arg0_9.dressType] = var7_9

	local var9_9 = (function()
		local var0_10 = 0

		if var7_9 ~= 0 and arg0_9.shipId == 0 then
			var0_10 = arg0_9.dressUpAgency:GetCurrentColorByDressId(var7_9)
			arg0_9.dressColorDic[var7_9] = var0_10
		end

		return var0_10
	end)()

	arg0_9.shipDressHelper:ChangeDressByType(arg0_9.dressType, {
		id = var7_9,
		colorId = var9_9
	})

	local var10_9 = #arg0_9.dressList

	arg0_9.dressRect:SetTotalCount(var10_9, 0)
	arg0_9:UpdateHatDisplay()
	arg0_9:UpdateColorList(true)
end

function var0_0.UpdateHatToggleDisplay(arg0_11, arg1_11)
	setActive(arg0_11.hatOn, not arg1_11)
	setActive(arg0_11.hatOff, arg1_11)
end

function var0_0.UpdateHatDisplay(arg0_12)
	if arg0_12.dressType ~= IslandShipDressHelperNew.DressType.Body then
		setActive(arg0_12.hatTF, false)

		return
	end

	local var0_12 = arg0_12.curDressTypeDataDic[arg0_12.dressType]

	if not var0_12 or var0_12 == 0 then
		setActive(arg0_12.hatTF, false)

		return
	end

	local var1_12 = (pg.island_dress_template.get_id_list_by_related_dress[var0_12] or {})[1]

	if not var1_12 then
		setActive(arg0_12.hatTF, false)

		return
	end

	setActive(arg0_12.hatTF, true)

	local var2_12 = pg.island_dress_template[var1_12].type
	local var3_12 = arg0_12.dressUpAgency:GetBodyHatIsOn(var0_12, var1_12)

	arg0_12.shipDressHelper:ChangeDressByType(var2_12, {
		id = var3_12 and var1_12 or 0
	})

	arg0_12.curDressTypeDataDic[var2_12] = var3_12 and var1_12 or 0

	arg0_12:UpdateHatToggleDisplay(var3_12)
	onButton(arg0_12, arg0_12.hatOn, function()
		if arg0_12.curDressTypeDataDic[var2_12] ~= var1_12 then
			arg0_12.curDressTypeDataDic[var2_12] = var1_12

			arg0_12.shipDressHelper:ChangeDressByType(var2_12, {
				id = var1_12
			})
			arg0_12:UpdateHatToggleDisplay(true)
		end
	end)
	onButton(arg0_12, arg0_12.hatOff, function()
		if arg0_12.curDressTypeDataDic[var2_12] ~= 0 then
			arg0_12.curDressTypeDataDic[var2_12] = 0

			arg0_12.shipDressHelper:ChangeDressByType(var2_12, {
				id = 0
			})
			arg0_12:UpdateHatToggleDisplay(false)
		end
	end)
end

function var0_0.OnDressInitItem(arg0_15, arg1_15)
	local var0_15 = IslandDressCard.New(arg1_15)

	arg0_15.dressCards[arg1_15] = var0_15
end

function var0_0.OnDressUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.dressCards[arg2_16]

	if not var0_16 then
		arg0_16:OnDressInitItem(arg2_16)

		var0_16 = arg0_16.dressCards[arg2_16]
	end

	local var1_16 = arg0_16.dressList[arg1_16 + 1]

	setActive(var0_16.canSendTF, false)

	local var2_16 = var1_16.ownCount ~= nil

	setActive(var0_16.ownNumTF, var2_16)

	if var2_16 then
		setText(var0_16.ownNumText, "×" .. var1_16.ownCount)
	end

	local var3_16 = var1_16.holdedShipId ~= nil

	setActive(var0_16.shipHoldTF, var3_16)

	if var3_16 then
		local var4_16 = IslandShip.StaticGetPrefab(var1_16.holdedShipId)

		GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var4_16, "", var0_16.shipIcon)
	end

	setActive(var0_16.redDot, var1_16.needRedDot)

	local var5_16
	local var6_16 = var1_16.id
	local var7_16 = tf(arg2_16)

	onButton(arg0_16, var7_16, function()
		arg0_16:ClickDressCardItem(var1_16)
	end)

	local var8_16 = false

	if arg0_16.shipId == 0 then
		local var9_16 = arg0_16.curDressTypeDataDic[arg0_16.dressType]

		var8_16 = (var9_16 ~= 0 and var9_16 or nil) == var1_16.id

		setActive(var0_16.exclusionTF, false)
	else
		local var10_16, var11_16 = arg0_16:CheckDressIsExclusive(var1_16.id)
		local var12_16 = var10_16 or var11_16

		setActive(var0_16.exclusionTF, var12_16)

		var8_16 = arg0_16.curShipDressTypeDataDic[arg0_16.dressType]:CheckIsEqualByShipIdAndDressId(var1_16.holdedShipId or 0, var1_16.id)
	end

	var0_16:Update(var6_16, var8_16)
end

function var0_0.OnSkinInitItem(arg0_18, arg1_18)
	local var0_18 = IslandSkinCard.New(arg1_18)

	arg0_18.skinCards[arg1_18] = var0_18
end

function var0_0.OnSkinUpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.skinCards[arg2_19]

	if not var0_19 then
		arg0_19:OnSkinInitItem(arg2_19)

		var0_19 = arg0_19.skinCards[arg2_19]
	end

	local var1_19 = arg0_19.skinList[arg1_19 + 1]
	local var2_19 = tf(arg2_19)
	local var3_19 = #pg.island_skin_colordiff_template.get_id_list_by_skin_group[var1_19] or {}

	setActive(var2_19:Find("changeColor"), var3_19 > 0)

	local var4_19 = arg0_19.curSkinId
	local var5_19 = var4_19 ~= 0 and var4_19 or nil

	var0_19:Update(var1_19, var5_19)
	onButton(arg0_19, var2_19, function()
		arg0_19:ClickSkinCardItem(var1_19)
	end)
end

function var0_0.ChangeModelBySkinAndSkinColor(arg0_21)
	local var0_21 = arg0_21.characterAgency:GetShipById(arg0_21.shipId)
	local var1_21 = {}

	if arg0_21.curSkinId ~= 0 then
		local var2_21 = {
			IslandShipDressHelperNew.DressType.BackDecorate,
			IslandShipDressHelperNew.DressType.Flotage,
			IslandShipDressHelperNew.DressType.Footprint
		}

		for iter0_21, iter1_21 in ipairs(var2_21) do
			local var3_21 = arg0_21.curShipDressTypeDataDic[iter1_21]

			if var3_21 and var3_21.dress_id and var3_21.dress_id ~= 0 then
				local var4_21 = pg.island_dress_template[var3_21.dress_id].exclusive_skin
				local var5_21 = var4_21 == "" and {} or var4_21

				for iter2_21, iter3_21 in ipairs(var5_21) do
					if iter3_21 == arg0_21.curSkinId then
						table.insert(var1_21, var3_21.dress_id)
						var3_21:SetShipAndDressId(nil, nil)
					end
				end
			end
		end

		if #var1_21 > 0 then
			local var6_21 = ""

			for iter4_21, iter5_21 in ipairs(var1_21) do
				local var7_21 = pg.island_dress_template[iter5_21].name

				if iter4_21 > 1 then
					var7_21 = "," .. var7_21
				end

				var6_21 = var6_21 .. var7_21
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive", var6_21))
		end
	end

	local var8_21 = var0_21:GetModelBySkinAndColorId(arg0_21.curSkinId, arg0_21.curskinColorId)

	if #var1_21 > 0 then
		arg0_21.shipDressHelper:ChangeModelTransfromByUnitIdAndChangeDress(var8_21, var1_21, nil, nil, true)
	else
		arg0_21.shipDressHelper:ChangeModelTransfromByUnitId(var8_21, nil, true)
	end
end

function var0_0.ClickSkinCardItem(arg0_22, arg1_22)
	if arg1_22 == arg0_22.curSkinId then
		arg0_22.curSkinId = 0
	else
		arg0_22.curSkinId = arg1_22
	end

	arg0_22:UpdateSkinList()

	if arg0_22.curSkinId ~= 0 then
		arg0_22.curskinColorId = arg0_22.characterAgency:GetCurrentSkinColorByShipId(arg0_22.shipId, arg0_22.curSkinId)
	end

	arg0_22:ChangeModelBySkinAndSkinColor()
	arg0_22:UpdateColorList()
	arg0_22:UpdateHatDisplay()
end

function var0_0.ClearSkinSelected(arg0_23, arg1_23)
	return
end

function var0_0.AddListeners(arg0_24)
	arg0_24:AddListener(GAME.ISLAND_CHANGE_ROLE_DRESS_DONE, arg0_24.OnChangeRoleDressDone)
	arg0_24:AddListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_24.OnSendRoleDressReadDone)
	arg0_24:AddListener(GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE, arg0_24.OnSendRoleDressReadDone)
	arg0_24:AddListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_24.OnBuyRoleSkinColorDone)
	arg0_24:AddListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_24.OnBuyRoleDressColorDone)
	arg0_24:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_24.GetBuySkindDone)
end

function var0_0.RemoveListeners(arg0_25)
	arg0_25:RemoveListener(GAME.ISLAND_CHANGE_ROLE_DRESS_DONE, arg0_25.OnChangeRoleDressDone)
	arg0_25:RemoveListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_25.OnSendRoleDressReadDone)
	arg0_25:RemoveListener(GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE, arg0_25.OnSendRoleDressReadDone)
	arg0_25:RemoveListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_25.OnBuyRoleSkinColorDone)
	arg0_25:RemoveListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_25.OnBuyRoleDressColorDone)
	arg0_25:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_25.GetBuySkindDone)
end

function var0_0.OnClosePage(arg0_26, arg1_26)
	return
end

function var0_0.OnInit(arg0_27)
	onButton(arg0_27, arg0_27.saveBtn, function()
		if not arg0_27:CheckDressIsDirty() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))

			return
		end

		arg0_27:SaveDressUpDataHandle()
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.dressUpConfireBtn, function()
		arg0_27:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_dressup_tip"),
			onYes = function()
				arg0_27:SaveDressUpDataHandle()
			end,
			onNo = function()
				return
			end
		})
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.restBtn, function()
		arg0_27:ResetDressUp()
	end, SFX_PANEL)

	for iter0_27, iter1_27 in ipairs(arg0_27.toggles) do
		onToggle(arg0_27, iter1_27, function(arg0_33)
			if arg0_33 then
				arg0_27:SwitchPage(iter0_27)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_27, arg0_27.sortBtn, function()
		arg0_27.sortPage:ExecuteAction("Show", arg0_27.indexData, function(arg0_35)
			arg0_27:OnSort(arg0_35)
		end)
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.orderBtn, function()
		local var0_36 = 1 - arg0_27.indexData.order

		arg0_27:OnOrder(var0_36)
	end, SFX_PANEL)
end

function var0_0.OnSort(arg0_37, arg1_37)
	arg0_37.indexData.sortKey = arg1_37

	arg0_37:UpdateOrderTxt()
	arg0_37:UpdateDressUpList()
end

function var0_0.OnOrder(arg0_38, arg1_38)
	arg0_38.indexData.order = arg1_38
	arg0_38.orderBtn.localScale = Vector3(1, arg1_38 == 1 and 1 or -1, 1)

	arg0_38:UpdateDressUpList()
end

function var0_0.UpdateOrderTxt(arg0_39)
	arg0_39.orderTxt.text = var0_0.SORTCN[arg0_39.indexData.sortKey]
end

function var0_0.SwitchPage(arg0_40, arg1_40)
	arg0_40.currentToggleIndex = arg1_40

	if arg0_40.currentToggleIndex == 4 then
		setActive(arg0_40.dressTF, false)
		setActive(arg0_40.skinTF, true)
		setActive(arg0_40.hatTF, false)
		arg0_40:GetSkinList()
		arg0_40:UpdateSkinList()
		arg0_40:UpdateColorList()
	else
		arg0_40.dressType = var1_0[arg0_40.currentToggleIndex]

		if arg0_40.SmoothFunc then
			if arg0_40.dressType == IslandShipDressHelperNew.DressType.BackDecorate then
				arg0_40.SmoothFunc(Quaternion.Euler(0, 0, 0))
			else
				arg0_40.SmoothFunc(Quaternion.Euler(0, 180, 0))
			end
		end

		setActive(arg0_40.dressTF, true)
		setActive(arg0_40.skinTF, false)
		arg0_40:GetDressUpList()
		arg0_40:UpdateDressUpList()
		arg0_40:UpdateHatDisplay()
		arg0_40:UpdateOrderTxt()
		arg0_40:UpdateColorList(true)
	end
end

function var0_0.GetDressUpList(arg0_41)
	arg0_41.dressList = {}

	if arg0_41.shipId == 0 then
		for iter0_41, iter1_41 in ipairs(arg0_41.dressUpAgency:GetHasDressByType(arg0_41.dressType)) do
			local var0_41 = pg.island_dress_template[iter1_41.id].quality

			table.insert(arg0_41.dressList, IslandDressItem.New({
				id = iter1_41.id,
				quality = var0_41,
				needRedDot = iter1_41.state == 0
			}))
		end
	else
		for iter2_41, iter3_41 in pairs(arg0_41.characterAgency:GetAllOwnDressDic()) do
			if iter3_41:getConfigTable().type == arg0_41.dressType and iter3_41.num > 0 then
				local var1_41 = pg.island_dress_template[iter3_41.id].quality

				table.insert(arg0_41.dressList, IslandDressItem.New({
					id = iter3_41.id,
					ownCount = iter3_41.num,
					needRedDot = iter3_41.read == 0,
					quality = var1_41
				}))
			end
		end

		for iter4_41, iter5_41 in pairs(arg0_41.characterAgency:GetShipHoldedDressDic()) do
			for iter6_41, iter7_41 in ipairs(iter5_41) do
				if iter7_41:getConfigTable().type == arg0_41.dressType then
					local var2_41 = pg.island_dress_template[iter7_41.dress_id].quality

					table.insert(arg0_41.dressList, IslandDressItem.New({
						id = iter7_41.dress_id,
						holdedShipId = iter7_41.ship_id,
						quality = var2_41
					}))
				end
			end
		end
	end

	local var3_41

	if arg0_41.indexData.sortKey == var0_0.SORT_DEFAULT then
		var3_41 = {
			function(arg0_42)
				return arg0_42.holdedShipId and 0 or 1
			end,
			function(arg0_43)
				return arg0_43.needRedDot and 0 or 1
			end,
			function(arg0_44)
				return -arg0_44.quality
			end,
			function(arg0_45)
				return -arg0_45.id
			end
		}
	end

	table.sort(arg0_41.dressList, CompareFuncs(var3_41))
end

function var0_0.GetSkinList(arg0_46)
	if arg0_46.shipId ~= 0 then
		arg0_46.skinList = {}

		for iter0_46, iter1_46 in ipairs(pg.island_skin_template.get_id_list_by_ship_group[arg0_46.shipId] or {}) do
			if arg0_46.characterAgency:CheckSkinIsOwned(iter1_46) then
				table.insert(arg0_46.skinList, iter1_46)
			end
		end
	end
end

function var0_0.UpdateSkinList(arg0_47)
	local var0_47 = #arg0_47.skinList

	setActive(arg0_47.skinRectTF, var0_47 ~= 0)
	setActive(arg0_47.skinEmpty, var0_47 == 0)
	arg0_47.skinRect:SetTotalCount(var0_47)
end

function var0_0.UpdateDressUpList(arg0_48)
	local var0_48 = #arg0_48.dressList

	setActive(arg0_48.dressRectTF, var0_48 ~= 0)
	setActive(arg0_48.dressEmpty, var0_48 == 0)
	setText(arg0_48.dressEmptyTips, i18n("island_dress_no_item"))
	setActive(arg0_48.sortBtn, false)

	if var0_48 ~= 0 then
		arg0_48.dressRect:SetTotalCount(var0_48, 0)
	end
end

function var0_0.OnShow(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	arg0_49.SmoothFunc = arg4_49
	arg0_49.isFirstDressUp = arg2_49

	setActive(arg0_49.color_listPanel, false)
	setActive(arg0_49.saveBtn, not arg2_49)
	setActive(arg0_49.restBtn, not arg2_49)

	arg0_49.shipDressHelper = arg3_49
	arg0_49.island = getProxy(IslandProxy):GetIsland()
	arg0_49.characterAgency = arg0_49.island:GetCharacterAgency()
	arg0_49.dressUpAgency = arg0_49.island:GetDressUpAgency()
	arg0_49.shipId = arg1_49
	arg0_49.indexData = {
		order = 1,
		sortKey = var0_0.SORT_DEFAULT
	}
	arg0_49.smothObj = smothObj

	arg0_49:InitCurDressData()
	setActive(arg0_49.dressUpConfireBtn, arg2_49)

	if arg1_49 == 0 then
		setActive(arg0_49.toggles[4], false)
		setActive(arg0_49.toggles[5], not arg2_49)
		setActive(arg0_49.toggles[6], not arg2_49)
		setActive(arg0_49.toggles[7], not arg2_49)
		triggerToggle(arg0_49.toggles[1], true)
	else
		setActive(arg0_49.toggles[4], true)
		triggerToggle(arg0_49.toggles[4], true)
	end

	setActive(arg0_49.toggles[1], arg1_49 == 0)
	setActive(arg0_49.toggles[2], arg1_49 == 0)
	setActive(arg0_49.toggles[3], arg1_49 == 0)
	arg0_49:UpdateRightReddot()
end

function var0_0.InitCurDressData(arg0_50)
	arg0_50.curDressTypeDataDic = {}
	arg0_50.curShipDressTypeDataDic = {}
	arg0_50.dressColorDic = {}

	if arg0_50.shipId == 0 then
		local var0_50 = arg0_50.isFirstDressUp and IslandShipDressHelperNew.CommanderCustom or IslandShipDressHelperNew.DressType

		for iter0_50, iter1_50 in pairs(var0_50) do
			local var1_50 = arg0_50.isFirstDressUp and IslandShipDressHelperNew.GetInitDressByType(iter1_50) or arg0_50.dressUpAgency:GetDressByType(iter1_50)

			arg0_50.curDressTypeDataDic[iter1_50] = var1_50

			if var1_50 then
				arg0_50.dressColorDic[var1_50] = arg0_50.dressUpAgency:GetCurrentColorByDressId(var1_50)
			end
		end
	else
		arg0_50.curSkinId = arg0_50.characterAgency:GetShipById(arg0_50.shipId):GetCurSkinId()

		if arg0_50.curSkinId == 0 then
			arg0_50.curskinColorId = 0
		else
			arg0_50.curskinColorId = arg0_50.characterAgency:GetCurrentSkinColorByShipId(arg0_50.shipId, arg0_50.curSkinId)
		end

		for iter2_50, iter3_50 in pairs(IslandShipDressHelperNew.ExtraDressType) do
			local var2_50 = arg0_50.characterAgency:GetCurDressIdByShipId(arg0_50.shipId, iter3_50) or {}

			arg0_50.curShipDressTypeDataDic[iter3_50] = IslandShipDressItem.New(var2_50)
		end
	end
end

function var0_0.CheckDressIsDirty(arg0_51)
	if arg0_51.shipId == 0 then
		for iter0_51, iter1_51 in pairs(arg0_51.curDressTypeDataDic) do
			if (arg0_51.dressUpAgency:GetDressByType(iter0_51) or 0) ~= iter1_51 then
				return true
			end

			if iter1_51 ~= 0 and arg0_51.dressUpAgency:GetCurrentColorByDressId(iter1_51) ~= (arg0_51.dressColorDic[iter1_51] or 0) then
				return true
			end
		end

		return false
	else
		local var0_51 = arg0_51.characterAgency:GetShipById(arg0_51.shipId):GetCurSkinId()
		local var1_51 = arg0_51.characterAgency:GetCurrentSkinColorByShipId(arg0_51.shipId, var0_51)

		if var0_51 ~= arg0_51.curSkinId or var1_51 ~= arg0_51.curskinColorId then
			return true
		end

		for iter2_51, iter3_51 in pairs(arg0_51.curShipDressTypeDataDic) do
			local var2_51 = arg0_51.characterAgency:GetCurDressIdByShipId(arg0_51.shipId, iter2_51) or {}

			if not iter3_51:CheckIsEqualByShipDressItem(var2_51) then
				return true
			end
		end

		return false
	end
end

function var0_0.ResetDressUp(arg0_52)
	if arg0_52.shipId == 0 then
		for iter0_52, iter1_52 in pairs(IslandShipDressHelperNew.DressType) do
			local var0_52 = arg0_52.dressUpAgency:GetDressByType(iter1_52) or 0
			local var1_52 = arg0_52.dressUpAgency:GetCurrentColorByDressId(var0_52)
			local var2_52 = arg0_52.curDressTypeDataDic[iter1_52]
			local var3_52 = arg0_52.dressColorDic[var2_52]

			if var0_52 == var2_52 and var3_52 ~= var1_52 then
				arg0_52.shipDressHelper:ChangeCommanderPartColor(iter1_52, var1_52)

				return
			end

			arg0_52.shipDressHelper:ChangeDressByType(iter1_52, {
				id = var0_52,
				colorId = var1_52
			})

			arg0_52.curDressTypeDataDic[iter1_52] = var0_52
			arg0_52.dressColorDic[var0_52] = var1_52
		end

		local var4_52 = arg0_52.curDressTypeDataDic[IslandShipDressHelperNew.DressType.Body]
		local var5_52 = arg0_52.dressUpAgency:GetBodyHatIsOn(var4_52)

		arg0_52:UpdateHatToggleDisplay(var5_52)
		arg0_52:UpdateDressUpList()
	else
		local var6_52 = arg0_52.characterAgency:GetShipById(arg0_52.shipId)

		if (function()
			local var0_53 = var6_52:GetCurSkinId()
			local var1_53 = arg0_52.characterAgency:GetCurrentSkinColorByShipId(arg0_52.shipId, var0_53)

			if var0_53 ~= arg0_52.curSkinId or var1_53 ~= arg0_52.curskinColorId then
				arg0_52.curSkinId = var0_53
				arg0_52.curskinColorId = var1_53

				return true
			end

			return false
		end)() then
			local var7_52 = var6_52:GetModelBySkinAndColorId(arg0_52.curSkinId, arg0_52.curskinColorId)

			arg0_52.shipDressHelper:ChangeModelTransfromByUnitId(var7_52)
			arg0_52:UpdateSkinList()
			arg0_52:UpdateColorList()
		end

		local var8_52 = {
			IslandShipDressHelperNew.DressType.BackDecorate,
			IslandShipDressHelperNew.DressType.Flotage,
			IslandShipDressHelperNew.DressType.Footprint
		}

		for iter2_52, iter3_52 in ipairs(var8_52) do
			local var9_52 = arg0_52.characterAgency:GetCurDressIdByShipId(arg0_52.shipId, iter3_52) or {}

			arg0_52.shipDressHelper:ChangeDressByType(iter3_52, {
				colorId = 0,
				id = var9_52.dress_id or 0
			})

			arg0_52.curShipDressTypeDataDic[iter3_52] = IslandShipDressItem.New(var9_52)
		end

		arg0_52:UpdateDressUpList()
	end
end

function var0_0.CheckShipCanSave(arg0_54)
	local var0_54 = true

	if not arg0_54.characterAgency:CheckSkinIsOwned(arg0_54.curSkinId) then
		arg0_54.curSkinId = arg0_54.characterAgency:GetShipById(arg0_54.shipId):GetCurSkinId()
		var0_54 = false
	end

	if arg0_54.curSkinId ~= 0 and not arg0_54.characterAgency:CheckSkinColorIsOwned(arg0_54.curSkinId, arg0_54.curskinColorId) then
		arg0_54.curskinColorId = arg0_54.characterAgency:GetCurrentSkinColorByShipId(arg0_54.shipId, arg0_54.curSkinId)
		var0_54 = false
	end

	return var0_54
end

function var0_0.SaveDressUpDataHandle(arg0_55, arg1_55)
	if arg0_55.shipId == 0 then
		arg0_55:SaveDressUpData(arg1_55)
	else
		if not arg0_55:CheckShipCanSave() then
			local var0_55 = arg0_55.characterAgency:GetShipById(arg0_55.shipId):GetModelBySkinAndColorId(arg0_55.curSkinId, arg0_55.curskinColorId)

			arg0_55.shipDressHelper:ChangeModelTransfromByUnitId(var0_55)
			arg0_55:UpdateSkinList()
			arg0_55:UpdateColorList()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save2"))
			existCall(arg1_55)

			return
		end

		arg0_55:SaveDressUpData(arg1_55)
	end
end

function var0_0.SaveDressUpData(arg0_56, arg1_56)
	if arg0_56.shipId == 0 then
		local var0_56, var1_56 = (function()
			local var0_57 = {}
			local var1_57 = {}

			for iter0_57, iter1_57 in pairs(arg0_56.curDressTypeDataDic) do
				local var2_57 = arg0_56.dressUpAgency:GetDressByType(iter0_57)
				local var3_57 = false

				if iter1_57 ~= var2_57 then
					var3_57 = true
				end

				if iter0_57 == IslandShipDressHelperNew.DressType.Hat and iter1_57 == 0 then
					var3_57 = true
				end

				if var3_57 then
					table.insert(var0_57, {
						type = iter0_57,
						id = iter1_57
					})
				end

				local var4_57 = arg0_56.dressColorDic[iter1_57] or 0

				if arg0_56.dressUpAgency:GetCurrentColorByDressId(iter1_57) ~= var4_57 then
					table.insert(var1_57, {
						id = iter1_57,
						color = var4_57
					})
				end
			end

			return var0_57, var1_57
		end)()

		pg.m02:sendNotification(GAME.ISLAND_CHANGE_COMMANDER_DRESS, {
			dress_List = var0_56,
			color_list = var1_56,
			island_id = arg0_56.island.id
		})
		existCall(arg1_56)
	else
		local var2_56 = {}
		local var3_56 = {}
		local var4_56 = {}
		local var5_56 = {}

		for iter0_56, iter1_56 in pairs(arg0_56.curShipDressTypeDataDic) do
			local var6_56 = arg0_56.characterAgency:GetCurDressIdByShipId(arg0_56.shipId, iter0_56) or {}

			if not iter1_56:CheckIsEqualByShipDressItem(var6_56) then
				if not iter1_56.dress_id then
					table.insert(var3_56, var6_56.dress_id)
				elseif iter1_56.ship_id ~= 0 then
					if var6_56.dress_id then
						table.insert(var5_56, var6_56.dress_id)
					end

					table.insert(var4_56, {
						ship_id = iter1_56.ship_id,
						dress_id = iter1_56.dress_id
					})
				else
					if var6_56.dress_id then
						table.insert(var3_56, var6_56.dress_id)
					end

					table.insert(var2_56, {
						ship_id = iter1_56.ship_id,
						dress_id = iter1_56.dress_id
					})
				end
			end
		end

		local function var7_56()
			pg.m02:sendNotification(GAME.ISLAND_CHANGE_DRESS, {
				dress_List = var2_56,
				unload_dress = var3_56,
				ship_id = arg0_56.shipId,
				skin_id = arg0_56.curSkinId,
				color_id = arg0_56.curskinColorId
			})
		end

		if #var4_56 == 0 then
			var7_56()
			existCall(arg1_56)

			return
		end

		arg0_56:ShowMsgBox({
			type = IslandMsgBox.TYPE_DRESS_WEAR_CONFIRE,
			content = i18n("island_dress_replace_tip"),
			needconfirmDressList = var4_56,
			onYes = function()
				for iter0_59, iter1_59 in ipairs(var4_56) do
					table.insert(var2_56, iter1_59)
				end

				for iter2_59, iter3_59 in ipairs(var5_56) do
					table.insert(var3_56, iter3_59)
				end

				var7_56()
				existCall(arg1_56)
			end,
			onNo = function()
				existCall(arg1_56)
			end
		})
	end
end

function var0_0.CheckInReturn(arg0_61, arg1_61)
	if not arg0_61:CheckDressIsDirty() then
		existCall(arg1_61)

		return
	end

	if not arg0_61:CheckShipCanSave() then
		existCall(arg1_61)
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_exit2"))

		return
	end

	arg0_61:ShowMsgBox({
		type = IslandMsgBox.TYPE_COMMON,
		content = i18n("island_dressup_tip_1"),
		onYes = function()
			arg0_61:SaveDressUpDataHandle(arg1_61)
		end,
		onNo = function()
			existCall(arg1_61)
		end
	})
end

function var0_0.OnChangeRoleDressDone(arg0_64)
	for iter0_64, iter1_64 in pairs(arg0_64.curShipDressTypeDataDic) do
		local var0_64 = arg0_64.characterAgency:GetCurDressIdByShipId(arg0_64.shipId, iter0_64) or {}

		arg0_64.curShipDressTypeDataDic[iter0_64] = IslandShipDressItem.New(var0_64)
	end

	arg0_64:GetDressUpList()
	arg0_64:UpdateDressUpList()
end

function var0_0.OnSendRoleDressReadDone(arg0_65, arg1_65)
	for iter0_65, iter1_65 in ipairs(arg1_65) do
		for iter2_65, iter3_65 in ipairs(arg0_65.dressList) do
			if iter3_65.id == iter1_65 and iter3_65.needRedDot then
				iter3_65.needRedDot = false
			end
		end
	end

	arg0_65:UpdateDressUpList()
	arg0_65:UpdateRightReddot()
end

function var0_0.OnBuyRoleSkinColorDone(arg0_66)
	arg0_66:UpdateColorList()
end

function var0_0.OnBuyRoleDressColorDone(arg0_67)
	arg0_67:UpdateColorList(true)
end

function var0_0.GetBuySkindDone(arg0_68)
	arg0_68:UpdateSkinList()
end

function var0_0.UpdateRightReddot(arg0_69)
	local var0_69 = arg0_69.shipId == 0 and {
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

	for iter0_69, iter1_69 in ipairs(var0_69) do
		local var1_69 = arg0_69.toggles[iter1_69]:Find("red_dot")
		local var2_69 = false
		local var3_69 = var1_0[iter1_69]

		if arg0_69.shipId == 0 then
			var2_69 = arg0_69.dressUpAgency:CheckRedDotByDressType(var3_69)
		else
			var2_69 = arg0_69.characterAgency:CheckRedDotByDressType(var3_69)
		end

		setActive(var1_69, var2_69)
	end
end

function var0_0.UpdateColorPanel(arg0_70)
	if not (function()
		if arg0_70.isDressColor then
			local var0_71 = arg0_70.curDressTypeDataDic[arg0_70.dressType]

			if not var0_71 or var0_71 == 0 then
				return false
			end

			return #(pg.island_dress_colordiff_template.get_id_list_by_belongto_dress[var0_71] or {}) > 0
		end

		if not (arg0_70.curSkinId ~= 0 and arg0_70.curSkinId or nil) then
			return false
		end

		return true
	end)() then
		setActive(arg0_70.color_listPanel, false)

		return
	end

	setActive(arg0_70.color_listPanel, true)
end

function var0_0.UpdateColorUnlockState(arg0_72)
	local var0_72
	local var1_72
	local var2_72

	if arg0_72.isDressColor then
		var2_72 = arg0_72.curDressTypeDataDic[arg0_72.dressType]

		if not var2_72 or var2_72 == 0 then
			return true
		end

		var1_72 = arg0_72.dressColorDic[var2_72] or 0
		var0_72 = pg.island_dress_colordiff_template[var1_72]
	else
		var0_72 = pg.island_skin_colordiff_template[arg0_72.curskinColorId]
	end

	local var3_72, var4_72 = (function()
		if arg0_72.isDressColor then
			if arg0_72.shipId == 0 then
				if arg0_72.dressUpAgency:CheckDressColorIsOwned(var2_72, var1_72) then
					return true
				end
			else
				return true
			end

			return false, true
		else
			if not arg0_72.curskinColorId or arg0_72.curskinColorId == 0 then
				return true
			end

			if arg0_72.characterAgency:CheckSkinColorIsOwned(arg0_72.curSkinId, arg0_72.curskinColorId) then
				return true
			end

			local var0_73 = arg0_72.characterAgency:CheckSkinIsOwned(arg0_72.curSkinId)

			return false, var0_73
		end
	end)()

	if var3_72 then
		setActive(arg0_72.color_bg_unlock, true)
		setActive(arg0_72.color_bg_locked, false)
	else
		setActive(arg0_72.color_bg_unlock, false)
		setActive(arg0_72.color_bg_locked, true)

		local var5_72 = pg.island_item_data_template[var0_72.cost[1][1]]

		GetImageSpriteFromAtlasAsync("island/" .. var5_72.icon, "", arg0_72.color_cost_item_icon)

		local var6_72 = var0_72.cost[1][2]

		setText(arg0_72.color_cost_item_count, "×" .. var6_72)
		setActive(arg0_72.color_lockedBtn, var4_72)
	end

	onButton(arg0_72, arg0_72.color_lockedBtn, function()
		local function var0_74()
			if arg0_72.isDressColor then
				pg.m02:sendNotification(GAME.ISLAND_BUY_ROLE_DRESS_COLOR, {
					id = arg0_72.shipId,
					dress_id = var2_72,
					color_id = var1_72
				})
			else
				pg.m02:sendNotification(GAME.ISLAND_BUY_ROLE_SKIN_COLOR, {
					ship_id = arg0_72.shipId,
					skin_id = arg0_72.curSkinId,
					color_id = arg0_72.curskinColorId
				})
			end
		end

		local var1_74 = pg.island_item_data_template[var0_72.cost[1][1]]
		local var2_74 = i18n("island_dress_color_buy", var1_74.name .. "x" .. var0_72.cost[1][2])

		arg0_72:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = var2_74,
			onYes = function()
				if not (function(arg0_77)
					local var0_77 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

					for iter0_77, iter1_77 in ipairs(arg0_77) do
						local var1_77 = iter1_77[1]

						if iter1_77[2] > var0_77:GetOwnCount(var1_77) then
							return false
						end
					end

					return true
				end)(var0_72.cost) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ShowTips"))

					return
				end

				var0_74()
			end,
			onNo = function()
				return
			end
		})
	end)
end

function var0_0.UpdateColorItemList(arg0_79)
	(function()
		arg0_79.colorItemList = {}

		if arg0_79.isDressColor then
			local var0_80 = arg0_79.curDressTypeDataDic[arg0_79.dressType]
			local var1_80 = arg0_79.dressColorDic[var0_80]
			local var2_80 = pg.island_dress_colordiff_template.get_id_list_by_belongto_dress[var0_80] or {}

			if #var2_80 > 0 then
				local var3_80 = var1_80 == 0
				local var4_80 = true

				table.insert(arg0_79.colorItemList, {
					itemId = 0,
					selected = var3_80,
					owned = var4_80
				})

				for iter0_80, iter1_80 in ipairs(var2_80) do
					local var5_80 = var1_80 == iter1_80
					local var6_80 = arg0_79.dressUpAgency:CheckDressColorIsOwned(var0_80, iter1_80)

					table.insert(arg0_79.colorItemList, {
						itemId = iter1_80,
						selected = var5_80,
						owned = var6_80,
						costItemIcon = pg.island_dress_colordiff_template[iter1_80].color_icon
					})
				end
			end
		else
			local var7_80 = pg.island_skin_colordiff_template.get_id_list_by_skin_group[arg0_79.curSkinId] or {}

			if #var7_80 > 0 then
				local var8_80 = arg0_79.curskinColorId == 0
				local var9_80 = arg0_79.characterAgency:CheckSkinIsOwned(arg0_79.curSkinId)

				table.insert(arg0_79.colorItemList, {
					itemId = 0,
					selected = var8_80,
					owned = var9_80
				})

				for iter2_80, iter3_80 in ipairs(var7_80) do
					local var10_80 = arg0_79.curskinColorId == iter3_80
					local var11_80 = arg0_79.characterAgency:CheckSkinColorIsOwned(arg0_79.curSkinId, iter3_80)

					table.insert(arg0_79.colorItemList, {
						itemId = iter3_80,
						selected = var10_80,
						owned = var11_80,
						costItemIcon = pg.island_skin_colordiff_template[iter3_80].color_icon
					})
				end
			end
		end
	end)()
	arg0_79.colorItemUIList:make(function(arg0_81, arg1_81, arg2_81)
		if arg0_81 == UIItemList.EventUpdate then
			arg1_81 = arg1_81 + 1

			local var0_81 = arg0_79.colorItemList[arg1_81]

			setActive(arg2_81:Find("select"), var0_81.selected)

			local var1_81 = var0_81.itemId

			setActive(arg2_81:Find("orginName"), var1_81 == 0)
			setActive(arg2_81:Find("locked"), var1_81 == 0)
			setActive(arg2_81:Find("icon"), false)

			if var0_81.costItemIcon then
				setActive(arg2_81:Find("icon"), true)
				GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. var0_81.costItemIcon, "", arg2_81:Find("icon"))
			end

			setActive(arg2_81:Find("locked"), not var0_81.owned)
			onButton(arg0_79, arg2_81, function()
				if arg0_79.isDressColor then
					local var0_82 = arg0_79.curDressTypeDataDic[arg0_79.dressType]
					local var1_82 = arg0_79.dressColorDic[var0_82]

					if var1_81 == var1_82 then
						return
					end

					arg0_79.dressColorDic[var0_82] = var1_81

					arg0_79.shipDressHelper:ChangeCommanderPartColor(arg0_79.dressType, var1_81)
				else
					if var1_81 == arg0_79.curskinColorId then
						return
					end

					arg0_79.curskinColorId = var1_81

					arg0_79:ChangeModelBySkinAndSkinColor()
				end

				arg0_79:UpdateColorList(arg0_79.isDressColor)
			end)
		end
	end)
	arg0_79.colorItemUIList:align(#arg0_79.colorItemList)
end

function var0_0.UpdateColorList(arg0_83, arg1_83)
	arg0_83.isDressColor = arg1_83

	arg0_83:UpdateColorPanel()
	arg0_83:UpdateColorUnlockState()
	arg0_83:UpdateColorItemList()
end

function var0_0.OnHide(arg0_84)
	return
end

function var0_0.OnDestroy(arg0_85)
	for iter0_85, iter1_85 in pairs(arg0_85.dressCards or {}) do
		-- block empty
	end

	arg0_85.dressCards = nil
end

return var0_0
