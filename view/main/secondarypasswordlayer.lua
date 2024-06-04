local var0 = class("SecondaryPasswordLayer", import("..base.BaseUI"))

var0.SetView = 1
var0.InputView = 2

function var0.getUIName(arg0)
	return "SecondaryPasswordUI"
end

function var0.init(arg0)
	arg0.window = arg0:findTF("window")
	arg0.setView = arg0:findTF("sliders/set", arg0.window)
	arg0.inputView = arg0:findTF("sliders/input", arg0.window)
	arg0.frame = arg0:findTF("frame")
	arg0.informBg = arg0:findTF("top/bg/information", arg0.window)
	arg0.textTitle = arg0:findTF("title", arg0.informBg):GetComponent(typeof(Text))
	arg0.textTitleEn = arg0:findTF("title/title_en", arg0.informBg):GetComponent(typeof(Text))
	arg0.inputpanel = arg0:findTF("inputpanel", arg0.window)
	arg0.containerbtn = arg0:findTF("btns", arg0.inputpanel)
	arg0.btngroup = CustomIndexLayer.Clone2Full(arg0.containerbtn, 10)

	_.each(arg0.btngroup, function(arg0)
		local var0 = (arg0:GetSiblingIndex() + 1) % 10

		arg0.name = tostring(var0)

		setText(arg0:Find("text"), tostring(var0))
		setText(arg0:Find("highlight/text2"), tostring(var0))
	end)

	arg0.btnconfirm = arg0:findTF("confirmbtn", arg0.inputpanel)
	arg0.btndelete = arg0:findTF("deletebtn", arg0.inputpanel)
	arg0.btnclose = arg0:findTF("top/btnBack", arg0.window)
	arg0.resources = arg0:findTF("resources")
	arg0.selectFrame = arg0:findTF("resources/xian")
	arg0.setDigitGroup = {}
	arg0.setLine1Grid = arg0:findTF("line1/input/grid", arg0.setView)
	arg0.setLine2Grid = arg0:findTF("line2/input/grid", arg0.setView)

	CustomIndexLayer.Clone2Full(arg0.setLine1Grid, 6)
	CustomIndexLayer.Clone2Full(arg0.setLine2Grid, 6)

	local var0 = arg0.setLine1Grid.childCount

	for iter0 = 0, var0 - 1 do
		table.insert(arg0.setDigitGroup, arg0.setLine1Grid:GetChild(iter0))
	end

	for iter1 = 0, var0 - 1 do
		table.insert(arg0.setDigitGroup, arg0.setLine2Grid:GetChild(iter1))
	end

	arg0.btnhide = arg0:findTF("line1/hidebtn/hide", arg0.setView)
	arg0.btnshow = arg0:findTF("line1/hidebtn/show", arg0.setView)
	arg0.tipseterror = arg0:findTF("line2/tip", arg0.setView)
	arg0.inputDigitGroup = {}
	arg0.inputLineGrid = arg0:findTF("line1/input/grid", arg0.inputView)

	CustomIndexLayer.Clone2Full(arg0.inputLineGrid, 6)

	local var1 = arg0.inputLineGrid.childCount

	for iter2 = 0, var1 - 1 do
		table.insert(arg0.inputDigitGroup, arg0.inputLineGrid:GetChild(iter2))
	end

	arg0.inputMode = false
	arg0.timers = {}

	arg0:InitInteractable()
end

