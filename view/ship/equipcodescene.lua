local var0 = class("EquipCodeScene", import("..base.BaseUI"))

var0.optionsPath = {
	"adpter/frame/option"
}

function var0.getUIName(arg0)
	return "EquipCodeUI"
end

function var0.setEquipments(arg0, arg1, arg2)
	arg0.equips = arg1

	table.sort(arg0.equips, CompareFuncs(EquipmentSortCfg.sortFunc(EquipmentSortCfg.sort[1], false)))

	arg0.spWeapons = arg2

	table.sort(arg0.spWeapons, CompareFuncs(SpWeaponSortCfg.sortFunc(SpWeaponSortCfg.sort[1], false)))
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = getProxy(BayProxy):getShipById(arg1)
	arg0.shipData = {}

	for iter0, iter1 in ipairs(arg0.shipVO:getAllEquipments()) do
		if not iter1 then
			arg0.shipData[iter0] = false
		else
			arg0.shipData[iter0] = underscore.detect(arg0.equips, function(arg0)
				return arg0.configId == iter1.configId and arg0.shipId == arg0.shipVO.id and arg0.shipPos == iter0
			end) or false
		end
	end

	local var0 = arg0.shipVO:GetSpWeapon()

	if not var0 then
		arg0.shipData[6] = false
	else
		arg0.shipData[6] = underscore.detect(arg0.spWeapons, function(arg0)
			return arg0.configId == var0.configId and arg0:GetShipId() == arg0.shipVO.id
		end) or false
	end
end

function var0.getEquipShipVO(arg0, arg1)
	local var0 = arg0.shipVO:clone()

	var0.equipments = underscore.first(arg1, 5)
	var0.spWeapon = arg1[6] or nil

	return var0
end

local function var1(arg0, arg1, arg2)
	setActive(arg0:Find("IconTpl"), tobool(arg1))

	if arg1 then
		updateEquipment(arg0:Find("IconTpl"), arg1)
	end

	if arg0:Find("equip_flag") then
		setActive(arg0:Find("equip_flag"), arg2)

		if arg2 then
			setImageSprite(arg0:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2:getPainting()))
		end
	end
end

local function var2(arg0, arg1, arg2)
	setActive(arg0:Find("IconTpl"), tobool(arg1))

	if arg1 then
		updateSpWeapon(arg0:Find("IconTpl"), arg1)
	end

	if arg0:Find("equip_flag") then
		setActive(arg0:Find("equip_flag"), arg2)

		if arg2 then
			setImageSprite(arg0:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2:getPainting()))
		end
	end
end

local function var3(arg0, arg1, arg2)
	setActive(arg0:Find("Icon"), arg1)
	setActive(arg0:Find("IconShadow"), arg1)

	if arg1 then
		UpdateSpWeaponSlot(arg0, arg1)
	end

	if arg0:Find("equip_flag") then
		setActive(arg0:Find("equip_flag"), arg2)

		if arg2 then
			setImageSprite(arg0:Find("equip_flag/Image"), LoadSprite("qicon/" .. arg2:getPainting()))
		end
	end
end

local function var4(arg0, arg1, arg2)
	local var0 = arg0:Find("error")

	if not arg1 or not arg2 then
		setActive(var0, false)
	elseif arg1.configId == arg2.configId then
		setActive(var0, false)
	else
		local var1 = false
		local var2 = instanceof(arg1, SpWeapon) and pg.spweapon_data_statistics or pg.equip_data_template

		for iter0, iter1 in ipairs({
			"next",
			"prev"
		}) do
			local var3 = arg1.configId

			while var2[var3][iter1] > 0 do
				var3 = var2[var3][iter1]

				if var3 == arg2.configId then
					var1 = true

					break
				end
			end

			if var1 then
				break
			end
		end

		setActive(var0, true)
		setText(var0:Find("Text"), i18n(var1 and "equipcode_level_unmatched" or "equipcode_diff_selected"))
	end
end

function var0.onBackPressed(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.shipData do
		if (arg0.shipData[iter0] and arg0.shipData[iter0].configId or 0) ~= (arg0.equipData[iter0] and arg0.equipData[iter0].configId or 0) then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipcode_unsaved_tips"),
					onYes = arg0
				})
			end)

			break
		end
	end

	seriesAsync(var0, function()
		arg0:closeView()
	end)
