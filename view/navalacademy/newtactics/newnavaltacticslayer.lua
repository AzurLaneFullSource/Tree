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

function var0_0.OnUnlockSlot(arg0_2)
	if arg0_2.studentsPage:GetLoaded() then
		arg0_2.studentsPage:OnUnlockSlot()
	end
end

function var0_0.OnAddStudent(arg0_3)
	if arg0_3.studentsPage:GetLoaded() then
		arg0_3.studentsPage:OnAddStudent()
	end

	if arg0_3.selLessonPage:GetLoaded() and arg0_3.selLessonPage:isShowing() then
		arg0_3.selLessonPage:Hide()
	end
end

function var0_0.ResendCancelOp(arg0_4, arg1_4)
	arg0_4.inAddStudentProcess = false

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		arg0_4:emit(NewNavalTacticsMediator.ON_CANCEL, iter1_4[1], iter1_4[2])
	end
end

function var0_0.OnExitStudent(arg0_5)
	if arg0_5.studentsPage:GetLoaded() then
		arg0_5.studentsPage:OnExitStudent()
	end
end

function var0_0.BlockEvents(arg0_6)
	GetOrAddComponent(arg0_6._tf, typeof(CanvasGroup)).blocksRaycasts = false
end

function var0_0.UnblockEvents(arg0_7)
	GetOrAddComponent(arg0_7._tf, typeof(CanvasGroup)).blocksRaycasts = true
end

function var0_0.IsInAddStudentProcess(arg0_8)
	return arg0_8.inAddStudentProcess
end

function var0_0.OnUpdateMetaSkillPanel(arg0_9, arg1_9)
	if arg0_9.metaSkillPage then
		arg0_9.metaSkillPage:reUpdate()
	end
end

function var0_0.SetStudents(arg0_10, arg1_10)
	arg0_10.students = arg1_10
end

function var0_0.init(arg0_11)
	arg0_11.painting = arg0_11:findTF("painting"):GetComponent(typeof(Image))
	arg0_11.backBtn = arg0_11:findTF("adpter/frame/btnBack")
	arg0_11.option = arg0_11:findTF("adpter/frame/option")
	arg0_11.stampBtn = arg0_11:findTF("stamp")
	arg0_11.quickFinishPanel = arg0_11:findTF("painting/quick_finish", arg0_11.mainPanel)
	arg0_11.quickFinishText = arg0_11:findTF("painting/quick_finish/Text", arg0_11.mainPanel)

	local var0_11 = arg0_11:findTF("adpter")

	arg0_11.studentsPage = NewNavalTacticsStudentsPage.New(var0_11, arg0_11.event)
	arg0_11.unlockPage = NewNavalTacticsUnlockSlotPage.New(arg0_11._tf, arg0_11.event)
	arg0_11.selSkillPage = NewNavalTacticsSelSkillsPage.New(arg0_11._tf, arg0_11.event, arg0_11.contextData)
	arg0_11.selLessonPage = NewNavalTacticsSelLessonPage.New(arg0_11._tf, arg0_11.event)
	arg0_11.finishLessonUtil = NewNavalTacticsFinishLessonUtil.New(arg0_11.studentsPage, arg0_11.selLessonPage, arg0_11.selSkillPage)
end

function var0_0.didEnter(arg0_12)
	arg0_12:bind(var0_0.ON_UNLOCK, function(arg0_13, arg1_13)
		arg0_12.unlockPage:ExecuteAction("Show", arg1_13, function()
			arg0_12:emit(NewNavalTacticsMediator.ON_SHOPPING, arg1_13)
		end)
	end)
	arg0_12:bind(var0_0.ON_ADD_STUDENT, function(arg0_15, arg1_15)
		if not getProxy(BagProxy):ExitTypeItems(Item.LESSON_TYPE) then
			if not ItemTipPanel.ShowItemTipbyID(16001, i18n("item_lack_title", i18n("ship_book"), i18n("ship_book"))) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
			end

			return
		end

		arg0_12:emit(NewNavalTacticsMediator.ON_SELECT_SHIP, arg1_15)
	end)
	arg0_12:bind(var0_0.ON_SKILL_SELECTED, function(arg0_16, arg1_16)
		arg0_12.selLessonPage:ExecuteAction("Show", arg1_16)
		arg0_12.selSkillPage:Hide()
	end)
	arg0_12:bind(var0_0.ON_RESEL_SKILL, function(arg0_17, arg1_17)
		arg0_12.selLessonPage:Hide()
		arg0_12.selSkillPage:Show(arg1_17)
	end)
	arg0_12:bind(var0_0.ON_LESSON_SELECTED, function(arg0_18, arg1_18)
		arg0_12:AddStudentFinish(arg1_18)
	end)
	setActive(arg0_12.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_12.stampBtn, false)
	end

	onButton(arg0_12, arg0_12.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(3)
	end, SFX_CONFIRM)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:closeView()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.option, function()
		arg0_12:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_12:SetPainting()
	arg0_12:Init()
	arg0_12:OnUpdateQuickFinishPanel()
	arg0_12.studentsPage:ExecuteAction("Show", arg0_12.students)
