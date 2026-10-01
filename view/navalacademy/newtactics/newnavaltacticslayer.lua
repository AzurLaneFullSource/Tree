local var0_0 = class("NewNavalTacticsLayer", import("...base.BaseUI"))

var0_0.ON_UNLOCK = "NewNavalTacticsLayer:ON_UNLOCK"
var0_0.ON_ADD_STUDENT = "NewNavalTacticsLayer:ON_ADD_STUDENT"
var0_0.ON_SKILL_SELECTED = "NewNavalTacticsLayer:ON_SKILL_SELECTED"
var0_0.ON_RESEL_SKILL = "NewNavalTacticsLayer:ON_RESEL_SKILL"
var0_0.ON_LESSON_SELECTED = "NewNavalTacticsLayer:ON_LESSON_SELECTED"
var0_0.ON_CANCEL_ADD_STUDENT = "NewNavalTacticsLayer:ON_CANCEL_ADD_STUDENT"

function var0_0.getUIName(arg0_1)
	return "NewNavalTacticsUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/newnavaltacticsui"
	}

	local function var1_2(arg0_3, arg1_3)
		if noEmptyStr(arg1_3) and not table.contains(arg0_3, arg1_3) then
			table.insert(arg0_3, arg1_3)
		end
	end

	local var2_2 = (function()
		local var0_4 = {}

		local function var1_4(arg0_5)
			for iter0_5, iter1_5 in ipairs(arg0_5:getSkillList() or {}) do
				local var0_5 = ShipSkill.New(arg0_5.skills[iter1_5], arg0_5.id)

				var1_2(var0_4, "skillicon/" .. var0_5:GetIcon())
			end
		end

		local function var2_4(arg0_6)
			local var0_6 = Item.getConfigData(arg0_6.id)

			var1_2(var0_4, var0_6.icon)
		end

		local var3_4 = getProxy(NavalAcademyProxy)
		local var4_4 = getProxy(BayProxy)

		for iter0_4, iter1_4 in pairs(var3_4:RawGetStudentList() or {}) do
			local var5_4 = var4_4:RawGetShipById(iter1_4.shipId)

			if var5_4 then
				var1_4(var5_4)
				table.insertto(var0_4, ResPathSupport.GetPaintingShipYardIconListByPaintingName(var5_4:getPainting()))
				table.insert(var0_4, string.format(ResPathSupport.ConstPath.BG.ShipCard, var5_4:rarity2bgPrint()))
			end
		end

		for iter2_4, iter3_4 in pairs(var4_4:getRawData() or {}) do
			var1_4(iter3_4)
		end

		for iter4_4, iter5_4 in ipairs(getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE) or {}) do
			var2_4(iter5_4)
		end

		var1_2(var0_4, "template/shipcardtpl")
		var1_2(var0_4, "clutter/class_painting")

		return var0_4
	end)()

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var2_2)
end

function var0_0.OnUnlockSlot(arg0_7)
	if arg0_7.studentsPage:GetLoaded() then
		arg0_7.studentsPage:OnUnlockSlot()
	end
end

function var0_0.OnAddStudent(arg0_8)
	if arg0_8.studentsPage:GetLoaded() then
		arg0_8.studentsPage:OnAddStudent()
	end

	if arg0_8.selLessonPage:GetLoaded() and arg0_8.selLessonPage:isShowing() then
		arg0_8.selLessonPage:Hide()
	end
end

function var0_0.ResendCancelOp(arg0_9, arg1_9)
	arg0_9.inAddStudentProcess = false

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		arg0_9:emit(NewNavalTacticsMediator.ON_CANCEL, iter1_9[1], iter1_9[2])
	end
end

function var0_0.OnExitStudent(arg0_10)
	if arg0_10.studentsPage:GetLoaded() then
		arg0_10.studentsPage:OnExitStudent()
	end
end

function var0_0.BlockEvents(arg0_11)
	GetOrAddComponent(arg0_11._tf, typeof(CanvasGroup)).blocksRaycasts = false
end

function var0_0.UnblockEvents(arg0_12)
	GetOrAddComponent(arg0_12._tf, typeof(CanvasGroup)).blocksRaycasts = true
