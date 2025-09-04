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
	arg0_3.dressUpConfireBtn = arg0_3:findTF("confire")
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

function var0_0.ClickDressCardItem(arg0_8, arg1_8)
	local var0_8 = table.contains(IslandShipDressHelperNew.CommanderCustom, arg0_8.dressType)

	if arg0_8.curDressTypeDataDic[arg0_8.dressType] == arg1_8 then
		if var0_8 then
			return
		else
			arg1_8 = 0
		end
	end

	arg0_8.curDressTypeDataDic[arg0_8.dressType] = arg1_8

	local var1_8 = getProxy(IslandProxy):GetIsland()
	local var2_8 = (function()
		local var0_9 = 0

		if arg1_8 ~= 0 and arg0_8.shipId == 0 then
			var0_9 = var1_8:GetDressUpAgency():GetCurrentColorByDressId(arg1_8)
			arg0_8.dressColorDic[arg1_8] = var0_9
		end

		return var0_9
	end)()

	arg0_8.shipDressHelper:ChangeDressByType(arg0_8.dressType, {
		id = arg1_8,
		colorId = var2_8
	})

	local var3_8 = #arg0_8.dressList

	arg0_8.dressRect:SetTotalCount(var3_8, 0)
	arg0_8:UpdateHatDisplay()
	arg0_8:UpdateColorList(true)
end

function var0_0.UpdateHatToggleDisplay(arg0_10, arg1_10)
	setActive(arg0_10.hatOn, not arg1_10)
	setActive(arg0_10.hatOff, arg1_10)
end

function var0_0.UpdateHatDisplay(arg0_11)
	if arg0_11.dressType ~= IslandShipDressHelperNew.DressType.Body then
		setActive(arg0_11.hatTF, false)

		return
	end

	local var0_11 = arg0_11.curDressTypeDataDic[arg0_11.dressType]

	if not var0_11 or var0_11 == 0 then
		setActive(arg0_11.hatTF, false)

		return
	end

	local var1_11 = (pg.island_dress_template.get_id_list_by_related_dress[var0_11] or {})[1]

	if not var1_11 then
		setActive(arg0_11.hatTF, false)

		return
	end

	setActive(arg0_11.hatTF, true)

	local var2_11 = pg.island_dress_template[var1_11].type
	local var3_11 = getProxy(IslandProxy):GetIsland():GetDressUpAgency():GetBodyHatIsOn(var0_11, var1_11)

	arg0_11.shipDressHelper:ChangeDressByType(var2_11, {
		id = var3_11 and var1_11 or 0
	})

	arg0_11.curDressTypeDataDic[var2_11] = var3_11 and var1_11 or 0

	arg0_11:UpdateHatToggleDisplay(var3_11)
	onButton(arg0_11, arg0_11.hatOn, function()
		if arg0_11.curDressTypeDataDic[var2_11] ~= var1_11 then
			arg0_11.curDressTypeDataDic[var2_11] = var1_11

			arg0_11.shipDressHelper:ChangeDressByType(var2_11, {
				id = var1_11
			})
			arg0_11:UpdateHatToggleDisplay(true)
		end
	end)
	onButton(arg0_11, arg0_11.hatOff, function()
		if arg0_11.curDressTypeDataDic[var2_11] ~= 0 then
			arg0_11.curDressTypeDataDic[var2_11] = 0

			arg0_11.shipDressHelper:ChangeDressByType(var2_11, {
				id = 0
			})
			arg0_11:UpdateHatToggleDisplay(false)
		end
	end)
end

function var0_0.OnDressInitItem(arg0_14, arg1_14)
	local var0_14 = IslandDressCard.New(arg1_14)

	arg0_14.dressCards[arg1_14] = var0_14
end

