local var0 = class("NewNavalTacticsMediator", import("...base.ContextMediator"))

var0.ON_SKILL = "NewNavalTacticsMediator:ON_SKILL"
var0.ON_SHOPPING = "NewNavalTacticsMediator:ON_SHOPPING"
var0.ON_SELECT_SHIP = "NewNavalTacticsMediator:ON_SELECT_SHIP"
var0.ON_START = "NewNavalTacticsMediator:ON_START"
var0.ON_CANCEL = "NewNavalTacticsMediator:ON_CANCEL"
var0.ON_FINISH_ONE_ANIM = "NewNavalTacticsMediator:ON_FINISH_ONE_ANIM"
var0.ON_CANCEL_ADD_STUDENT = "NewNavalTacticsMediator:ON_CANCEL_ADD_STUDENT"
var0.ON_QUICK_FINISH = "NavalTacticsMediator:ON_QUICK_FINISH"

function var0.register(arg0)
	arg0:bind(var0.ON_CANCEL_ADD_STUDENT, function(arg0)
		arg0:sendNotification(var0.ON_CANCEL_ADD_STUDENT)
	end)
	arg0:bind(var0.ON_SELECT_SHIP, function(arg0, arg1)
		arg0:SelectShip(arg1)
	end)
	arg0:bind(var0.ON_SKILL, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = NavalTacticsSkillInfoLayer,
			data = {
				skillOnShip = arg2,
				skillId = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1)
		arg0:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1
		})
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		arg0:sendNotification(GAME.START_TO_LEARN_TACTICS, arg1)
	end)

	arg0.cancelList = {}

	arg0:bind(var0.ON_CANCEL, function(arg0, arg1, arg2)
		if arg0.viewComponent:IsInAddStudentProcess() then
			table.insert(arg0.cancelList, {
				arg1,
				arg2
			})
		else
			arg0.viewComponent.finishLessonUtil:Enter(arg1, arg2)
		end
	end)
	arg0:bind(var0.ON_QUICK_FINISH, function(arg0, arg1)
		if arg0.viewComponent:IsInAddStudentProcess() then
			table.insert(arg0.cancelList, {
				arg1,
				type
			})
		else
			arg0.viewComponent.finishLessonUtil:Enter(arg1, Student.CANCEL_TYPE_QUICKLY)
		end
	end)

	local var0 = getProxy(NavalAcademyProxy):RawGetStudentList()

	arg0.viewComponent:SetStudents(var0)
end

function var0.SelectShip(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(NavalAcademyProxy)

	for iter0, iter1 in pairs(var1:RawGetStudentList()) do
		table.insert(var0, iter1.shipId)
	end

	local var2 = {
		selectedMax = 1,
		prevPage = "NewNavalTacticsMediator",
		ignoredIds = var0,
		hideTagFlags = ShipStatus.TAG_HIDE_TACTICES,
		onShip = function(arg0, arg1, arg2)
			if not arg0 then
				return false
			end

			local var0, var1 = ShipStatus.ShipStatusCheck("inTactics", arg0, arg1)

			if not var0 then
				return var0, var1
			end

			return true
		end,
		onSelected = function(arg0)
			local var0 = arg0[1]

			if not var0 then
				return
			end

			if getProxy(BayProxy):RawGetShipById(var0):isMetaShip() then
				arg0.contextData.metaShipID = var0

				arg0.viewComponent:Init()

				return
			end

			arg0.contextData.shipToLesson = {
				shipId = var0,
				index = arg1
			}

			arg0.viewComponent:Init()
		end
	}

	arg0:addSubLayers(Context.New({
		viewComponent = NavTacticsDockyardScene,
		mediator = DockyardMediator,
		data = var2
	}))
end

function var0.listNotificationInterests(arg0)
	return {
		NavalAcademyProxy.SKILL_CLASS_POS_UPDATED,
		GAME.START_TO_LEARN_TACTICS_DONE,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		var0.ON_FINISH_ONE_ANIM,
		GAME.CANCEL_LEARN_TACTICS,
		var0.ON_CANCEL_ADD_STUDENT,
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE,
		GAME.QUICK_FINISH_LEARN_TACTICS_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == NavalAcademyProxy.SKILL_CLASS_POS_UPDATED then
		arg0.viewComponent:OnUnlockSlot()
	elseif var0 == GAME.START_TO_LEARN_TACTICS_DONE then
		arg0.viewComponent:OnAddStudent()
		arg0.viewComponent:ResendCancelOp(arg0.cancelList)

		arg0.cancelList = {}
	elseif var0 == var0.ON_CANCEL_ADD_STUDENT then
		arg0.viewComponent:ResendCancelOp(arg0.cancelList)

		arg0.cancelList = {}
	elseif var0 == GAME.CANCEL_LEARN_TACTICS_DONE then
		local var2 = var1.id
		local var3 = var1.totalExp
		local var4 = ShipSkill.New(var1.oldSkill)
		local var5 = ShipSkill.New(var1.newSkill)
		local var6 = var1.shipId

		arg0.viewComponent.finishLessonUtil:WaitForFinish(var2, var6, var3, var4, var5)
	elseif var0 == GAME.CANCEL_LEARN_TACTICS then
		arg0.viewComponent:BlockEvents()
	elseif var0 == var0.ON_FINISH_ONE_ANIM then
		arg0.viewComponent:UnblockEvents()
		arg0.viewComponent:OnExitStudent()
	elseif var0 == GAME.TACTICS_META_UNLOCK_SKILL_DONE then
		arg0.viewComponent:OnUpdateMetaSkillPanel(var1.metaShipID)
	elseif var0 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		arg0.viewComponent:OnUpdateMetaSkillPanel(var1.metaShipID)
	elseif var0 == GAME.QUICK_FINISH_LEARN_TACTICS_DONE then
		arg0.viewComponent:BlockEvents()
		arg0.viewComponent:OnUpdateQuickFinishPanel()
	end
end

return var0
