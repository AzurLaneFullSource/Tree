local var0_0 = class("LoveLetterSelectCharLayer", import("..base.BaseUI"))

var0_0.ON_INDEX = "LoveLetterSelectCharLayer.ON_INDEX"
var0_0.SELECT_CHAR = "LoveLetterSelectCharLayer.SELECT_CHAR"
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
	return "LoveLetterGroupChangeUI"
end

function var0_0.back(arg0_4)
	if arg0_4.exited then
		return
	end

	arg0_4:emit(var0_0.ON_CLOSE)
end

function var0_0.init(arg0_5)
	arg0_5.topTF = arg0_5._tf:Find("blur_panel/adapt/top")
	arg0_5.backBtn = arg0_5.topTF:Find("back_btn")
	arg0_5.indexBtn = arg0_5.topTF:Find("index_button")

	setActive(arg0_5._tf:Find("list_card/types"), false)

	arg0_5.cardItems = {}
	arg0_5.cardList = arg0_5._tf:Find("list_card/scroll"):GetComponent("LScrollRect")

	function arg0_5.cardList.onInitItem(arg0_6)
		arg0_5:onInitCard(arg0_6)
	end

	function arg0_5.cardList.onUpdateItem(arg0_7, arg1_7)
		arg0_5:onUpdateCard(arg0_7, arg1_7)
	end

	function arg0_5.cardList.onReturnItem(arg0_8, arg1_8)
		arg0_5:onReturnCard(arg0_8, arg1_8)
	end

	arg0_5:OverlayPanel(arg0_5._tf)
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:back()
	end)
	onButton(arg0_9, arg0_9.indexBtn, function()
		local var0_11 = Clone(var0_0.ShipIndexData)

		var0_11.indexDatas = Clone(var0_0.ShipIndex)

		function var0_11.callback(arg0_12)
			var0_0.ShipIndex.typeIndex = arg0_12.typeIndex

			if arg0_12.campIndex then
				var0_0.ShipIndex.campIndex = arg0_12.campIndex
			end

			var0_0.ShipIndex.rarityIndex = arg0_12.rarityIndex

			arg0_9:updateCardList()
		end

		arg0_9:emit(var0_0.ON_INDEX, var0_11)
	end)
	arg0_9:updateCardList()
end

function var0_0.willExit(arg0_13)
	arg0_13:UnOverlayPanel(arg0_13._tf)
end

local function var1_0(arg0_14, arg1_14, arg2_14)
	if arg0_14 == var0_0.TOGGLE_CHAR and not arg1_14 then
		return arg2_14
	elseif arg0_14 == var0_0.TOGGLE_LINK and arg1_14 then
		return arg2_14 - 10000
	elseif arg0_14 == var0_0.TOGGLE_BLUEPRINT then
		return arg2_14 - 20000
	end

	return -1
end

