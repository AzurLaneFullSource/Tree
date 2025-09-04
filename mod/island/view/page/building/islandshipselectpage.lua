local var0_0 = class("IslandShipSelectPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipSelectUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.title = arg0_2:findTF("top/title/Text")

	setText(arg0_2.title, i18n("island_select_ship"))

	arg0_2.frameTF = arg0_2:findTF("frame")
	arg0_2.shipRectCom = arg0_2:findTF("ships", arg0_2.frameTF):GetComponent("LScrollRect")

	setText(arg0_2.frameTF:Find("selected/Text"), i18n("island_select_ship_label_1"))

	arg0_2.selectedTextCom = arg0_2.frameTF:Find("selected/num"):GetComponent("Text")
	arg0_2.benefitsTF = arg0_2._tf:Find("benefits")
	arg0_2.benefitTipBtn = arg0_2.benefitsTF:Find("tip/help")

	setText(arg0_2.benefitsTF:Find("tip/Text"), i18n("island_select_ship_overview"))

	arg0_2.mainAttrBar = arg0_2.benefitsTF:Find("main/slider/bar")

	setText(arg0_2.benefitsTF:Find("main/Text"), IslandShipAttr.ATTRS_CH[1])

	arg0_2.subAttrUIList = UIItemList.New(arg0_2.benefitsTF:Find("subs"), arg0_2.benefitsTF:Find("subs/tpl"))
	arg0_2.infoEmptyTF = arg0_2:findTF("info/empty")

	setText(arg0_2.infoEmptyTF:Find("Image/Text"), i18n("island_select_ship"))

	arg0_2.infoEmptyTitleTF = arg0_2.infoEmptyTF:Find("name")
	arg0_2.infoPanel = arg0_2:findTF("info/content")
	arg0_2.nameTF = arg0_2:findTF("name", arg0_2.infoPanel)
	arg0_2.levelTF = arg0_2:findTF("name/level", arg0_2.infoPanel)
	arg0_2.attrUIList = UIItemList.New(arg0_2:findTF("attrs", arg0_2.infoPanel), arg0_2:findTF("attrs/tpl", arg0_2.infoPanel))
	arg0_2.skillTF = arg0_2:findTF("skill", arg0_2.infoPanel)
	arg0_2.energyTFInfo = arg0_2:findTF("selectShipEnergyInfo", arg0_2.infoPanel)
	arg0_2.energyTF = arg0_2:findTF("energy", arg0_2.energyTFInfo)
	arg0_2.statusTF = arg0_2:findTF("status", arg0_2.infoPanel)
	arg0_2.sureBtn = arg0_2:findTF("sure")
	arg0_2.indexBtn = arg0_2._tf:Find("frame/filter_panel/IndexIco")
	arg0_2.orderBtn = arg0_2._tf:Find("frame/filter_panel/index")
	arg0_2.orderIco = arg0_2._tf:Find("frame/filter_panel/index/content/icon/icon")
	arg0_2.orderTxt = arg0_2._tf:Find("frame/filter_panel/index/content/Text"):GetComponent(typeof(Text))
	arg0_2.shipIconTF = arg0_2.energyTFInfo:Find("icon_mask/icon")
	arg0_2.energyTimeTextTf = arg0_2.energyTFInfo:Find("time_Text")
	arg0_2.recoveryTimeTips = arg0_2:findTF("selectShipEnergyInfo/recoveryTimeTips", arg0_2.infoPanel)
	arg0_2.skill = arg0_2.infoPanel:Find("skill")
	arg0_2.skillEmp = arg0_2.infoPanel:Find("skillEmp")
	arg0_2.skillEmpDes = arg0_2.skillEmp:Find("Text")
	arg0_2.skillInuse = arg0_2.skill:Find("skill_tab_bg/iconBright")
	arg0_2.skillUnuse = arg0_2.skill:Find("skill_tab_bg/iconDark")
	arg0_2.skillName = arg0_2.skill:Find("name"):GetComponent(typeof(Text))
	arg0_2.skillDes = arg0_2.skill:Find("desc/Text"):GetComponent(typeof(Text))
	arg0_2.shipContent = arg0_2.frameTF:Find("ships")
	arg0_2.shipEmpty = arg0_2.frameTF:Find("empShip")
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3.dftAniEvent:SetEndEvent(nil)
		arg0_3.dftAniEvent:SetEndEvent(function()
			arg0_3:Hide()

			if arg0_3.cancelFunc then
				arg0_3.cancelFunc()
			end
		end)
		arg0_3.animationPlayer:Play("anim_IslandShipSelectUI_Out")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sureBtn, function()
		arg0_3:Hide()

		if arg0_3.confirmFunc then
			arg0_3.confirmFunc(arg0_3.selectedIds)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.indexBtn, function(arg0_7)
		if arg0_7 then
			arg0_3:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_8)
					arg0_3:OnFilter(arg0_8)
				end,
				defaultIndex = arg0_3.sortData
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.orderBtn, function()
		arg0_3.selectAsc = not arg0_3.selectAsc

		arg0_3:UpdateSortBtn()
		arg0_3:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.benefitTipBtn, function()
		arg0_3:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_manage_help_tip")
		})
	end, SFX_PANEL)
	arg0_3.subAttrUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			local var0_11 = IslandShipAttr.ATTRS[arg1_11 + 1]

			arg2_11.name = var0_11

			setText(arg2_11:Find("Text"), IslandShipAttr.ToChinese(var0_11))
		elseif arg0_11 == UIItemList.EventUpdate then
			setFillAmount(arg2_11:Find("slider/bar"), arg0_3:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_11 + 1]))
		end
	end)

	function arg0_3.shipRectCom.onInitItem(arg0_12)
		arg0_3:OnInitShip(arg0_12)
	end

	function arg0_3.shipRectCom.onUpdateItem(arg0_13, arg1_13)
		arg0_3:OnUpdateShip(arg0_13, arg1_13)
	end

	arg0_3.cards = {}
	arg0_3.selectAsc = true
	arg0_3.sortData = {
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_3:UpdateSortBtn()

	arg0_3.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFilter(arg0_14, arg1_14)
	arg0_14.sortData = arg1_14

	arg0_14:UpdateSortBtn()
	arg0_14:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_15)
	arg0_15.orderIco.localScale = arg0_15.selectAsc and Vector3(1, -1, 1) or Vector3(1, 1, 1)

	local var0_15, var1_15 = IslandShipIndexLayer.getSortFuncAndName(arg0_15.sortData.sortIndex, arg0_15.selectAsc)

	arg0_15.orderTxt.text = i18n(var1_15)
