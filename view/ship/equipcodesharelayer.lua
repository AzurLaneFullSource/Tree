local var0 = class("EquipCodeShareLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipCodeShareUI"
end

function var0.setShipGroup(arg0, arg1)
	arg0.shipGroup = arg1
	arg0.codes = arg1:getEquipCodes()

	local var0 = {}

	arg0.firstPool = underscore(arg0.codes):chain():filter(function(arg0)
		return arg0.new == 0 and arg0.state == 0
	end):sort(CompareFuncs({
		function(arg0)
			return -arg0.like
		end
	})):first(12):each(function(arg0)
		var0[arg0.id] = true
	end):sort(CompareFuncs({
		function(arg0)
			return -arg0.evaPoint
		end
	})):value()
	arg0.oldPool = underscore.filter(arg0.codes, function(arg0)
		return arg0.new == 0 and not var0[arg0.id]
	end)
	arg0.newPool = underscore.filter(arg0.codes, function(arg0)
		return arg0.new == 1
	end)
end

local function var1(arg0, arg1, arg2)
	setActive(arg0:Find("IconTpl"), tobool(arg1))

	if not arg1 then
		return
	end

	updateEquipment(arg0:Find("IconTpl"), arg1)

	if not arg0:Find("IconTpl/icon_bg/equip_flag") then
		return
	end

	setActive(arg0:Find("IconTpl/icon_bg/equip_flag"), arg2)

	if not arg2 then
		return
	end

	setImageSprite(arg0:Find("IconTpl/icon_bg/equip_flag/Image"), LoadSprite("qicon/" .. arg2:getPainting()))
end

local function var2(arg0, arg1, arg2)
	setActive(arg0:Find("Icon"), arg1)
	setActive(arg0:Find("IconShadow"), arg1)

	if not arg1 then
		return
	end

	UpdateSpWeaponSlot(arg0, arg1)

	if not arg0:Find("Icon/equip_flag") then
		return
	end

	setActive(arg0:Find("Icon/equip_flag"), arg2)

	if not arg2 then
		return
	end

	setImageSprite(arg0:Find("Icon/equip_flag/Image"), LoadSprite("qicon/" .. arg2:getPainting()))
end

local var3 = {
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

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.rtMainPanel = arg0._tf:Find("mainPanel")

	onButton(arg0, arg0.rtMainPanel:Find("top_panel/btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.indexData = arg0.indexData or {}

	local var0 = arg0.rtMainPanel:Find("top_panel/btn_filter")

	onButton(arg0, var0, function()
		arg0:emit(EquipCodeShareMediator.OPEN_TAG_INDEX, setmetatable({
			indexDatas = Clone(arg0.indexData),
			callback = function(arg0)
				arg0.indexData.labelIndex = arg0.labelIndex

				local var0 = arg0:isDefaultFilter()

				setImageAlpha(var0, var0 and 1 or 0)
				setActive(var0:Find("on"), not var0)

				arg0.refreshCount = 0

				arg0:refreshCodes()
			end
		}, {
			__index = var3
		}))
	end, SFX_PANEL)

	arg0.rtShipCard = arg0.rtMainPanel:Find("left_panel/ship_tpl")

	onButton(arg0, arg0.rtMainPanel:Find("left_panel/btn_refresh"), function()
		arg0:refreshCodes()
	end, SFX_PANEL)

	local var1 = arg0.rtMainPanel:Find("right_panel/content/container")

	arg0.itemList = UIItemList.New(var1, var1:Find("tpl"))

	local var2 = pg.equip_data_template
	local var3 = pg.spweapon_data_statistics

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.filterCodes[arg1]
			local var1 = {}
			local var2
			local var3
			local var4, var5

			var4, var5, var1[1], var1[2] = unpack(string.split(var0.str, "&"))

			for iter0, iter1 in ipairs(parseEquipCode(var4)) do
				if iter0 == 6 then
					var2(arg2:Find("left/equipments/SpSlot"), var3[iter1] and SpWeapon.New({
						id = iter1
					}) or false)
				else
					var1(arg2:Find("left/equipments"):GetChild(iter0 - 1), var2[iter1] and Equipment.New({
						id = iter1
					}) or false)
				end
			end

			for iter2, iter3 in ipairs(var1) do
				setText(arg2:Find("left/tags/" .. iter2 .. "/Text"), i18n("equip_share_label_" .. iter3))
			end

			setText(arg2:Find("right/like/Text"), var0.like)
			onButton(arg0, arg2:Find("right/like/btn_like"), function()
				if var0.afterLike then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_limited"))
				else
					function arg0.successCallback()
						arg0.successCallback = nil

						setText(arg2:Find("right/like/Text"), var0.like)
					end

					arg0:emit(EquipCodeShareMediator.LIKE_EQUIP_CODE, arg0.shipGroup.id, var0.id)
				end
			end, SFX_PANEL)
			onButton(arg0, arg2:Find("right/like/btn_impeach"), function()
				arg0.impeachCodeId = var0.id

				setActive(arg0.rtMainPanel, false)
				setActive(arg0.impackPanel, true)
				triggerToggle(arg0.impackPanel:Find("window/msg_panel/content/options/tpl"), true)
			end, SFX_PANEL)
			onButton(arg0, arg2:Find("right/btn_copy"), function()
				UniPasteBoard.SetClipBoardString(var4)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_export_success"))
			end, SFX_CONFIRM)
		end
	end)
	setText(arg0.rtMainPanel:Find("right_panel/content/nothing/Text_2"), i18n("equipcode_share_listempty"))
	setText(arg0.rtMainPanel:Find("top_panel/title/name"), i18n("equipcode_share_title"))
	setText(arg0.rtMainPanel:Find("top_panel/title/name/name_en"), i18n("equipcode_share_titleeng"))
	arg0:initImpeachPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData()
	})
end

function var0.refreshLikeCommand(arg0, arg1, arg2)
	local var0 = underscore.detect(arg0.codes, function(arg0)
		return arg0.id == arg1
	end)

	var0.afterLike = true
	var0.like = var0.like + (arg2 and 1 or 0)

	existCall(arg0.successCallback)
end

function var0.initImpeachPanel(arg0)
	arg0.impackPanel = arg0._tf:Find("impeachPanel")

	setText(arg0.impackPanel:Find("window/top/bg/impeach/title"), i18n("report_sent_title"))
	onButton(arg0, arg0.impackPanel:Find("window/top/btnBack"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)

	local var0 = {
		{
			"equipcode_report_type_1",
			"equipcode_report_type_1"
		},
		{
			"equipcode_report_type_2",
			"equipcode_report_type_2"
		}
	}
	local var1 = arg0.impackPanel:Find("window/msg_panel/content")

	setText(var1:Find("title"), i18n("report_sent_desc"))

	local var2 = UIItemList.New(var1:Find("options"), var1:Find("options/tpl"))

	var2:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1]

			setText(arg2:Find("Text"), i18n(var0[1]))
			setText(arg2:Find("Text_2"), i18n(var0[2]))
			onToggle(arg0, arg2, function(arg0)
				arg0.impeachOption = arg1
			end)
		end
	end)
	var2:align(#var0)

	local var3 = var1:Find("other/field/input")

	onButton(arg0, arg0.impackPanel:Find("window/button_container/button"), function()
		arg0:emit(EquipCodeShareMediator.IMPEACH_EQUIP_CODE, arg0.shipGroup.id, arg0.impeachCodeId, arg0.impeachOption)
		arg0:onBackPressed()
	end, SFX_CONFIRM)
end

function var0.onBackPressed(arg0)
	if isActive(arg0.impackPanel) then
		setActive(arg0.rtMainPanel, true)
		setActive(arg0.impackPanel, false)

		return
	end

	arg0:closeView()
end

function var0.didEnter(arg0)
	arg0:flushShip()

	arg0.refreshCount = 0

	arg0:refreshCodes()
end

function var0.flushShip(arg0)
	arg0.head = arg0.rtMainPanel:Find("left_panel/ship_tpl")
	arg0.iconType = arg0.head:Find("content/main_bg/type_mask/type_icon"):GetComponent(typeof(Image))
	arg0.imageBg = arg0.head:Find("content/icon_bg"):GetComponent(typeof(Image))
	arg0.imageFrame = arg0.head:Find("content/main_bg/frame")
	arg0.iconShip = arg0.head:Find("content/icon"):GetComponent(typeof(Image))
	arg0.labelName = arg0.head:Find("content/main_bg/name_mask/name"):GetComponent(typeof(Text))
	arg0.scrollText = arg0.head:Find("content/main_bg/name_mask/name"):GetComponent(typeof(ScrollText))
	arg0.stars = arg0.head:Find("content/main_bg/stars")
	arg0.star = arg0.stars:Find("tpl")

	local var0 = arg0.shipGroup.shipConfig
	local var1 = arg0.shipGroup:getPainting(arg0.showTrans)
	local var2 = arg0.shipGroup:rarity2bgPrint(arg0.showTrans)

	setShipCardFrame(arg0.imageFrame, var2, nil)
	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2, "", arg0.imageBg)

	arg0.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

	LoadImageSpriteAsync("shipYardIcon/" .. var1, arg0.iconShip)

	arg0.labelName.text = arg0.shipGroup:getName(arg0.showTrans)

	if arg0.scrollText then
		arg0.scrollText:SetText(arg0.shipGroup:getName(arg0.showTrans))
	end

	local var3 = GetSpriteFromAtlas("shiptype", shipType2print(arg0.shipGroup:getShipType(arg0.showTrans)))

	if not var3 then
		warning("找不到船形, shipConfigId: " .. var0.id)
	end

	arg0.iconType.sprite = var3

	local var4 = pg.ship_data_template[var0.id].star_max

	for iter0 = arg0.stars.childCount, var4 - 1 do
		local var5 = cloneTplTo(arg0.star, arg0.stars)
	end