end

local var5

function var0.init(arg0)
	var5 = var5 or {
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
	arg0.btnBack = arg0._tf:Find("adpter/frame/btnBack")

	onButton(arg0, arg0.btnBack, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)

	arg0.rtMainPanel = arg0._tf:Find("main_panel")

	onButton(arg0, arg0.rtMainPanel:Find("btns/btn_export"), function()
		UniPasteBoard.SetClipBoardString(buildEquipCode(arg0.shipVO))
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_export_success"))
	end, SFX_CONFIRM)
	onButton(arg0, arg0.rtMainPanel:Find("share/btn_comments"), function()
		arg0:emit(EquipCodeMediator.OPEN_EQUIP_CODE_SHARE, arg0.shipVO:getGroupId())
	end, SFX_PANEL)

	arg0.tagIndexData = {}

	onButton(arg0, arg0.rtMainPanel:Find("share/btn_share"), function()
		arg0:emit(EquipCodeMediator.OPEN_CUSTOM_INDEX, setmetatable({
			indexDatas = Clone(arg0.tagIndexData),
			callback = function(arg0)
				arg0.tagIndexData.labelIndex = arg0.labelIndex

				local var0 = 0
				local var1 = arg0.labelIndex

				while var1 > 0 do
					var0 = var0 + 1
					var1 = bit.band(var1, var1 - 1)
				end

				if var0 == 2 then
					local var2 = buildEquipCode(arg0.shipVO)
					local var3 = {}
					local var4 = arg0.tagIndexData.labelIndex

					while var4 > 0 do
						local var5 = bit.band(var4, -var4)

						var4 = var4 - var5

						local var6 = 0

						while var5 > 0 do
							var6 = var6 + 1
							var5 = math.floor(var5 / 2)
						end

						table.insert(var3, tostring(var6))
					end

					local var7 = arg0.shipVO:getGroupId()
					local var8 = table.concat({
						var2,
						ConversionBase(32, var7),
						var3[1],
						var3[2]
					}, "&")

					arg0:emit(EquipCodeMediator.SHARE_EQUIP_CODE, var7, var8)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_nolabel"))
				end
			end
		}, {
			__index = var5
		}))
	end, SFX_PANEL)

	arg0.rtCodePanel = arg0._tf:Find("code_panel")

	onButton(arg0, arg0.rtCodePanel:Find("btns/btn_import"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("equipcode_confirm_doublecheck"),
			onYes = function()
				arg0:emit(EquipCodeMediator.IMPORT_SHIP_EQUIP, arg0.shipVO.id, arg0.equipData)
			end
		})
	end, SFX_CONFIRM)
	onButton(arg0, arg0.rtCodePanel:Find("btns/btn_withdrawn"), function()
		arg0.code = nil

		arg0:updateDispalyPanel(arg0.rtCodePanel, "code")
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtCodePanel:Find("btns/btn_cancel"), function()
		arg0:updateDispalyPanel(arg0.rtCodePanel, "code")
		arg0:initQuickPanel()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.rtCodePanel:Find("btns/toggle_quick"), function(arg0)
		setActive(arg0.rtMainPanel, false)
		setActive(arg0.rtBottomPanel, false)
		setActive(arg0.rtQuickPanel, false)
		setActive(arg0.rtCodePanel:Find("btns/btn_withdrawn"), not arg0)
		setActive(arg0.rtCodePanel:Find("btns/btn_cancel"), arg0)

		if arg0.quickIndex then
			triggerToggle(arg0.rtCodePanel:Find("equipments_quick"):GetChild(arg0.quickIndex - 1), false)
		end

		eachChild(arg0.rtCodePanel:Find("equipments_quick"), function(arg0)
			SetCompomentEnabled(arg0, typeof(Toggle), false)
		end)

		arg0.ltID = LeanTween.moveY(arg0.rtCodePanel, arg0 and 420 or 80, math.max(math.abs((arg0 and 420 or 80) - arg0.rtCodePanel.anchoredPosition.y), 0.1) / 2000):setOnComplete(System.Action(function()
			arg0.ltID = nil

			setActive(arg0.rtMainPanel, not arg0)
			setActive(arg0.rtBottomPanel, not arg0)
			setActive(arg0.rtQuickPanel, arg0)

			if arg0 then
				arg0:initQuickPanel()
			end
		end)).uniqueId
	end)
	eachChild(arg0.rtCodePanel:Find("equipments_quick"), function(arg0)
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0.quickIndex = arg0:GetSiblingIndex() + 1

				arg0:updateQuickPanel()
			elseif arg0.quickIndex == arg0:GetSiblingIndex() + 1 then
				arg0.quickIndex = nil

				arg0:updateQuickPanel()
			end
		end, SFX_PANEL)
		SetCompomentEnabled(arg0, typeof(Toggle), false)
	end)

	arg0.rtQuickPanel = arg0._tf:Find("quick_panel")

	onToggle(arg0, arg0.rtQuickPanel:Find("title/equiping"), function(arg0)
		arg0.equipingFlag = arg0

		if isActive(arg0.rtQuickPanel) then
			arg0:updateQuickPanel(true)
		end
	end, SFX_PANEL)

	arg0.indexData = arg0.indexData or {}
	arg0.spweaponIndexDatas = arg0.spweaponIndexDatas or {}

	local var0 = arg0.rtQuickPanel:Find("title/filter")

	onButton(arg0, var0, function()
		assert(arg0.quickIndex)

		local var0 = switch(arg0.quickIndex, {
			[6] = function()
				return setmetatable({
					indexDatas = Clone(arg0.spweaponIndexDatas),
					callback = function(arg0)
						arg0.spweaponIndexDatas.typeIndex = arg0.typeIndex
						arg0.spweaponIndexDatas.rarityIndex = arg0.rarityIndex

						local var0 = underscore(arg0.spweaponIndexDatas):chain():keys():all(function(arg0)
							return arg0.spweaponIndexDatas[arg0] == StoreHouseConst.SPWEAPON_INDEX_COMMON.customPanels[arg0].options[1]
						end):value()

						setActive(var0:Find("on"), not var0)
						setActive(var0:Find("off"), var0)
						arg0:updateQuickPanel()
					end
				}, {
					__index = StoreHouseConst.SPWEAPON_INDEX_COMMON
				})
			end
		}, function()
			return setmetatable({
				indexDatas = Clone(arg0.indexData),
				callback = function(arg0)
					arg0.indexData.typeIndex = arg0.typeIndex
					arg0.indexData.equipPropertyIndex = arg0.equipPropertyIndex
					arg0.indexData.equipPropertyIndex2 = arg0.equipPropertyIndex2
					arg0.indexData.equipAmmoIndex1 = arg0.equipAmmoIndex1
					arg0.indexData.equipAmmoIndex2 = arg0.equipAmmoIndex2
					arg0.indexData.equipCampIndex = arg0.equipCampIndex
					arg0.indexData.rarityIndex = arg0.rarityIndex
					arg0.indexData.extraIndex = arg0.extraIndex

					local var0 = underscore(arg0.indexData):chain():keys():all(function(arg0)
						return arg0.indexData[arg0] == StoreHouseConst.EQUIPMENT_INDEX_COMMON.customPanels[arg0].options[1]
					end):value()

					setActive(var0:Find("on"), not var0)
					setActive(var0:Find("off"), var0)
					arg0:updateQuickPanel()
				end
			}, {
				__index = StoreHouseConst.EQUIPMENT_INDEX_COMMON
			})
		end)

		arg0:emit(EquipCodeMediator.OPEN_CUSTOM_INDEX, var0)
	end, SFX_PANEL)

	arg0.comList = arg0.rtQuickPanel:Find("frame/container"):GetComponent("LScrollRect")

	function arg0.comList.onInitItem(arg0)
		ClearTweenItemAlphaAndWhite(arg0)
	end

	function arg0.comList.onReturnItem(arg0, arg1)
		ClearTweenItemAlphaAndWhite(arg1)
	end

	function arg0.comList.onUpdateItem(arg0, arg1)
		if not arg0.quickIndex then
			return
		end

		TweenItemAlphaAndWhite(arg1)

		local var0 = tf(arg1)
		local var1 = arg0.filterEquipments[arg0 + 1]

		setActive(var0:Find("unEquip"), not var1)
		setActive(var0:Find("bg"), var1)
		setActive(var0:Find("IconTpl"), var1)

		if arg0.quickIndex == 6 then
			var2(var0, var1, var1 and var1.shipId and getProxy(BayProxy):getShipById(var1.shipId) or nil)
			onButton(arg0, var0, function()
				local var0 = {}

				if var1 and PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
					table.insert(var0, function(arg0)
						arg0:emit(var0.ON_SPWEAPON, {
							quickFlag = true,
							type = EquipmentInfoMediator.TYPE_REPLACE,
							oldSpWeaponUid = var1:GetUID(),
							oldShipId = var1:GetShipId(),
							shipVO = arg0:getEquipShipVO(arg0.equipData),
							quickCallback = arg0
						})
					end)
				end

				seriesAsync(var0, function()
					arg0.equipData[arg0.quickIndex] = var1

					local var0 = arg0.rtCodePanel:Find("equipments_quick/SpSlot")

					var3(var0, var1, var1 and var1.shipId and getProxy(BayProxy):getShipById(var1.shipId) or nil)
					var4(var0, arg0.codeData[arg0.quickIndex], var1)
					arg0:updateQuickPanel()
				end)
			end, SFX_PANEL)
		else
			var1(var0, var1 and setmetatable({
				count = var1.count - underscore.reduce(arg0.equipData, 0, function(arg0, arg1)
					return arg0 + (arg1 == var1 and 1 or 0)
				end)
			}, {
				__index = var1
			}) or var1, var1 and var1.shipId and getProxy(BayProxy):getShipById(var1.shipId) or nil)
			setActive(var0:Find("IconTpl/mask"), var1 and var1.mask)
			onButton(arg0, var0, function()
				if var1 and var1.mask then
					return
				end

				local var0 = {}

				if var1 and PlayerPrefs.GetInt("QUICK_CHANGE_EQUIP", 1) == 1 then
					table.insert(var0, function(arg0)
						arg0:emit(var0.ON_EQUIPMENT, {
							quickFlag = true,
							type = EquipmentInfoMediator.TYPE_REPLACE,
							equipmentId = var1.id,
							oldShipId = var1.shipId,
							oldPos = var1.shipPos,
							shipVO = arg0:getEquipShipVO(arg0.equipData),
							pos = arg0.quickIndex,
							quickCallback = arg0
						})
					end)
				end

				seriesAsync(var0, function()
					arg0.equipData[arg0.quickIndex] = var1

					local var0 = arg0.rtCodePanel:Find("equipments_quick"):GetChild(arg0.quickIndex - 1)

					var1(var0, var1, var1 and var1.shipId and getProxy(BayProxy):getShipById(var1.shipId) or nil)
					var4(var0, arg0.codeData[arg0.quickIndex], var1)
					arg0:updateQuickPanel()
				end)
			end, SFX_PANEL)
		end
	end

	setText(var0:Find("on/text2"), i18n("quick_equip_tip2"))
	setText(var0:Find("off/text2"), i18n("quick_equip_tip2"))
	setText(arg0.rtQuickPanel:Find("title/equiping/on/text2"), i18n("quick_equip_tip1"))
	setText(arg0.rtQuickPanel:Find("title/equiping/off/text2"), i18n("quick_equip_tip1"))
	setText(arg0.rtQuickPanel:Find("title/text"), i18n("quick_equip_tip3"))
	setText(arg0.rtQuickPanel:Find("frame/emptyTitle/text"), i18n("quick_equip_tip4"))
	setText(arg0.rtQuickPanel:Find("frame/selectTitle/text"), i18n("quick_equip_tip5"))

	arg0.rtBottomPanel = arg0._tf:Find("bottom_panel")
	arg0.rtInputField = arg0.rtBottomPanel:Find("InputField")

	setText(arg0.rtInputField:Find("Placeholder"), i18n("equipcode_input"))
	setInputText(arg0.rtInputField, arg0.contextData.code or nil)

	arg0.btnInput = arg0.rtBottomPanel:Find("btn_confirm")

	onButton(arg0, arg0.btnInput, function()
		arg0.code = getInputText(arg0.rtInputField)

		arg0:updateDispalyPanel(arg0.rtCodePanel, "code")
	end, SFX_CONFIRM)
