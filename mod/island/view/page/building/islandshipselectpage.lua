local var0_0 = class("IslandShipSelectPage", import("...base.IslandBasePage"))

var0_0.TYPE2NAME = {
	energy = i18n1("体力"),
	attr = i18n1("属性"),
	level = i18n1("等级")
}

function var0_0.getUIName(arg0_1)
	return "IslandShipSelectUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.title = arg0_2:findTF("top/title/Text")

	setText(arg0_2.title, i18n1("选择角色"))

	arg0_2.frameTF = arg0_2:findTF("frame")
	arg0_2.shipRectCom = arg0_2:findTF("ships", arg0_2.frameTF):GetComponent("LScrollRect")
	arg0_2.ascToggle = arg0_2:findTF("sort_toggle", arg0_2.frameTF)
	arg0_2.sortBtn = arg0_2:findTF("sort", arg0_2.frameTF)
	arg0_2.sortShow = arg0_2:findTF("show", arg0_2.sortBtn)
	arg0_2.sortDropdownTF = arg0_2:findTF("dropdown", arg0_2.sortBtn)

	setActive(arg0_2.sortDropdownTF, false)

	arg0_2.infoPanel = arg0_2:findTF("info")
	arg0_2.nameTF = arg0_2:findTF("name", arg0_2.infoPanel)
	arg0_2.levelTF = arg0_2:findTF("level", arg0_2.infoPanel)
	arg0_2.attrUIList = UIItemList.New(arg0_2:findTF("attrs", arg0_2.infoPanel), arg0_2:findTF("attrs/tpl", arg0_2.infoPanel))
	arg0_2.skillTF = arg0_2:findTF("skill", arg0_2.infoPanel)
	arg0_2.energyTF = arg0_2:findTF("energy", arg0_2.infoPanel)
	arg0_2.statusTF = arg0_2:findTF("status", arg0_2.infoPanel)
	arg0_2.sureBtn = arg0_2:findTF("sure")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
		arg0_3.cancelFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sureBtn, function()
		arg0_3:Hide()
		arg0_3.confirmFunc(arg0_3.selectedId)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.ascToggle, function(arg0_6)
		arg0_3.selectAsc = arg0_6

		arg0_3:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sortBtn, function()
		setActive(arg0_3.sortDropdownTF, true)
	end, SFX_PANEL)
	eachChild(arg0_3.sortDropdownTF, function(arg0_8)
		onButton(arg0_3, arg0_8, function()
			arg0_3.sortType = arg0_8.name

			arg0_3:UpdateSortBtn()
			setActive(arg0_3.sortDropdownTF, false)
			arg0_3:FlushShips()
		end, SFX_PANEL)
	end)
	arg0_3.attrUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = IslandShipAttr.ATTRS[arg1_10 + 1]

			setText(arg0_3:findTF("content/name", arg2_10), IslandShipAttr.ToChinese(var0_10))
			setText(arg0_3:findTF("content/value", arg2_10), arg0_3.selectedShip:GetAttr(var0_10))
		end
	end)

	function arg0_3.shipRectCom.onInitItem(arg0_11)
		arg0_3:OnInitShip(arg0_11)
	end

	function arg0_3.shipRectCom.onUpdateItem(arg0_12, arg1_12)
		arg0_3:OnUpdateShip(arg0_12, arg1_12)
	end

	arg0_3.cards = {}
	arg0_3.selectAsc = true

	arg0_3:UpdateSortBtn()
end

function var0_0.OnShow(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.confirmFunc = arg2_13
	arg0_13.cancelFunc = arg3_13
	arg0_13.showShips = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShips()

	if #arg0_13.showShips ~= 0 then
		arg0_13.selectedId = arg0_13.showShips[1].id
	end

	arg0_13:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_14)
	setText(arg0_14.sortShow, var0_0.TYPE2NAME[arg0_14.sortType])
end

function var0_0.OnInitShip(arg0_15, arg1_15)
	local var0_15 = IslandSelectShipCard.New(arg1_15)

	onButton(arg0_15, var0_15.go, function()
		arg0_15.selectedId = var0_15.id

		for iter0_16, iter1_16 in pairs(arg0_15.cards) do
			iter1_16:UpdateSelected(arg0_15.selectedId)
		end

		arg0_15:FlushInfo()
	end, SFX_PANEL)

	arg0_15.cards[arg1_15] = var0_15
end

