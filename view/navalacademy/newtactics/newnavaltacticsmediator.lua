local var0_0 = class("NewNavalTacticsMediator", import("...base.ContextMediator"))

var0_0.ON_SKILL = "NewNavalTacticsMediator:ON_SKILL"
var0_0.ON_SHOPPING = "NewNavalTacticsMediator:ON_SHOPPING"
var0_0.ON_SELECT_SHIP = "NewNavalTacticsMediator:ON_SELECT_SHIP"
var0_0.ON_START = "NewNavalTacticsMediator:ON_START"
var0_0.ON_CANCEL = "NewNavalTacticsMediator:ON_CANCEL"
var0_0.ON_FINISH_ONE_ANIM = "NewNavalTacticsMediator:ON_FINISH_ONE_ANIM"
var0_0.ON_CANCEL_ADD_STUDENT = "NewNavalTacticsMediator:ON_CANCEL_ADD_STUDENT"
var0_0.ON_QUICK_FINISH = "NavalTacticsMediator:ON_QUICK_FINISH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CANCEL_ADD_STUDENT, function(arg0_2)
		arg0_1:sendNotification(var0_0.ON_CANCEL_ADD_STUDENT)
	end)
	arg0_1:bind(var0_0.ON_SELECT_SHIP, function(arg0_3, arg1_3)
		arg0_1:SelectShip(arg1_3)
	end)
	arg0_1:bind(var0_0.ON_SKILL, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = NavalTacticsSkillInfoLayer,
			data = {
				skillOnShip = arg2_4,
				skillId = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1_5
		})
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.START_TO_LEARN_TACTICS, arg1_6)
	end)

	arg0_1.cancelList = {}

	arg0_1:bind(var0_0.ON_CANCEL, function(arg0_7, arg1_7, arg2_7)
		if arg0_1.viewComponent:IsInAddStudentProcess() then
			table.insert(arg0_1.cancelList, {
				arg1_7,
				arg2_7
			})
		else
			arg0_1.viewComponent.finishLessonUtil:Enter(arg1_7, arg2_7)
		end
	end)
	arg0_1:bind(var0_0.ON_QUICK_FINISH, function(arg0_8, arg1_8)
		if arg0_1.viewComponent:IsInAddStudentProcess() then
			table.insert(arg0_1.cancelList, {
				arg1_8,
				type
			})
		else
			arg0_1.viewComponent.finishLessonUtil:Enter(arg1_8, Student.CANCEL_TYPE_QUICKLY)
		end
	end)

	local var0_1 = getProxy(NavalAcademyProxy):RawGetStudentList()

	arg0_1.viewComponent:SetStudents(var0_1)
end

function var0_0.SelectShip(arg0_9, arg1_9)
	local var0_9 = {}
	local var1_9 = getProxy(NavalAcademyProxy)

	for iter0_9, iter1_9 in pairs(var1_9:RawGetStudentList()) do
		table.insert(var0_9, iter1_9.shipId)
	end

	local var2_9 = {
		selectedMax = 1,
		prevPage = "NewNavalTacticsMediator",
		ignoredIds = var0_9,
		hideTagFlags = ShipStatus.TAG_HIDE_TACTICES,
		onShip = function(arg0_10, arg1_10, arg2_10)
			if not arg0_10 then
				return false
			end

			local var0_10, var1_10 = ShipStatus.ShipStatusCheck("inTactics", arg0_10, arg1_10)

			if not var0_10 then
				return var0_10, var1_10
			end

			return true
		end,
		onSelected = function(arg0_11)
			local var0_11 = arg0_11[1]

			if not var0_11 then
				return
			end

			if getProxy(BayProxy):RawGetShipById(var0_11):isMetaShip() then
				arg0_9.contextData.metaShipID = var0_11

				arg0_9.viewComponent:Init()

				return
			end

			arg0_9.contextData.shipToLesson = {
				shipId = var0_11,
				index = arg1_9
			}

			arg0_9.viewComponent:Init()
		end
	}

	arg0_9:addSubLayers(Context.New({
		viewComponent = NavTacticsDockyardScene,
		mediator = DockyardMediator,
		data = var2_9
	}))
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		NavalAcademyProxy.SKILL_CLASS_POS_UPDATED,
		GAME.START_TO_LEARN_TACTICS_DONE,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		var0_0.ON_FINISH_ONE_ANIM,
		GAME.CANCEL_LEARN_TACTICS,
		var0_0.ON_CANCEL_ADD_STUDENT,
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE,
		GAME.QUICK_FINISH_LEARN_TACTICS_DONE
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == NavalAcademyProxy.SKILL_CLASS_POS_UPDATED then
		arg0_13.viewComponent:OnUnlockSlot()
	elseif var0_13 == GAME.START_TO_LEARN_TACTICS_DONE then
		arg0_13.viewComponent:OnAddStudent()
		arg0_13.viewComponent:ResendCancelOp(arg0_13.cancelList)

		arg0_13.cancelList = {}
	elseif var0_13 == var0_0.ON_CANCEL_ADD_STUDENT then
		arg0_13.viewComponent:ResendCancelOp(arg0_13.cancelList)

		arg0_13.cancelList = {}
	elseif var0_13 == GAME.CANCEL_LEARN_TACTICS_DONE then
		local var2_13 = var1_13.id
		local var3_13 = var1_13.totalExp
		local var4_13 = ShipSkill.New(var1_13.oldSkill)
		local var5_13 = ShipSkill.New(var1_13.newSkill)
		local var6_13 = var1_13.shipId

		arg0_13.viewComponent.finishLessonUtil:WaitForFinish(var2_13, var6_13, var3_13, var4_13, var5_13)
	elseif var0_13 == GAME.CANCEL_LEARN_TACTICS then
		arg0_13.viewComponent:BlockEvents()
	elseif var0_13 == var0_0.ON_FINISH_ONE_ANIM then
		arg0_13.viewComponent:UnblockEvents()
		arg0_13.viewComponent:OnExitStudent()
	elseif var0_13 == GAME.TACTICS_META_UNLOCK_SKILL_DONE then
		arg0_13.viewComponent:OnUpdateMetaSkillPanel(var1_13.metaShipID)
	elseif var0_13 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		arg0_13.viewComponent:OnUpdateMetaSkillPanel(var1_13.metaShipID)
	elseif var0_13 == GAME.QUICK_FINISH_LEARN_TACTICS_DONE then
		arg0_13.viewComponent:BlockEvents()
		arg0_13.viewComponent:OnUpdateQuickFinishPanel()
	end
end

return var0_0
