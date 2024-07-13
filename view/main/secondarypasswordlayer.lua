local var0_0 = class("SecondaryPasswordLayer", import("..base.BaseUI"))

var0_0.SetView = 1
var0_0.InputView = 2

function var0_0.getUIName(arg0_1)
	return "SecondaryPasswordUI"
end

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2:findTF("window")
	arg0_2.setView = arg0_2:findTF("sliders/set", arg0_2.window)
	arg0_2.inputView = arg0_2:findTF("sliders/input", arg0_2.window)
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.informBg = arg0_2:findTF("top/bg/information", arg0_2.window)
	arg0_2.textTitle = arg0_2:findTF("title", arg0_2.informBg):GetComponent(typeof(Text))
	arg0_2.textTitleEn = arg0_2:findTF("title/title_en", arg0_2.informBg):GetComponent(typeof(Text))
	arg0_2.inputpanel = arg0_2:findTF("inputpanel", arg0_2.window)
	arg0_2.containerbtn = arg0_2:findTF("btns", arg0_2.inputpanel)
	arg0_2.btngroup = CustomIndexLayer.Clone2Full(arg0_2.containerbtn, 10)

	_.each(arg0_2.btngroup, function(arg0_3)
		local var0_3 = (arg0_3:GetSiblingIndex() + 1) % 10

		arg0_3.name = tostring(var0_3)

		setText(arg0_3:Find("text"), tostring(var0_3))
		setText(arg0_3:Find("highlight/text2"), tostring(var0_3))
	end)

	arg0_2.btnconfirm = arg0_2:findTF("confirmbtn", arg0_2.inputpanel)
	arg0_2.btndelete = arg0_2:findTF("deletebtn", arg0_2.inputpanel)
	arg0_2.btnclose = arg0_2:findTF("top/btnBack", arg0_2.window)
	arg0_2.resources = arg0_2:findTF("resources")
	arg0_2.selectFrame = arg0_2:findTF("resources/xian")
	arg0_2.setDigitGroup = {}
	arg0_2.setLine1Grid = arg0_2:findTF("line1/input/grid", arg0_2.setView)
	arg0_2.setLine2Grid = arg0_2:findTF("line2/input/grid", arg0_2.setView)

	CustomIndexLayer.Clone2Full(arg0_2.setLine1Grid, 6)
	CustomIndexLayer.Clone2Full(arg0_2.setLine2Grid, 6)

	local var0_2 = arg0_2.setLine1Grid.childCount

	for iter0_2 = 0, var0_2 - 1 do
		table.insert(arg0_2.setDigitGroup, arg0_2.setLine1Grid:GetChild(iter0_2))
	end

	for iter1_2 = 0, var0_2 - 1 do
		table.insert(arg0_2.setDigitGroup, arg0_2.setLine2Grid:GetChild(iter1_2))
	end

	arg0_2.btnhide = arg0_2:findTF("line1/hidebtn/hide", arg0_2.setView)
	arg0_2.btnshow = arg0_2:findTF("line1/hidebtn/show", arg0_2.setView)
	arg0_2.tipseterror = arg0_2:findTF("line2/tip", arg0_2.setView)
	arg0_2.inputDigitGroup = {}
	arg0_2.inputLineGrid = arg0_2:findTF("line1/input/grid", arg0_2.inputView)

	CustomIndexLayer.Clone2Full(arg0_2.inputLineGrid, 6)

	local var1_2 = arg0_2.inputLineGrid.childCount

	for iter2_2 = 0, var1_2 - 1 do
		table.insert(arg0_2.inputDigitGroup, arg0_2.inputLineGrid:GetChild(iter2_2))
	end

	arg0_2.inputMode = false
	arg0_2.timers = {}

	arg0_2:InitInteractable()
end