end

function var0_0.Init(arg0_22)
	if arg0_22.contextData.shipToLesson then
		arg0_22.inAddStudentProcess = true

		local var0_22 = arg0_22.contextData.shipToLesson.skillIndex
		local var1_22 = arg0_22.contextData.shipToLesson.shipId
		local var2_22 = arg0_22.contextData.shipToLesson.index

		arg0_22:AddStudent(var1_22, var2_22, var0_22)

		arg0_22.contextData.shipToLesson = nil
	elseif arg0_22.contextData.metaShipID then
		arg0_22.inAddStudentProcess = true

		local var3_22 = arg0_22.contextData.metaShipID

		arg0_22:ShowMetaShipSkill(var3_22)

		arg0_22.contextData.metaShipID = nil
	end
end

function var0_0.OnUpdateQuickFinishPanel(arg0_23)
	local var0_23 = getProxy(NavalAcademyProxy):getDailyFinishCnt()

	setActive(arg0_23.quickFinishPanel, var0_23 > 0)
	setText(arg0_23.quickFinishText, i18n("skill_learn_tip", var0_23))
end

function var0_0.SetPainting(arg0_24)
	ResourceMgr.Inst:getAssetAsync("Clutter/class_painting", "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_25)
		arg0_24.painting.sprite = arg0_25

		arg0_24.painting:SetNativeSize()
	end), true, true)
end

function var0_0.ShowMetaShipSkill(arg0_26, arg1_26)
	arg0_26.metaSkillPage = NavalTacticsMetaSkillsView.New(arg0_26._tf, arg0_26.event)

	arg0_26.metaSkillPage:Reset()
	arg0_26.metaSkillPage:Load()
	arg0_26.metaSkillPage:setData(arg1_26, function()
		arg0_26.inAddStudentProcess = false

		arg0_26.metaSkillPage:Destroy()

		arg0_26.metaSkillPage = nil
	end)
end

function var0_0.AddStudent(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = Student.New({
		id = arg2_28,
		ship_id = arg1_28
	})

	arg0_28.selSkillPage:ExecuteAction("Show", var0_28, arg3_28)
end

function var0_0.AddStudentFinish(arg0_29, arg1_29)
	local var0_29 = getProxy(BayProxy):RawGetShipById(arg1_29.shipId)

	if var0_29:isActivityNpc() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("npc_learn_skill_tip"),
			onYes = function()
				arg0_29:StartLesson(arg1_29, var0_29)
			end
		})
	else
		arg0_29:StartLesson(arg1_29, var0_29)
	end
end

function var0_0.StartLesson(arg0_31, arg1_31, arg2_31)
	local var0_31 = Item.getConfigData(arg1_31.lessonId).name
	local var1_31 = arg1_31:getSkillId(arg2_31)
	local var2_31 = arg2_31:getName()
	local var3_31 = ShipSkill.New(arg2_31.skills[var1_31], arg2_31.id)
	local var4_31 = var3_31:GetName()

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("tactics_lesson_start_tip", var0_31, var2_31, var4_31),
		onYes = function()
			if var3_31:IsMaxLevel() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

				return
			end

			arg0_31:emit(NewNavalTacticsMediator.ON_START, {
				shipId = arg1_31.shipId,
				skillPos = arg1_31:getSkillId(arg2_31),
				lessonId = arg1_31.lessonId,
				roomId = arg1_31.id
			})
		end
	})
end

function var0_0.onBackPressed(arg0_33)
	if arg0_33.finishLessonUtil:IsWorking() then
		return
	end

	var0_0.super.onBackPressed(arg0_33)
end

function var0_0.willExit(arg0_34)
	if arg0_34.studentsPage then
		arg0_34.studentsPage:Destroy()

		arg0_34.studentsPage = nil
	end

	if arg0_34.unlockPage then
		arg0_34.unlockPage:Destroy()

		arg0_34.unlockPage = nil
	end

	if arg0_34.selSkillPage then
		arg0_34.selSkillPage:Destroy()

		arg0_34.selSkillPage = nil
	end

	if arg0_34.selLessonPage then
		arg0_34.selLessonPage:Destroy()

		arg0_34.selLessonPage = nil
	end

	if arg0_34.finishLessonUtil then
		arg0_34.finishLessonUtil:Dispose()

		arg0_34.finishLessonUtil = nil
	end

	if arg0_34.metaSkillPage then
		arg0_34.metaSkillPage:Destroy()

		arg0_34.metaSkillPage = nil
	end
end

return var0_0