end

function var0.isDefaultFilter(arg0)
	return underscore(arg0.indexData):chain():keys():all(function(arg0)
		return arg0.indexData[arg0] == var3.customPanels[arg0].options[1]
	end):value()
end

function var0.codesFilter(arg0, arg1)
	return underscore.filter(arg1, function(arg0)
		return IndexConst.filterEquipCodeByLable(arg0, arg0.indexData.labelIndex)
	end)
end

function var0.refreshCodes(arg0)
	arg0.refreshCount = arg0.refreshCount + 1
	arg0.filterCodes = {}

	if arg0.refreshCount > 4 or not arg0:isDefaultFilter() then
		local var0 = arg0:codesFilter(arg0.codes)

		if #var0 > 4 then
			for iter0 = 1, 4 do
				local var1 = math.random(#var0)

				table.insert(arg0.filterCodes, var0[var1])
				table.remove(var0, var1)
			end
		else
			arg0.filterCodes = var0
		end

		table.sort(arg0.filterCodes, CompareFuncs({
			function(arg0)
				return -arg0.like
			end
		}, false))
	else
		if #arg0.firstPool < 3 then
			arg0.filterCodes = underscore.rest(arg0.firstPool, 1)
		elseif #arg0.firstPool < arg0.refreshCount * 3 then
			local var2 = underscore.rest(arg0.firstPool, 1)

			for iter1 = 1, 3 do
				local var3 = math.random(#var2)

				table.insert(arg0.filterCodes, var2[var3])
				table.remove(var2, var3)
			end
		else
			arg0.filterCodes = underscore.slice(arg0.firstPool, (arg0.refreshCount - 1) * 3 + 1, 3)
		end

		local var4 = {
			underscore.rest(arg0.newPool, 1),
			underscore.rest(arg0.oldPool, 1),
			underscore.filter(arg0.firstPool, function(arg0)
				return underscore.all(arg0.filterCodes, function(arg0)
					return arg0.id ~= arg0.id
				end)
			end)
		}
		local var5

		while #arg0.filterCodes < 4 do
			if var5 and #var5 > 0 then
				local var6 = math.random(#var5)

				table.insert(arg0.filterCodes, var5[var6])
				table.remove(var5, var6)
			elseif #var4 > 0 then
				var5 = table.remove(var4, 1)
			else
				break
			end
		end
	end

	arg0.itemList:align(#arg0.filterCodes)
	setActive(arg0.rtMainPanel:Find("right_panel/content/nothing"), #arg0.filterCodes == 0)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
