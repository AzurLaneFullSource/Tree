local var0_0 = class("MetaCharacterTacticsMediator", import("...base.ContextMediator"))

var0_0.GO_TASK = "MetaCharacterTacticsMediator:GO_TASK"
var0_0.ON_SUBMIT = "MetaCharacterTacticsMediator:ON_SUBMIT"
var0_0.ON_TRIGGER = "MetaCharacterTacticsMediator:ON_TRIGGER"
var0_0.ON_SKILL = "MetaCharacterTacticsMediator:ON_SKILL"
var0_0.ON_QUICK = "MetaCharacterTacticsMediator:ON_QUICK"

function var0_0.register(arg0_1)
	arg0_1:requestTacticsData()
	arg0_1:bindEvent()
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.TACTICS_META_INFO_REQUEST_DONE,
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE,
		GAME.TACTICS_META_LEVELUP_SKILL_DONE,
		GAME.META_QUICK_TACTICS_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.TACTICS_META_INFO_REQUEST_DONE then
		local var2_3 = var1_3

		arg0_3.viewComponent:setTacticsData(var2_3)
		arg0_3.viewComponent:updateTacticsRedTag()
		arg0_3.viewComponent:updateExpPanel()
		arg0_3.viewComponent:updateMain()
		arg0_3.viewComponent:updateSkillTFLearning()
	elseif var0_3 == GAME.TACTICS_META_UNLOCK_SKILL_DONE then
		local var3_3 = arg0_3.viewComponent:isAllSkillLock()

		arg0_3.viewComponent:updateData()
		arg0_3.viewComponent:updateSkillListPanel()
		arg0_3.viewComponent:updateMain()

		if var3_3 then
			arg0_3.viewComponent:tryLearnSkillAfterFirstUnlock()
		end

		arg0_3.viewComponent:closeUnlockSkillPanel()
	elseif var0_3 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		local var4_3 = var1_3.skillID
		local var5_3 = var1_3.leftSwitchCount

		arg0_3.viewComponent:switchTacticsSkillData(var4_3, var5_3)
		arg0_3.viewComponent:updateExpPanel()
		arg0_3.viewComponent:updateTaskPanel(var4_3)
		arg0_3.viewComponent:updateSkillTFLearning()
	elseif var0_3 == GAME.TACTICS_META_LEVELUP_SKILL_DONE then
		local var6_3 = var1_3.skillID
		local var7_3 = var1_3.leftSwitchCount

		arg0_3.viewComponent:updateData()
		arg0_3.viewComponent:levelupTacticsSkillData(var6_3, var7_3)
		arg0_3.viewComponent:updateTacticsRedTag()
		arg0_3.viewComponent:updateSkillListPanel()
		arg0_3.viewComponent:updateTaskPanel(var6_3)
	elseif var0_3 == GAME.META_QUICK_TACTICS_DONE then
		local var8_3 = var1_3.skillID
		local var9_3 = var1_3.skillExp

		if var1_3.isLevelUp then
			arg0_3.viewComponent:clearTaskInfo(var8_3)
		end

		arg0_3.viewComponent:updateSkillExp(var8_3, var9_3)
		arg0_3.viewComponent:updateData()
		arg0_3.viewComponent:updateTacticsRedTag()
		arg0_3.viewComponent:updateSkillListPanel()
		arg0_3.viewComponent:updateTaskPanel(var8_3)
	end
end

function var0_0.bindEvent(arg0_4)
	arg0_4:bind(var0_0.ON_QUICK, function(arg0_5, arg1_5, arg2_5)
		arg0_4:addSubLayers(Context.New({
			mediator = MetaQuickTacticsMediator,
			viewComponent = MetaQuickTacticsLayer,
			data = {
				shipID = arg1_5,
				skillID = arg2_5
			}
		}))
	end)
end

function var0_0.requestTacticsData(arg0_6)
	arg0_6:sendNotification(GAME.TACTICS_META_INFO_REQUEST, {
		id = arg0_6.contextData.shipID
	})
end

return var0_0