end

function var0.didEnter(arg0)
	arg0.code = buildEquipCode(arg0.shipVO)

	arg0:updateDispalyPanel(arg0.rtMainPanel, "main")
	arg0:updateDispalyPanel(arg0.rtCodePanel, "code")
end

function var0.updateDispalyPanel(arg0, arg1, arg2)
	updateDrop(arg1:Find("IconTpl"), {
		type = DROP_TYPE_SHIP,
		id = arg0.shipVO.configId
	})

	local var0 = arg0.shipVO:IsSpweaponUnlock()

	setActive(arg1:Find("equipments/SpSlot/Lock"), not var0)

	if arg2 == "main" then
		for iter0, iter1 in ipairs(arg0.shipVO:getAllEquipments()) do
			var1(arg1:Find("equipments"):GetChild(iter0 - 1), iter1)
		end

		var3(arg1:Find("equipments/SpSlot"), arg0.shipVO:GetSpWeapon(), arg0.shipVO)
	elseif arg2 == "code" then
		local var1 = pg.equip_data_template
		local var2 = pg.spweapon_data_statistics
		local var3 = false

		arg0.codeData = {}

		for iter2, iter3 in ipairs(parseEquipCode(arg0.code)) do
			if iter2 == 6 then
				arg0.codeData[iter2] = var0 and var2[iter3] and SpWeapon.New({
					id = iter3
				}) or false

				if arg0.codeData[iter2] and not arg0:getEquipShipVO(arg0.codeData):CanEquipSpWeapon(arg0.codeData[iter2]) then
					arg0.codeData[iter2] = false
					var3 = true
				end

				var3(arg1:Find("equipments/SpSlot"), arg0.codeData[iter2])
			else
				arg0.codeData[iter2] = var1[iter3] and Equipment.New({
					id = iter3
				}) or false

				if arg0.codeData[iter2] and not arg0:getEquipShipVO(arg0.codeData):canEquipAtPos(arg0.codeData[iter2], iter2) then
					arg0.codeData[iter2] = false
					var3 = true
				end

				var1(arg1:Find("equipments"):GetChild(iter2 - 1), arg0.codeData[iter2])
			end
		end

		if var3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_slot_unmatch"))
		end

		arg0.equipData = {}

		for iter4, iter5 in ipairs(arg0.codeData) do
			if iter5 and arg0.shipData[iter4] and iter5.configId == arg0.shipData[iter4].configId then
				arg0.equipData[iter4] = arg0.shipData[iter4]
			end
		end

		for iter6, iter7 in ipairs(arg0.codeData) do
			if iter7 and not arg0.equipData[iter6] then
				local var4 = iter6 == 6 and var2 or var1
				local var5 = {
					iter7.configId
				}

				for iter8, iter9 in ipairs({
					"next",
					"prev"
				}) do
					local var6 = iter7.configId

					while var4[var6][iter9] > 0 do
						var6 = var4[var6][iter9]

						table.insert(var5, var6)
					end
				end

				if iter6 == 6 then
					for iter10, iter11 in ipairs(underscore.filter(arg0.spWeapons, function(arg0)
						return not arg0.shipId
					end)) do
						local var7 = table.indexof(var5, iter11.configId)

						if var7 and (not arg0.equipData[iter6] or var7 < table.indexof(var5, arg0.equipData[iter6].configId)) then
							arg0.equipData[iter6] = iter11
						end
					end
				else
					for iter12, iter13 in ipairs(underscore.filter(arg0.equips, function(arg0)
						return not arg0.shipId or arg0.shipId == arg0.shipVO.id
					end)) do
						local var8 = table.indexof(var5, iter13.configId)

						if var8 and (not arg0.equipData[iter6] or var8 < table.indexof(var5, arg0.equipData[iter6].configId)) and iter13.count > underscore.reduce(arg0.equipData, 0, function(arg0, arg1)
							return arg0 + (arg1 == iter13 and 1 or 0)
						end) then
							arg0.equipData[iter6] = iter13
						end
					end
				end
			end

			arg0.equipData[iter6] = defaultValue(arg0.equipData[iter6], false)
		end

		setActive(arg1:Find("equipments_quick/SpSlot/Lock"), not var0)

		for iter14, iter15 in ipairs(arg0.equipData) do
			local var9 = arg1:Find("equipments_quick"):GetChild(iter14 - 1)

			if iter14 == 6 then
				var3(var9, iter15, iter15 and iter15.shipId and getProxy(BayProxy):getShipById(iter15.shipId) or nil)
			else
				var1(var9, iter15, iter15 and iter15.shipId and getProxy(BayProxy):getShipById(iter15.shipId) or nil)
			end

			var4(var9, arg0.codeData[iter14], iter15)
		end
	else
		assert(false)
	end
