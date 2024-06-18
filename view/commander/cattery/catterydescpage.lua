local var0_0 = class("CatteryDescPage", import("...base.BaseSubView"))

var0_0.CHANGE_STYLE = "CatteryDescPage:CHANGE_STYLE"
var0_0.CHANGE_COMMANDER = "CatteryDescPage:CHANGE_COMMANDER"

function var0_0.getUIName(arg0_1)
	return "CatteryDescPage"
end

function var0_0.OnCatteryUpdate(arg0_2, arg1_2)
	arg0_2:Flush(arg1_2)

	if arg0_2.page and arg0_2.page:GetLoaded() and arg0_2.page:isShowing() then
		arg0_2.page:OnCatteryUpdate(arg1_2)
	end
end

function var0_0.OnCatteryStyleUpdate(arg0_3, arg1_3)
	arg0_3.cattery = arg1_3

	arg0_3:UpdateCatteryStyle()

	if arg0_3.page and arg0_3.page:GetLoaded() and arg0_3.page:isShowing() and isa(arg0_3.page, CommanderHomeSelCatteryStylePage) then
		arg0_3.page:OnCatteryStyleUpdate(arg1_3)
	end
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.closeBtn = arg0_4:findTF("right/close_btn")
	arg0_4.styleIcon = arg0_4:findTF("left/bg/mask/icon"):GetComponent(typeof(Image))
	arg0_4.char = arg0_4:findTF("left/bg/char")
	arg0_4.commanderEmpty = arg0_4:findTF("left/bg/info/empty")
	arg0_4.styleInfo = arg0_4.commanderEmpty
	arg0_4.commanderExp = arg0_4:findTF("left/bg/info/commander_exp")
	arg0_4.commanderLevelTxt = arg0_4.commanderExp:Find("level/Text"):GetComponent(typeof(Text))
	arg0_4.commanderExpTxt = arg0_4.commanderExp:Find("value_bg/Text"):GetComponent(typeof(Text))
	arg0_4.commanderExpImg = arg0_4.commanderExp:Find("exp/Image")
	arg0_4.pageContainer = arg0_4._tf:Find("")
	arg0_4.toggleGroup = arg0_4:findTF("left/tags"):GetComponent(typeof(ToggleGroup))
	arg0_4.pagesTF = arg0_4:findTF("right/pages")
	arg0_4.tags = {
		arg0_4:findTF("left/tags/commander"),
		arg0_4:findTF("left/tags/home")
	}
	arg0_4.pages = {
		CommanderHomeSelCommanderPage.New(arg0_4.pagesTF, arg0_4.event),
		CommanderHomeSelCatteryStylePage.New(arg0_4.pagesTF, arg0_4.event)
	}
end