function var0_0.InitInteractable(arg0_4)
	_.each(arg0_4.btngroup, function(arg0_5)
		onButton(arg0_4, arg0_5, function()
			local var0_6 = (arg0_5:GetSiblingIndex() + 1) % 10
			local var1_6 = arg0_4.inputPos + 1

			if var1_6 > 0 and var1_6 <= #arg0_4.digitGroup then
				arg0_4.inputs = arg0_4.inputs .. tostring(var0_6)

				local var2_6 = arg0_4.digitGroup[var1_6]:Find("text")

				setText(var2_6, var0_6)
				setActive(arg0_4.digitGroup[var1_6]:Find("filled"), false)
				setActive(arg0_4.digitGroup[var1_6]:Find("space"), false)

				local function var3_6()
					setText(var2_6, "")
					setActive(arg0_4.digitGroup[var1_6]:Find("filled"), true)
				end

				if not arg0_4.inputMode then
					if arg0_4.timers["input" .. var1_6] then
						arg0_4.timers["input" .. var1_6]:Reset(var3_6, 1, 1)
					else
						arg0_4.timers["input" .. var1_6] = Timer.New(var3_6, 1, 1)
					end

					arg0_4.timers["input" .. var1_6]:Start()
				end

				arg0_4:SetInputPos(var1_6)
			end

			setActive(arg0_5:Find("highlight"), true)

			local function var4_6()
				setActive(arg0_5:Find("highlight"), false)
			end

			if arg0_4.timers["btn" .. var0_6] then
				arg0_4.timers["btn" .. var0_6]:Reset(var4_6, 0.2, 1)
			else
				arg0_4.timers["btn" .. var0_6] = Timer.New(var4_6, 0.2, 1)
			end

			arg0_4.timers["btn" .. var0_6]:Start()
		end)
	end)
	onButton(arg0_4, arg0_4.btndelete, function()
		local var0_9 = arg0_4.inputPos

		if var0_9 > 0 and var0_9 <= #arg0_4.digitGroup then
			arg0_4.inputs = string.sub(arg0_4.inputs, 1, -2)

			setText(arg0_4.digitGroup[var0_9]:Find("text"), "")
			setActive(arg0_4.digitGroup[var0_9]:Find("filled"), false)
			setActive(arg0_4.digitGroup[var0_9]:Find("space"), not arg0_4.inputMode)

			if arg0_4.timers["input" .. var0_9] then
				arg0_4.timers["input" .. var0_9]:Stop()
			end

			arg0_4:SetInputPos(var0_9 - 1)
		end

		setActive(arg0_4.btndelete:Find("highlight"), true)

		local function var1_9()
			setActive(arg0_4.btndelete:Find("highlight"), false)
		end

		if arg0_4.timers.btndel then
			arg0_4.timers.btndel:Reset(var1_9, 0.3, 1)
		else
			arg0_4.timers.btndel = Timer.New(var1_9, 0.3, 1)
		end

		arg0_4.timers.btndel:Start()
	end)
	onButton(arg0_4, arg0_4.btnconfirm, function()
		if arg0_4.mode == var0_0.InputView then
			arg0_4.inputnone = false

			if #arg0_4.inputs ~= 6 then
				return
			end

			arg0_4:emit(SecondaryPasswordMediator.CONFIRM_PASSWORD, arg0_4.inputs)
		else
			arg0_4.inputnone = false

			local var0_11 = true

			if #arg0_4.inputs ~= 12 then
				var0_11 = false
			end

			for iter0_11 = 1, 6 do
				if string.byte(arg0_4.inputs, iter0_11) ~= string.byte(arg0_4.inputs, 6 + iter0_11) then
					var0_11 = false

					break
				end
			end

			if not var0_11 then
				arg0_4:UpdateView()

				return
			end

			local var1_11 = string.sub(arg0_4.inputs, 1, 6)
			local var2_11
			local var3_11 = {}
			local var4_11

			var2_11 = {
				modal = true,
				mode = "settips",
				hideYes = true,
				title = "setting",
				type = MSGBOX_TYPE_SECONDPWD,
				references = var3_11,
				onYes = function()
					local var0_12 = var3_11.inputfield.text

					var3_11.lasttext = var0_12
					var4_11 = {
						modal = true,
						content = string.format(i18n("secondarypassword_confirm_tips"), var0_12),
						onNo = function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox(var2_11)
						end,
						onYes = function()
							arg0_4:emit(SecondaryPasswordMediator.SET_PASSWORD, var1_11, var0_12)
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var4_11)
				end,
				onNo = function()
					arg0_4:emit(var0_0.ON_CLOSE)
				end,
				onPreShow = function()
					arg0_4:Hide()
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var2_11)
		end
	end)
	onButton(arg0_4, arg0_4.btnhide, function()
		arg0_4.inputMode = not arg0_4.inputMode

		arg0_4:UpdateInputSlider()
		setActive(arg0_4.btnhide, not arg0_4.inputMode)
		setActive(arg0_4.btnshow, arg0_4.inputMode)
	end)
	onButton(arg0_4, arg0_4.btnshow, function()
		arg0_4.inputMode = not arg0_4.inputMode

		arg0_4:UpdateInputSlider()
		setActive(arg0_4.btnhide, not arg0_4.inputMode)
		setActive(arg0_4.btnshow, arg0_4.inputMode)
	end)
	onButton(arg0_4, arg0_4.btnclose, function()
		if arg0_4.mode == var0_0.InputView then
			arg0_4:emit(SecondaryPasswordMediator.CANCEL_OPERATION)
		end

		arg0_4:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4._tf, function()
		return
	end, SOUND_BACK)