function var0_0.OnDressUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.dressCards[arg2_15]

	if not var0_15 then
		arg0_15:OnDressInitItem(arg2_15)

		var0_15 = arg0_15.dressCards[arg2_15]
	end

	local var1_15 = arg0_15.dressList[arg1_15 + 1]

	setActive(var0_15.canSendTF, not var1_15.hasSend)

	local var2_15 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	setText(var0_15.ownNum, string.format("×%d", var2_15:GetOwnDressCountByDressId(var1_15.id)))

	local var3_15
	local var4_15 = var1_15.id
	local var5_15 = tf(arg2_15)

	if var1_15.hasSend then
		onButton(arg0_15, var5_15, function()
			arg0_15:ClickDressCardItem(var4_15)
		end)

		var3_15 = arg0_15.curDressTypeDataDic[arg0_15.dressType]
	else
		onButton(arg0_15, var5_15, function()
			if var2_15:GetHasDressData(var4_15).read == 0 then
				local var0_17 = {
					var4_15
				}

				pg.m02:sendNotification(GAME.ISLAND_SEND_ROLE_DRESS_READ, {
					dress_List = var0_17
				})
			end

			arg0_15:ShowMsgBox({
				content = "是否赠送？",
				type = IslandMsgBox.TYPE_SEND_DRESS,
				onYes = function()
					pg.m02:sendNotification(GAME.ISLAND_SEND_ROLE_DRESS, {
						ship_id = arg0_15.shipId,
						dress_id = var4_15
					})
				end,
				onNo = function()
					return
				end,
				configId = var4_15
			})
		end)
	end

	local var6_15 = var3_15 ~= 0 and var3_15 or nil

	var0_15:Update(var4_15, var6_15, var1_15.hasSend)
end

function var0_0.OnSkinInitItem(arg0_20, arg1_20)
	local var0_20 = IslandSkinCard.New(arg1_20)

	arg0_20.skinCards[arg1_20] = var0_20
end

function var0_0.OnSkinUpdateItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.skinCards[arg2_21]

	if not var0_21 then
		arg0_21:OnSkinInitItem(arg2_21)

		var0_21 = arg0_21.skinCards[arg2_21]
	end

	local var1_21 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var2_21 = arg0_21.skinList[arg1_21 + 1]
	local var3_21 = tf(arg2_21)
	local var4_21 = #pg.island_skin_colordiff_template.get_id_list_by_skin_group[var2_21] or {}

	setActive(var3_21:Find("changeColor"), var4_21 > 0)

	local var5_21 = var1_21:CheckSkinIsOwned(var2_21)
	local var6_21 = arg0_21.curSkinId
	local var7_21 = var6_21 ~= 0 and var6_21 or nil

	var0_21:Update(var2_21, var7_21, var5_21)
	onButton(arg0_21, var3_21, function()
		arg0_21:ClickSkinCardItem(var2_21)
	end)
	onButton(arg0_21, var0_21.buyTF, function()
		local var0_23 = pg.island_skin_template[var2_21]
		local var1_23 = {
			{
				value2 = 1,
				key = var0_23.shop_id,
				value1 = var0_23.shop_goods_id
			}
		}
		local var2_23 = pg.island_shop_goods[var0_23.shop_goods_id]

		arg0_21:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_dress_skin_buy", "钻石x" .. var2_23.resource_consume[3], var0_23.name),
			onYes = function()
				arg0_21:emit(IslandMediator.BUY_COMMODITY, var1_23)
			end,
			onNo = function()
				return
			end
		})
	end)
end

function var0_0.ChangeModelBySkinAndSkinColor(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_26.shipId):GetModelBySkinAndColorId(arg0_26.curSkinId, arg0_26.curskinColorId)

	arg0_26.shipDressHelper:ChangeModelTransfromByUnitId(var0_26)
end

