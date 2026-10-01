local var0_0 = class("ClassLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ClassUI"
end

function var0_0.getResource(arg0_2)
	return {
		"ui/classui"
	}
end

function var0_0.SetStudents(arg0_3, arg1_3)
	arg0_3.shipGroups = arg1_3
end

function var0_0.SetCourse(arg0_4, arg1_4)
	arg0_4.course = arg1_4
end

function var0_0.SetClass(arg0_5, arg1_5)
	arg0_5.resClass = arg1_5
end

function var0_0.OnUpdateResField(arg0_6, arg1_6)
	if not isa(arg1_6, ClassResourceField) then
		return
	end

	arg0_6:SetClass(arg1_6)
	arg0_6:InitClassInfo()

	if arg0_6.resFieldPage:GetLoaded() and arg0_6.resFieldPage:isShowing() then
		arg0_6.resFieldPage:Update(arg1_6)
	end
end

function var0_0.init(arg0_7)
	arg0_7.backBtn = arg0_7._tf:Find("blur_panel/adapt/top/back")
	arg0_7.lessonTxt = arg0_7._tf:Find("blur_panel/adapt/bottom/lesson/mask/Text"):GetComponent("ScrollText")
	arg0_7.tranSpeedTxt = arg0_7._tf:Find("blur_panel/adapt/bottom/progress/proficiency/value"):GetComponent(typeof(Text))
	arg0_7.proficiencyProgressTxt = arg0_7._tf:Find("blur_panel/adapt/bottom/progress/proficiency/Text"):GetComponent(typeof(Text))
	arg0_7.proficiencyProgress = arg0_7._tf:Find("blur_panel/adapt/bottom/progress/proficiency/slider/Image")
	arg0_7.tranProgressTxt = arg0_7._tf:Find("blur_panel/adapt/bottom/progress/book/Text/value"):GetComponent(typeof(Text))
	arg0_7.tranProgress = arg0_7._tf:Find("blur_panel/adapt/bottom/progress/book/slider/Image")
	arg0_7.exp2ProficiencyRatioTxt = arg0_7._tf:Find("blur_panel/adapt/top/proficiency/Text"):GetComponent(typeof(Text))
	arg0_7.exp2ProficiencyRatio = arg0_7._tf:Find("blur_panel/adapt/top/proficiency")
	arg0_7.chatProficiency = arg0_7._tf:Find("blur_panel/adapt/top/proficiency/chat")
	arg0_7.chatProficiencyTxt = arg0_7.chatProficiency:Find("Text"):GetComponent(typeof(Text))
	arg0_7.helpBtn = arg0_7._tf:Find("blur_panel/adapt/top/btn_help")
	arg0_7.upgradeBtn = arg0_7._tf:Find("blur_panel/adapt/bottom/upgarde")
	arg0_7.teacherSeat = arg0_7._tf:Find("scene/desk0")
	arg0_7.studentSeats = {
		arg0_7._tf:Find("scene/desk1"),
		arg0_7._tf:Find("scene/desk2"),
		arg0_7._tf:Find("scene/desk3"),
		arg0_7._tf:Find("scene/desk4"),
		arg0_7._tf:Find("scene/desk5")
	}

	setText(arg0_7._tf:Find("blur_panel/adapt/bottom/progress/book/Text/label"), i18n("class_label_gen"))
	setText(arg0_7._tf:Find("blur_panel/adapt/bottom/progress/proficiency/label"), i18n("class_label_tran"))
	setText(arg0_7._tf:Find("blur_panel/adapt/bottom/upgarde/Text"), i18n("word_levelup"))

	arg0_7.chars = {}
	arg0_7.resFieldPage = ClassResourcePage.New(arg0_7._tf, arg0_7.event)
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("course_class_help")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.upgradeBtn, function()
		arg0_8.resFieldPage:ExecuteAction("Flush", arg0_8.resClass)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.exp2ProficiencyRatio, function()
		arg0_8.chatProficiencyTxt.text = i18n("course_proficiency_tip", pg.gameset.level_get_proficency.key_value, arg0_8.resClass:GetExp2ProficiencyRatio() * arg0_8.course:getExtraRate())

		arg0_8:DisplayChatContent()
	end, SFX_PANEL)

	arg0_8.students = arg0_8:FilterStudents()

	arg0_8:InitClassInfo()
	arg0_8:DownloadClassRoomResList(function()
		arg0_8:LoadClassRoom()
	end)
end

function var0_0.DisplayChatContent(arg0_14)
	setActive(arg0_14.chatProficiency, true)
	setButtonEnabled(arg0_14.exp2ProficiencyRatio, false)
	LeanTween.scale(rtf(arg0_14.chatProficiency), Vector3(1.5, 1.5, 1), 0.3):setFrom(Vector3.zero):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_14.chatProficiency), Vector3(0, 0, 0), 0.2):setDelay(2):setOnComplete(System.Action(function()
			if not IsNil(arg0_14.exp2ProficiencyRatio) then
				setButtonEnabled(arg0_14.exp2ProficiencyRatio, true)
				setActive(arg0_14.chatProficiency, false)
			end
		end))
	end))
end

function var0_0.FilterStudents(arg0_17)
	local var0_17 = {}
	local var1_17 = arg0_17.course:getConfig("type")

	for iter0_17, iter1_17 in pairs(arg0_17.shipGroups) do
		if table.contains(var1_17, iter1_17.shipConfig.type) then
			table.insert(var0_17, iter1_17)
		end
	end

	if #var0_17 > #arg0_17.studentSeats then
		shuffle(var0_17)
	end

	return var0_17