function var0_0.OnUpdateShip(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:OnInitItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	local var1_17 = arg0_17.showShips[arg1_17 + 1]

	var0_17:Update(var1_17, arg0_17.attrType, arg0_17.buildingId, arg0_17.selectedId)
end

function var0_0.FlushShips(arg0_18)
	switch(arg0_18.sortType, {
		energy = function()
			arg0_18:SortByEnergy()
		end,
		attr = function()
			arg0_18:SortByAttr()
		end,
		level = function()
			arg0_18:SortByLevel()
		end
	})
	arg0_18.shipRectCom:SetTotalCount(#arg0_18.showShips)
	arg0_18:FlushInfo()
end

function var0_0.FlushInfo(arg0_22)
	setActive(arg0_22.infoPanel, arg0_22.selectedId)

	if not arg0_22.selectedId then
		return
	end

	arg0_22.selectedShip = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_22.selectedId)

	setText(arg0_22.nameTF, arg0_22.selectedShip:GetName())
	setText(arg0_22.levelTF, arg0_22.selectedShip:GetLevel())
	arg0_22.attrUIList:align(#IslandShipAttr.ATTRS)

	local var0_22 = pg.island_ship_skill[arg0_22.selectedShip:GetMainSkill()]

	GetImageSpriteFromAtlasAsync("IslandSkillIcon/" .. var0_22.icon, "", arg0_22:findTF("title/icon", arg0_22.skillTF))
	setText(arg0_22:findTF("title/name", arg0_22.skillTF), var0_22.name)
	setText(arg0_22:findTF("title/level", arg0_22.skillTF), var0_22.level)
	setText(arg0_22:findTF("mask/desc", arg0_22.skillTF), var0_22.desc)

	local var1_22 = arg0_22.selectedShip:GetEnergy()
	local var2_22 = arg0_22.selectedShip:GetMaxEnergy()

	setText(arg0_22:findTF("title/name", arg0_22.energyTF), i18n1("体力"))
	setText(arg0_22:findTF("title/value", arg0_22.energyTF), var1_22 .. "/" .. var2_22)
	setSlider(arg0_22:findTF("energy_bar", arg0_22.energyTF), 0, 1, var1_22 / var2_22)
	setActive(arg0_22:findTF("time", arg0_22.energyTF), false)

	local var3_22 = arg0_22.selectedShip:GetValidStatus()

	setActive(arg0_22.statusTF, #var3_22 > 0)

	if #var3_22 > 0 then
		GetImageSpriteFromAtlasAsync(var3_22[1]:GetIcon(), "", arg0_22:findTF("title/icon", arg0_22.statusTF))
		setText(arg0_22:findTF("title/name", arg0_22.statusTF), var3_22[1]:GetName())
		setText(arg0_22:findTF("desc", arg0_22.statusTF), var3_22[1]:GetDesc())
	end
end

function var0_0.SortByEnergy(arg0_23)
	table.sort(arg0_23.showShips, CompareFuncs({
		function(arg0_24)
			return arg0_24:GetEnergy() * (arg0_23.selectAsc and -1 or 1)
		end,
		function(arg0_25)
			return arg0_25:GetAttr(IslandShipAttr.ATTRS[arg0_23.attrType])
		end,
		function(arg0_26)
			return arg0_26:IsMainSkillEffective(arg0_23.buildingId) and 0 or 1
		end,
		function(arg0_27)
			return arg0_27:GetLevel()
		end,
		function(arg0_28)
			return arg0_28.id
		end
	}))
end

function var0_0.SortByAttr(arg0_29)
	table.sort(arg0_29.showShips, CompareFuncs({
		function(arg0_30)
			return arg0_30:GetAttr(IslandShipAttr.ATTRS[arg0_29.attrType]) * (arg0_29.selectAsc and -1 or 1)
		end,
		function(arg0_31)
			return arg0_31:GetEnergy()
		end,
		function(arg0_32)
			return arg0_32:IsMainSkillEffective(arg0_29.buildingId) and 0 or 1
		end,
		function(arg0_33)
			return arg0_33:GetLevel()
		end,
		function(arg0_34)
			return arg0_34.id
		end
	}))
end

function var0_0.SortByLevel(arg0_35)
	table.sort(arg0_35.showShips, CompareFuncs({
		function(arg0_36)
			return arg0_36:GetLevel() * (arg0_35.selectAsc and -1 or 1)
		end,
		function(arg0_37)
			return arg0_37:GetAttr(IslandShipAttr.ATTRS[arg0_35.attrType])
		end,
		function(arg0_38)
			return arg0_38:GetEnergy()
		end,
		function(arg0_39)
			return arg0_39:IsMainSkillEffective(arg0_35.buildingId) and 0 or 1
		end,
		function(arg0_40)
			return arg0_40.id
		end
	}))
end

function var0_0.OnDestroy(arg0_41)
	return
end

return var0_0