end

function var0_0.UpdateAttrs(arg0_16, arg1_16)
	local var0_16 = IslandShipAttr.ATTRS

	arg0_16.attrUIList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg1_17 + 1

			arg0_16:UpdateAttr(arg2_17, var0_16, var0_17, arg1_16)
		end
	end)
	arg0_16.attrUIList:align(#var0_16)
end

function var0_0.UpdateAttr(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18 = arg2_18[arg3_18]
	local var1_18 = arg4_18:GetAttr(var0_18)

	setText(arg1_18:Find("name"), IslandShipAttr.ToChinese(var0_18))
	setText(arg1_18:Find("value"), var1_18)

	local var2_18 = arg4_18:GetAttrGrade(var0_18)
	local var3_18 = IslandShipAttr.Grade2Img(var2_18)

	arg1_18:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_18[1])
	arg1_18:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_18[2])
end

function var0_0.OnShow(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf)

	arg0_19.selectNum = arg1_19
	arg0_19.selectedIds = arg2_19
	arg0_19.attrType = arg3_19
	arg0_19.confirmFunc = arg4_19
	arg0_19.cancelFunc = arg5_19
	arg0_19.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	arg0_19.place_Id = arg6_19 and arg6_19.place_Id
	arg0_19.showBenefits = arg6_19 and arg6_19.showBenefits

	local var0_19 = arg6_19 and arg6_19.emptyInfoTitle and arg6_19.emptyInfoTitle or ""

	setText(arg0_19.infoEmptyTitleTF, var0_19)

	local var1_19 = #arg0_19.selectedIds == 0 and arg0_19.selectNum == 1

	arg0_19:FlushShips(var1_19)
end