end

function var0_0.IsInAddStudentProcess(arg0_13)
	return arg0_13.inAddStudentProcess
end

function var0_0.OnUpdateMetaSkillPanel(arg0_14, arg1_14)
	if arg0_14.metaSkillPage then
		arg0_14.metaSkillPage:reUpdate()
	end
end

function var0_0.SetStudents(arg0_15, arg1_15)
	arg0_15.students = arg1_15
end

function var0_0.init(arg0_16)
	arg0_16.painting = arg0_16._tf:Find("painting"):GetComponent(typeof(Image))
	arg0_16.backBtn = arg0_16._tf:Find("adpter/frame/btnBack")
	arg0_16.option = arg0_16._tf:Find("adpter/frame/option")
	arg0_16.stampBtn = arg0_16._tf:Find("stamp")
	arg0_16.quickFinishPanel = arg0_16._tf:Find("painting/quick_finish")
	arg0_16.quickFinishText = arg0_16._tf:Find("painting/quick_finish/Text")

	local var0_16 = arg0_16._tf:Find("adpter")

	arg0_16.studentsPage = NewNavalTacticsStudentsPage.New(var0_16, arg0_16.event)
	arg0_16.unlockPage = NewNavalTacticsUnlockSlotPage.New(arg0_16._tf, arg0_16.event)
	arg0_16.selSkillPage = NewNavalTacticsSelSkillsPage.New(arg0_16._tf, arg0_16.event, arg0_16.contextData)
	arg0_16.selLessonPage = NewNavalTacticsSelLessonPage.New(arg0_16._tf, arg0_16.event)
	arg0_16.finishLessonUtil = NewNavalTacticsFinishLessonUtil.New(arg0_16.studentsPage, arg0_16.selLessonPage, arg0_16.selSkillPage)
end

function var0_0.didEnter(arg0_17)
	arg0_17:bind(var0_0.ON_UNLOCK, function(arg0_18, arg1_18)
		arg0_17.unlockPage:ExecuteAction("Show", arg1_18, function()
			arg0_17:emit(NewNavalTacticsMediator.ON_SHOPPING, arg1_18)
		end)
	end)
	arg0_17:bind(var0_0.ON_ADD_STUDENT, function(arg0_20, arg1_20)
		if not getProxy(BagProxy):ExitTypeItems(Item.LESSON_TYPE) then
			if not ItemTipPanel.ShowItemTipbyID(16001, i18n("item_lack_title", i18n("ship_book"), i18n("ship_book"))) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
			end

			return
		end

		arg0_17:emit(NewNavalTacticsMediator.ON_SELECT_SHIP, arg1_20)
	end)
	arg0_17:bind(var0_0.ON_SKILL_SELECTED, function(arg0_21, arg1_21)
		arg0_17.selLessonPage:ExecuteAction("Show", arg1_21)
		arg0_17.selSkillPage:Hide()
	end)
	arg0_17:bind(var0_0.ON_RESEL_SKILL, function(arg0_22, arg1_22)
		arg0_17.selLessonPage:Hide()
		arg0_17.selSkillPage:Show(arg1_22)
	end)
	arg0_17:bind(var0_0.ON_LESSON_SELECTED, function(arg0_23, arg1_23)
		arg0_17:AddStudentFinish(arg1_23)
	end)
	setActive(arg0_17.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_17.stampBtn, false)
	end

	onButton(arg0_17, arg0_17.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(3)
	end, SFX_CONFIRM)
	onButton(arg0_17, arg0_17.backBtn, function()
		arg0_17:closeView()
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17.option, function()
		arg0_17:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_17:SetPainting()
	arg0_17:Init()
	arg0_17:OnUpdateQuickFinishPanel()
	arg0_17.studentsPage:ExecuteAction("Show", arg0_17.students)
end

function var0_0.Init(arg0_27)
	if arg0_27.contextData.shipToLesson then
		arg0_27.inAddStudentProcess = true

		local var0_27 = arg0_27.contextData.shipToLesson.skillIndex
		local var1_27 = arg0_27.contextData.shipToLesson.shipId
		local var2_27 = arg0_27.contextData.shipToLesson.index

		arg0_27:AddStudent(var1_27, var2_27, var0_27)

		arg0_27.contextData.shipToLesson = nil
	elseif arg0_27.contextData.metaShipID then
		arg0_27.inAddStudentProcess = true

		local var3_27 = arg0_27.contextData.metaShipID

		arg0_27:ShowMetaShipSkill(var3_27)

		arg0_27.contextData.metaShipID = nil
	end
end

function var0_0.OnUpdateQuickFinishPanel(arg0_28)
	local var0_28 = getProxy(NavalAcademyProxy):getDailyFinishCnt()

	setActive(arg0_28.quickFinishPanel, var0_28 > 0)
	setText(arg0_28.quickFinishText, i18n("skill_learn_tip", var0_28))
end

function var0_0.SetPainting(arg0_29)
	ResourceMgr.Inst:getAssetAsync("Clutter/class_painting", "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_30)
		arg0_29.painting.sprite = arg0_30

		arg0_29.painting:SetNativeSize()
	end), true, true)
