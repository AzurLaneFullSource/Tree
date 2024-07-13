local var0_0 = class("SnapshotSelectCharLayer", import("..base.BaseUI"))

var0_0.ON_INDEX = "SnapshotSelectCharLayer.ON_INDEX"
var0_0.SELECT_CHAR = "SnapshotSelectCharLayer.SELECT_CHAR"
var0_0.TOGGLE_UNDEFINED = -1
var0_0.TOGGLE_CHAR = 0
var0_0.TOGGLE_LINK = 1
var0_0.TOGGLE_BLUEPRINT = 2
var0_0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0_0.ShipIndexData = {
	customPanels = {
		typeIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.TypeIndexs,
			names = ShipIndexConst.TypeNames
		},
		campIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.CampIndexs,
			names = ShipIndexConst.CampNames
		},
		rarityIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.RarityIndexs,
			names = ShipIndexConst.RarityNames
		}
	},
	groupList = {
		{
			dropdown = false,
			titleTxt = "indexsort_index",
			titleENTxt = "indexsort_indexeng",
			tags = {
				"typeIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_camp",
			titleENTxt = "indexsort_campeng",
			tags = {
				"campIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_rarity",
			titleENTxt = "indexsort_rarityeng",
			tags = {
				"rarityIndex"
			}
		}
	}
}

function var0_0.setShipGroups(arg0_1, arg1_1)
	arg0_1.shipGroups = arg1_1
end

function var0_0.setProposeList(arg0_2, arg1_2)
	arg0_2.proposeList = arg1_2
end

function var0_0.getUIName(arg0_3)
	return "snapshotselectchar"
end

function var0_0.back(arg0_4)
	if arg0_4.exited then
		return
	end

	arg0_4:emit(var0_0.ON_CLOSE)

	arg0_4.scrollValue = 0
end

function var0_0.init(arg0_5)
	arg0_5.toggleType = var0_0.TOGGLE_UNDEFINED
	arg0_5.topTF = arg0_5:findTF("blur_panel/adapt/top")
	arg0_5.backBtn = arg0_5:findTF("back_btn", arg0_5.topTF)
	arg0_5.indexBtn = arg0_5:findTF("index_button", arg0_5.topTF)
	arg0_5.toggleChar = arg0_5:findTF("list_card/types/char")
	arg0_5.toggleLink = arg0_5:findTF("list_card/types/link")
	arg0_5.toggleBlueprint = arg0_5:findTF("list_card/types/blueprint")
	arg0_5.cardItems = {}
	arg0_5.cardList = arg0_5:findTF("list_card/scroll"):GetComponent("LScrollRect")

	function arg0_5.cardList.onInitItem(arg0_6)
		arg0_5:onInitCard(arg0_6)
	end

	function arg0_5.cardList.onUpdateItem(arg0_7, arg1_7)
		arg0_5:onUpdateCard(arg0_7, arg1_7)
	end

	function arg0_5.cardList.onReturnItem(arg0_8, arg1_8)
		arg0_5:onReturnCard(arg0_8, arg1_8)
	end

	arg0_5:initSelectSkinPanel()
	cameraPaintViewAdjust(false)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf)
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:back()
	end)
	onToggle(arg0_9, arg0_9.toggleChar, function()
		if arg0_9.toggleType == var0_0.TOGGLE_CHAR then
			return
		end

		arg0_9.toggleType = var0_0.TOGGLE_CHAR

		arg0_9:updateCardList()
	end)
	onToggle(arg0_9, arg0_9.toggleLink, function()
		if arg0_9.toggleType == var0_0.TOGGLE_LINK then
			return
		end

		arg0_9.toggleType = var0_0.TOGGLE_LINK

		arg0_9:updateCardList()
	end)
	onToggle(arg0_9, arg0_9.toggleBlueprint, function()
		if arg0_9.toggleType == var0_0.TOGGLE_BLUEPRINT then
			return
		end

		arg0_9.toggleType = var0_0.TOGGLE_BLUEPRINT

		arg0_9:updateCardList()
	end)
	onButton(arg0_9, arg0_9.indexBtn, function()
		local var0_14 = Clone(var0_0.ShipIndexData)

		if arg0_9.toggleType == var0_0.TOGGLE_LINK then
			var0_14.customPanels.campIndex = nil
			var0_14.groupList[2] = nil
		end

		var0_14.indexDatas = Clone(var0_0.ShipIndex)

		function var0_14.callback(arg0_15)
			var0_0.ShipIndex.typeIndex = arg0_15.typeIndex

			if arg0_15.campIndex then
				var0_0.ShipIndex.campIndex = arg0_15.campIndex
			end

			var0_0.ShipIndex.rarityIndex = arg0_15.rarityIndex

			arg0_9:updateCardList()
		end

		arg0_9:emit(var0_0.ON_INDEX, var0_14)
	end)
	triggerToggle(arg0_9.toggleChar, true)