function var0_0.ClickSkinCardItem(arg0_27, arg1_27)
	if arg1_27 == arg0_27.curSkinId then
		arg0_27.curSkinId = 0
	else
		arg0_27.curSkinId = arg1_27
	end

	arg0_27:UpdateSkinList()

	if arg0_27.curSkinId ~= 0 then
		arg0_27.curskinColorId = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetCurrentSkinColorByShipId(arg0_27.shipId, arg0_27.curSkinId)
	end

	arg0_27:ChangeModelBySkinAndSkinColor()
	arg0_27:UpdateColorList()
	arg0_27:UpdateHatDisplay()
end

function var0_0.ClearSkinSelected(arg0_28, arg1_28)
	return
end

function var0_0.AddListeners(arg0_29)
	arg0_29:AddListener(GAME.ISLAND_SEND_ROLE_DRESS_DONE, arg0_29.OnSendRoleDressDone)
	arg0_29:AddListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_29.OnSendRoleDressReadDone)
	arg0_29:AddListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_29.OnBuyRoleSkinColorDone)
	arg0_29:AddListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_29.OnBuyRoleDressColorDone)
	arg0_29:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_29.GetBuySkindDone)
end

function var0_0.RemoveListeners(arg0_30)
	arg0_30:RemoveListener(GAME.ISLAND_SEND_ROLE_DRESS_DONE, arg0_30.OnSendRoleDressDone)
	arg0_30:RemoveListener(GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE, arg0_30.OnSendRoleDressReadDone)
	arg0_30:RemoveListener(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE, arg0_30.OnBuyRoleSkinColorDone)
	arg0_30:RemoveListener(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE, arg0_30.OnBuyRoleDressColorDone)
	arg0_30:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_30.GetBuySkindDone)
end

function var0_0.OnClosePage(arg0_31, arg1_31)
	return
end

function var0_0.OnInit(arg0_32)
	onButton(arg0_32, arg0_32.saveBtn, function()
		if not arg0_32:CheckDressIsDirty() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))

			return
		end

		arg0_32:SaveDressUpDataHandle()
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.dressUpConfireBtn, function()
		arg0_32:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_dressup_tip"),
			onYes = function()
				arg0_32:SaveDressUpDataHandle()
			end,
			onNo = function()
				return
			end
		})
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.restBtn, function()
		arg0_32:ResetDressUp()
	end, SFX_PANEL)

	for iter0_32, iter1_32 in ipairs(arg0_32.toggles) do
		onToggle(arg0_32, iter1_32, function(arg0_38)
			if arg0_38 then
				arg0_32:SwitchPage(iter0_32)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_32, arg0_32.sortBtn, function()
		arg0_32.sortPage:ExecuteAction("Show", arg0_32.indexData, function(arg0_40)
			arg0_32:OnSort(arg0_40)
		end)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.orderBtn, function()
		local var0_41 = 1 - arg0_32.indexData.order

		arg0_32:OnOrder(var0_41)
	end, SFX_PANEL)
end

function var0_0.OnSort(arg0_42, arg1_42)
	arg0_42.indexData.sortKey = arg1_42

	arg0_42:UpdateOrderTxt()
	arg0_42:UpdateDressUpList()
end

function var0_0.OnOrder(arg0_43, arg1_43)
	arg0_43.indexData.order = arg1_43
	arg0_43.orderBtn.localScale = Vector3(1, arg1_43 == 1 and 1 or -1, 1)

	arg0_43:UpdateDressUpList()
end

function var0_0.UpdateOrderTxt(arg0_44)
	arg0_44.orderTxt.text = var0_0.SORTCN[arg0_44.indexData.sortKey]
end