function var0.InitInteractable(arg0)
	_.each(arg0.btngroup, function(arg0)
		onButton(arg0, arg0, function()
			local var0 = (arg0:GetSiblingIndex() + 1) % 10
			local var1 = arg0.inputPos + 1

			if var1 > 0 and var1 <= #arg0.digitGroup then
				arg0.inputs = arg0.inputs .. tostring(var0)

				local var2 = arg0.digitGroup[var1]:Find("text")

				setText(var2, var0)
				setActive(arg0.digitGroup[var1]:Find("filled"), false)
				setActive(arg0.digitGroup[var1]:Find("space"), false)

				local function var3()
					setText(var2, "")
					setActive(arg0.digitGroup[var1]:Find("filled"), true)
				end

				if not arg0.inputMode then
					if arg0.timers["input" .. var1] then
						arg0.timers["input" .. var1]:Reset(var3, 1, 1)
					else
						arg0.timers["input" .. var1] = Timer.New(var3, 1, 1)
					end

					arg0.timers["input" .. var1]:Start()
				end

				arg0:SetInputPos(var1)
			end

			setActive(arg0:Find("highlight"), true)

			local function var4()
				setActive(arg0:Find("highlight"), false)
			end

			if arg0.timers["btn" .. var0] then
				arg0.timers["btn" .. var0]:Reset(var4, 0.2, 1)
			else
				arg0.timers["btn" .. var0] = Timer.New(var4, 0.2, 1)
			end

			arg0.timers["btn" .. var0]:Start()
		end)
	end)
	onButton(arg0, arg0.btndelete, function()
		local var0 = arg0.inputPos

		if var0 > 0 and var0 <= #arg0.digitGroup then
			arg0.inputs = string.sub(arg0.inputs, 1, -2)

			setText(arg0.digitGroup[var0]:Find("text"), "")
			setActive(arg0.digitGroup[var0]:Find("filled"), false)
			setActive(arg0.digitGroup[var0]:Find("space"), not arg0.inputMode)

			if arg0.timers["input" .. var0] then
				arg0.timers["input" .. var0]:Stop()
			end

			arg0:SetInputPos(var0 - 1)
		end

		setActive(arg0.btndelete:Find("highlight"), true)

		local function var1()
			setActive(arg0.btndelete:Find("highlight"), false)
		end

		if arg0.timers.btndel then
			arg0.timers.btndel:Reset(var1, 0.3, 1)
		else
			arg0.timers.btndel = Timer.New(var1, 0.3, 1)
		end

		arg0.timers.btndel:Start()
	end)
	onButton(arg0, arg0.btnconfirm, function()
		if arg0.mode == var0.InputView then
			arg0.inputnone = false

			if #arg0.inputs ~= 6 then
				return
			end

			arg0:emit(SecondaryPasswordMediator.CONFIRM_PASSWORD, arg0.inputs)
		else
			arg0.inputnone = false

			local var0 = true

			if #arg0.inputs ~= 12 then
				var0 = false
			end

			for iter0 = 1, 6 do
				if string.byte(arg0.inputs, iter0) ~= string.byte(arg0.inputs, 6 + iter0) then
					var0 = false

					break
				end
			end

			if not var0 then
				arg0:UpdateView()

				return
			end

			local var1 = string.sub(arg0.inputs, 1, 6)
			local var2
			local var3 = {}
			local var4

			var2 = {
				modal = true,
				mode = "settips",
				hideYes = true,
				title = "setting",
				type = MSGBOX_TYPE_SECONDPWD,
				references = var3,
				onYes = function()
					local var0 = var3.inputfield.text

					var3.lasttext = var0
					var4 = {
						modal = true,
						content = string.format(i18n("secondarypassword_confirm_tips"), var0),
						onNo = function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox(var2)
						end,
						onYes = function()
							arg0:emit(SecondaryPasswordMediator.SET_PASSWORD, var1, var0)
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var4)
				end,
				onNo = function()
					arg0:emit(var0.ON_CLOSE)
				end,
				onPreShow = function()
					arg0:Hide()
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var2)
		end
	end)
	onButton(arg0, arg0.btnhide, function()
		arg0.inputMode = not arg0.inputMode

		arg0:UpdateInputSlider()
		setActive(arg0.btnhide, not arg0.inputMode)
		setActive(arg0.btnshow, arg0.inputMode)
	end)
	onButton(arg0, arg0.btnshow, function()
		arg0.inputMode = not arg0.inputMode

		arg0:UpdateInputSlider()
		setActive(arg0.btnhide, not arg0.inputMode)
		setActive(arg0.btnshow, arg0.inputMode)
	end)
	onButton(arg0, arg0.btnclose, function()
		if arg0.mode == var0.InputView then
			arg0:emit(SecondaryPasswordMediator.CANCEL_OPERATION)
		end

		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0, arg0._tf, function()
		return
	end, SOUND_BACK)
end

local var1 = 69

function var0.didEnter(arg0)
	if arg0.contextData.parent then
		setParent(arg0._tf, arg0.contextData.parent)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
			groupName = arg0:getGroupNameFromData(),
			weight = arg0:getWeightFromData()
		})
	end

	local var0 = arg0.contextData.mode

	setActive(arg0.setView, var0 == var0.SetView)
	setActive(arg0.inputView, var0 == var0.InputView)

	arg0.mode = var0
	arg0.type = arg0.contextData.type
	arg0.digitGroup = var0 == var0.SetView and arg0.setDigitGroup or arg0.inputDigitGroup
	arg0.textTitle.text = var0 == var0.SetView and i18n("words_set_password") or i18n("words_information")
	arg0.textTitleEn.text = var0 == var0.SetView and "PASSWORD" or "INFORM"

	local var1 = arg0.informBg.sizeDelta

	var1.x = arg0.textTitle.preferredWidth + arg0.textTitleEn.preferredWidth + var1
	arg0.informBg.sizeDelta = var1
	arg0.inputs = ""

	arg0:SetInputPos(0)

	arg0.inputnone = true

	arg0:UpdateView()
	arg0:UpdateInputSlider()
