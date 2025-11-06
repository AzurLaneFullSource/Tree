local var0_0 = class("EquipCodeScene", import("..base.BaseUI"))

var0_0.optionsPath = {
	"adpter/frame/option"
}

function var0_0.getUIName(arg0_1)
	return "EquipCodeUI"
end

function var0_0.setEquipments(arg0_2, arg1_2, arg2_2)
	arg0_2.equips = arg1_2

	table.sort(arg0_2.equips, CompareFuncs(EquipmentSortCfg.sortFunc(EquipmentSortCfg.sort[1], false)))

	arg0_2.spWeapons = arg2_2

	table.sort(arg0_2.spWeapons, CompareFuncs(SpWeaponSortCfg.sortFunc(SpWeaponSortCfg.sort[1], false)))
end

function var0_0.setShip(arg0_3, arg1_3)
	arg0_3.shipVO = getProxy(BayProxy):getShipById(arg1_3)
	arg0_3.shipData = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.shipVO:getAllEquipments()) do
		if not iter1_3 then
			arg0_3.shipData[iter0_3] = false
		else
			arg0_3.shipData[iter0_3] = underscore.detect(arg0_3.equips, function(arg0_4)
				return arg0_4.configId == iter1_3.configId and arg0_4.shipId == arg0_3.shipVO.id and arg0_4.shipPos == iter0_3
			end) or false
		end
	end

	local var0_3 = arg0_3.shipVO:GetSpWeapon()

	if not var0_3 then
		arg0_3.shipData[6] = false
	else
		arg0_3.shipData[6] = underscore.detect(arg0_3.spWeapons, function(arg0_5)
			return arg0_5.configId == var0_3.configId and arg0_5:GetShipId() == arg0_3.shipVO.id
		end) or false
	end
end

function var0_0.getEquipShipVO(arg0_6, arg1_6)
	local var0_6 = arg0_6.shipVO:clone()

	var0_6.equipments = underscore.first(arg1_6, 5)
	var0_6.spWeapon = arg1_6[6] or nil

	return var0_6
end

local function var1_0(arg0_7, arg1_7, arg2_7)
	setActive(arg0_7:Find("IconTpl"), tobool(arg1_7))

	if arg1_7 then
		updateEquipment(arg0_7:Find("IconTpl"), arg1_7)
	end

	if arg0_7:Find("equip_flag") then
		setActive(arg0_7:Find("equip_flag"), arg2_7)

		if arg2_7 then
			setImageSprite(arg0_7:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2_7:getPainting()))
		end
	end
end

local function var2_0(arg0_8, arg1_8, arg2_8)
	setActive(arg0_8:Find("IconTpl"), tobool(arg1_8))

	if arg1_8 then
		updateSpWeapon(arg0_8:Find("IconTpl"), arg1_8)
	end

	if arg0_8:Find("equip_flag") then
		setActive(arg0_8:Find("equip_flag"), arg2_8)

		if arg2_8 then
			setImageSprite(arg0_8:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2_8:getPainting()))
		end
	end
end

local function var3_0(arg0_9, arg1_9, arg2_9)
	setActive(arg0_9:Find("Icon"), arg1_9)
	setActive(arg0_9:Find("IconShadow"), arg1_9)

	if arg1_9 then
		UpdateSpWeaponSlot(arg0_9, arg1_9)
	end

	if arg0_9:Find("equip_flag") then
		setActive(arg0_9:Find("equip_flag"), arg2_9)

		if arg2_9 then
			setImageSprite(arg0_9:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2_9:getPainting()))
		end
	end
end

