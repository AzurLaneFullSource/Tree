local var0_0 = class("ClassLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ClassUI"
end

function var0_0.SetStudents(arg0_2, arg1_2)
	arg0_2.shipGroups = arg1_2
end

function var0_0.SetCourse(arg0_3, arg1_3)
	arg0_3.course = arg1_3
end

function var0_0.SetClass(arg0_4, arg1_4)
	arg0_4.resClass = arg1_4
end

function var0_0.OnUpdateResField(arg0_5, arg1_5)
	if not isa(arg1_5, ClassResourceField) then
		return
	end

	arg0_5:SetClass(arg1_5)
	arg0_5:InitClassInfo()

	if arg0_5.resFieldPage:GetLoaded() and arg0_5.resFieldPage:isShowing() then
		arg0_5.resFieldPage:Update(arg1_5)
	end
end

function var0_0.init(arg0_6)
	arg0_6.backBtn = arg0_6:findTF("blur_panel/adapt/top/back")
	arg0_6.lessonTxt = arg0_6:findTF("blur_panel/adapt/bottom/lesson/mask/Text"):GetComponent("ScrollText")
	arg0_6.tranSpeedTxt = arg0_6:findTF("blur_panel/adapt/bottom/progress/proficiency/value"):GetComponent(typeof(Text))
	arg0_6.proficiencyProgressTxt = arg0_6:findTF("blur_panel/adapt/bottom/progress/proficiency/Text"):GetComponent(typeof(Text))
	arg0_6.proficiencyProgress = arg0_6:findTF("blur_panel/adapt/bottom/progress/proficiency/slider/Image")
	arg0_6.tranProgressTxt = arg0_6:findTF("blur_panel/adapt/bottom/progress/book/Text/value"):GetComponent(typeof(Text))
	arg0_6.tranProgress = arg0_6:findTF("blur_panel/adapt/bottom/progress/book/slider/Image")
	arg0_6.exp2ProficiencyRatioTxt = arg0_6:findTF("blur_panel/adapt/top/proficiency/Text"):GetComponent(typeof(Text))
	arg0_6.exp2ProficiencyRatio = arg0_6:findTF("blur_panel/adapt/top/proficiency")
	arg0_6.chatProficiency = arg0_6:findTF("blur_panel/adapt/top/proficiency/chat")
	arg0_6.chatProficiencyTxt = arg0_6.chatProficiency:Find("Text"):GetComponent(typeof(Text))
	arg0_6.helpBtn = arg0_6:findTF("blur_panel/adapt/top/btn_help")
	arg0_6.upgradeBtn = arg0_6:findTF("blur_panel/adapt/bottom/upgarde")
	arg0_6.teacherSeat = arg0_6:findTF("scene/desk0")
	arg0_6.studentSeats = {
		arg0_6:findTF("scene/desk1"),
		arg0_6:findTF("scene/desk2"),
		arg0_6:findTF("scene/desk3"),
		arg0_6:findTF("scene/desk4"),
		arg0_6:findTF("scene/desk5")
	}

	setText(arg0_6:findTF("blur_panel/adapt/bottom/progress/book/Text/label"), i18n("class_label_gen"))
	setText(arg0_6:findTF("blur_panel/adapt/bottom/progress/proficiency/label"), i18n("class_label_tran"))
	setText(arg0_6:findTF("blur_panel/adapt/bottom/upgarde/Text"), i18n("word_levelup"))

	arg0_6.chars = {}
	arg0_6.resFieldPage = ClassResourcePage.New(arg0_6._tf, arg0_6.event)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("course_class_help")
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.upgradeBtn, function()
		arg0_7.resFieldPage:ExecuteAction("Flush", arg0_7.resClass)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.exp2ProficiencyRatio, function()
		arg0_7.chatProficiencyTxt.text = i18n("course_proficiency_tip", pg.gameset.level_get_proficency.key_value, arg0_7.resClass:GetExp2ProficiencyRatio() * arg0_7.course:getExtraRate())

		arg0_7:DisplayChatContent()
	end, SFX_PANEL)

	arg0_7.students = arg0_7:FilterStudents()

	arg0_7:InitClassInfo()
	arg0_7:LoadClassRoom()
end

function var0_0.DisplayChatContent(arg0_12)
	setActive(arg0_12.chatProficiency, true)
	setButtonEnabled(arg0_12.exp2ProficiencyRatio, false)
	LeanTween.scale(rtf(arg0_12.chatProficiency), Vector3(1.5, 1.5, 1), 0.3):setFrom(Vector3.zero):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_12.chatProficiency), Vector3(0, 0, 0), 0.2):setDelay(2):setOnComplete(System.Action(function()
			if not IsNil(arg0_12.exp2ProficiencyRatio) then
				setButtonEnabled(arg0_12.exp2ProficiencyRatio, true)
				setActive(arg0_12.chatProficiency, false)
			end
		end))
	end))
