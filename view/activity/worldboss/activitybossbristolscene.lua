local var0_0 = class("ActivityBossBristolScene", import(".ActivityBossSceneTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossBristolUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	setText(arg0_2:findTF("ticket/Desc", arg0_2.top), i18n("word_special_challenge_ticket"))
end

function var0_0.UpdateDropItems(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.contextData.DisplayItems or {}) do
		local var0_3 = arg0_3:findTF("milestone/item/IconTpl", arg0_3.barList[iter0_3])
		local var1_3 = {
			type = arg0_3.contextData.DisplayItems[5 - iter0_3][1],
			id = arg0_3.contextData.DisplayItems[5 - iter0_3][2],
			count = arg0_3.contextData.DisplayItems[5 - iter0_3][3]
		}

		updateDrop(var0_3, var1_3)
		onButton(arg0_3, var0_3, function()
			arg0_3:emit(var0_0.ON_DROP, var1_3)
		end, SFX_PANEL)
	end
end

return var0_0
