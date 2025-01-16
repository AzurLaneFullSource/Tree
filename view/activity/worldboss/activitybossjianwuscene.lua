local var0_0 = class("ActivityBossJianwuScene", import(".ActivityBossSceneTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossJianwuUI"
end

function var0_0.UpdateDropItems(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.contextData.DisplayItems or {}) do
		local var0_2 = arg0_2:findTF("milestone/item", arg0_2.barList[iter0_2])
		local var1_2 = {
			type = arg0_2.contextData.DisplayItems[5 - iter0_2][1],
			id = arg0_2.contextData.DisplayItems[5 - iter0_2][2],
			count = arg0_2.contextData.DisplayItems[5 - iter0_2][3]
		}

		updateDrop(var0_2:GetChild(0), var1_2)
		onButton(arg0_2, var0_2, function()
			arg0_2:emit(var0_0.ON_DROP, var1_2)
		end, SFX_PANEL)
	end
end

return var0_0