end

function var0_0.FilterStudents(arg0_15)
	local var0_15 = {}
	local var1_15 = arg0_15.course:getConfig("type")

	for iter0_15, iter1_15 in pairs(arg0_15.shipGroups) do
		if table.contains(var1_15, iter1_15.shipConfig.type) then
			table.insert(var0_15, iter1_15)
		end
	end

	if #var0_15 > #arg0_15.studentSeats then
		shuffle(var0_15)
	end

	return var0_15
end

function var0_0.InitClassInfo(arg0_16)
	local var0_16 = arg0_16.resClass
	local var1_16 = arg0_16.course

	arg0_16.lessonTxt:SetText(i18n("course_class_name", var1_16:getConfig("name_show")))

	arg0_16.tranSpeedTxt.text = "-" .. var0_16:GetTranValuePreHour() .. "/h"

	local var2_16 = var1_16:GetProficiency()
	local var3_16 = var0_16:GetMaxProficiency()

	arg0_16.proficiencyProgressTxt.text = var2_16 .. "/" .. var3_16

	setFillAmount(arg0_16.proficiencyProgress, var2_16 / var3_16)

	local var4_16 = var0_16:GetPlayerRes()
	local var5_16 = var0_16:GetTarget()
	local var6_16 = var4_16 % var5_16

	arg0_16.tranProgressTxt.text = " <color=#92FC63FF>" .. var6_16 .. "</color>/" .. var5_16

	setFillAmount(arg0_16.tranProgress, var6_16 / var5_16)

	local var7_16 = var0_16:GetExp2ProficiencyRatio() * var1_16:getExtraRate()

	arg0_16.exp2ProficiencyRatioTxt.text = var7_16 .. "%"
end

function var0_0.LoadClassRoom(arg0_17)
	local var0_17 = {}

	for iter0_17 = 1, math.min(#arg0_17.students, #arg0_17.studentSeats) do
		table.insert(var0_17, function(arg0_18)
			local var0_18 = arg0_17.students[iter0_17]:GetSkin().prefab

			arg0_17:LoadChar(var0_18, function(arg0_19)
				arg0_17:AddStudent(arg0_19, arg0_17.studentSeats[iter0_17])
				arg0_18()
			end)
		end)
	end

	table.insert(var0_17, function(arg0_20)
		local var0_20 = Ship.New({
			configId = arg0_17.course:getConfig("id")
		})

		arg0_17:LoadChar(var0_20:getPrefab(), function(arg0_21)
			arg0_17:AddTeacher(arg0_21, arg0_17.teacherSeat)
			arg0_20()
		end)
	end)
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync(var0_17, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.AddStudent(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23.transform

	var0_23.localScale = Vector3(-0.9, 0.9, 1)
	var0_23.localPosition = Vector3(37, 62, 0)

	setParent(var0_23, arg2_23)
	setActive(arg2_23:Find("icon"), true)
	arg1_23:GetComponent("SpineAnimUI"):SetAction("sit", 0)
	var0_23:SetSiblingIndex(0)
end

function var0_0.AddTeacher(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24.transform

	var0_24.localScale = Vector3(0.9, 0.9, 1)
	var0_24.localPosition = Vector3(0, 0, 0)

	setParent(var0_24, arg2_24)
	arg1_24:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
end

function var0_0.willExit(arg0_25)
	arg0_25:ClearChars()
	arg0_25.resFieldPage:Destroy()

	arg0_25.resFieldPage = nil
end

function var0_0.LoadChar(arg0_26, arg1_26, arg2_26)
	PoolMgr.GetInstance():GetSpineChar(arg1_26, true, function(arg0_27)
		if arg0_26.exited then
			PoolMgr.GetInstance():ReturnSpineChar(arg1_26, arg0_27)

			return
		end

		pg.ViewUtils.SetLayer(arg0_27.transform, Layer.UI)

		arg0_26.chars[arg1_26] = arg0_27

		arg2_26(arg0_27)
	end)
end

function var0_0.ClearChars(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.chars) do
		PoolMgr.GetInstance():ReturnSpineChar(iter0_28, iter1_28)
	end

	arg0_28.chars = {}
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.resFieldPage and arg0_29.resFieldPage:GetLoaded() and arg0_29.resFieldPage:isShowing() then
		arg0_29.resFieldPage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_29)
end

return var0_0
