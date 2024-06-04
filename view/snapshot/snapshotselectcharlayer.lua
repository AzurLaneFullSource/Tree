local var0 = class("SnapshotSelectCharLayer", import("..base.BaseUI"))

var0.ON_INDEX = "SnapshotSelectCharLayer.ON_INDEX"
var0.SELECT_CHAR = "SnapshotSelectCharLayer.SELECT_CHAR"
var0.TOGGLE_UNDEFINED = -1
var0.TOGGLE_CHAR = 0
var0.TOGGLE_LINK = 1
var0.TOGGLE_BLUEPRINT = 2
var0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0.ShipIndexData = {
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

function var0.setShipGroups(arg0, arg1)
	arg0.shipGroups = arg1
end

function var0.setProposeList(arg0, arg1)
	arg0.proposeList = arg1
end

function var0.getUIName(arg0)
	return "snapshotselectchar"
end

function var0.back(arg0)
	if arg0.exited then
		return
	end

	arg0:emit(var0.ON_CLOSE)

	arg0.scrollValue = 0
end

function var0.init(arg0)
	arg0.toggleType = var0.TOGGLE_UNDEFINED
	arg0.topTF = arg0:findTF("blur_panel/adapt/top")
	arg0.backBtn = arg0:findTF("back_btn", arg0.topTF)
	arg0.indexBtn = arg0:findTF("index_button", arg0.topTF)
	arg0.toggleChar = arg0:findTF("list_card/types/char")
	arg0.toggleLink = arg0:findTF("list_card/types/link")
	arg0.toggleBlueprint = arg0:findTF("list_card/types/blueprint")
	arg0.cardItems = {}
	arg0.cardList = arg0:findTF("list_card/scroll"):GetComponent("LScrollRect")

	function arg0.cardList.onInitItem(arg0)
		arg0:onInitCard(arg0)
	end

	function arg0.cardList.onUpdateItem(arg0, arg1)
		arg0:onUpdateCard(arg0, arg1)
	end

	function arg0.cardList.onReturnItem(arg0, arg1)
		arg0:onReturnCard(arg0, arg1)
	end

	arg0:initSelectSkinPanel()
	cameraPaintViewAdjust(false)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:back()
	end)
	onToggle(arg0, arg0.toggleChar, function()
		if arg0.toggleType == var0.TOGGLE_CHAR then
			return
		end

		arg0.toggleType = var0.TOGGLE_CHAR

		arg0:updateCardList()
	end)
	onToggle(arg0, arg0.toggleLink, function()
		if arg0.toggleType == var0.TOGGLE_LINK then
			return
		end

		arg0.toggleType = var0.TOGGLE_LINK

		arg0:updateCardList()
	end)
	onToggle(arg0, arg0.toggleBlueprint, function()
		if arg0.toggleType == var0.TOGGLE_BLUEPRINT then
			return
		end

		arg0.toggleType = var0.TOGGLE_BLUEPRINT

		arg0:updateCardList()
	end)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = Clone(var0.ShipIndexData)

		if arg0.toggleType == var0.TOGGLE_LINK then
			var0.customPanels.campIndex = nil
			var0.groupList[2] = nil
		end

		var0.indexDatas = Clone(var0.ShipIndex)

		function var0.callback(arg0)
			var0.ShipIndex.typeIndex = arg0.typeIndex

			if arg0.campIndex then
				var0.ShipIndex.campIndex = arg0.campIndex
			end

			var0.ShipIndex.rarityIndex = arg0.rarityIndex

			arg0:updateCardList()
		end

		arg0:emit(var0.ON_INDEX, var0)
	end)
	triggerToggle(arg0.toggleChar, true)
end

function var0.willExit(arg0)
	cameraPaintViewAdjust(true)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

local function var1(arg0, arg1, arg2)
	if arg0 == var0.TOGGLE_CHAR and not arg1 then
		return arg2
	elseif arg0 == var0.TOGGLE_LINK and arg1 then
		return arg2 - 10000
	elseif arg0 == var0.TOGGLE_BLUEPRINT then
		return arg2 - 20000
	end

	return -1
end