function var0_0.SwitchPage(arg0_45, arg1_45)
	arg0_45.currentToggleIndex = arg1_45

	if arg0_45.currentToggleIndex == 4 then
		setActive(arg0_45.dressTF, false)
		setActive(arg0_45.skinTF, true)
		arg0_45:GetSkinList()
		arg0_45:UpdateSkinList()
		arg0_45:UpdateColorList()
	else
		arg0_45.dressType = var1_0[arg0_45.currentToggleIndex]

		if arg0_45.SmoothFunc then
			if arg0_45.dressType == IslandShipDressHelperNew.DressType.BackDecorate then
				arg0_45.SmoothFunc(Quaternion.Euler(0, 0, 0))
			else
				arg0_45.SmoothFunc(Quaternion.Euler(0, 180, 0))
			end
		end

		setActive(arg0_45.dressTF, true)
		setActive(arg0_45.skinTF, false)
		arg0_45:GetDressUpList()
		arg0_45:UpdateDressUpList()
		arg0_45:UpdateHatDisplay()
		arg0_45:UpdateOrderTxt()
		arg0_45:UpdateColorList(true)
	end
end

function var0_0.GetDressUpList(arg0_46)
	local var0_46 = getProxy(IslandProxy):GetIsland()

	arg0_46.dressList = {}

	if arg0_46.shipId == 0 then
		local var1_46 = var0_46:GetDressUpAgency()

		for iter0_46, iter1_46 in ipairs(var1_46:GetHasDressByType(arg0_46.dressType)) do
			table.insert(arg0_46.dressList, IslandDressItem.New({
				hasSend = true,
				id = iter1_46.id
			}))
		end
	else
		local var2_46 = var0_46:GetCharacterAgency():GetShipById(arg0_46.shipId)
		local var3_46 = var2_46:GetAllOwnDressList()
		local var4_46 = var2_46:GetALLHasSendToShipDress()

		for iter2_46, iter3_46 in ipairs(var3_46) do
			if pg.island_dress_template[iter3_46].type == arg0_46.dressType then
				table.insert(arg0_46.dressList, IslandDressItem.New({
					hasSend = false,
					id = iter3_46
				}))
			end
		end

		for iter4_46, iter5_46 in ipairs(var4_46) do
			if pg.island_dress_template[iter5_46].type == arg0_46.dressType then
				table.insert(arg0_46.dressList, IslandDressItem.New({
					hasSend = true,
					id = iter5_46
				}))
			end
		end
	end

	local var5_46

	if arg0_46.indexData.sortKey == var0_0.SORT_DEFAULT then
		var5_46 = {
			function(arg0_47)
				return arg0_47.id
			end
		}
	else
		var5_46 = {
			function(arg0_48)
				return arg0_48:GetSortValue(arg0_46.indexData.sortKey, arg0_46.indexData.order)
			end
		}
	end

	table.sort(arg0_46.dressList, CompareFuncs(var5_46))
end

function var0_0.GetSkinList(arg0_49)
	if arg0_49.shipId ~= 0 then
		local var0_49 = getProxy(IslandProxy):GetIsland()

		arg0_49.skinList = pg.island_skin_template.get_id_list_by_ship_group[arg0_49.shipId] or {}
	end
end

function var0_0.UpdateSkinList(arg0_50)
	local var0_50 = #arg0_50.skinList

	setActive(arg0_50.skinRectTF, var0_50 ~= 0)
	setActive(arg0_50.skinEmpty, var0_50 == 0)
	arg0_50.skinRect:SetTotalCount(var0_50)
end

function var0_0.UpdateDressUpList(arg0_51)
	local var0_51 = #arg0_51.dressList

	setActive(arg0_51.dressRectTF, var0_51 ~= 0)
	setActive(arg0_51.dressEmpty, var0_51 == 0)
	setText(arg0_51.dressEmptyTips, i18n("island_dress_no_item"))
	setActive(arg0_51.sortBtn, false)

	if var0_51 ~= 0 then
		arg0_51.dressRect:SetTotalCount(var0_51, 0)
	end
end