local function var4_0(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:Find("error")

	if not arg1_10 or not arg2_10 then
		setActive(var0_10, false)
	elseif arg1_10.configId == arg2_10.configId then
		setActive(var0_10, false)
	else
		local var1_10 = false
		local var2_10 = instanceof(arg1_10, SpWeapon) and pg.spweapon_data_statistics or pg.equip_data_template

		for iter0_10, iter1_10 in ipairs({
			"next",
			"prev"
		}) do
			local var3_10 = arg1_10.configId

			while var2_10[var3_10][iter1_10] > 0 do
				var3_10 = var2_10[var3_10][iter1_10]

				if var3_10 == arg2_10.configId then
					var1_10 = true

					break
				end
			end

			if var1_10 then
				break
			end
		end

		setActive(var0_10, true)
		setText(var0_10:Find("Text"), i18n(var1_10 and "equipcode_level_unmatched" or "equipcode_diff_selected"))
	end
end

function var0_0.onBackPressed(arg0_11)
	local var0_11 = {}

	for iter0_11 = 1, #arg0_11.shipData do
		if (arg0_11.shipData[iter0_11] and arg0_11.shipData[iter0_11].configId or 0) ~= (arg0_11.equipData[iter0_11] and arg0_11.equipData[iter0_11].configId or 0) then
			table.insert(var0_11, function(arg0_12)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipcode_unsaved_tips"),
					onYes = arg0_12
				})
			end)

			break
		end
	end

	seriesAsync(var0_11, function()
		arg0_11:closeView()
	end)
end

local var5_0

