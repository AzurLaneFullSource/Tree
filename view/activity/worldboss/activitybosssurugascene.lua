local var0_0 = class("ActivityBossSurugaScene", import(".ActivityBossSceneTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)

	table.insert(var0_2, "ui/cysx_fk")

	return var0_2
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = PoolMgr.GetInstance()

	var0_3:GetPrefab("ui/cysx_fk", "cysx_fk", true, function(arg0_4)
		var0_3:ReturnPrefab("ui/cysx_fk", "cysx_fk", arg0_4)
		arg1_3()
	end)
end

function var0_0.init(arg0_5)
	var0_0.super.init(arg0_5)
	setText(arg0_5.rankTF:Find("title/Text"), i18n("word_billboard"))

	arg0_5.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_6)
	var0_0.super.didEnter(arg0_6)
	arg0_6.loader:GetPrefab("ui/cysx_fk", "cysx_fk", function(arg0_7)
		setParent(arg0_7, arg0_6.left)
		setAnchoredPosition(arg0_7, Vector2(69, 295))
		arg0_7.transform:SetAsFirstSibling()
	end)
end

function var0_0.UpdateRank(arg0_8, arg1_8)
	arg1_8 = arg1_8 or {}

	for iter0_8 = 1, #arg0_8.rankList do
		local var0_8 = arg0_8.rankList[iter0_8]

		setActive(var0_8, iter0_8 <= #arg1_8)

		if iter0_8 <= #arg1_8 then
			local var1_8 = var0_8:Find("name/Text")

			setText(var1_8, tostring(arg1_8[iter0_8].name))
			setText(var0_8:Find("num/Text"), "NO." .. iter0_8)
		end
	end
end

function var0_0.UpdateDropItems(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.contextData.DisplayItems or {}) do
		local var0_9 = arg0_9.barList[iter0_9]:Find("milestone/item")
		local var1_9 = {
			type = arg0_9.contextData.DisplayItems[5 - iter0_9][1],
			id = arg0_9.contextData.DisplayItems[5 - iter0_9][2],
			count = arg0_9.contextData.DisplayItems[5 - iter0_9][3]
		}

		updateDrop(var0_9, var1_9)
		onButton(arg0_9, var0_9, function()
			arg0_9:emit(var0_0.ON_DROP, var1_9)
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_11)
	var0_0.super.willExit(arg0_11)
	arg0_11.loader:Clear()
end

return var0_0