end

function var0_0.willExit(arg0_16)
	cameraPaintViewAdjust(true)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16._tf)
end

local function var1_0(arg0_17, arg1_17, arg2_17)
	if arg0_17 == var0_0.TOGGLE_CHAR and not arg1_17 then
		return arg2_17
	elseif arg0_17 == var0_0.TOGGLE_LINK and arg1_17 then
		return arg2_17 - 10000
	elseif arg0_17 == var0_0.TOGGLE_BLUEPRINT then
		return arg2_17 - 20000
	end

	return -1
end

function var0_0.updateCardList(arg0_18)
	local var0_18 = {}
	local var1_18 = _.filter(pg.ship_data_group.all, function(arg0_19)
		return pg.ship_data_group[arg0_19].handbook_type == arg0_18.toggleType
	end)

	if var0_0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and var0_0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0_0.ShipIndex.campIndex == ShipIndexConst.CampAll and arg0_18.toggleType == var0_0.TOGGLE_CHAR then
		for iter0_18, iter1_18 in ipairs(var1_18) do
			local var2_18 = pg.ship_data_group[iter1_18]
			local var3_18
			local var4_18 = false

			if var2_18 then
				var3_18 = arg0_18.shipGroups[var2_18.group_type]
				var4_18 = Nation.IsLinkType(ShipGroup.getDefaultShipConfig(var2_18.group_type).nationality)
			end

			local var5_18 = var1_0(arg0_18.toggleType, var4_18, iter1_18)

			if var5_18 ~= -1 then
				var0_18[iter0_18] = {
					showTrans = false,
					code = var5_18,
					group = var3_18
				}
			end
		end
	else
		for iter2_18, iter3_18 in ipairs(var1_18) do
			local var6_18 = pg.ship_data_group[iter3_18]

			if var6_18 then
				local var7_18 = ShipGroup.New({
					id = var6_18.group_type
				})
				local var8_18 = arg0_18.shipGroups[var6_18.group_type]

				if var7_18 and ShipIndexConst.filterByType(var7_18, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var7_18, var0_0.ShipIndex.rarityIndex) then
					local var9_18 = Nation.IsLinkType(var7_18:getNation())

					if arg0_18.toggleType == var0_0.TOGGLE_CHAR and not var9_18 and ShipIndexConst.filterByCamp(var7_18, var0_0.ShipIndex.campIndex) then
						var0_18[#var0_18 + 1] = {
							showTrans = false,
							code = var1_0(arg0_18.toggleType, var9_18, iter3_18),
							group = var8_18
						}
					elseif arg0_18.toggleType == var0_0.TOGGLE_LINK and var9_18 then
						var0_18[#var0_18 + 1] = {
							showTrans = false,
							code = var1_0(arg0_18.toggleType, var9_18, iter3_18),
							group = var8_18
						}
					elseif arg0_18.toggleType == var0_0.TOGGLE_BLUEPRINT and ShipIndexConst.filterByCamp(var7_18, var0_0.ShipIndex.campIndex) then
						var0_18[#var0_18 + 1] = {
							showTrans = false,
							code = var1_0(arg0_18.toggleType, var9_18, iter3_18),
							group = var8_18
						}
					end
				end
			end
		end
	end

	arg0_18.cardInfos = var0_18

	arg0_18.cardList:SetTotalCount(#arg0_18.cardInfos, -1)
	arg0_18.cardList:ScrollTo(arg0_18.scrollValue or 0)
end

local function var2_0(arg0_20)
	return getProxy(ShipSkinProxy):GetAllSkinForARCamera(arg0_20)
end

local function var3_0(arg0_21)
	local var0_21 = {}
	local var1_21 = getProxy(ShipSkinProxy):getSkinList()
	local var2_21 = getProxy(CollectionProxy):getShipGroup(arg0_21)

	if var2_21 then
		local var3_21 = ShipGroup.getSkinList(arg0_21)

		for iter0_21, iter1_21 in ipairs(var3_21) do
			if iter1_21.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_21, iter1_21.id) or iter1_21.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_21.trans or iter1_21.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_21.married == 1 then
				var0_21[iter1_21.id] = true
			end
		end
	end

	return var0_21
