local var0 = class("NewNavalTacticsLayer", import("...base.BaseUI"))

var0.ON_UNLOCK = "NewNavalTacticsLayer:ON_UNLOCK"
var0.ON_ADD_STUDENT = "NewNavalTacticsLayer:ON_ADD_STUDENT"
var0.ON_SKILL_SELECTED = "NewNavalTacticsLayer:ON_SKILL_SELECTED"
var0.ON_RESEL_SKILL = "NewNavalTacticsLayer:ON_RESEL_SKILL"
var0.ON_LESSON_SELECTED = "NewNavalTacticsLayer:ON_LESSON_SELECTED"
var0.ON_CANCEL_ADD_STUDENT = "NewNavalTacticsLayer:ON_CANCEL_ADD_STUDENT"

function var0.getUIName(arg0)
	return "NewNavalTacticsUI"
end

function var0.OnUnlockSlot(arg0)
	if arg0.studentsPage:GetLoaded() then
		arg0.studentsPage:OnUnlockSlot()
	end
end

function var0.OnAddStudent(arg0)
	if arg0.studentsPage:GetLoaded() then
		arg0.studentsPage:OnAddStudent()
	end

	if arg0.selLessonPage:GetLoaded() and arg0.selLessonPage:isShowing() then
		arg0.selLessonPage:Hide()
	end
end

function var0.ResendCancelOp(arg0, arg1)
	arg0.inAddStudentProcess = false

	for iter0, iter1 in ipairs(arg1) do
		arg0:emit(NewNavalTacticsMediator.ON_CANCEL, iter1[1], iter1[2])
	end
end

function var0.OnExitStudent(arg0)
	if arg0.studentsPage:GetLoaded() then
		arg0.studentsPage:OnExitStudent()
	end
end

function var0.BlockEvents(arg0)
	GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).blocksRaycasts = false
end

function var0.UnblockEvents(arg0)
	GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).blocksRaycasts = true
end

function var0.IsInAddStudentProcess(arg0)
	return arg0.inAddStudentProcess
end

function var0.OnUpdateMetaSkillPanel(arg0, arg1)
	if arg0.metaSkillPage then
		arg0.metaSkillPage:reUpdate()
	end
end

function var0.SetStudents(arg0, arg1)
	arg0.students = arg1
end

function var0.init(arg0)
	arg0.painting = arg0:findTF("painting"):GetComponent(typeof(Image))
	arg0.backBtn = arg0:findTF("adpter/frame/btnBack")
	arg0.option = arg0:findTF("adpter/frame/option")
	arg0.stampBtn = arg0:findTF("stamp")
	arg0.quickFinishPanel = arg0:findTF("painting/quick_finish", arg0.mainPanel)
	arg0.quickFinishText = arg0:findTF("painting/quick_finish/Text", arg0.mainPanel)

	local var0 = arg0:findTF("adpter")

	arg0.studentsPage = NewNavalTacticsStudentsPage.New(var0, arg0.event)
	arg0.unlockPage = NewNavalTacticsUnlockSlotPage.New(arg0._tf, arg0.event)
	arg0.selSkillPage = NewNavalTacticsSelSkillsPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.selLessonPage = NewNavalTacticsSelLessonPage.New(arg0._tf, arg0.event)
	arg0.finishLessonUtil = NewNavalTacticsFinishLessonUtil.New(arg0.studentsPage, arg0.selLessonPage, arg0.selSkillPage)
end