end

function var0_0.ShowMetaShipSkill(arg0_31, arg1_31)
	arg0_31.metaSkillPage = NavalTacticsMetaSkillsView.New(arg0_31._tf, arg0_31.event)

	arg0_31.metaSkillPage:Reset()
	arg0_31.metaSkillPage:Load()
	arg0_31.metaSkillPage:setData(arg1_31, function()
		arg0_31.inAddStudentProcess = false

		arg0_31.metaSkillPage:Destroy()

		arg0_31.metaSkillPage = nil
	end)
end

function var0_0.AddStudent(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = Student.New({
		id = arg2_33,
		ship_id = arg1_33
	})

	arg0_33.selSkillPage:ExecuteAction("Show", var0_33, arg3_33)
end

function var0_0.AddStudentFinish(arg0_34, arg1_34)
	local var0_34 = getProxy(BayProxy):RawGetShipById(arg1_34.shipId)

	if var0_34:isActivityNpc() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("npc_learn_skill_tip"),
			onYes = function()
				arg0_34:StartLesson(arg1_34, var0_34)
			end
		})
	else
		arg0_34:StartLesson(arg1_34, var0_34)
	end
end

function var0_0.StartLesson(arg0_36, arg1_36, arg2_36)
	local var0_36 = Item.getConfigData(arg1_36.lessonId).name
	local var1_36 = arg1_36:getSkillId(arg2_36)
	local var2_36 = arg2_36:getName()
	local var3_36 = ShipSkill.New(arg2_36.skills[var1_36], arg2_36.id)
	local var4_36 = var3_36:GetName()

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("tactics_lesson_start_tip", var0_36, var2_36, var4_36),
		onYes = function()
			if var3_36:IsMaxLevel() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

				return
			end

			arg0_36:emit(NewNavalTacticsMediator.ON_START, {
				shipId = arg1_36.shipId,
				skillPos = arg1_36:getSkillId(arg2_36),
				lessonId = arg1_36.lessonId,
				roomId = arg1_36.id
			})
		end
	})
end

function var0_0.onBackPressed(arg0_38)
	if arg0_38.finishLessonUtil:IsWorking() then
		return
	end

	var0_0.super.onBackPressed(arg0_38)
end

function var0_0.willExit(arg0_39)
	if arg0_39.studentsPage then
		arg0_39.studentsPage:Destroy()

		arg0_39.studentsPage = nil
	end

	if arg0_39.unlockPage then
		arg0_39.unlockPage:Destroy()

		arg0_39.unlockPage = nil
	end

	if arg0_39.selSkillPage then
		arg0_39.selSkillPage:Destroy()

		arg0_39.selSkillPage = nil
	end

	if arg0_39.selLessonPage then
		arg0_39.selLessonPage:Destroy()

		arg0_39.selLessonPage = nil
	end

	if arg0_39.finishLessonUtil then
		arg0_39.finishLessonUtil:Dispose()

		arg0_39.finishLessonUtil = nil
	end

	if arg0_39.metaSkillPage then
		arg0_39.metaSkillPage:Destroy()

		arg0_39.metaSkillPage = nil
	end
end

return var0_0