end

local var1_0 = 69

function var0_0.didEnter(arg0_21)
	if arg0_21.contextData.parent then
		setParent(arg0_21._tf, arg0_21.contextData.parent)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0_21._tf, true, {
			groupName = arg0_21:getGroupNameFromData(),
			weight = arg0_21:getWeightFromData()
		})
	end

	local var0_21 = arg0_21.contextData.mode

	setActive(arg0_21.setView, var0_21 == var0_0.SetView)
	setActive(arg0_21.inputView, var0_21 == var0_0.InputView)

	arg0_21.mode = var0_21
	arg0_21.type = arg0_21.contextData.type
	arg0_21.digitGroup = var0_21 == var0_0.SetView and arg0_21.setDigitGroup or arg0_21.inputDigitGroup
	arg0_21.textTitle.text = var0_21 == var0_0.SetView and i18n("words_set_password") or i18n("words_information")
	arg0_21.textTitleEn.text = var0_21 == var0_0.SetView and "PASSWORD" or "INFORM"

	local var1_21 = arg0_21.informBg.sizeDelta

	var1_21.x = arg0_21.textTitle.preferredWidth + arg0_21.textTitleEn.preferredWidth + var1_0
	arg0_21.informBg.sizeDelta = var1_21
	arg0_21.inputs = ""

	arg0_21:SetInputPos(0)

	arg0_21.inputnone = true

	arg0_21:UpdateView()
	arg0_21:UpdateInputSlider()
end

function var0_0.UpdateInputSlider(arg0_22)
	arg0_22:ClearInputTimers()

	local var0_22 = arg0_22.inputMode

	arg0_22:SetInputXian(arg0_22.inputPos + 1)

	for iter0_22 = 1, #arg0_22.digitGroup do
		local var1_22 = arg0_22.digitGroup[iter0_22]
		local var2_22 = iter0_22 <= #arg0_22.inputs and string.char(string.byte(arg0_22.inputs, iter0_22)) or nil

		setText(var1_22:Find("text"), var0_22 and var2_22 or "")
		setActive(var1_22:Find("space"), not var0_22 and var2_22 == nil)
		setActive(var1_22:Find("filled"), not var0_22 and var2_22 ~= nil)
	end
end

function var0_0.ClearInputTimers(arg0_23)
	for iter0_23 = 1, 12 do
		if arg0_23.timers["input" .. iter0_23] then
			arg0_23.timers["input" .. iter0_23]:Stop()

			arg0_23.timers["input" .. iter0_23] = nil
		end
	end
end

function var0_0.ClearAllTimers(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.timers) do
		if iter1_24 then
			iter1_24:Stop()
		end
	end

	arg0_24.timers = {}
end

function var0_0.ClearInputs(arg0_25)
	arg0_25.inputs = ""

	arg0_25:SetInputPos(0)
	arg0_25:UpdateInputSlider()
