local var0 = class("NewCommanderSkillLayer", import(".CommanderSkillLayer"))

function var0.getUIName(arg0)
	return "NewCommanderSkillUI"
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)

	arg0.commonFlag = defaultValue(arg0.contextData.commonFlag, true)

	local var0 = arg0:findTF("panel/bg/tags")

	onToggle(arg0, var0, function(arg0)
		arg0.commonFlag = arg0

		arg0:UpdateList()
	end, SFX_PANEL)
	triggerToggle(var0, arg0.commonFlag)
end

function var0.SetLocaliza(arg0)
	return
end

function var0.GetColor(arg0, arg1)
	return arg1 and "#66472a" or "#a3a2a2"
end

return var0