function var0_0.OnInit(arg0_5)
	arg0_5:bind(var0_0.CHANGE_STYLE, function(arg0_6, arg1_6)
		arg0_5:PreviewCatteryStyle(arg1_6)
	end, SFX_PANEL)
	arg0_5:bind(var0_0.CHANGE_COMMANDER, function(arg0_7, arg1_7)
		arg0_5:PreviewCatteryCommader(arg1_7)
	end)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)

	for iter0_5, iter1_5 in ipairs(arg0_5.tags) do
		onToggle(arg0_5, iter1_5, function(arg0_10)
			if arg0_10 then
				arg0_5:SwitchPage(iter0_5)
			end
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPage(arg0_11, arg1_11)
	local var0_11 = arg0_11.pages[arg1_11]

	if arg0_11.page == var0_11 then
		return
	end

	if arg0_11.page then
		arg0_11.page:Hide()
	end

	var0_11:ExecuteAction("Update", arg0_11.home, arg0_11.cattery)

	arg0_11.page = var0_11

	local var1_11 = isa(var0_11, CommanderHomeSelCatteryStylePage)

	setActive(arg0_11.commanderEmpty, var1_11)
	setActive(arg0_11.commanderExp, not var1_11)
	arg0_11:FlushCatteryInfo()
end

function var0_0.Update(arg0_12, arg1_12, arg2_12)
	arg0_12:Show()

	arg0_12.home = arg1_12
	arg0_12.cattery = arg2_12
	arg0_12.page = nil

	triggerToggle(arg0_12.tags[1], true)

	if arg2_12 then
		arg0_12:Flush(arg2_12)
	end
end

function var0_0.Show(arg0_13)
	var0_0.super.Show(arg0_13)
	arg0_13:emit(CommanderHomeLayer.DESC_PAGE_OPEN)
end

function var0_0.Flush(arg0_14, arg1_14)
	arg0_14.cattery = arg1_14

	arg0_14:FlushCatteryInfo()
	arg0_14:UpdateCatteryStyle()
end

function var0_0.FlushCatteryInfo(arg0_15)
	local var0_15 = false

	if isa(arg0_15.page, CommanderHomeSelCommanderPage) then
		local var1_15 = arg0_15.cattery:ExistCommander()
	end

	arg0_15:UpdateCommander(arg0_15.cattery:GetCommander())

	local var2_15 = arg0_15.home
end

function var0_0.UpdateCommander(arg0_16, arg1_16)
	local var0_16 = arg1_16 ~= nil

	arg0_16:ReturnChar()

	if var0_16 then
		arg0_16:LoadChar(arg1_16)

		arg0_16.commanderLevelTxt.text = "LV." .. arg1_16:getLevel()

		if arg1_16:isMaxLevel() then
			arg0_16.commanderExpTxt.text = "MAX"

			setFillAmount(arg0_16.commanderExpImg, 1)
		else
			arg0_16.commanderExpTxt.text = "<color=#92FC63FF>" .. arg1_16.exp .. "</color>/" .. arg1_16:getNextLevelExp()

			setFillAmount(arg0_16.commanderExpImg, arg1_16.exp / arg1_16:getNextLevelExp())
		end
	end

	setActive(arg0_16.commanderExp, var0_16)
	setActive(arg0_16.commanderEmpty, not var0_16)
end

function var0_0.PreviewCatteryCommader(arg0_17, arg1_17)
	arg0_17:UpdateCommander(arg1_17)
end

function var0_0.UpdateCatteryStyle(arg0_18)
	local var0_18 = arg0_18.cattery
	local var1_18 = var0_18:_GetStyle_()

	if var0_18:ExistCommander() then
		arg0_18.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var1_18:GetName(var0_18:IsDirty()), "")
	else
		arg0_18.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var1_18:GetName(false), "")
	end
end

function var0_0.PreviewCatteryStyle(arg0_19, arg1_19)
	local var0_19 = pg.commander_home_style[arg1_19].name

	arg0_19.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var0_19, "")
end

function var0_0.LoadChar(arg0_20, arg1_20)
	arg0_20.painting = arg1_20:getPainting()

	setCommanderPaintingPrefab(arg0_20.char, arg0_20.painting, "info")
end

function var0_0.ReturnChar(arg0_21)
	if arg0_21.painting then
		retCommanderPaintingPrefab(arg0_21.char, arg0_21.painting)

		arg0_21.painting = nil
	end
end

function var0_0.Hide(arg0_22)
	arg0_22:emit(CommanderHomeLayer.DESC_PAGE_CLOSE)
	arg0_22.toggleGroup:SetAllTogglesOff()
	var0_0.super.Hide(arg0_22)

	for iter0_22, iter1_22 in pairs(arg0_22.pages) do
		if iter1_22:GetLoaded() and iter1_22:isShowing() then
			iter1_22:Hide()
		end
	end
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:ReturnChar()

	for iter0_23, iter1_23 in ipairs(arg0_23.pages) do
		iter1_23:Destroy()
	end
end

return var0_0