end

function var0_0.UpdateView(arg0_26)
	if arg0_26.mode == var0_0.InputView then
		arg0_26:UpdateInputView()
	else
		arg0_26:UpdateSetView()
	end
end

local var2_0

local function var3_0(arg0_27)
	local var0_27 = pg.SecondaryPWDMgr.GetInstance()

	var2_0 = var2_0 or {
		[var0_27.UNLOCK_SHIP] = function(arg0_28)
			local var0_28 = arg0_28.contextData.info[1]
			local var1_28 = getProxy(BayProxy)
			local var2_28 = var1_28:getData()
			local var3_28 = var1_28:getShipById(var0_28)

			if var3_28 then
				return string.format(i18n("words_desc_unlock"), var3_28:getName())
			end
		end,
		[var0_27.UNLOCK_COMMANDER] = function(arg0_29)
			local var0_29 = arg0_29.contextData.info
			local var1_29 = getProxy(CommanderProxy):getCommanderById(var0_29)

			if var1_29 then
				return string.format(i18n("words_desc_unlock"), var1_29:getName())
			end
		end,
		[var0_27.RESOLVE_EQUIPMENT] = function(arg0_30)
			local var0_30 = arg0_30.contextData.info
			local var1_30 = getProxy(EquipmentProxy):getEquipmentById(var0_30)

			if var1_30 then
				local var2_30 = var1_30:getConfig("name")

				if var1_30:getConfig("id") % 20 > 0 then
					var2_30 = var2_30 .. "+" .. tostring(var1_30:getConfig("id") % 20)
				end

				return string.format(i18n("words_desc_resolve_equip"), var2_30)
			end
		end,
		[var0_27.CREATE_INHERIT] = function()
			return i18n("words_desc_create_inherit")
		end,
		[var0_27.CLOSE_PASSWORD] = function()
			return i18n("words_desc_close_password")
		end,
		[var0_27.CHANGE_SETTING] = function()
			return i18n("words_desc_change_settings")
		end
	}

	return var2_0[arg0_27]
end

function var0_0.UpdateInputView(arg0_34)
	local var0_34 = getProxy(SecondaryPWDProxy):getRawData()
	local var1_34 = arg0_34.inputView:Find("line1/tip")

	setText(var1_34, var0_34.notice)
	setActive(var1_34, not arg0_34.inputnone)

	local var2_34 = arg0_34.inputView:Find("line1/tip1")
	local var3_34 = var3_0(arg0_34.contextData.type)

	setText(var2_34, var3_34 and var3_34(arg0_34) or "")
end

function var0_0.UpdateConfirmButton(arg0_35)
	arg0_35.btnconfirm:GetComponent(typeof(Button)).interactable = #arg0_35.inputs == #arg0_35.digitGroup

	setActive(arg0_35.btnconfirm:Find("gray"), #arg0_35.inputs ~= #arg0_35.digitGroup)
end

function var0_0.UpdateSetView(arg0_36)
	setActive(arg0_36.tipseterror, not arg0_36.inputnone)
end

function var0_0.SetInputPos(arg0_37, arg1_37)
	arg0_37.inputPos = arg1_37
	arg1_37 = arg1_37 + 1

	arg0_37:SetInputXian(arg1_37)
	arg0_37:UpdateConfirmButton()
end

function var0_0.Hide(arg0_38)
	arg0_38:willExit()
	setActive(arg0_38._tf, false)
end

function var0_0.Resume(arg0_39)
	arg0_39:didEnter()
	setActive(arg0_39._tf, true)
end

function var0_0.SetInputXian(arg0_40, arg1_40)
	if arg0_40.inputMode and arg1_40 > 0 and arg1_40 <= #arg0_40.digitGroup then
		setParent(arg0_40.selectFrame, arg0_40.digitGroup[arg1_40])
	else
		setParent(arg0_40.selectFrame, arg0_40.resources)
	end
end

function var0_0.willExit(arg0_41)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_41._tf, pg.UIMgr.GetInstance().UIMain)
	arg0_41:ClearAllTimers()
end

return var0_0
