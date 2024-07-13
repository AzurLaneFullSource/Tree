local var0_0 = class("EquipCodeShareLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipCodeShareUI"
end

function var0_0.setShipGroup(arg0_2, arg1_2)
	arg0_2.shipGroup = arg1_2
	arg0_2.codes = arg1_2:getEquipCodes()

	local var0_2 = {}

	arg0_2.firstPool = underscore(arg0_2.codes):chain():filter(function(arg0_3)
		return arg0_3.new == 0 and arg0_3.state == 0
	end):sort(CompareFuncs({
		function(arg0_4)
			return -arg0_4.like
		end
	})):first(12):each(function(arg0_5)
		var0_2[arg0_5.id] = true
	end):sort(CompareFuncs({
		function(arg0_6)
			return -arg0_6.evaPoint
		end
	})):value()
	arg0_2.oldPool = underscore.filter(arg0_2.codes, function(arg0_7)
		return arg0_7.new == 0 and not var0_2[arg0_7.id]
	end)
	arg0_2.newPool = underscore.filter(arg0_2.codes, function(arg0_8)
		return arg0_8.new == 1
	end)
end

local function var1_0(arg0_9, arg1_9, arg2_9)
	setActive(arg0_9:Find("IconTpl"), tobool(arg1_9))

	if not arg1_9 then
		return
	end

	updateEquipment(arg0_9:Find("IconTpl"), arg1_9)

	if not arg0_9:Find("IconTpl/icon_bg/equip_flag") then
		return
	end

	setActive(arg0_9:Find("IconTpl/icon_bg/equip_flag"), arg2_9)

	if not arg2_9 then
		return
	end

	setImageSprite(arg0_9:Find("IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. arg2_9:getPainting()))
end

local function var2_0(arg0_10, arg1_10, arg2_10)
	setActive(arg0_10:Find("Icon"), arg1_10)
	setActive(arg0_10:Find("IconShadow"), arg1_10)

	if not arg1_10 then
		return
	end

	UpdateSpWeaponSlot(arg0_10, arg1_10)

	if not arg0_10:Find("Icon/equip_flag") then
		return
	end

	setActive(arg0_10:Find("Icon/equip_flag"), arg2_10)

	if not arg2_10 then
		return
	end

	setImageSprite(arg0_10:Find("Icon/equip_flag/Image"), LoadSprite("qicon/" .. arg2_10:getPainting()))
end

local var3_0 = {
	customPanels = {
		minHeight = 650,
		labelIndex = {
			mode = CustomIndexLayer.Mode.AND,
			options = IndexConst.ECodeLabelIndexs,
			names = IndexConst.ECodeLabelNames
		}
	},
	groupList = {
		{
			dropdown = false,
			titleTxt = "indexsort_label",
			titleENTxt = "indexsort_labeleng",
			tags = {
				"labelIndex"
			}
		}
	}
}

function var0_0.init(arg0_11)
	onButton(arg0_11, arg0_11._tf:Find("BG"), function()
		arg0_11:closeView()
	end, SFX_CANCEL)

	arg0_11.rtMainPanel = arg0_11._tf:Find("mainPanel")

	onButton(arg0_11, arg0_11.rtMainPanel:Find("top_panel/btnBack"), function()
		arg0_11:closeView()
	end, SFX_CANCEL)

	arg0_11.indexData = arg0_11.indexData or {}

	local var0_11 = arg0_11.rtMainPanel:Find("top_panel/btn_filter")

	onButton(arg0_11, var0_11, function()
		arg0_11:emit(EquipCodeShareMediator.OPEN_TAG_INDEX, setmetatable({
			indexDatas = Clone(arg0_11.indexData),
			callback = function(arg0_15)
				arg0_11.indexData.labelIndex = arg0_15.labelIndex

				local var0_15 = arg0_11:isDefaultFilter()

				setImageAlpha(var0_11, var0_15 and 1 or 0)
				setActive(var0_11:Find("on"), not var0_15)

				arg0_11.refreshCount = 0

				arg0_11:refreshCodes()
			end
		}, {
			__index = var3_0
		}))
	end, SFX_PANEL)

	arg0_11.rtShipCard = arg0_11.rtMainPanel:Find("left_panel/ship_tpl")

	onButton(arg0_11, arg0_11.rtMainPanel:Find("left_panel/btn_refresh"), function()
		arg0_11:refreshCodes()
	end, SFX_PANEL)

	local var1_11 = arg0_11.rtMainPanel:Find("right_panel/content/container")

	arg0_11.itemList = UIItemList.New(var1_11, var1_11:Find("tpl"))

	local var2_11 = pg.equip_data_template
	local var3_11 = pg.spweapon_data_statistics

	arg0_11.itemList:make(function(arg0_17, arg1_17, arg2_17)
		arg1_17 = arg1_17 + 1

		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg0_11.filterCodes[arg1_17]
			local var1_17 = {}
			local var2_17
			local var3_17
			local var4_17, var5_17

			var4_17, var5_17, var1_17[1], var1_17[2] = unpack(string.split(var0_17.str, "&"))

			for iter0_17, iter1_17 in ipairs(parseEquipCode(var4_17)) do
				if iter0_17 == 6 then
					var2_0(arg2_17:Find("left/equipments/SpSlot"), var3_11[iter1_17] and SpWeapon.New({
						id = iter1_17
					}) or false)
				else
					var1_0(arg2_17:Find("left/equipments"):GetChild(iter0_17 - 1), var2_11[iter1_17] and Equipment.New({
						id = iter1_17
					}) or false)
				end
			end

			for iter2_17, iter3_17 in ipairs(var1_17) do
				setText(arg2_17:Find("left/tags/" .. iter2_17 .. "/Text"), i18n("equip_share_label_" .. iter3_17))
			end

			setText(arg2_17:Find("right/like/Text"), var0_17.like)
			onButton(arg0_11, arg2_17:Find("right/like/btn_like"), function()
				if var0_17.afterLike then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_limited"))
				else
					function arg0_11.successCallback()
						arg0_11.successCallback = nil

						setText(arg2_17:Find("right/like/Text"), var0_17.like)
					end

					arg0_11:emit(EquipCodeShareMediator.LIKE_EQUIP_CODE, arg0_11.shipGroup.id, var0_17.id)
				end
			end, SFX_PANEL)
			onButton(arg0_11, arg2_17:Find("right/like/btn_impeach"), function()
				arg0_11.impeachCodeId = var0_17.id

				setActive(arg0_11.rtMainPanel, false)
				setActive(arg0_11.impackPanel, true)
				triggerToggle(arg0_11.impackPanel:Find("window/msg_panel/content/options/tpl"), true)
			end, SFX_PANEL)
			onButton(arg0_11, arg2_17:Find("right/btn_copy"), function()
				UniPasteBoard.SetClipBoardString(var4_17)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_export_success"))
			end, SFX_CONFIRM)
		end
	end)
	setText(arg0_11.rtMainPanel:Find("right_panel/content/nothing/Text_2"), i18n("equipcode_share_listempty"))
	setText(arg0_11.rtMainPanel:Find("top_panel/title/name"), i18n("equipcode_share_title"))
	setText(arg0_11.rtMainPanel:Find("top_panel/title/name/name_en"), i18n("equipcode_share_titleeng"))
	arg0_11:initImpeachPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, false, {
		groupName = arg0_11:getGroupNameFromData(),
		weight = arg0_11:getWeightFromData()
	})
end

function var0_0.refreshLikeCommand(arg0_22, arg1_22, arg2_22)
	local var0_22 = underscore.detect(arg0_22.codes, function(arg0_23)
		return arg0_23.id == arg1_22
	end)

	var0_22.afterLike = true
	var0_22.like = var0_22.like + (arg2_22 and 1 or 0)

	existCall(arg0_22.successCallback)
end

function var0_0.initImpeachPanel(arg0_24)
	arg0_24.impackPanel = arg0_24._tf:Find("impeachPanel")

	setText(arg0_24.impackPanel:Find("window/top/bg/impeach/title"), i18n("report_sent_title"))
	onButton(arg0_24, arg0_24.impackPanel:Find("window/top/btnBack"), function()
		arg0_24:onBackPressed()
	end, SFX_CANCEL)

	local var0_24 = {
		{
			"equipcode_report_type_1",
			"equipcode_report_type_1"
		},
		{
			"equipcode_report_type_2",
			"equipcode_report_type_2"
		}
	}
	local var1_24 = arg0_24.impackPanel:Find("window/msg_panel/content")

	setText(var1_24:Find("title"), i18n("report_sent_desc"))

	local var2_24 = UIItemList.New(var1_24:Find("options"), var1_24:Find("options/tpl"))

	var2_24:make(function(arg0_26, arg1_26, arg2_26)
		arg1_26 = arg1_26 + 1

		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var0_24[arg1_26]

			setText(arg2_26:Find("Text"), i18n(var0_26[1]))
			setText(arg2_26:Find("Text_2"), i18n(var0_26[2]))
			onToggle(arg0_24, arg2_26, function(arg0_27)
				arg0_24.impeachOption = arg1_26
			end)
		end
	end)
	var2_24:align(#var0_24)

	local var3_24 = var1_24:Find("other/field/input")

	onButton(arg0_24, arg0_24.impackPanel:Find("window/button_container/button"), function()
		arg0_24:emit(EquipCodeShareMediator.IMPEACH_EQUIP_CODE, arg0_24.shipGroup.id, arg0_24.impeachCodeId, arg0_24.impeachOption)
		arg0_24:onBackPressed()
	end, SFX_CONFIRM)
end

function var0_0.onBackPressed(arg0_29)
	if isActive(arg0_29.impackPanel) then
		setActive(arg0_29.rtMainPanel, true)
		setActive(arg0_29.impackPanel, false)

		return
	end

	arg0_29:closeView()
end

function var0_0.didEnter(arg0_30)
	arg0_30:flushShip()

	arg0_30.refreshCount = 0

	arg0_30:refreshCodes()
end

function var0_0.flushShip(arg0_31)
	arg0_31.head = arg0_31.rtMainPanel:Find("left_panel/ship_tpl")
	arg0_31.iconType = arg0_31.head:Find("content/main_bg/type_mask/type_icon"):GetComponent(typeof(Image))
	arg0_31.imageBg = arg0_31.head:Find("content/icon_bg"):GetComponent(typeof(Image))
	arg0_31.imageFrame = arg0_31.head:Find("content/main_bg/frame")
	arg0_31.iconShip = arg0_31.head:Find("content/icon"):GetComponent(typeof(Image))
	arg0_31.labelName = arg0_31.head:Find("content/main_bg/name_mask/name"):GetComponent(typeof(Text))
	arg0_31.scrollText = arg0_31.head:Find("content/main_bg/name_mask/name"):GetComponent(typeof(ScrollText))
	arg0_31.stars = arg0_31.head:Find("content/main_bg/stars")
	arg0_31.star = arg0_31.stars:Find("tpl")

	local var0_31 = arg0_31.shipGroup.shipConfig
	local var1_31 = arg0_31.shipGroup:getPainting(arg0_31.showTrans)
	local var2_31 = arg0_31.shipGroup:rarity2bgPrint(arg0_31.showTrans)

	setShipCardFrame(arg0_31.imageFrame, var2_31, nil)
	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2_31, "", arg0_31.imageBg)

	arg0_31.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

	LoadImageSpriteAsync("shipYardIcon/" .. var1_31, arg0_31.iconShip)

	arg0_31.labelName.text = arg0_31.shipGroup:getName(arg0_31.showTrans)

	if arg0_31.scrollText then
		arg0_31.scrollText:SetText(arg0_31.shipGroup:getName(arg0_31.showTrans))
	end

	local var3_31 = GetSpriteFromAtlas("shiptype", shipType2print(arg0_31.shipGroup:getShipType(arg0_31.showTrans)))

	if not var3_31 then
		warning("找不到船形, shipConfigId: " .. var0_31.id)
	end

	arg0_31.iconType.sprite = var3_31

	local var4_31 = pg.ship_data_template[var0_31.id].star_max

	for iter0_31 = arg0_31.stars.childCount, var4_31 - 1 do
		local var5_31 = cloneTplTo(arg0_31.star, arg0_31.stars)
	end
end

function var0_0.isDefaultFilter(arg0_32)
	return underscore(arg0_32.indexData):chain():keys():all(function(arg0_33)
		return arg0_32.indexData[arg0_33] == var3_0.customPanels[arg0_33].options[1]
	end):value()
end

function var0_0.codesFilter(arg0_34, arg1_34)
	return underscore.filter(arg1_34, function(arg0_35)
		return IndexConst.filterEquipCodeByLable(arg0_35, arg0_34.indexData.labelIndex)
	end)
end

function var0_0.refreshCodes(arg0_36)
	arg0_36.refreshCount = arg0_36.refreshCount + 1
	arg0_36.filterCodes = {}

	if arg0_36.refreshCount > 4 or not arg0_36:isDefaultFilter() then
		local var0_36 = arg0_36:codesFilter(arg0_36.codes)

		if #var0_36 > 4 then
			for iter0_36 = 1, 4 do
				local var1_36 = math.random(#var0_36)

				table.insert(arg0_36.filterCodes, var0_36[var1_36])
				table.remove(var0_36, var1_36)
			end
		else
			arg0_36.filterCodes = var0_36
		end

		table.sort(arg0_36.filterCodes, CompareFuncs({
			function(arg0_37)
				return -arg0_37.like
			end
		}, false))
	else
		if #arg0_36.firstPool < 3 then
			arg0_36.filterCodes = underscore.rest(arg0_36.firstPool, 1)
		elseif #arg0_36.firstPool < arg0_36.refreshCount * 3 then
			local var2_36 = underscore.rest(arg0_36.firstPool, 1)

			for iter1_36 = 1, 3 do
				local var3_36 = math.random(#var2_36)

				table.insert(arg0_36.filterCodes, var2_36[var3_36])
				table.remove(var2_36, var3_36)
			end
		else
			arg0_36.filterCodes = underscore.slice(arg0_36.firstPool, (arg0_36.refreshCount - 1) * 3 + 1, 3)
		end

		local var4_36 = {
			underscore.rest(arg0_36.newPool, 1),
			underscore.rest(arg0_36.oldPool, 1),
			underscore.filter(arg0_36.firstPool, function(arg0_38)
				return underscore.all(arg0_36.filterCodes, function(arg0_39)
					return arg0_39.id ~= arg0_38.id
				end)
			end)
		}
		local var5_36

		while #arg0_36.filterCodes < 4 do
			if var5_36 and #var5_36 > 0 then
				local var6_36 = math.random(#var5_36)

				table.insert(arg0_36.filterCodes, var5_36[var6_36])
				table.remove(var5_36, var6_36)
			elseif #var4_36 > 0 then
				var5_36 = table.remove(var4_36, 1)
			else
				break
			end
		end
	end

	arg0_36.itemList:align(#arg0_36.filterCodes)
	setActive(arg0_36.rtMainPanel:Find("right_panel/content/nothing"), #arg0_36.filterCodes == 0)
end

function var0_0.willExit(arg0_40)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_40._tf)
end

return var0_0
