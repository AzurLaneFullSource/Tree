local var0 = class("MetaCharacterTacticsMediator", import("...base.ContextMediator"))

var0.GO_TASK = "MetaCharacterTacticsMediator:GO_TASK"
var0.ON_SUBMIT = "MetaCharacterTacticsMediator:ON_SUBMIT"
var0.ON_TRIGGER = "MetaCharacterTacticsMediator:ON_TRIGGER"
var0.ON_SKILL = "MetaCharacterTacticsMediator:ON_SKILL"
var0.ON_QUICK = "MetaCharacterTacticsMediator:ON_QUICK"

function var0.register(arg0)
	arg0:requestTacticsData()
	arg0:bindEvent()
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.TACTICS_META_INFO_REQUEST_DONE,
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE,
		GAME.TACTICS_META_LEVELUP_SKILL_DONE,
		GAME.META_QUICK_TACTICS_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.TACTICS_META_INFO_REQUEST_DONE then
		local var2 = var1

		arg0.viewComponent:setTacticsData(var2)
		arg0.viewComponent:updateTacticsRedTag()
		arg0.viewComponent:updateExpPanel()
		arg0.viewComponent:updateMain()
		arg0.viewComponent:updateSkillTFLearning()
	elseif var0 == GAME.TACTICS_META_UNLOCK_SKILL_DONE then
		local var3 = arg0.viewComponent:isAllSkillLock()

		arg0.viewComponent:updateData()
		arg0.viewComponent:updateSkillListPanel()
		arg0.viewComponent:updateMain()

		if var3 then
			arg0.viewComponent:tryLearnSkillAfterFirstUnlock()
		end

		arg0.viewComponent:closeUnlockSkillPanel()
	elseif var0 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		local var4 = var1.skillID
		local var5 = var1.leftSwitchCount

		arg0.viewComponent:switchTacticsSkillData(var4, var5)
		arg0.viewComponent:updateExpPanel()
		arg0.viewComponent:updateTaskPanel(var4)
		arg0.viewComponent:updateSkillTFLearning()
	elseif var0 == GAME.TACTICS_META_LEVELUP_SKILL_DONE then
		local var6 = var1.skillID
		local var7 = var1.leftSwitchCount

		arg0.viewComponent:updateData()
		arg0.viewComponent:levelupTacticsSkillData(var6, var7)
		arg0.viewComponent:updateTacticsRedTag()
		arg0.viewComponent:updateSkillListPanel()
		arg0.viewComponent:updateTaskPanel(var6)
	elseif var0 == GAME.META_QUICK_TACTICS_DONE then
		local var8 = var1.skillID
		local var9 = var1.skillExp

		if var1.isLevelUp then
			arg0.viewComponent:clearTaskInfo(var8)
		end

		arg0.viewComponent:updateSkillExp(var8, var9)
		arg0.viewComponent:updateData()
		arg0.viewComponent:updateTacticsRedTag()
		arg0.viewComponent:updateSkillListPanel()
		arg0.viewComponent:updateTaskPanel(var8)
	end
end

function var0.bindEvent(arg0)
	arg0:bind(var0.ON_QUICK, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = MetaQuickTacticsMediator,
			viewComponent = MetaQuickTacticsLayer,
			data = {
				shipID = arg1,
				skillID = arg2
			}
		}))
	end)
end

function var0.requestTacticsData(arg0)
	arg0:sendNotification(GAME.TACTICS_META_INFO_REQUEST, {
		id = arg0.contextData.shipID
	})
end

return var0