function var0_0.updateCardList(arg0_15)
	local var0_15 = {}
	local var1_15 = {}
	local var2_15

	if arg0_15.contextData.isRepair then
		var2_15 = underscore.map(pg.lover_letter_content.get_id_list_by_year[2018], function(arg0_16)
			return pg.lover_letter_content[arg0_16].ship_group
		end)
	else
		var2_15 = pg.lover_character_template.all
	end

	for iter0_15, iter1_15 in ipairs(var2_15) do
		local var3_15 = pg.ship_data_group.get_id_list_by_group_type[iter1_15]

		assert(not var3_15 or #var3_15 == 1)

		if not var3_15 then
			warning(iter1_15)
		elseif underscore.any(table.insertto({
			iter1_15
		}, pg.lover_character_template[iter1_15].relate_group_id), function(arg0_17)
			return arg0_15.shipGroups[arg0_17]
		end) then
			table.insert(var1_15, var3_15[1])
		end
	end

	table.sort(var1_15)

	if var0_0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and var0_0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0_0.ShipIndex.campIndex == ShipIndexConst.CampAll then
		for iter2_15, iter3_15 in ipairs(var1_15) do
			local var4_15 = pg.ship_data_group[iter3_15]
			local var5_15
			local var6_15 = false

			if var4_15 then
				var5_15 = arg0_15.shipGroups[var4_15.group_type] or ShipGroup.New({
					id = var4_15.group_type
				})
				var6_15 = Nation.IsLinkType(ShipGroup.getDefaultShipConfig(var4_15.group_type).nationality)
			end

			local var7_15 = var4_15.handbook_type
			local var8_15 = var1_0(var7_15, var6_15, iter3_15)

			if var8_15 ~= -1 then
				var0_15[iter2_15] = {
					showTrans = false,
					code = var8_15,
					group = var5_15
				}
			end
		end
	else
		for iter4_15, iter5_15 in ipairs(var1_15) do
			local var9_15 = pg.ship_data_group[iter5_15]

			if var9_15 then
				local var10_15 = ShipGroup.New({
					id = var9_15.group_type
				})
				local var11_15 = arg0_15.shipGroups[var9_15.group_type]

				if var10_15 and ShipIndexConst.filterByType(var10_15, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var10_15, var0_0.ShipIndex.rarityIndex) then
					local var12_15 = Nation.IsLinkType(var10_15:getNation())
					local var13_15 = var9_15.handbook_type

					if ShipIndexConst.filterByCamp(var10_15, var0_0.ShipIndex.campIndex) then
						var0_15[#var0_15 + 1] = {
							showTrans = false,
							code = var1_0(var13_15, var12_15, iter5_15),
							group = var11_15
						}
					end
				end
			end
		end
	end

	arg0_15.cardInfos = var0_15

	arg0_15.cardList:SetTotalCount(#arg0_15.cardInfos, -1)
end

local function var2_0(arg0_18)
	return getProxy(ShipSkinProxy):GetAllSkinForARCamera(arg0_18)
end

local function var3_0(arg0_19)
	local var0_19 = {}
	local var1_19 = getProxy(ShipSkinProxy)
	local var2_19 = var1_19:getSkinList()
	local var3_19 = getProxy(CollectionProxy):getShipGroup(arg0_19)

	if var3_19 then
		local var4_19 = ShipGroup.getSkinList(arg0_19)

		for iter0_19, iter1_19 in ipairs(var4_19) do
			if iter1_19.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var2_19, iter1_19.id) or iter1_19.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3_19.trans or iter1_19.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var3_19.married == 1 or var1_19:hasSkin(iter1_19.id) then
				var0_19[iter1_19.id] = true
			end
		end
	end

	return var0_19
end

function var0_0.onInitCard(arg0_20, arg1_20)
	local var0_20 = LoveLetterShipCard.New(arg1_20)

	onButton(arg0_20, var0_20.go, function()
		if var0_20.shipGroup then
			arg0_20:emit(var0_0.SELECT_CHAR, var0_20.shipGroup.id)
		end
	end)

	arg0_20.cardItems[arg1_20] = var0_20
end

function var0_0.onUpdateCard(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cardItems[arg2_22]

	if not var0_22 then
		arg0_22:onInitCard(arg2_22)

		var0_22 = arg0_22.cardItems[arg2_22]
	end

	local var1_22 = arg1_22 + 1
	local var2_22 = arg0_22.cardInfos[var1_22]

	if not var2_22 then
		return
	end

	local var3_22

	if var2_22.group then
		local var4_22 = arg0_22.proposeList[var2_22.group.id]
	end

	var0_22:update(var2_22.group)
end

function var0_0.onReturnCard(arg0_23, arg1_23, arg2_23)
	if arg0_23.exited then
		return
	end

	local var0_23 = arg0_23.cardItems[arg2_23]

	if var0_23 then
		var0_23:clear()
	end

	arg0_23.cardItems[arg2_23] = nil
end

return var0_0