function var0_0.OnShow(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52)
	arg0_52.SmoothFunc = arg4_52
	arg0_52.isFirstDressUp = arg2_52

	setActive(arg0_52.color_listPanel, false)
	setActive(arg0_52.saveBtn, not arg2_52)
	setActive(arg0_52.restBtn, not arg2_52)

	arg0_52.shipDressHelper = arg3_52
	arg0_52.shipId = arg1_52
	arg0_52.indexData = {
		order = 1,
		sortKey = var0_0.SORT_DEFAULT
	}
	arg0_52.smothObj = smothObj

	arg0_52:InitCurDressData()
	setActive(arg0_52.dressUpConfireBtn, arg2_52)

	if arg1_52 == 0 then
		setActive(arg0_52.toggles[4], false)
		setActive(arg0_52.toggles[5], not arg2_52)
		setActive(arg0_52.toggles[6], not arg2_52)
		setActive(arg0_52.toggles[7], not arg2_52)
		triggerToggle(arg0_52.toggles[1], true)
	else
		setActive(arg0_52.toggles[4], true)
		triggerToggle(arg0_52.toggles[4], true)
	end

	setActive(arg0_52.toggles[1], arg1_52 == 0)
	setActive(arg0_52.toggles[2], arg1_52 == 0)
	setActive(arg0_52.toggles[3], arg1_52 == 0)
	arg0_52:UpdateRightReddot()
end

function var0_0.InitCurDressData(arg0_53)
	arg0_53.curDressTypeDataDic = {}
	arg0_53.dressColorDic = {}

	local var0_53 = getProxy(IslandProxy):GetIsland()

	if arg0_53.shipId == 0 then
		local var1_53 = var0_53:GetDressUpAgency()
		local var2_53 = arg0_53.isFirstDressUp and IslandShipDressHelperNew.CommanderCustom or IslandShipDressHelperNew.DressType

		for iter0_53, iter1_53 in pairs(var2_53) do
			local var3_53 = arg0_53.isFirstDressUp and IslandShipDressHelperNew.GetInitDressByType(iter1_53) or var1_53:GetDressByType(iter1_53)

			arg0_53.curDressTypeDataDic[iter1_53] = var3_53

			if var3_53 then
				arg0_53.dressColorDic[var3_53] = var1_53:GetCurrentColorByDressId(var3_53)
			end
		end

		print(123)
	else
		local var4_53 = var0_53:GetCharacterAgency()
		local var5_53 = var4_53:GetShipById(arg0_53.shipId)

		arg0_53.curSkinId = var5_53:GetCurSkinId()

		if arg0_53.curSkinId == 0 then
			arg0_53.curskinColorId = 0
		else
			arg0_53.curskinColorId = var4_53:GetCurrentSkinColorByShipId(arg0_53.shipId, arg0_53.curSkinId)
		end

		for iter2_53, iter3_53 in pairs(IslandShipDressHelperNew.DressType) do
			arg0_53.curDressTypeDataDic[iter3_53] = var5_53:GetDressByType(iter3_53)
		end
	end
end

function var0_0.CheckDressIsDirty(arg0_54)
	local var0_54 = getProxy(IslandProxy):GetIsland()

	if arg0_54.shipId == 0 then
		local var1_54 = var0_54:GetDressUpAgency()

		for iter0_54, iter1_54 in pairs(arg0_54.curDressTypeDataDic) do
			if (var1_54:GetDressByType(iter0_54) or 0) ~= iter1_54 then
				return true
			end

			if iter1_54 ~= 0 and var1_54:GetCurrentColorByDressId(iter1_54) ~= (arg0_54.dressColorDic[iter1_54] or 0) then
				return true
			end
		end

		return false
	else
		local var2_54 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
		local var3_54 = var2_54:GetShipById(arg0_54.shipId)
		local var4_54 = var3_54:GetCurSkinId()
		local var5_54 = var2_54:GetCurrentSkinColorByShipId(arg0_54.shipId, var4_54)

		if var4_54 ~= arg0_54.curSkinId or var5_54 ~= arg0_54.curskinColorId then
			return true
		end

		for iter2_54, iter3_54 in pairs(arg0_54.curDressTypeDataDic) do
			if (var3_54:GetDressByType(iter2_54) or 0) ~= iter3_54 then
				return true
			end
		end

		return false
	end
