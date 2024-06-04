local var0 = class("ClassLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ClassUI"
end

function var0.SetStudents(arg0, arg1)
	arg0.shipGroups = arg1
end

function var0.SetCourse(arg0, arg1)
	arg0.course = arg1
end

function var0.SetClass(arg0, arg1)
	arg0.resClass = arg1
end

function var0.OnUpdateResField(arg0, arg1)
	if not isa(arg1, ClassResourceField) then
		return
	end

	arg0:SetClass(arg1)
	arg0:InitClassInfo()

	if arg0.resFieldPage:GetLoaded() and arg0.resFieldPage:isShowing() then
		arg0.resFieldPage:Update(arg1)
	end
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")
	arg0.lessonTxt = arg0:findTF("blur_panel/adapt/bottom/lesson/mask/Text"):GetComponent("ScrollText")
	arg0.tranSpeedTxt = arg0:findTF("blur_panel/adapt/bottom/progress/proficiency/value"):GetComponent(typeof(Text))
	arg0.proficiencyProgressTxt = arg0:findTF("blur_panel/adapt/bottom/progress/proficiency/Text"):GetComponent(typeof(Text))
	arg0.proficiencyProgress = arg0:findTF("blur_panel/adapt/bottom/progress/proficiency/slider/Image")
	arg0.tranProgressTxt = arg0:findTF("blur_panel/adapt/bottom/progress/book/Text/value"):GetComponent(typeof(Text))
	arg0.tranProgress = arg0:findTF("blur_panel/adapt/bottom/progress/book/slider/Image")
	arg0.exp2ProficiencyRatioTxt = arg0:findTF("blur_panel/adapt/top/proficiency/Text"):GetComponent(typeof(Text))
	arg0.exp2ProficiencyRatio = arg0:findTF("blur_panel/adapt/top/proficiency")
	arg0.chatProficiency = arg0:findTF("blur_panel/adapt/top/proficiency/chat")
	arg0.chatProficiencyTxt = arg0.chatProficiency:Find("Text"):GetComponent(typeof(Text))
	arg0.helpBtn = arg0:findTF("blur_panel/adapt/top/btn_help")
	arg0.upgradeBtn = arg0:findTF("blur_panel/adapt/bottom/upgarde")
	arg0.teacherSeat = arg0:findTF("scene/desk0")
	arg0.studentSeats = {
		arg0:findTF("scene/desk1"),
		arg0:findTF("scene/desk2"),
		arg0:findTF("scene/desk3"),
		arg0:findTF("scene/desk4"),
		arg0:findTF("scene/desk5")
	}

	setText(arg0:findTF("blur_panel/adapt/bottom/progress/book/Text/label"), i18n("class_label_gen"))
	setText(arg0:findTF("blur_panel/adapt/bottom/progress/proficiency/label"), i18n("class_label_tran"))
	setText(arg0:findTF("blur_panel/adapt/bottom/upgarde/Text"), i18n("word_levelup"))

	arg0.chars = {}
	arg0.resFieldPage = ClassResourcePage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("course_class_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.upgradeBtn, function()
		arg0.resFieldPage:ExecuteAction("Flush", arg0.resClass)
	end, SFX_PANEL)
	onButton(arg0, arg0.exp2ProficiencyRatio, function()
		arg0.chatProficiencyTxt.text = i18n("course_proficiency_tip", pg.gameset.level_get_proficency.key_value, arg0.resClass:GetExp2ProficiencyRatio() * arg0.course:getExtraRate())

		arg0:DisplayChatContent()
	end, SFX_PANEL)

	arg0.students = arg0:FilterStudents()

	arg0:InitClassInfo()
	arg0:LoadClassRoom()
end

function var0.DisplayChatContent(arg0)
	setActive(arg0.chatProficiency, true)
	setButtonEnabled(arg0.exp2ProficiencyRatio, false)
	LeanTween.scale(rtf(arg0.chatProficiency), Vector3(1.5, 1.5, 1), 0.3):setFrom(Vector3.zero):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0.chatProficiency), Vector3(0, 0, 0), 0.2):setDelay(2):setOnComplete(System.Action(function()
			if not IsNil(arg0.exp2ProficiencyRatio) then
				setButtonEnabled(arg0.exp2ProficiencyRatio, true)
				setActive(arg0.chatProficiency, false)
			end
		end))
	end))