end

function var0_0.GetClassRoomResList(arg0_18)
	local var0_18 = {}
	local var1_18 = arg0_18.students or {}

	for iter0_18 = 1, math.min(#var1_18, #arg0_18.studentSeats) do
		local var2_18 = var1_18[iter0_18]:GetSkin()

		if var2_18 then
			arg0_18:InsertClassRoomCharRes(var0_18, var2_18.prefab)
		end
	end

	if arg0_18.course then
		local var3_18 = Ship.New({
			configId = arg0_18.course:getConfig("id")
		})

		arg0_18:InsertClassRoomCharRes(var0_18, var3_18:getPrefab())
	end

	return var0_18
end

function var0_0.InsertClassRoomCharRes(arg0_19, arg1_19, arg2_19)
	if not arg2_19 or arg2_19 == "" then
		return
	end

	local var0_19 = {
		"char/" .. arg2_19,
		"char/" .. arg2_19 .. "_hx"
	}

	for iter0_19, iter1_19 in ipairs(var0_19) do
		iter1_19 = string.lower(iter1_19)

		if not table.contains(arg1_19, iter1_19) then
			table.insert(arg1_19, iter1_19)
		end
	end
end

function var0_0.DownloadClassRoomResList(arg0_20, arg1_20)
	SplitPackConst.DownloadByLuaArr(arg0_20:GetClassRoomResList(), function()
		if arg0_20.exited then
			return
		end

		arg1_20()
	end)
end

function var0_0.InitClassInfo(arg0_22)
	local var0_22 = arg0_22.resClass
	local var1_22 = arg0_22.course

	arg0_22.lessonTxt:SetText(i18n("course_class_name", var1_22:getConfig("name_show")))

	arg0_22.tranSpeedTxt.text = "-" .. var0_22:GetTranValuePreHour() .. "/h"

	local var2_22 = var1_22:GetProficiency()
	local var3_22 = var0_22:GetMaxProficiency()

	arg0_22.proficiencyProgressTxt.text = var2_22 .. "/" .. var3_22

	setFillAmount(arg0_22.proficiencyProgress, var2_22 / var3_22)

	local var4_22 = var0_22:GetPlayerRes()
	local var5_22 = var0_22:GetTarget()
	local var6_22 = var4_22 % var5_22

	arg0_22.tranProgressTxt.text = " <color=#92FC63FF>" .. var6_22 .. "</color>/" .. var5_22

	setFillAmount(arg0_22.tranProgress, var6_22 / var5_22)

	local var7_22 = var0_22:GetExp2ProficiencyRatio() * var1_22:getExtraRate()

	arg0_22.exp2ProficiencyRatioTxt.text = var7_22 .. "%"
end

function var0_0.LoadClassRoom(arg0_23)
	local var0_23 = {}

	for iter0_23 = 1, math.min(#arg0_23.students, #arg0_23.studentSeats) do
		table.insert(var0_23, function(arg0_24)
			local var0_24 = arg0_23.students[iter0_23]:GetSkin().prefab

			arg0_23:LoadChar(var0_24, function(arg0_25)
				arg0_23:AddStudent(arg0_25, arg0_23.studentSeats[iter0_23])
				arg0_24()
			end)
		end)
	end

	table.insert(var0_23, function(arg0_26)
		local var0_26 = Ship.New({
			configId = arg0_23.course:getConfig("id")
		})

		arg0_23:LoadChar(var0_26:getPrefab(), function(arg0_27)
			arg0_23:AddTeacher(arg0_27, arg0_23.teacherSeat)
			arg0_26()
		end)
	end)
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync(var0_23, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.AddStudent(arg0_29, arg1_29, arg2_29)
	arg1_29:SetLocalScale(Vector3(-0.9, 0.9, 1))
	arg1_29:SetLocalPosition(Vector3(37, 62, 0))
	arg1_29:SetParent(arg2_29)
	setActive(arg2_29:Find("icon"), true)
	arg1_29:SetAction("sit", 0)
	arg1_29:SetSiblingIndex(0)
end

function var0_0.AddTeacher(arg0_30, arg1_30, arg2_30)
	arg1_30:SetLocalScale(Vector3(0.9, 0.9, 1))
	arg1_30:SetLocalPosition(Vector3(0, 0, 0))
	arg1_30:SetParent(arg2_30)
	arg1_30:SetAction("stand2", 0)
end

function var0_0.willExit(arg0_31)
	arg0_31:ClearChars()
	arg0_31.resFieldPage:Destroy()

	arg0_31.resFieldPage = nil
end

function var0_0.LoadChar(arg0_32, arg1_32, arg2_32)
	local var0_32 = SpineAnimChar.New()

	var0_32:SetPaint(arg1_32)
	var0_32:Load(true, function(arg0_33)
		if arg0_32.exited then
			arg0_33:Dispose()

			return
		end

		arg0_33:SetLayer(Layer.UI)

		arg0_32.chars[arg1_32] = arg0_33

		arg2_32(arg0_33)
	end)
end

function var0_0.ClearChars(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.chars) do
		iter1_34:Dispose()
	end

	arg0_34.chars = {}
end

function var0_0.onBackPressed(arg0_35)
	if arg0_35.resFieldPage and arg0_35.resFieldPage:GetLoaded() and arg0_35.resFieldPage:isShowing() then
		arg0_35.resFieldPage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_35)
end

return var0_0