end

function var0_0.ResetDressUp(arg0_55)
	local var0_55 = getProxy(IslandProxy):GetIsland()

	if arg0_55.shipId == 0 then
		local var1_55 = var0_55:GetDressUpAgency()

		for iter0_55, iter1_55 in pairs(IslandShipDressHelperNew.DressType) do
			local var2_55 = var1_55:GetDressByType(iter1_55) or 0
			local var3_55 = var1_55:GetCurrentColorByDressId(var2_55)
			local var4_55 = arg0_55.curDressTypeDataDic[iter1_55]
			local var5_55 = arg0_55.dressColorDic[var4_55]

			if var2_55 == var4_55 and var5_55 ~= var3_55 then
				arg0_55.shipDressHelper:ChangeCommanderPartColor(iter1_55, var3_55)

				return
			end

			arg0_55.shipDressHelper:ChangeDressByType(iter1_55, {
				id = var2_55,
				colorId = var3_55
			})

			arg0_55.curDressTypeDataDic[iter1_55] = var2_55
			arg0_55.dressColorDic[var2_55] = var3_55
		end

		local var6_55 = arg0_55.curDressTypeDataDic[IslandShipDressHelperNew.DressType.Body]
		local var7_55 = var1_55:GetBodyHatIsOn(var6_55)

		arg0_55:UpdateHatToggleDisplay(var7_55)
		arg0_55:UpdateDressUpList()
	else
		local var8_55 = var0_55:GetCharacterAgency()
		local var9_55 = var8_55:GetShipById(arg0_55.shipId)

		if (function()
			local var0_56 = var9_55:GetCurSkinId()
			local var1_56 = var8_55:GetCurrentSkinColorByShipId(arg0_55.shipId, var0_56)

			if var0_56 ~= arg0_55.curSkinId or var1_56 ~= arg0_55.curskinColorId then
				arg0_55.curSkinId = var0_56
				arg0_55.curskinColorId = var1_56

				return true
			end

			return false
		end)() then
			local var10_55 = var9_55:GetModelBySkinAndColorId(arg0_55.curSkinId, arg0_55.curskinColorId)

			arg0_55.shipDressHelper:ChangeModelTransfromByUnitId(var10_55)
			arg0_55:UpdateSkinList()
			arg0_55:UpdateColorList()
		end

		local var11_55 = {
			IslandShipDressHelperNew.DressType.BackDecorate,
			IslandShipDressHelperNew.DressType.Flotage,
			IslandShipDressHelperNew.DressType.Footprint
		}

		for iter2_55, iter3_55 in ipairs(var11_55) do
			local var12_55 = var9_55:GetDressByType(iter3_55) or 0
			local var13_55 = 0

			if var12_55 ~= 0 then
				local var14_55 = dressUpAgency:GetCurrentColorByDressId(var12_55)

				var13_55 = arg0_55.dressColorDic[var12_55] or 0
			end

			arg0_55.shipDressHelper:ChangeDressByType(iter3_55, {
				id = var13_55,
				colorId = var13_55
			})

			arg0_55.curDressTypeDataDic[iter3_55] = var12_55
			arg0_55.dressColorDic[var12_55] = var13_55
		end

		arg0_55:UpdateDressUpList()
	end
end

function var0_0.CheckShipCanSave(arg0_57)
	local var0_57 = true
	local var1_57 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	if not var1_57:CheckSkinIsOwned(arg0_57.curSkinId) then
		arg0_57.curSkinId = var1_57:GetShipById(arg0_57.shipId):GetCurSkinId()
		var0_57 = false
	end

	if arg0_57.curSkinId ~= 0 and not var1_57:CheckSkinColorIsOwned(arg0_57.curSkinId, arg0_57.curskinColorId) then
		arg0_57.curskinColorId = var1_57:GetCurrentSkinColorByShipId(arg0_57.shipId, arg0_57.curSkinId)
		var0_57 = false
	end

	return var0_57