function var0_0.OnInitShip(arg0_20, arg1_20)
	local var0_20 = IslandSelectShipCard.New(arg1_20)

	arg0_20.cards[arg1_20] = var0_20
end

function var0_0.OnUpdateShip(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.cards[arg2_21]

	if not var0_21 then
		arg0_21:OnInitItem(arg2_21)

		var0_21 = arg0_21.cards[arg2_21]
	end

	local var1_21 = arg0_21.showShips[arg1_21 + 1]
	local var2_21 = arg0_21.characterAgency:GetShipById(var1_21)

	onButton(arg0_21, var0_21.go, function()
		if var2_21:GetState() ~= IslandShip.STATE_NORMAL then
			return
		end

		if arg0_21.showId == var0_21.id then
			arg0_21.showId = nil
		else
			arg0_21.showId = var0_21.id
		end

		if table.contains(arg0_21.selectedIds, var0_21.id) then
			table.removebyvalue(arg0_21.selectedIds, var0_21.id)
		elseif arg0_21.selectNum == 1 then
			arg0_21.selectedIds = {
				var0_21.id
			}
		else
			if #arg0_21.selectedIds >= arg0_21.selectNum then
				return
			end

			table.insert(arg0_21.selectedIds, var0_21.id)
		end

		for iter0_22, iter1_22 in pairs(arg0_21.cards) do
			iter1_22:UpdateSelected(arg0_21.selectedIds)
		end

		arg0_21:FlushInfo()
	end, SFX_PANEL)
	var0_21:Update(var1_21, arg0_21.attrType, arg0_21.place_Id, arg0_21.selectedIds)
end

function var0_0.FlushShips(arg0_23, arg1_23)
	arg0_23.showShips = arg0_23:GetShips()

	if #arg0_23.showShips ~= 0 and arg1_23 then
		local var0_23 = arg0_23:GetFristSelectableShipId()

		if var0_23 then
			arg0_23.showId = var0_23

			table.insert(arg0_23.selectedIds, var0_23)
		end
	end

	arg0_23.showId = arg0_23.selectedIds[1]

	setActive(arg0_23.shipContent, #arg0_23.showShips ~= 0)
	setActive(arg0_23.shipEmpty, #arg0_23.showShips == 0)
	arg0_23.shipRectCom:SetTotalCount(#arg0_23.showShips)
	arg0_23:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.showShips) do
		if arg0_24.characterAgency:GetShipById(iter1_24):GetState() == IslandShip.STATE_NORMAL then
			return iter1_24
		end
	end

	return nil
end

function var0_0.UpdateTimer(arg0_25, arg1_25)
	local var0_25 = arg1_25 - arg0_25.timeMgr:GetServerTime()

	setText(arg0_25.energyTimeTextTf, arg0_25.timeMgr:DescCDTime(var0_25))
end

function var0_0.StopTimer(arg0_26)
	if arg0_26.energyTimer ~= nil then
		arg0_26.energyTimer:Stop()

		arg0_26.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_27)
	arg0_27.selectedTextCom.text = #arg0_27.selectedIds .. "/" .. arg0_27.selectNum

	arg0_27:FlushBenefits()
	setActive(arg0_27.sureBtn, arg0_27.showId)
	setActive(arg0_27.infoPanel, arg0_27.showId)
	setActive(arg0_27.infoEmptyTF, not arg0_27.showId)

	if not arg0_27.showId then
		return
	end

	local var0_27 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_27.showId)

	setText(arg0_27.nameTF, var0_27:GetName())
	setText(arg0_27.levelTF, string.format("-Lv.%d", var0_27:GetLevel()))
	arg0_27:UpdateAttrs(var0_27)

	local var1_27 = IslandShip.StaticGetPrefab(var0_27.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_27, "", arg0_27.shipIconTF)

	local var2_27 = var0_27:GetCurrentEnergy()
	local var3_27 = var0_27:GetMaxEnergy()

	setText(arg0_27:findTF("text", arg0_27.energyTF), var2_27 .. "/" .. var3_27)
	setSlider(arg0_27:findTF("energy_bar", arg0_27.energyTF), 0, 1, var2_27 / var3_27)

	if var2_27 ~= var3_27 then
		setActive(arg0_27.recoveryTimeTips, true)
		setActive(arg0_27.energyTimeTextTf, true)

		local var4_27 = var0_27:GetEnergyMaxTime()

		arg0_27:StopTimer()
		arg0_27:UpdateTimer(var4_27)

		arg0_27.energyTimer = Timer.New(function()
			arg0_27:UpdateTimer(var4_27)
		end, 1, -1)

		arg0_27.energyTimer:Start()
	else
		arg0_27:StopTimer()
		setActive(arg0_27.recoveryTimeTips, false)
		setActive(arg0_27.energyTimeTextTf, false)
	end

	local var5_27 = var0_27:GetSkill()
	local var6_27 = var5_27:IsUnlock()

	setActive(arg0_27.skill, var6_27)
	setActive(arg0_27.skillEmp, not var6_27)
	setText(arg0_27.skillEmpDes, i18n("island_need_star", var0_27:GetSkillUnlockLevel()))

	local var7_27 = var5_27:IsEffectiveInPlace(arg0_27.place_Id)

	setActive(arg0_27.skillInuse, var7_27)
	setActive(arg0_27.skillUnuse, not var7_27)

	arg0_27.skillName.text = string.format("%s - %s", var5_27:GetName(), "[Lv." .. var5_27:GetLevel() .. "]")
	arg0_27.skillDes.text = var5_27:GetEffectDesc()
end

function var0_0.FlushBenefits(arg0_29)
	setActive(arg0_29.benefitsTF, arg0_29.showBenefits)

	if arg0_29.showBenefits then
		setFillAmount(arg0_29.mainAttrBar, arg0_29:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_29.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_30, arg1_30)
	local var0_30 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_30 = var0_30 * arg0_30.selectNum
	local var2_30 = 0

	for iter0_30, iter1_30 in ipairs(arg0_30.selectedIds) do
		var2_30 = var2_30 + (var0_30 - arg0_30.characterAgency:GetShipById(iter1_30):GetAttrGrade(arg1_30) + 1)
	end

	return var2_30 / var1_30
end

function var0_0.ToVShip(arg0_31, arg1_31)
	if not arg0_31.vship then
		arg0_31.vship = {}

		function arg0_31.vship.getNation()
			return arg0_31.vship.config.nationality
		end

		function arg0_31.vship.getShipType()
			return arg0_31.vship.config.type
		end

		function arg0_31.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_31.vship.config.type)
		end

		function arg0_31.vship.getRarity()
			return arg0_31.vship.config.rarity
		end
	end

	arg0_31.vship.config = arg1_31

	return arg0_31.vship