end

function var0.FilterStudents(arg0)
	local var0 = {}
	local var1 = arg0.course:getConfig("type")

	for iter0, iter1 in pairs(arg0.shipGroups) do
		if table.contains(var1, iter1.shipConfig.type) then
			table.insert(var0, iter1)
		end
	end

	if #var0 > #arg0.studentSeats then
		shuffle(var0)
	end

	return var0
end

function var0.InitClassInfo(arg0)
	local var0 = arg0.resClass
	local var1 = arg0.course

	arg0.lessonTxt:SetText(i18n("course_class_name", var1:getConfig("name_show")))

	arg0.tranSpeedTxt.text = "-" .. var0:GetTranValuePreHour() .. "/h"

	local var2 = var1:GetProficiency()
	local var3 = var0:GetMaxProficiency()

	arg0.proficiencyProgressTxt.text = var2 .. "/" .. var3

	setFillAmount(arg0.proficiencyProgress, var2 / var3)

	local var4 = var0:GetPlayerRes()
	local var5 = var0:GetTarget()
	local var6 = var4 % var5

	arg0.tranProgressTxt.text = " <color=#92FC63FF>" .. var6 .. "</color>/" .. var5

	setFillAmount(arg0.tranProgress, var6 / var5)

	local var7 = var0:GetExp2ProficiencyRatio() * var1:getExtraRate()

	arg0.exp2ProficiencyRatioTxt.text = var7 .. "%"
end

function var0.LoadClassRoom(arg0)
	local var0 = {}

	for iter0 = 1, math.min(#arg0.students, #arg0.studentSeats) do
		table.insert(var0, function(arg0)
			local var0 = arg0.students[iter0]:GetSkin().prefab

			arg0:LoadChar(var0, function(arg0)
				arg0:AddStudent(arg0, arg0.studentSeats[iter0])
				arg0()
			end)
		end)
	end

	table.insert(var0, function(arg0)
		local var0 = Ship.New({
			configId = arg0.course:getConfig("id")
		})

		arg0:LoadChar(var0:getPrefab(), function(arg0)
			arg0:AddTeacher(arg0, arg0.teacherSeat)
			arg0()
		end)
	end)
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync(var0, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.AddStudent(arg0, arg1, arg2)
	local var0 = arg1.transform

	var0.localScale = Vector3(-0.9, 0.9, 1)
	var0.localPosition = Vector3(37, 62, 0)

	setParent(var0, arg2)
	setActive(arg2:Find("icon"), true)
	arg1:GetComponent("SpineAnimUI"):SetAction("sit", 0)
	var0:SetSiblingIndex(0)
end

function var0.AddTeacher(arg0, arg1, arg2)
	local var0 = arg1.transform

	var0.localScale = Vector3(0.9, 0.9, 1)
	var0.localPosition = Vector3(0, 0, 0)

	setParent(var0, arg2)
	arg1:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
end

function var0.willExit(arg0)
	arg0:ClearChars()
	arg0.resFieldPage:Destroy()

	arg0.resFieldPage = nil
end

function var0.LoadChar(arg0, arg1, arg2)
	PoolMgr.GetInstance():GetSpineChar(arg1, true, function(arg0)
		if arg0.exited then
			PoolMgr.GetInstance():ReturnSpineChar(arg1, arg0)

			return
		end

		pg.ViewUtils.SetLayer(arg0.transform, Layer.UI)

		arg0.chars[arg1] = arg0

		arg2(arg0)
	end)
end

function var0.ClearChars(arg0)
	for iter0, iter1 in pairs(arg0.chars) do
		PoolMgr.GetInstance():ReturnSpineChar(iter0, iter1)
	end

	arg0.chars = {}
end

function var0.onBackPressed(arg0)
	if arg0.resFieldPage and arg0.resFieldPage:GetLoaded() and arg0.resFieldPage:isShowing() then
		arg0.resFieldPage:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

return var0