end

function var0_0.SaveDressUpDataHandle(arg0_58)
	if arg0_58.shipId == 0 then
		arg0_58:SaveDressUpData()
	else
		if not arg0_58:CheckShipCanSave() then
			local var0_58 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_58.shipId):GetModelBySkinAndColorId(arg0_58.curSkinId, arg0_58.curskinColorId)

			arg0_58.shipDressHelper:ChangeModelTransfromByUnitId(var0_58)
			arg0_58:UpdateSkinList()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save2"))

			return
		end

		arg0_58:SaveDressUpData()
	end
end

function var0_0.SaveDressUpData(arg0_59)
	local var0_59 = getProxy(IslandProxy):GetIsland()

	local function var1_59()
		local var0_60 = {}
		local var1_60 = {}
		local var2_60 = var0_59:GetDressUpAgency()

		for iter0_60, iter1_60 in pairs(arg0_59.curDressTypeDataDic) do
			local var3_60 = var2_60:GetDressByType(iter0_60)
			local var4_60 = false

			if iter1_60 ~= var3_60 then
				var4_60 = true
			end

			if iter0_60 == IslandShipDressHelperNew.DressType.Hat and iter1_60 == 0 then
				var4_60 = true
			end

			if var4_60 then
				table.insert(var0_60, {
					type = iter0_60,
					id = iter1_60
				})
			end

			local var5_60 = arg0_59.dressColorDic[iter1_60] or 0

			if var2_60:GetCurrentColorByDressId(iter1_60) ~= var5_60 then
				table.insert(var1_60, {
					id = iter1_60,
					color = var5_60
				})
			end
		end

		return var0_60, var1_60
	end

	if arg0_59.shipId == 0 then
		local var2_59, var3_59 = var1_59()

		pg.m02:sendNotification(GAME.ISLAND_CHANGE_COMMANDER_DRESS, {
			dress_List = var2_59,
			color_list = var3_59,
			island_id = var0_59.id
		})
	else
		local var4_59 = var1_59()
		local var5_59 = {}

		pg.m02:sendNotification(GAME.ISLAND_CHANGE_DRESS, {
			dress_List = var4_59,
			color_list = var5_59,
			ship_id = arg0_59.shipId,
			skin_id = arg0_59.curSkinId,
			color_id = arg0_59.curskinColorId
		})
	end
end

function var0_0.CheckInReturn(arg0_61, arg1_61)
	if not arg0_61:CheckDressIsDirty() then
		if arg1_61 then
			arg1_61()
		end

		return
	end

	local var0_61 = getProxy(IslandProxy):GetIsland()

	if not arg0_61:CheckShipCanSave() then
		if arg1_61 then
			arg1_61()
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_exit2"))

		return
	end

	arg0_61:ShowMsgBox({
		type = IslandMsgBox.TYPE_COMMON,
		content = i18n("island_dressup_tip_1"),
		onYes = function()
			arg0_61:SaveDressUpDataHandle()

			if arg1_61 then
				arg1_61()
			end
		end,
		onNo = function()
			if arg1_61 then
				arg1_61()
			end
		end
	})
end

function var0_0.OnSendRoleDressDone(arg0_64, arg1_64)
	local var0_64 = pg.island_dress_template[arg1_64.dress_id]

	arg0_64.shipDressHelper:ChangeDressByType(var0_64.type, arg1_64.dress_id)
	arg0_64:GetDressUpList()
	arg0_64:UpdateDressUpList()
end