end

local function var1_0(arg0_36, arg1_36)
	if not arg1_36 or arg1_36 == "" then
		return true
	end

	local var0_36 = string.lower(string.gsub(arg1_36, "%.", "%%."))
	local var1_36 = IslandShip.StaticGetName(arg0_36)

	return string.find(string.lower(var1_36), var0_36)
end

local function var2_0(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg1_37
	local var1_37 = ShipGroup.getDefaultShipConfig(var0_37)
	local var2_37 = arg0_37:ToVShip(var1_37)
	local var3_37 = arg0_37.characterAgency:GetShipById(arg1_37)

	if ShipIndexConst.filterByCamp(var2_37, arg2_37.campIndex) and ShipIndexConst.filterByRarity(var2_37, arg2_37.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_37, arg2_37.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_38)
	local var0_38 = {}
	local var1_38 = arg0_38.characterAgency:GetShipsContainNpc()

	for iter0_38, iter1_38 in ipairs(var1_38) do
		if var1_0(iter1_38.id, arg0_38.searchKey) and var2_0(arg0_38, iter1_38.id, arg0_38.sortData) then
			table.insert(var0_38, iter1_38.id)
		end
	end

	local var2_38 = IslandShipIndexLayer.getSortFuncAndName(arg0_38.sortData.sortIndex, arg0_38.selectAsc)

	table.sort(var0_38, CompareFuncs(var2_38))

	return var0_38
end

function var0_0.OnDestroy(arg0_39)
	arg0_39:StopTimer()
	arg0_39.dftAniEvent:SetEndEvent(nil)
end

function var0_0.OnHide(arg0_40)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_40._tf)
end

return var0_0
