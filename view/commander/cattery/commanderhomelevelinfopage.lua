local var0 = class("CommanderHomeLevelInfoPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderHomeLevelUI"
end

function var0.OnLoaded(arg0)
	arg0.close = arg0:findTF("bg/frame/close_btn")
	arg0.scrollrect = arg0:findTF("bg/frame/scrollrect"):GetComponent("LScrollRect")
	arg0.levelTxt = arg0:findTF("bg/frame/level/Text"):GetComponent(typeof(Text))
	arg0.descPanel = arg0:findTF("desc_panel")
	arg0.descLevelTxt = arg0.descPanel:Find("frame/level"):GetComponent(typeof(Text))
	arg0.descTxt = arg0.descPanel:Find("frame/Text"):GetComponent(typeof(Text))
	arg0.expTxt = arg0:findTF("bg/frame/level/exp"):GetComponent(typeof(Text))

	setText(arg0:findTF("bg/frame/level/label"), i18n("commander_home_level_label"))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	onButton(arg0, arg0.descPanel, function()
		arg0:CloseDescWindow()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.close, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = CommanderHomeLevelCard.New(arg1, arg0)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(arg0.home, var1)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.home = arg1

	arg0:InitMainView()
end

function var0.InitMainView(arg0)
	local var0 = arg0.home

	arg0.levelTxt.text = "LV." .. var0:GetLevel()

	if var0:IsMaxLevel() then
		arg0.expTxt.text = "EXP MAX"
	else
		arg0.expTxt.text = "EXP " .. var0.exp .. "/" .. var0:GetNextLevelExp()
	end

	local var1 = var0:GetAllLevel()

	arg0.displays = {}

	local var2 = var0:bindConfigTable()

	for iter0, iter1 in ipairs(var1) do
		local var3 = var2[iter1]
		local var4 = var0:GetTargetExpForLevel(iter1)

		table.insert(arg0.displays, {
			level = var3.level,
			totalExp = var4,
			tail = iter0 == #var1,
			exp = var3.home_exp,
			desc = var2[iter1].desc
		})
	end

	arg0.scrollrect:SetTotalCount(#arg0.displays)
end

function var0.ShowDescWindow(arg0, arg1, arg2)
	setActive(arg0.descPanel, true)

	arg0.descTxt.text = arg1
	arg0.descLevelTxt.text = "LV." .. arg2
end

function var0.CloseDescWindow(arg0)
	setActive(arg0.descPanel, false)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end
end

return var0
