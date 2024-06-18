local var0_0 = class("NewCommanderSkillLayer", import(".CommanderSkillLayer"))

function var0_0.getUIName(arg0_1)
	return "NewCommanderSkillUI"
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)

	arg0_2.commonFlag = defaultValue(arg0_2.contextData.commonFlag, true)

	local var0_2 = arg0_2:findTF("panel/bg/tags")

	onToggle(arg0_2, var0_2, function(arg0_3)
		arg0_2.commonFlag = arg0_3

		arg0_2:UpdateList()
	end, SFX_PANEL)
	triggerToggle(var0_2, arg0_2.commonFlag)
end

function var0_0.SetLocaliza(arg0_4)
	return
end

function var0_0.GetColor(arg0_5, arg1_5)
	return arg1_5 and "#66472a" or "#a3a2a2"
end

return var0_0