function var0_0.OnSendRoleDressReadDone(arg0_65)
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
	local var0_69 = {
		5,
		6,
		7
	}

	for iter0_69, iter1_69 in ipairs(var0_69) do
		local var1_69 = arg0_69.toggles[iter1_69]:Find("red_dot")

		if arg0_69.shipId == 0 then
			setActive(var1_69, false)
		else
			local var2_69 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():CheckRedDotByDressType(arg0_69.dressType)

			setActive(var1_69, var2_69)
		end
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
		local var0_73 = getProxy(IslandProxy):GetIsland()

		if arg0_72.isDressColor then
			if arg0_72.shipId == 0 and var0_73:GetDressUpAgency():CheckDressColorIsOwned(var2_72, var1_72) then
				return true
			end

			return false, true
		else
			if not arg0_72.curskinColorId or arg0_72.curskinColorId == 0 then
				return true
			end

			local var1_73 = var0_73:GetCharacterAgency()

			if var1_73:CheckSkinColorIsOwned(arg0_72.curSkinId, arg0_72.curskinColorId) then
				return true
			end

			local var2_73 = var1_73:CheckSkinIsOwned(arg0_72.curSkinId)

			return false, var2_73
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
					skin_id = selectSkinId,
					color_id = currentColorId
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
					pg.TipsMgr.GetInstance():ShowTips("消耗不够")

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
		local var0_80 = getProxy(IslandProxy):GetIsland()

		arg0_79.colorItemList = {}

		if arg0_79.isDressColor then
			local var1_80 = var0_80:GetDressUpAgency()
			local var2_80 = arg0_79.curDressTypeDataDic[arg0_79.dressType]
			local var3_80 = arg0_79.dressColorDic[var2_80]
			local var4_80 = pg.island_dress_colordiff_template.get_id_list_by_belongto_dress[var2_80] or {}

			if #var4_80 > 0 then
				local var5_80 = var3_80 == 0
				local var6_80 = true

				table.insert(arg0_79.colorItemList, {
					itemId = 0,
					selected = var5_80,
					owned = var6_80
				})

				for iter0_80, iter1_80 in ipairs(var4_80) do
					local var7_80 = var3_80 == iter1_80
					local var8_80 = var1_80:CheckDressColorIsOwned(var2_80, iter1_80)

					table.insert(arg0_79.colorItemList, {
						itemId = iter1_80,
						selected = var7_80,
						owned = var8_80,
						costItemIcon = pg.island_dress_colordiff_template[iter1_80].color_icon
					})
				end
			end
		else
			local var9_80 = var0_80:GetCharacterAgency()
			local var10_80 = pg.island_skin_colordiff_template.get_id_list_by_skin_group[arg0_79.curSkinId] or {}

			if #var10_80 > 0 then
				local var11_80 = arg0_79.curskinColorId == 0
				local var12_80 = var9_80:CheckSkinIsOwned(arg0_79.curSkinId)

				table.insert(arg0_79.colorItemList, {
					itemId = 0,
					selected = var11_80,
					owned = var12_80
				})

				for iter2_80, iter3_80 in ipairs(var10_80) do
					local var13_80 = arg0_79.curskinColorId == iter3_80
					local var14_80 = var9_80:CheckSkinColorIsOwned(arg0_79.curSkinId, iter3_80)

					table.insert(arg0_79.colorItemList, {
						itemId = iter3_80,
						selected = var13_80,
						owned = var14_80,
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
			setText(arg2_81:Find("orginName"), i18n("island_skin_original_desc"))
			setActive(arg2_81:Find("icon"), false)

			if var0_81.costItemIcon then
				setActive(arg2_81:Find("icon"), true)
				GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. pg.island_dress_colordiff_template[var1_81].color_icon, "", arg2_81:Find("icon"))
			end

			setActive(arg2_81:Find("locked"), not var0_81.owned)
			onButton(arg0_79, arg2_81, function()
				if arg0_79.isDressColor then
					local var0_82 = arg0_79.curDressTypeDataDic[arg0_79.dressType]
					local var1_82 = arg0_79.dressColorDic[dressColorId]

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