function var0.updateCardList(arg0)
	local var0 = {}
	local var1 = _.filter(pg.ship_data_group.all, function(arg0)
		return pg.ship_data_group[arg0].handbook_type == arg0.toggleType
	end)

	if var0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and var0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0.ShipIndex.campIndex == ShipIndexConst.CampAll and arg0.toggleType == var0.TOGGLE_CHAR then
		for iter0, iter1 in ipairs(var1) do
			local var2 = pg.ship_data_group[iter1]
			local var3
			local var4 = false

			if var2 then
				var3 = arg0.shipGroups[var2.group_type]
				var4 = Nation.IsLinkType(ShipGroup.getDefaultShipConfig(var2.group_type).nationality)
			end

			local var5 = var1(arg0.toggleType, var4, iter1)

			if var5 ~= -1 then
				var0[iter0] = {
					showTrans = false,
					code = var5,
					group = var3
				}
			end
		end
	else
		for iter2, iter3 in ipairs(var1) do
			local var6 = pg.ship_data_group[iter3]

			if var6 then
				local var7 = ShipGroup.New({
					id = var6.group_type
				})
				local var8 = arg0.shipGroups[var6.group_type]

				if var7 and ShipIndexConst.filterByType(var7, var0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var7, var0.ShipIndex.rarityIndex) then
					local var9 = Nation.IsLinkType(var7:getNation())

					if arg0.toggleType == var0.TOGGLE_CHAR and not var9 and ShipIndexConst.filterByCamp(var7, var0.ShipIndex.campIndex) then
						var0[#var0 + 1] = {
							showTrans = false,
							code = var1(arg0.toggleType, var9, iter3),
							group = var8
						}
					elseif arg0.toggleType == var0.TOGGLE_LINK and var9 then
						var0[#var0 + 1] = {
							showTrans = false,
							code = var1(arg0.toggleType, var9, iter3),
							group = var8
						}
					elseif arg0.toggleType == var0.TOGGLE_BLUEPRINT and ShipIndexConst.filterByCamp(var7, var0.ShipIndex.campIndex) then
						var0[#var0 + 1] = {
							showTrans = false,
							code = var1(arg0.toggleType, var9, iter3),
							group = var8
						}
					end
				end
			end
		end
	end

	arg0.cardInfos = var0

	arg0.cardList:SetTotalCount(#arg0.cardInfos, -1)
	arg0.cardList:ScrollTo(arg0.scrollValue or 0)
end

local function var2(arg0)
	return getProxy(ShipSkinProxy):GetAllSkinForARCamera(arg0)
end

local function var3(arg0)
	local var0 = {}
	local var1 = getProxy(ShipSkinProxy):getSkinList()
	local var2 = getProxy(CollectionProxy):getShipGroup(arg0)

	if var2 then
		local var3 = ShipGroup.getSkinList(arg0)

		for iter0, iter1 in ipairs(var3) do
			if iter1.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1, iter1.id) or iter1.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2.trans or iter1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2.married == 1 then
				var0[iter1.id] = true
			end
		end
	end

	return var0
end

function var0.onInitCard(arg0, arg1)
	local var0 = SnapshotShipCard.New(arg1)

	onButton(arg0, var0.go, function()
		if var0.shipGroup then
			if HXSet.isHxSkin() then
				local var0 = ShipGroup.getDefaultSkin(var0.shipGroup.id)

				arg0:emit(var0.SELECT_CHAR, var0.id)
				arg0:back()

				return
			end

			local var1 = var2(var0.shipGroup.id)

			if #var1 > 1 then
				local var2 = var3(var0.shipGroup.id)

				arg0:openSelectSkinPanel(var1, var2)
			elseif #var1 == 1 then
				arg0:emit(var0.SELECT_CHAR, var1[1].id)
				arg0:back()
			end
		end
	end)

	arg0.cardItems[arg1] = var0
end

function var0.onUpdateCard(arg0, arg1, arg2)
	local var0 = arg0.cardItems[arg2]

	if not var0 then
		arg0:onInitCard(arg2)

		var0 = arg0.cardItems[arg2]
	end

	local var1 = arg1 + 1
	local var2 = arg0.cardInfos[var1]

	if not var2 then
		return
	end

	local var3

	if var2.group then
		var3 = arg0.proposeList[var2.group.id]
	end

	var0:update(var2.code, var2.group, var2.showTrans, var3)
end

function var0.onReturnCard(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.cardItems[arg2]

	if var0 then
		var0:clear()
	end

	arg0.cardItems[arg2] = nil
end

function var0.initSelectSkinPanel(arg0)
	arg0.skinPanel = arg0:findTF("selectSkinPnl")

	local var0 = arg0:findTF("select_skin/btnBack", arg0.skinPanel)

	onButton(arg0, var0, function()
		arg0:closeSelectSkinPanel()
	end)

	arg0.skinScroll = arg0:findTF("select_skin/style_scroll", arg0.skinPanel)
	arg0.skinContainer = arg0:findTF("view_port", arg0.skinScroll)
	arg0.skinCard = arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0]

	setActive(arg0.skinCard, false)
	setActive(arg0.skinPanel, false)

	arg0.skinCardMap = {}
end

function var0.openSelectSkinPanel(arg0, arg1, arg2)
	setActive(arg0.skinPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.skinPanel, false)

	for iter0 = arg0.skinContainer.childCount, #arg1 - 1 do
		cloneTplTo(arg0.skinCard, arg0.skinContainer)
	end

	for iter1 = #arg1, arg0.skinContainer.childCount - 1 do
		setActive(arg0.skinContainer:GetChild(iter1), false)
	end

	local var0 = arg0.skinContainer.childCount

	for iter2, iter3 in ipairs(arg1) do
		local var1 = arg0.skinContainer:GetChild(iter2 - 1)
		local var2 = arg0.skinCardMap[var1]

		if not var2 then
			var2 = ShipSkinCard.New(var1.gameObject)
			arg0.skinCardMap[var1] = var2
		end

		local var3 = arg2[iter3.id]

		var2:updateSkin(iter3, var3)
		var2:updateUsing(false)
		removeOnButton(var1)
		onButton(arg0, var1, function()
			if var3 then
				arg0:emit(var0.SELECT_CHAR, iter3.id)
				arg0:closeSelectSkinPanel()
				arg0:back()
			end
		end)
		setActive(var1, true)
	end
end

function var0.closeSelectSkinPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.skinPanel, arg0._tf)
	setActive(arg0.skinPanel, false)
end

return var0