end

function var0.initQuickPanel(arg0)
	eachChild(arg0.rtCodePanel:Find("equipments_quick"), function(arg0)
		if arg0:GetSiblingIndex() + 1 == 6 then
			SetCompomentEnabled(arg0, typeof(Toggle), arg0.shipVO:IsSpweaponUnlock())
		else
			SetCompomentEnabled(arg0, typeof(Toggle), true)
		end
	end)

	if arg0.quickIndex then
		triggerToggle(arg0.rtCodePanel:Find("equipments_quick"):GetChild(arg0.quickIndex - 1), false)
	end

	triggerToggle(arg0.rtQuickPanel:Find("title/equiping"), true)
	arg0:updateQuickPanel()
end

function var0.updateQuickPanel(arg0)
	if not isActive(arg0.rtQuickPanel) then
		return
	end

	setActive(arg0.rtQuickPanel:Find("title/filter"), arg0.quickIndex)
	setActive(arg0.rtQuickPanel:Find("frame/selectTitle"), not arg0.quickIndex)

	if arg0.quickIndex then
		if arg0.quickIndex == 6 then
			arg0.filterEquipments = arg0:getFilterSpWeapon()
		else
			arg0.filterEquipments = arg0:getFilterEquipments()
		end

		if arg0.equipData[arg0.quickIndex] then
			table.insert(arg0.filterEquipments, 1, false)
		end

		arg0.comList:SetTotalCount(#arg0.filterEquipments)
		setActive(arg0.rtQuickPanel:Find("frame/emptyTitle"), #arg0.filterEquipments == 0)
	else
		arg0.comList:SetTotalCount(0)
		setActive(arg0.rtQuickPanel:Find("frame/emptyTitle"), false)
	end
end

function var0.getFilterEquipments(arg0)
	local var0 = arg0:getEquipShipVO(arg0.equipData)
	local var1 = {
		arg0.indexData.equipPropertyIndex,
		arg0.indexData.equipPropertyIndex2
	}

	return underscore(arg0.equips):chain():filter(function(arg0)
		return (not arg0.shipId or arg0.equipingFlag) and arg0.count > underscore.reduce(arg0.equipData, 0, function(arg0, arg1)
			return arg0 + (arg0 == arg1 and 1 or 0)
		end) and not var0:isForbiddenAtPos(arg0, arg0.quickIndex) and IndexConst.filterEquipByType(arg0, arg0.indexData.typeIndex) and IndexConst.filterEquipByProperty(arg0, var1) and IndexConst.filterEquipAmmo1(arg0, arg0.indexData.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(arg0, arg0.indexData.equipAmmoIndex2) and IndexConst.filterEquipByCamp(arg0, arg0.indexData.equipCampIndex) and IndexConst.filterEquipByRarity(arg0, arg0.indexData.rarityIndex) and IndexConst.filterEquipByExtra(arg0, arg0.indexData.extraIndex)
	end):each(function(arg0)
		arg0.mask = not var0:canEquipAtPos(arg0, arg0.quickIndex)
	end):value()
end

function var0.getFilterSpWeapon(arg0)
	local var0 = arg0:getEquipShipVO(arg0.equipData)

	return underscore.filter(arg0.spWeapons, function(arg0)
		return (not arg0.shipId or arg0.equipingFlag) and arg0 ~= arg0.equipData[6] and not var0:IsSpWeaponForbidden(arg0) and IndexConst.filterSpWeaponByType(arg0, arg0.spweaponIndexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(arg0, arg0.spweaponIndexDatas.rarityIndex)
	end)
end

function var0.willExit(arg0)
	if arg0.ltID then
		LeanTween.cancel(arg0.ltID)

		arg0.ltID = nil
	end
end

return var0
