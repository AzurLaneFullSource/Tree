local var0_0 = class("CommanderHomeLevelInfoPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderHomeLevelUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.close = arg0_2:findTF("bg/frame/close_btn")
	arg0_2.scrollrect = arg0_2:findTF("bg/frame/scrollrect"):GetComponent("LScrollRect")
	arg0_2.levelTxt = arg0_2:findTF("bg/frame/level/Text"):GetComponent(typeof(Text))
	arg0_2.descPanel = arg0_2:findTF("desc_panel")
	arg0_2.descLevelTxt = arg0_2.descPanel:Find("frame/level"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2.descPanel:Find("frame/Text"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("bg/frame/level/exp"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("bg/frame/level/label"), i18n("commander_home_level_label"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.cards = {}

	function arg0_3.scrollrect.onInitItem(arg0_4)
		arg0_3:OnInitItem(arg0_4)
	end

	function arg0_3.scrollrect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateItem(arg0_5, arg1_5)
	end

	onButton(arg0_3, arg0_3.descPanel, function()
		arg0_3:CloseDescWindow()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.close, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = CommanderHomeLevelCard.New(arg1_9, arg0_9)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.displays[arg1_10 + 1]

	var0_10:Update(arg0_10.home, var1_10)
end

function var0_0.Show(arg0_11, arg1_11)
	var0_0.super.Show(arg0_11)

	arg0_11.home = arg1_11

	arg0_11:InitMainView()
end

function var0_0.InitMainView(arg0_12)
	local var0_12 = arg0_12.home

	arg0_12.levelTxt.text = "LV." .. var0_12:GetLevel()

	if var0_12:IsMaxLevel() then
		arg0_12.expTxt.text = "EXP MAX"
	else
		arg0_12.expTxt.text = "EXP " .. var0_12.exp .. "/" .. var0_12:GetNextLevelExp()
	end

	local var1_12 = var0_12:GetAllLevel()

	arg0_12.displays = {}

	local var2_12 = var0_12:bindConfigTable()

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var3_12 = var2_12[iter1_12]
		local var4_12 = var0_12:GetTargetExpForLevel(iter1_12)

		table.insert(arg0_12.displays, {
			level = var3_12.level,
			totalExp = var4_12,
			tail = iter0_12 == #var1_12,
			exp = var3_12.home_exp,
			desc = var2_12[iter1_12].desc
		})
	end

	arg0_12.scrollrect:SetTotalCount(#arg0_12.displays)
end

function var0_0.ShowDescWindow(arg0_13, arg1_13, arg2_13)
	setActive(arg0_13.descPanel, true)

	arg0_13.descTxt.text = arg1_13
	arg0_13.descLevelTxt.text = "LV." .. arg2_13
end

function var0_0.CloseDescWindow(arg0_14)
	setActive(arg0_14.descPanel, false)
end

function var0_0.OnDestroy(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:Dispose()
	end
end

return var0_0