function var0.didEnter(arg0)
	arg0:bind(var0.ON_UNLOCK, function(arg0, arg1)
		arg0.unlockPage:ExecuteAction("Show", arg1, function()
			arg0:emit(NewNavalTacticsMediator.ON_SHOPPING, arg1)
		end)
	end)
	arg0:bind(var0.ON_ADD_STUDENT, function(arg0, arg1)
		if not getProxy(BagProxy):ExitTypeItems(Item.LESSON_TYPE) then
			if not ItemTipPanel.ShowItemTipbyID(16001, i18n("item_lack_title", i18n("ship_book"), i18n("ship_book"))) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
			end

			return
		end

		arg0:emit(NewNavalTacticsMediator.ON_SELECT_SHIP, arg1)
	end)
	arg0:bind(var0.ON_SKILL_SELECTED, function(arg0, arg1)
		arg0.selLessonPage:ExecuteAction("Show", arg1)
		arg0.selSkillPage:Hide()
	end)
	arg0:bind(var0.ON_RESEL_SKILL, function(arg0, arg1)
		arg0.selLessonPage:Hide()
		arg0.selSkillPage:Show(arg1)
	end)
	arg0:bind(var0.ON_LESSON_SELECTED, function(arg0, arg1)
		arg0:AddStudentFinish(arg1)
	end)
	setActive(arg0.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0.stampBtn, false)
	end

	onButton(arg0, arg0.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(3)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.option, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	arg0:SetPainting()
	arg0:Init()
	arg0:OnUpdateQuickFinishPanel()
	arg0.studentsPage:ExecuteAction("Show", arg0.students)
end

function var0.Init(arg0)
	if arg0.contextData.shipToLesson then
		arg0.inAddStudentProcess = true

		local var0 = arg0.contextData.shipToLesson.skillIndex
		local var1 = arg0.contextData.shipToLesson.shipId
		local var2 = arg0.contextData.shipToLesson.index

		arg0:AddStudent(var1, var2, var0)

		arg0.contextData.shipToLesson = nil
	elseif arg0.contextData.metaShipID then
		arg0.inAddStudentProcess = true

		local var3 = arg0.contextData.metaShipID

		arg0:ShowMetaShipSkill(var3)

		arg0.contextData.metaShipID = nil
	end
end

function var0.OnUpdateQuickFinishPanel(arg0)
	local var0 = getProxy(NavalAcademyProxy):getDailyFinishCnt()

	setActive(arg0.quickFinishPanel, var0 > 0)
	setText(arg0.quickFinishText, i18n("skill_learn_tip", var0))
end

function var0.SetPainting(arg0)
	ResourceMgr.Inst:getAssetAsync("Clutter/class_painting", "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg0.painting.sprite = arg0

		arg0.painting:SetNativeSize()
	end), true, true)
end

function var0.ShowMetaShipSkill(arg0, arg1)
	arg0.metaSkillPage = NavalTacticsMetaSkillsView.New(arg0._tf, arg0.event)

	arg0.metaSkillPage:Reset()
	arg0.metaSkillPage:Load()
	arg0.metaSkillPage:setData(arg1, function()
		arg0.inAddStudentProcess = false

		arg0.metaSkillPage:Destroy()

		arg0.metaSkillPage = nil
	end)
end

function var0.AddStudent(arg0, arg1, arg2, arg3)
	local var0 = Student.New({
		id = arg2,
		ship_id = arg1
	})

	arg0.selSkillPage:ExecuteAction("Show", var0, arg3)
end

function var0.AddStudentFinish(arg0, arg1)
	local var0 = getProxy(BayProxy):RawGetShipById(arg1.shipId)

	if var0:isActivityNpc() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("npc_learn_skill_tip"),
			onYes = function()
				arg0:StartLesson(arg1, var0)
			end
		})
	else
		arg0:StartLesson(arg1, var0)
	end
end

function var0.StartLesson(arg0, arg1, arg2)
	local var0 = Item.getConfigData(arg1.lessonId).name
	local var1 = arg1:getSkillId(arg2)
	local var2 = arg2:getName()
	local var3 = ShipSkill.New(arg2.skills[var1], arg2.id)
	local var4 = var3:GetName()

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("tactics_lesson_start_tip", var0, var2, var4),
		onYes = function()
			if var3:IsMaxLevel() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

				return
			end

			arg0:emit(NewNavalTacticsMediator.ON_START, {
				shipId = arg1.shipId,
				skillPos = arg1:getSkillId(arg2),
				lessonId = arg1.lessonId,
				roomId = arg1.id
			})
		end
	})
end

function var0.onBackPressed(arg0)
	if arg0.finishLessonUtil:IsWorking() then
		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.studentsPage then
		arg0.studentsPage:Destroy()

		arg0.studentsPage = nil
	end

	if arg0.unlockPage then
		arg0.unlockPage:Destroy()

		arg0.unlockPage = nil
	end

	if arg0.selSkillPage then
		arg0.selSkillPage:Destroy()

		arg0.selSkillPage = nil
	end

	if arg0.selLessonPage then
		arg0.selLessonPage:Destroy()

		arg0.selLessonPage = nil
	end

	if arg0.finishLessonUtil then
		arg0.finishLessonUtil:Dispose()

		arg0.finishLessonUtil = nil
	end

	if arg0.metaSkillPage then
		arg0.metaSkillPage:Destroy()

		arg0.metaSkillPage = nil
	end
end

return var0