function var0_0.init(arg0_14)
	var5_0 = var5_0 or {
		customPanels = {
			labelIndex = {
				num = 2,
				mode = CustomIndexLayer.Mode.NUM,
				options = underscore.rest(IndexConst.ECodeLabelIndexs),
				names = underscore.rest(IndexConst.ECodeLabelNames)
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
		},
		tip = i18n("equipcode_share_ruletips")
	}
	arg0_14.btnBack = arg0_14._tf:Find("adpter/frame/btnBack")

	onButton(arg0_14, arg0_14.btnBack, function()
		arg0_14:onBackPressed()
	end, SFX_CANCEL)

	arg0_14.rtMainPanel = arg0_14._tf:Find("main_panel")

	onButton(arg0_14, arg0_14.rtMainPanel:Find("btns/btn_export"), function()
		UniPasteBoard.SetClipBoardString(buildEquipCode(arg0_14.shipVO))
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_export_success"))
	end, SFX_CONFIRM)
	onButton(arg0_14, arg0_14.rtMainPanel:Find("share/btn_comments"), function()
		arg0_14:emit(EquipCodeMediator.OPEN_EQUIP_CODE_SHARE, arg0_14.shipVO:getGroupId())
	end, SFX_PANEL)

	arg0_14.tagIndexData = {}

	onButton(arg0_14, arg0_14.rtMainPanel:Find("share/btn_share"), function()
		arg0_14:emit(EquipCodeMediator.OPEN_CUSTOM_INDEX, setmetatable({
			indexDatas = Clone(arg0_14.tagIndexData),
			callback = function(arg0_19)
				arg0_14.tagIndexData.labelIndex = arg0_19.labelIndex

				local var0_19 = 0
				local var1_19 = arg0_19.labelIndex

				while var1_19 > 0 do
					var0_19 = var0_19 + 1
					var1_19 = bit.band(var1_19, var1_19 - 1)
				end

				if var0_19 == 2 then
					local var2_19 = buildEquipCode(arg0_14.shipVO)
					local var3_19 = {}
					local var4_19 = arg0_14.tagIndexData.labelIndex

					while var4_19 > 0 do
						local var5_19 = bit.band(var4_19, -var4_19)

						var4_19 = var4_19 - var5_19

						local var6_19 = 0

						while var5_19 > 0 do
							var6_19 = var6_19 + 1
							var5_19 = math.floor(var5_19 / 2)
						end

						table.insert(var3_19, tostring(var6_19))
					end

					local var7_19 = arg0_14.shipVO:getGroupId()
					local var8_19 = table.concat({
						var2_19,
						ConversionBase(32, var7_19),
						var3_19[1],
						var3_19[2]
					}, "&")

					arg0_14:emit(EquipCodeMediator.SHARE_EQUIP_CODE, var7_19, var8_19)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_nolabel"))
				end
			end
		}, {
			__index = var5_0
		}))
	end, SFX_PANEL)

	arg0_14.rtCodePanel = arg0_14._tf:Find("code_panel")

	onButton(arg0_14, arg0_14.rtCodePanel:Find("btns/btn_import"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("equipcode_confirm_doublecheck"),
			onYes = function()
				arg0_14:emit(EquipCodeMediator.IMPORT_SHIP_EQUIP, arg0_14.shipVO.id, arg0_14.equipData)
			end
		})
	end, SFX_CONFIRM)
	onButton(arg0_14, arg0_14.rtCodePanel:Find("btns/btn_withdrawn"), function()
		arg0_14.code = nil

		arg0_14:updateDispalyPanel(arg0_14.rtCodePanel, "code")
	end, SFX_CANCEL)
	onButton(arg0_14, arg0_14.rtCodePanel:Find("btns/btn_cancel"), function()
		arg0_14:updateDispalyPanel(arg0_14.rtCodePanel, "code")
		arg0_14:initQuickPanel()
	end, SFX_CANCEL)
	onToggle(arg0_14, arg0_14.rtCodePanel:Find("btns/toggle_quick"), function(arg0_24)
		setInputText(arg0_14.nameSearchInput, "")
		setActive(arg0_14.rtMainPanel, false)
		setActive(arg0_14.rtBottomPanel, false)
		setActive(arg0_14.rtQuickPanel, false)
		setActive(arg0_14.rtCodePanel:Find("btns/btn_withdrawn"), not arg0_24)
		setActive(arg0_14.rtCodePanel:Find("btns/btn_cancel"), arg0_24)

		if arg0_14.quickIndex then
			triggerToggle(arg0_14.rtCodePanel:Find("equipments_quick"):GetChild(arg0_14.quickIndex - 1), false)
		end

		eachChild(arg0_14.rtCodePanel:Find("equipments_quick"), function(arg0_25)
			SetCompomentEnabled(arg0_25, typeof(Toggle), false)
		end)

		arg0_14.ltID = LeanTween.moveY(arg0_14.rtCodePanel, arg0_24 and 420 or 80, math.max(math.abs((arg0_24 and 420 or 80) - arg0_14.rtCodePanel.anchoredPosition.y), 0.1) / 2000):setOnComplete(System.Action(function()
			arg0_14.ltID = nil

			setActive(arg0_14.rtMainPanel, not arg0_24)
			setActive(arg0_14.rtBottomPanel, not arg0_24)
			setActive(arg0_14.rtQuickPanel, arg0_24)

			if arg0_24 then
				arg0_14:initQuickPanel()
			end
		end)).uniqueId
	end)
	eachChild(arg0_14.rtCodePanel:Find("equipments_quick"), function(arg0_27)
		onToggle(arg0_14, arg0_27, function(arg0_28)
			if arg0_28 then
				arg0_14.quickIndex = arg0_27:GetSiblingIndex() + 1

				arg0_14:updateQuickPanel()
			elseif arg0_14.quickIndex == arg0_27:GetSiblingIndex() + 1 then
				arg0_14.quickIndex = nil

				arg0_14:updateQuickPanel()
			end
		end, SFX_PANEL)
		SetCompomentEnabled(arg0_27, typeof(Toggle), false)
	end)

	arg0_14.rtQuickPanel = arg0_14._tf:Find("quick_panel")

	onToggle(arg0_14, arg0_14.rtQuickPanel:Find("title/equiping"), function(arg0_29)
		arg0_14.equipingFlag = arg0_29

		if isActive(arg0_14.rtQuickPanel) then
			arg0_14:updateQuickPanel(true)
		end
	end, SFX_PANEL)

	arg0_14.nameSearchInput = arg0_14.rtQuickPanel:Find("title/serachPanel/search")
	arg0_14.nameSearchText = arg0_14.nameSearchInput:Find("holder")

	setText(arg0_14.nameSearchText, i18n("search_equipment"))
	setInputText(arg0_14.nameSearchInput, "")
	onInputChanged(arg0_14, arg0_14.nameSearchInput, function()
		arg0_14:updateQuickPanel(true)
	end)

	arg0_14.indexData = arg0_14.indexData or {}
	arg0_14.spweaponIndexDatas = arg0_14.spweaponIndexDatas or {}

	local var0_14 = arg0_14.rtQuickPanel:Find("title/filter")

	onButton(arg0_14, var0_14, function()
		assert(arg0_14.quickIndex)

		local var0_31 = switch(arg0_14.quickIndex, {
			[6] = function()
				return setmetatable({
					indexDatas = Clone(arg0_14.spweaponIndexDatas),
					callback = function(arg0_33)
						arg0_14.spweaponIndexDatas.typeIndex = arg0_33.typeIndex
						arg0_14.spweaponIndexDatas.rarityIndex = arg0_33.rarityIndex

						local var0_33 = underscore(arg0_14.spweaponIndexDatas):chain():keys():all(function(arg0_34)
							return arg0_14.spweaponIndexDatas[arg0_34] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0_34].options[1]
						end):value()

						setActive(var0_14:Find("on"), not var0_33)
						setActive(var0_14:Find("off"), var0_33)
						arg0_14:updateQuickPanel()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		}, function()
			return setmetatable({
				indexDatas = Clone(arg0_14.indexData),
				callback = function(arg0_36)
					arg0_14.indexData.typeIndex = arg0_36.typeIndex
					arg0_14.indexData.equipPropertyIndex = arg0_36.equipPropertyIndex
					arg0_14.indexData.equipPropertyIndex2 = arg0_36.equipPropertyIndex2
					arg0_14.indexData.equipAmmoIndex1 = arg0_36.equipAmmoIndex1
					arg0_14.indexData.equipAmmoIndex2 = arg0_36.equipAmmoIndex2
					arg0_14.indexData.equipCampIndex = arg0_36.equipCampIndex
					arg0_14.indexData.rarityIndex = arg0_36.rarityIndex
					arg0_14.indexData.extraIndex = arg0_36.extraIndex

					local var0_36 = underscore(arg0_14.indexData):chain():keys():all(function(arg0_37)
						return arg0_14.indexData[arg0_37] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0_37].options[1]
					end):value()

					setActive(var0_14:Find("on"), not var0_36)
					setActive(var0_14:Find("off"), var0_36)
					arg0_14:updateQuickPanel()
				end
			}, {
				__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
			})
		end)

		arg0_14:emit(EquipCodeMediator.OPEN_CUSTOM_INDEX, var0_31)
	end, SFX_PANEL)

	arg0_14.comList = arg0_14.rtQuickPanel:Find("frame/container"):GetComponent("LScrollRect")

	function arg0_14.comList.onInitItem(arg0_38)
		ClearTweenItemAlphaAndWhite(arg0_38)
	end

	function arg0_14.comList.onReturnItem(arg0_39, arg1_39)
		ClearTweenItemAlphaAndWhite(arg1_39)
	end

	function arg0_14.comList.onUpdateItem(arg0_40, arg1_40)
		if not arg0_14.quickIndex then
			return
		end

		TweenItemAlphaAndWhite(arg1_40)

		local var0_40 = tf(arg1_40)
		local var1_40 = arg0_14.filterEquipments[arg0_40 + 1]

		setActive(var0_40:Find("unEquip"), not var1_40)
		setActive(var0_40:Find("bg"), var1_40)
		setActive(var0_40:Find("IconTpl"), var1_40)

		if arg0_14.quickIndex == 6 then
			var2_0(var0_40, var1_40, var1_40 and var1_40.shipId and getProxy(BayProxy):getShipById(var1_40.shipId) or nil)
			onButton(arg0_14, var0_40, function()
				local var0_41 = {}

				if var1_40 and PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
					table.insert(var0_41, function(arg0_42)
						arg0_14:emit(var0_0.ON_SPWEAPON, {
							quickFlag = true,
							type = EquipmentInfoMediator.TYPE_REPLACE,
							oldSpWeaponUid = var1_40:GetUID(),
							oldShipId = var1_40:GetShipId(),
							shipVO = arg0_14:getEquipShipVO(arg0_14.equipData),
							quickCallback = arg0_42
						})
					end)
				end

				seriesAsync(var0_41, function()
					arg0_14.equipData[arg0_14.quickIndex] = var1_40

					local var0_43 = arg0_14.rtCodePanel:Find("equipments_quick/SpSlot")

					var3_0(var0_43, var1_40, var1_40 and var1_40.shipId and getProxy(BayProxy):getShipById(var1_40.shipId) or nil)
					var4_0(var0_43, arg0_14.codeData[arg0_14.quickIndex], var1_40)
					arg0_14:updateQuickPanel()
				end)
			end, SFX_PANEL)
		else
			var1_0(var0_40, var1_40 and setmetatable({
				count = var1_40.count - underscore.reduce(arg0_14.equipData, 0, function(arg0_44, arg1_44)
					return arg0_44 + (arg1_44 == var1_40 and 1 or 0)
				end)
			}, {
				__index = var1_40
			}) or var1_40, var1_40 and var1_40.shipId and getProxy(BayProxy):getShipById(var1_40.shipId) or nil)
			setActive(var0_40:Find("IconTpl/mask"), var1_40 and var1_40.mask)
			onButton(arg0_14, var0_40, function()
				if var1_40 and var1_40.mask then
					return
				end

				local var0_45 = {}

				if var1_40 and PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
					table.insert(var0_45, function(arg0_46)
						arg0_14:emit(var0_0.ON_EQUIPMENT, {
							quickFlag = true,
							type = EquipmentInfoMediator.TYPE_REPLACE,
							equipmentId = var1_40.id,
							oldShipId = var1_40.shipId,
							oldPos = var1_40.shipPos,
							shipVO = arg0_14:getEquipShipVO(arg0_14.equipData),
							pos = arg0_14.quickIndex,
							quickCallback = arg0_46
						})
					end)
				end

				seriesAsync(var0_45, function()
					arg0_14.equipData[arg0_14.quickIndex] = var1_40

					local var0_47 = arg0_14.rtCodePanel:Find("equipments_quick"):GetChild(arg0_14.quickIndex - 1)

					var1_0(var0_47, var1_40, var1_40 and var1_40.shipId and getProxy(BayProxy):getShipById(var1_40.shipId) or nil)
					var4_0(var0_47, arg0_14.codeData[arg0_14.quickIndex], var1_40)
					arg0_14:updateQuickPanel()
				end)
			end, SFX_PANEL)
		end
	end

	setText(var0_14:Find("on/text2"), i18n("quick_equip_tip2"))
	setText(var0_14:Find("off/text2"), i18n("quick_equip_tip2"))
	setText(arg0_14.rtQuickPanel:Find("title/equiping/on/text2"), i18n("quick_equip_tip1"))
	setText(arg0_14.rtQuickPanel:Find("title/equiping/off/text2"), i18n("quick_equip_tip1"))
	setText(arg0_14.rtQuickPanel:Find("title/text"), i18n("quick_equip_tip3"))
	setText(arg0_14.rtQuickPanel:Find("frame/emptyTitle/text"), i18n("quick_equip_tip4"))
	setText(arg0_14.rtQuickPanel:Find("frame/selectTitle/text"), i18n("quick_equip_tip5"))

	arg0_14.rtBottomPanel = arg0_14._tf:Find("bottom_panel")
	arg0_14.rtInputField = arg0_14.rtBottomPanel:Find("InputField")

	setText(arg0_14.rtInputField:Find("Placeholder"), i18n("equipcode_input"))
	setInputText(arg0_14.rtInputField, arg0_14.contextData.code or nil)

	arg0_14.btnInput = arg0_14.rtBottomPanel:Find("btn_confirm")

	onButton(arg0_14, arg0_14.btnInput, function()
		arg0_14.code = getInputText(arg0_14.rtInputField)

		arg0_14:updateDispalyPanel(arg0_14.rtCodePanel, "code")
	end, SFX_CONFIRM)
