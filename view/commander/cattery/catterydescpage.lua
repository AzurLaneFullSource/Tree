local var0 = class("CatteryDescPage", import("...base.BaseSubView"))

var0.CHANGE_STYLE = "CatteryDescPage:CHANGE_STYLE"
var0.CHANGE_COMMANDER = "CatteryDescPage:CHANGE_COMMANDER"

function var0.getUIName(arg0)
	return "CatteryDescPage"
end

function var0.OnCatteryUpdate(arg0, arg1)
	arg0:Flush(arg1)

	if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
		arg0.page:OnCatteryUpdate(arg1)
	end
end

function var0.OnCatteryStyleUpdate(arg0, arg1)
	arg0.cattery = arg1

	arg0:UpdateCatteryStyle()

	if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() and isa(arg0.page, CommanderHomeSelCatteryStylePage) then
		arg0.page:OnCatteryStyleUpdate(arg1)
	end
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("right/close_btn")
	arg0.styleIcon = arg0:findTF("left/bg/mask/icon"):GetComponent(typeof(Image))
	arg0.char = arg0:findTF("left/bg/char")
	arg0.commanderEmpty = arg0:findTF("left/bg/info/empty")
	arg0.styleInfo = arg0.commanderEmpty
	arg0.commanderExp = arg0:findTF("left/bg/info/commander_exp")
	arg0.commanderLevelTxt = arg0.commanderExp:Find("level/Text"):GetComponent(typeof(Text))
	arg0.commanderExpTxt = arg0.commanderExp:Find("value_bg/Text"):GetComponent(typeof(Text))
	arg0.commanderExpImg = arg0.commanderExp:Find("exp/Image")
	arg0.pageContainer = arg0._tf:Find("")
	arg0.toggleGroup = arg0:findTF("left/tags"):GetComponent(typeof(ToggleGroup))
	arg0.pagesTF = arg0:findTF("right/pages")
	arg0.tags = {
		arg0:findTF("left/tags/commander"),
		arg0:findTF("left/tags/home")
	}
	arg0.pages = {
		CommanderHomeSelCommanderPage.New(arg0.pagesTF, arg0.event),
		CommanderHomeSelCatteryStylePage.New(arg0.pagesTF, arg0.event)
	}
end

function var0.OnInit(arg0)
	arg0:bind(var0.CHANGE_STYLE, function(arg0, arg1)
		arg0:PreviewCatteryStyle(arg1)
	end, SFX_PANEL)
	arg0:bind(var0.CHANGE_COMMANDER, function(arg0, arg1)
		arg0:PreviewCatteryCommader(arg1)
	end)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.tags) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:SwitchPage(iter0)
			end
		end, SFX_PANEL)
	end
end

function var0.SwitchPage(arg0, arg1)
	local var0 = arg0.pages[arg1]

	if arg0.page == var0 then
		return
	end

	if arg0.page then
		arg0.page:Hide()
	end

	var0:ExecuteAction("Update", arg0.home, arg0.cattery)

	arg0.page = var0

	local var1 = isa(var0, CommanderHomeSelCatteryStylePage)

	setActive(arg0.commanderEmpty, var1)
	setActive(arg0.commanderExp, not var1)
	arg0:FlushCatteryInfo()
end

function var0.Update(arg0, arg1, arg2)
	arg0:Show()

	arg0.home = arg1
	arg0.cattery = arg2
	arg0.page = nil

	triggerToggle(arg0.tags[1], true)

	if arg2 then
		arg0:Flush(arg2)
	end
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:emit(CommanderHomeLayer.DESC_PAGE_OPEN)
end

function var0.Flush(arg0, arg1)
	arg0.cattery = arg1

	arg0:FlushCatteryInfo()
	arg0:UpdateCatteryStyle()
end

function var0.FlushCatteryInfo(arg0)
	local var0 = false

	if isa(arg0.page, CommanderHomeSelCommanderPage) then
		local var1 = arg0.cattery:ExistCommander()
	end

	arg0:UpdateCommander(arg0.cattery:GetCommander())

	local var2 = arg0.home
end

function var0.UpdateCommander(arg0, arg1)
	local var0 = arg1 ~= nil

	arg0:ReturnChar()

	if var0 then
		arg0:LoadChar(arg1)

		arg0.commanderLevelTxt.text = "LV." .. arg1:getLevel()

		if arg1:isMaxLevel() then
			arg0.commanderExpTxt.text = "MAX"

			setFillAmount(arg0.commanderExpImg, 1)
		else
			arg0.commanderExpTxt.text = "<color=#92FC63FF>" .. arg1.exp .. "</color>/" .. arg1:getNextLevelExp()

			setFillAmount(arg0.commanderExpImg, arg1.exp / arg1:getNextLevelExp())
		end
	end

	setActive(arg0.commanderExp, var0)
	setActive(arg0.commanderEmpty, not var0)
end

function var0.PreviewCatteryCommader(arg0, arg1)
	arg0:UpdateCommander(arg1)
end

function var0.UpdateCatteryStyle(arg0)
	local var0 = arg0.cattery
	local var1 = var0:_GetStyle_()

	if var0:ExistCommander() then
		arg0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var1:GetName(var0:IsDirty()), "")
	else
		arg0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var1:GetName(false), "")
	end
end

function var0.PreviewCatteryStyle(arg0, arg1)
	local var0 = pg.commander_home_style[arg1].name

	arg0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var0, "")
end

function var0.LoadChar(arg0, arg1)
	arg0.painting = arg1:getPainting()

	setCommanderPaintingPrefab(arg0.char, arg0.painting, "info")
end

function var0.ReturnChar(arg0)
	if arg0.painting then
		retCommanderPaintingPrefab(arg0.char, arg0.painting)

		arg0.painting = nil
	end
end

function var0.Hide(arg0)
	arg0:emit(CommanderHomeLayer.DESC_PAGE_CLOSE)
	arg0.toggleGroup:SetAllTogglesOff()
	var0.super.Hide(arg0)

	for iter0, iter1 in pairs(arg0.pages) do
		if iter1:GetLoaded() and iter1:isShowing() then
			iter1:Hide()
		end
	end
end

function var0.OnDestroy(arg0)
	arg0:ReturnChar()

	for iter0, iter1 in ipairs(arg0.pages) do
		iter1:Destroy()
	end
end

return var0
