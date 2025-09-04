local var0_0 = class("IslandShipUpgradePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.expBar = arg0_2:findTF("frame/frame_1/exp/bar")
	arg0_2.expBarPre = arg0_2:findTF("frame/frame_1/exp/bar_pre")
	arg0_2.levelTxt = arg0_2:findTF("frame/frame_1/exp/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("frame/frame_1/exp/Text"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("frame/frame_1/close")
	arg0_2.confirmBtn = arg0_2:findTF("frame/btn_confirm")
	arg0_2.delBtn = arg0_2:findTF("frame/frame_2/del")
	arg0_2.maxBtn = arg0_2:findTF("frame/frame_2/max")
	arg0_2.switchBtn = arg0_2:findTF("frame/frame_1/switch")
	arg0_2.uiBreakList = UIItemList.New(arg0_2:findTF("frame/frame_1/attr/stars"), arg0_2:findTF("frame/frame_1/attr/stars/tpl"))
	arg0_2.uiAttrList = UIItemList.New(arg0_2:findTF("frame/frame_1/attr/list"), arg0_2:findTF("frame/frame_1/attr/list/tpl"))
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/frame_2/items"), arg0_2:findTF("frame/frame_2/items/tpl"))

	setText(arg0_2:findTF("frame/frame_1/title"), i18n("island_word_ship_level_upgrade"))
	setText(arg0_2:findTF("frame/frame_2/sub_title/Text"), i18n("island_skill_consume_title"))
	setText(arg0_2:findTF("frame/frame_1/attr/label"), i18n("island_word_ship_level_upgrade_1"))
	setText(arg0_2:findTF("frame/frame_1/attr/title/Text"), i18n("island_word_ship_rank"))
	setText(arg0_2.confirmBtn:Find("Text"), i18n("island_chara_up_button"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3:NothingSelected() then
			return
		end

		arg0_3:emit(IslandMediator.USE_SHIP_EXP_BOOK, arg0_3.ship.id, arg0_3.selected)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.delBtn, function()
		arg0_3.selected = {}

		arg0_3:UpdateConsume(arg0_3.ship)
		arg0_3:UpdateLevelPreview()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.maxBtn, function()
		arg0_3:FillSelected(arg0_3.ship)
		arg0_3:UpdateLevelPreview()
	end, SFX_PANEL)

	arg0_3.isShowAttrPanel = false

	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_9)
		arg0_3.isShowAttrPanel = arg0_9

		if arg0_9 then
			arg0_3:UpdateAttrs(arg0_3.ship)
			arg0_3:UpdateBreakOutLevel(arg0_3.ship)
		end
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_10, arg1_10)
	arg0_10.ship = arg1_10
	arg0_10.selected = {}

	arg0_10:UpdateLevelAndExp(arg1_10)
	arg0_10:UpdateConsume(arg1_10)
	arg0_10:BlurPanel()
end

function var0_0.UpdateLevelAndExp(arg0_11, arg1_11, arg2_11)
	setActive(arg0_11.expBarPre, false)

	local var0_11 = arg1_11:GetExp()
	local var1_11 = arg1_11:GetTargetExp()
	local var2_11 = arg1_11:GetLevel()

	if arg1_11:IsMaxLevel() then
		setFillAmount(arg0_11.expBar, 1)

		arg0_11.expTxt.text = ""
	else
		setFillAmount(arg0_11.expBar, var0_11 / var1_11)

		arg0_11.expTxt.text = "<color=#39BFFF>" .. var0_11 .. "</color>/" .. var1_11
	end

	arg0_11.levelTxt.text = var2_11
end

function var0_0.UpdateConsume(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetShipExpBooks()

	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_12[arg1_13 + 1]

			updateCustomDrop(arg2_13, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = var0_13.id,
				count = var0_13.count
			}))
			setActive(arg2_13:Find("icon_bg/count_bg"), true)
			setText(arg2_13:Find("icon_bg/count_bg/count"), "X" .. var0_13.count)
			onButton(arg0_12, arg2_13, function()
				if var0_13.count <= 0 or arg0_12:CheckMaxLevel() then
					return
				end

				arg0_12:OpenCalcPanel(arg2_13, var0_13)
			end, SFX_PANEL)
			arg0_12:UpdateCalcPanel(arg2_13, var0_13)
		end
	end)
	arg0_12.uiItemList:align(#var0_12)
end

function var0_0.OpenCalcPanel(arg0_15, arg1_15, arg2_15)
	arg0_15.selected[arg2_15.id] = math.min(arg2_15.count, (arg0_15.selected[arg2_15.id] or 0) + 1)

	arg0_15:UpdateCalcPanel(arg1_15, arg2_15)
	arg0_15:UpdateLevelPreview()
end

function var0_0.CheckMaxLevel(arg0_16)
	local var0_16 = Clone(arg0_16.ship)
	local var1_16 = arg0_16:CalcExpAddition(arg0_16.selected)

	var0_16:AddExp(var1_16)

	return var0_16:IsMaxLevel()
end

function var0_0.UpdateLevelPreview(arg0_17)
	local var0_17 = Clone(arg0_17.ship)
	local var1_17 = arg0_17:CalcExpAddition(arg0_17.selected)

	var0_17:AddExp(var1_17)
	setActive(arg0_17.expBarPre, var1_17 > 0)

	local var2_17 = arg0_17.ship:GetLevel()

	if var1_17 > 0 then
		local var3_17 = var0_17:GetExp()
		local var4_17 = var0_17:GetTargetExp()
		local var5_17 = var0_17:GetLevel()

		if var0_17:IsMaxLevel() then
			setFillAmount(arg0_17.expBarPre, 1)

			arg0_17.expTxt.text = ""
		else
			setFillAmount(arg0_17.expBarPre, var3_17 / var4_17)

			arg0_17.expTxt.text = "<color=#39BFFF>" .. var3_17 .. "</color>/" .. var4_17
		end

		if var2_17 < var5_17 then
			arg0_17.levelTxt.text = var5_17

			setFillAmount(arg0_17.expBar, 0)
		end
	else
		arg0_17:UpdateLevelAndExp(arg0_17.ship)
	end
end

function var0_0.UpdateCalcPanel(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.selected[arg2_18.id] or 0

	setText(arg1_18:Find("calc/Text"), var0_18)
	setActive(arg1_18:Find("calc"), var0_18 > 0)
	onButton(arg0_18, arg1_18:Find("calc/bg"), function()
		arg0_18.selected[arg2_18.id] = (arg0_18.selected[arg2_18.id] or 0) - 1

		arg0_18:UpdateCalcPanel(arg1_18, arg2_18)
		arg0_18:UpdateLevelPreview()
	end, SFX_PANEL)
	setGray(arg0_18.confirmBtn, arg0_18:NothingSelected(), true)
	arg0_18:UpdateAttrs(arg0_18.ship)
	arg0_18:UpdateBreakOutLevel(arg0_18.ship)
end

function var0_0.NothingSelected(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.selected) do
		if iter1_20 > 0 then
			return false
		end
	end

	return true
end

function var0_0.FillSelected(arg0_21, arg1_21)
	arg0_21.selected = {}

	local var0_21 = Clone(arg1_21)
	local var1_21 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetShipExpBooks()

	table.sort(var1_21, function(arg0_22, arg1_22)
		return arg0_22:GetRarity() > arg1_22:GetRarity()
	end)

	for iter0_21, iter1_21 in ipairs(var1_21) do
		for iter2_21 = 1, iter1_21.count do
			if var0_21:IsMaxLevel() then
				break
			end

			local var2_21 = tonumber(iter1_21:GetUseArg())

			var0_21:AddExp(var2_21)

			arg0_21.selected[iter1_21.id] = (arg0_21.selected[iter1_21.id] or 0) + 1
		end
	end

	arg0_21:UpdateConsume(arg0_21.ship)
end

function var0_0.CalcExpAddition(arg0_23, arg1_23)
	local var0_23 = 0
	local var1_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_23, iter1_23 in pairs(arg1_23) do
		for iter2_23 = 1, iter1_23 do
			local var2_23 = var1_23:GetItemById(iter0_23)

			var0_23 = var0_23 + tonumber(var2_23:GetUseArg())
		end
	end

	return var0_23
end

function var0_0.UpdateAttrs(arg0_24, arg1_24)
	if not arg0_24.isShowAttrPanel then
		return
	end

	local var0_24 = arg1_24:GetGrowthAtt()

	arg0_24.uiAttrList:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = IslandShipAttr.ATTRS[arg1_25 + 1]
			local var1_25 = arg1_24:GetAttrGrade(var0_25)
			local var2_25 = IslandShipAttr.Grade2Img(var1_25)

			arg2_25:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var2_25[2])

			setText(arg2_25:Find("name"), IslandShipAttr.ToChinese(var0_25))
			setText(arg2_25:Find("value"), "+" .. (var0_24[var0_25] or 0))
		end
	end)
	arg0_24.uiAttrList:align(#IslandShipAttr.ATTRS)
end

function var0_0.UpdateBreakOutLevel(arg0_26, arg1_26)
	if not arg0_26.isShowAttrPanel then
		return
	end

	arg0_26.uiBreakList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			setActive(arg2_27:Find("Image"), true)
		end
	end)
	arg0_26.uiBreakList:align(arg1_26:GetBreakLevel())
end

function var0_0.OnHide(arg0_28)
	arg0_28:UnBlurPanel()

	arg0_28.selected = {}
end

return var0_0