end

function var0_0.didEnter(arg0_49)
	arg0_49.code = buildEquipCode(arg0_49.shipVO)

	arg0_49:updateDispalyPanel(arg0_49.rtMainPanel, "main")
	arg0_49:updateDispalyPanel(arg0_49.rtCodePanel, "code")
end

function var0_0.updateDispalyPanel(arg0_50, arg1_50, arg2_50)
	updateDrop(arg1_50:Find("IconTpl"), {
		type = DROP_TYPE_SHIP,
		id = arg0_50.shipVO.configId
	})

	local var0_50 = arg0_50.shipVO:IsSpweaponUnlock()

	setActive(arg1_50:Find("equipments/SpSlot/Lock"), not var0_50)

	if arg2_50 == "main" then
		for iter0_50, iter1_50 in ipairs(arg0_50.shipVO:getAllEquipments()) do
			var1_0(arg1_50:Find("equipments"):GetChild(iter0_50 - 1), iter1_50)
		end

		var3_0(arg1_50:Find("equipments/SpSlot"), arg0_50.shipVO:GetSpWeapon(), arg0_50.shipVO)
	elseif arg2_50 == "code" then
		local var1_50 = pg.equip_data_template
		local var2_50 = pg.spweapon_data_statistics
		local var3_50 = false

		arg0_50.codeData = {}

		for iter2_50, iter3_50 in ipairs(parseEquipCode(arg0_50.code)) do
			if iter2_50 == 6 then
				arg0_50.codeData[iter2_50] = var0_50 and var2_50[iter3_50] and SpWeapon.New({
					id = iter3_50
				}) or false

				if arg0_50.codeData[iter2_50] and not arg0_50:getEquipShipVO(arg0_50.codeData):CanEquipSpWeapon(arg0_50.codeData[iter2_50]) then
					arg0_50.codeData[iter2_50] = false
					var3_50 = true
				end

				var3_0(arg1_50:Find("equipments/SpSlot"), arg0_50.codeData[iter2_50])
			else
				arg0_50.codeData[iter2_50] = var1_50[iter3_50] and Equipment.New({
					id = iter3_50
				}) or false

				if arg0_50.codeData[iter2_50] and not arg0_50:getEquipShipVO(arg0_50.codeData):canEquipAtPos(arg0_50.codeData[iter2_50], iter2_50) then
					arg0_50.codeData[iter2_50] = false
					var3_50 = true
				end

				var1_0(arg1_50:Find("equipments"):GetChild(iter2_50 - 1), arg0_50.codeData[iter2_50])
			end
		end

		if var3_50 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_slot_unmatch"))
		end

		arg0_50.equipData = {}

		for iter4_50, iter5_50 in ipairs(arg0_50.codeData) do
			if iter5_50 and arg0_50.shipData[iter4_50] and iter5_50.configId == arg0_50.shipData[iter4_50].configId then
				arg0_50.equipData[iter4_50] = arg0_50.shipData[iter4_50]
			end
		end

		for iter6_50, iter7_50 in ipairs(arg0_50.codeData) do
			if iter7_50 and not arg0_50.equipData[iter6_50] then
				local var4_50 = iter6_50 == 6 and var2_50 or var1_50
				local var5_50 = {
					iter7_50.configId
				}

				for iter8_50, iter9_50 in ipairs({
					"next",
					"prev"
				}) do
					local var6_50 = iter7_50.configId

					while var4_50[var6_50][iter9_50] > 0 do
						var6_50 = var4_50[var6_50][iter9_50]

						table.insert(var5_50, var6_50)
					end
				end

				if iter6_50 == 6 then
					for iter10_50, iter11_50 in ipairs(underscore.filter(arg0_50.spWeapons, function(arg0_51)
						return not arg0_51.shipId
					end)) do
						local var7_50 = table.indexof(var5_50, iter11_50.configId)

						if var7_50 and (not arg0_50.equipData[iter6_50] or var7_50 < table.indexof(var5_50, arg0_50.equipData[iter6_50].configId)) then
							arg0_50.equipData[iter6_50] = iter11_50
						end
					end
				else
					for iter12_50, iter13_50 in ipairs(underscore.filter(arg0_50.equips, function(arg0_52)
						return not arg0_52.shipId or arg0_52.shipId == arg0_50.shipVO.id
					end)) do
						local var8_50 = table.indexof(var5_50, iter13_50.configId)

						if var8_50 and (not arg0_50.equipData[iter6_50] or var8_50 < table.indexof(var5_50, arg0_50.equipData[iter6_50].configId)) and iter13_50.count > underscore.reduce(arg0_50.equipData, 0, function(arg0_53, arg1_53)
							return arg0_53 + (arg1_53 == iter13_50 and 1 or 0)
						end) then
							arg0_50.equipData[iter6_50] = iter13_50
						end
					end
				end
			end

			arg0_50.equipData[iter6_50] = defaultValue(arg0_50.equipData[iter6_50], false)
		end

		setActive(arg1_50:Find("equipments_quick/SpSlot/Lock"), not var0_50)

		for iter14_50, iter15_50 in ipairs(arg0_50.equipData) do
			local var9_50 = arg1_50:Find("equipments_quick"):GetChild(iter14_50 - 1)

			if iter14_50 == 6 then
				var3_0(var9_50, iter15_50, iter15_50 and iter15_50.shipId and getProxy(BayProxy):getShipById(iter15_50.shipId) or nil)
			else
				var1_0(var9_50, iter15_50, iter15_50 and iter15_50.shipId and getProxy(BayProxy):getShipById(iter15_50.shipId) or nil)
			end

			var4_0(var9_50, arg0_50.codeData[iter14_50], iter15_50)
		end
	else
		assert(false)
	end
