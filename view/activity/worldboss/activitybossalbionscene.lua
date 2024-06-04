local var0 = class("ActivityBossAlbionScene", import(".ActivityBossSceneTemplate"))

function var0.getUIName(arg0)
	return "ActivityBossAlbionUI"
end

function var0.UpdateDropItems(arg0)
	for iter0, iter1 in ipairs(arg0.contextData.DisplayItems or {}) do
		local var0 = arg0:findTF("milestone/item/IconTpl", arg0.barList[iter0])
		local var1 = {
			type = arg0.contextData.DisplayItems[5 - iter0][1],
			id = arg0.contextData.DisplayItems[5 - iter0][2],
			count = arg0.contextData.DisplayItems[5 - iter0][3]
		}

		updateDrop(var0, var1)
		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var1)
		end, SFX_PANEL)
	end
end

return var0