end

function var0.UpdateInputSlider(arg0)
	arg0:ClearInputTimers()

	local var0 = arg0.inputMode

	arg0:SetInputXian(arg0.inputPos + 1)

	for iter0 = 1, #arg0.digitGroup do
		local var1 = arg0.digitGroup[iter0]
		local var2 = iter0 <= #arg0.inputs and string.char(string.byte(arg0.inputs, iter0)) or nil

		setText(var1:Find("text"), var0 and var2 or "")
		setActive(var1:Find("space"), not var0 and var2 == nil)
		setActive(var1:Find("filled"), not var0 and var2 ~= nil)
	end
end

function var0.ClearInputTimers(arg0)
	for iter0 = 1, 12 do
		if arg0.timers["input" .. iter0] then
			arg0.timers["input" .. iter0]:Stop()

			arg0.timers["input" .. iter0] = nil
		end
	end
end

function var0.ClearAllTimers(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		if iter1 then
			iter1:Stop()
		end
	end

	arg0.timers = {}
end

function var0.ClearInputs(arg0)
	arg0.inputs = ""

	arg0:SetInputPos(0)
	arg0:UpdateInputSlider()
end

function var0.UpdateView(arg0)
	if arg0.mode == var0.InputView then
		arg0:UpdateInputView()
	else
		arg0:UpdateSetView()
	end
end

local var2

local function var3(arg0)
	local var0 = pg.SecondaryPWDMgr.GetInstance()

	var2 = var2 or {
		[var0.UNLOCK_SHIP] = function(arg0)
			local var0 = arg0.contextData.info[1]
			local var1 = getProxy(BayProxy)
			local var2 = var1:getData()
			local var3 = var1:getShipById(var0)

			if var3 then
				return string.format(i18n("words_desc_unlock"), var3:getName())
			end
		end,
		[var0.UNLOCK_COMMANDER] = function(arg0)
			local var0 = arg0.contextData.info
			local var1 = getProxy(CommanderProxy):getCommanderById(var0)

			if var1 then
				return string.format(i18n("words_desc_unlock"), var1:getName())
			end
		end,
		[var0.RESOLVE_EQUIPMENT] = function(arg0)
			local var0 = arg0.contextData.info
			local var1 = getProxy(EquipmentProxy):getEquipmentById(var0)

			if var1 then
				local var2 = var1:getConfig("name")

				if var1:getConfig("id") % 20 > 0 then
					var2 = var2 .. "+" .. tostring(var1:getConfig("id") % 20)
				end

				return string.format(i18n("words_desc_resolve_equip"), var2)
			end
		end,
		[var0.CREATE_INHERIT] = function()
			return i18n("words_desc_create_inherit")
		end,
		[var0.CLOSE_PASSWORD] = function()
			return i18n("words_desc_close_password")
		end,
		[var0.CHANGE_SETTING] = function()
			return i18n("words_desc_change_settings")
		end
	}

	return var2[arg0]
end

function var0.UpdateInputView(arg0)
	local var0 = getProxy(SecondaryPWDProxy):getRawData()
	local var1 = arg0.inputView:Find("line1/tip")

	setText(var1, var0.notice)
	setActive(var1, not arg0.inputnone)

	local var2 = arg0.inputView:Find("line1/tip1")
	local var3 = var3(arg0.contextData.type)

	setText(var2, var3 and var3(arg0) or "")
end

function var0.UpdateConfirmButton(arg0)
	arg0.btnconfirm:GetComponent(typeof(Button)).interactable = #arg0.inputs == #arg0.digitGroup

	setActive(arg0.btnconfirm:Find("gray"), #arg0.inputs ~= #arg0.digitGroup)
end

function var0.UpdateSetView(arg0)
	setActive(arg0.tipseterror, not arg0.inputnone)
end

function var0.SetInputPos(arg0, arg1)
	arg0.inputPos = arg1
	arg1 = arg1 + 1

	arg0:SetInputXian(arg1)
	arg0:UpdateConfirmButton()
end

function var0.Hide(arg0)
	arg0:willExit()
	setActive(arg0._tf, false)
end

function var0.Resume(arg0)
	arg0:didEnter()
	setActive(arg0._tf, true)
end

function var0.SetInputXian(arg0, arg1)
	if arg0.inputMode and arg1 > 0 and arg1 <= #arg0.digitGroup then
		setParent(arg0.selectFrame, arg0.digitGroup[arg1])
	else
		setParent(arg0.selectFrame, arg0.resources)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
	arg0:ClearAllTimers()
end

return var0