end

function var0_0.initQuickPanel(arg0_54)
	eachChild(arg0_54.rtCodePanel:Find("equipments_quick"), function(arg0_55)
		if arg0_55:GetSiblingIndex() + 1 == 6 then
			SetCompomentEnabled(arg0_55, typeof(Toggle), arg0_54.shipVO:IsSpweaponUnlock())
		else
			SetCompomentEnabled(arg0_55, typeof(Toggle), true)
		end
	end)

	if arg0_54.quickIndex then
		triggerToggle(arg0_54.rtCodePanel:Find("equipments_quick"):GetChild(arg0_54.quickIndex - 1), false)
	end

	triggerToggle(arg0_54.rtQuickPanel:Find("title/equiping"), true)
	arg0_54:updateQuickPanel()
end

function var0_0.updateQuickPanel(arg0_56)
	if not isActive(arg0_56.rtQuickPanel) then
		return
	end

	setActive(arg0_56.rtQuickPanel:Find("title/filter"), arg0_56.quickIndex)
	setActive(arg0_56.rtQuickPanel:Find("frame/selectTitle"), not arg0_56.quickIndex)

	if arg0_56.quickIndex then
		if arg0_56.quickIndex == 6 then
			arg0_56.filterEquipments = arg0_56:getFilterSpWeapon()
		else
			arg0_56.filterEquipments = arg0_56:getFilterEquipments()
		end

		if arg0_56.equipData[arg0_56.quickIndex] then
			table.insert(arg0_56.filterEquipments, 1, false)
		end

		arg0_56.comList:SetTotalCount(#arg0_56.filterEquipments)
		setActive(arg0_56.rtQuickPanel:Find("frame/emptyTitle"), #arg0_56.filterEquipments == 0)
	else
		arg0_56.comList:SetTotalCount(0)
		setActive(arg0_56.rtQuickPanel:Find("frame/emptyTitle"), false)
	end
end

function var0_0.getFilterEquipments(arg0_57)
	local var0_57 = arg0_57:getEquipShipVO(arg0_57.equipData)
	local var1_57 = getInputText(arg0_57.nameSearchInput)
	local var2_57 = {
		arg0_57.indexData.equipPropertyIndex,
		arg0_57.indexData.equipPropertyIndex2
	}

	return underscore(arg0_57.equips):chain():filter(function(arg0_58)
		return (not arg0_58.shipId or arg0_57.equipingFlag) and arg0_58.count > underscore.reduce(arg0_57.equipData, 0, function(arg0_59, arg1_59)
			return arg0_59 + (arg0_58 == arg1_59 and 1 or 0)
		end) and not var0_57:isForbiddenAtPos(arg0_58, arg0_57.quickIndex) and IndexConst.filterEquipByType(arg0_58, arg0_57.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg0_58, var2_57) and IndexConst.filterEquipAmmo1(arg0_58, arg0_57.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg0_58, arg0_57.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg0_58, arg0_57.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg0_58, arg0_57.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg0_58, arg0_57.indexData.extraIndex) and (var1_57 == "" or arg0_58:IsMatchKey(var1_57))
	end):each(function(arg0_60)
		arg0_60.mask = not var0_57:canEquipAtPos(arg0_60, arg0_57.quickIndex)
	end):value()
end

function var0_0.getFilterSpWeapon(arg0_61)
	local var0_61 = arg0_61:getEquipShipVO(arg0_61.equipData)
	local var1_61 = getInputText(arg0_61.nameSearchInput)

	return underscore.filter(arg0_61.spWeapons, function(arg0_62)
		return (not arg0_62.shipId or arg0_61.equipingFlag) and arg0_62 ~= arg0_61.equipData[6] and not var0_61:IsSpWeaponForbidden(arg0_62) and IndexConst.filterSpWeaponByType(arg0_62, arg0_61.spweaponIndexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(arg0_62, arg0_61.spweaponIndexDatas.rarityIndex) and (var1_61 == "" or arg0_62:IsMatchKey(var1_61))
	end)
end

function var0_0.willExit(arg0_63)
	if arg0_63.ltID then
		LeanTween.cancel(arg0_63.ltID)

		arg0_63.ltID = nil
	end
end

return var0_0