end

function var0_0.onInitCard(arg0_22, arg1_22)
	local var0_22 = SnapshotShipCard.New(arg1_22)

	onButton(arg0_22, var0_22.go, function()
		if var0_22.shipGroup then
			if HXSet.isHxSkin() then
				local var0_23 = ShipGroup.getDefaultSkin(var0_22.shipGroup.id)

				arg0_22:emit(var0_0.SELECT_CHAR, var0_23.id)
				arg0_22:back()

				return
			end

			local var1_23 = var2_0(var0_22.shipGroup.id)

			if #var1_23 > 1 then
				local var2_23 = var3_0(var0_22.shipGroup.id)

				arg0_22:openSelectSkinPanel(var1_23, var2_23)
			elseif #var1_23 == 1 then
				arg0_22:emit(var0_0.SELECT_CHAR, var1_23[1].id)
				arg0_22:back()
			end
		end
	end)

	arg0_22.cardItems[arg1_22] = var0_22
end

function var0_0.onUpdateCard(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cardItems[arg2_24]

	if not var0_24 then
		arg0_24:onInitCard(arg2_24)

		var0_24 = arg0_24.cardItems[arg2_24]
	end

	local var1_24 = arg1_24 + 1
	local var2_24 = arg0_24.cardInfos[var1_24]

	if not var2_24 then
		return
	end

	local var3_24

	if var2_24.group then
		var3_24 = arg0_24.proposeList[var2_24.group.id]
	end

	var0_24:update(var2_24.code, var2_24.group, var2_24.showTrans, var3_24)
end

function var0_0.onReturnCard(arg0_25, arg1_25, arg2_25)
	if arg0_25.exited then
		return
	end

	local var0_25 = arg0_25.cardItems[arg2_25]

	if var0_25 then
		var0_25:clear()
	end

	arg0_25.cardItems[arg2_25] = nil
end

function var0_0.initSelectSkinPanel(arg0_26)
	arg0_26.skinPanel = arg0_26:findTF("selectSkinPnl")

	local var0_26 = arg0_26:findTF("select_skin/btnBack", arg0_26.skinPanel)

	onButton(arg0_26, var0_26, function()
		arg0_26:closeSelectSkinPanel()
	end)

	arg0_26.skinScroll = arg0_26:findTF("select_skin/style_scroll", arg0_26.skinPanel)
	arg0_26.skinContainer = arg0_26:findTF("view_port", arg0_26.skinScroll)
	arg0_26.skinCard = arg0_26._tf:GetComponent(typeof(ItemList)).prefabItem[0]

	setActive(arg0_26.skinCard, false)
	setActive(arg0_26.skinPanel, false)

	arg0_26.skinCardMap = {}
end

function var0_0.openSelectSkinPanel(arg0_28, arg1_28, arg2_28)
	setActive(arg0_28.skinPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_28.skinPanel, false)

	for iter0_28 = arg0_28.skinContainer.childCount, #arg1_28 - 1 do
		cloneTplTo(arg0_28.skinCard, arg0_28.skinContainer)
	end

	for iter1_28 = #arg1_28, arg0_28.skinContainer.childCount - 1 do
		setActive(arg0_28.skinContainer:GetChild(iter1_28), false)
	end

	local var0_28 = arg0_28.skinContainer.childCount

	for iter2_28, iter3_28 in ipairs(arg1_28) do
		local var1_28 = arg0_28.skinContainer:GetChild(iter2_28 - 1)
		local var2_28 = arg0_28.skinCardMap[var1_28]

		if not var2_28 then
			var2_28 = ShipSkinCard.New(var1_28.gameObject)
			arg0_28.skinCardMap[var1_28] = var2_28
		end

		local var3_28 = arg2_28[iter3_28.id]

		var2_28:updateSkin(iter3_28, var3_28)
		var2_28:updateUsing(false)
		removeOnButton(var1_28)
		onButton(arg0_28, var1_28, function()
			if var3_28 then
				arg0_28:emit(var0_0.SELECT_CHAR, iter3_28.id)
				arg0_28:closeSelectSkinPanel()
				arg0_28:back()
			end
		end)
		setActive(var1_28, true)
	end
end

function var0_0.closeSelectSkinPanel(arg0_30)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30.skinPanel, arg0_30._tf)
	setActive(arg0_30.skinPanel, false)
end

return var0_0
