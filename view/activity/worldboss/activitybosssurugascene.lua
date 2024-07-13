local var0_0 = class("ActivityBossSurugaScene", import(".ActivityBossSceneTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = PoolMgr.GetInstance()

	var0_2:GetPrefab("ui/cysx_fk", "cysx_fk", true, function(arg0_3)
		var0_2:ReturnPrefab("ui/cysx_fk", "cysx_fk", arg0_3)
		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	var0_0.super.init(arg0_4)
	setText(arg0_4.rankTF:Find("title/Text"), i18n("word_billboard"))

	arg0_4.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_5)
	var0_0.super.didEnter(arg0_5)
	arg0_5.loader:GetPrefab("ui/cysx_fk", "cysx_fk", function(arg0_6)
		setParent(arg0_6, arg0_5.left)
		setAnchoredPosition(arg0_6, Vector2(69, 295))
		arg0_6.transform:SetAsFirstSibling()
	end)
end

function var0_0.UpdateRank(arg0_7, arg1_7)
	arg1_7 = arg1_7 or {}

	for iter0_7 = 1, #arg0_7.rankList do
		local var0_7 = arg0_7.rankList[iter0_7]

		setActive(var0_7, iter0_7 <= #arg1_7)

		if iter0_7 <= #arg1_7 then
			local var1_7 = var0_7:Find("name/Text")

			setText(var1_7, tostring(arg1_7[iter0_7].name))
			setText(var0_7:Find("num/Text"), "NO." .. iter0_7)
		end
	end
end

function var0_0.UpdateDropItems(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.contextData.DisplayItems or {}) do
		local var0_8 = arg0_8:findTF("milestone/item", arg0_8.barList[iter0_8])
		local var1_8 = {
			type = arg0_8.contextData.DisplayItems[5 - iter0_8][1],
			id = arg0_8.contextData.DisplayItems[5 - iter0_8][2],
			count = arg0_8.contextData.DisplayItems[5 - iter0_8][3]
		}

		updateDrop(var0_8, var1_8)
		onButton(arg0_8, var0_8, function()
			arg0_8:emit(var0_0.ON_DROP, var1_8)
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_10)
	var0_0.super.willExit(arg0_10)
	arg0_10.loader:Clear()
end

return var0_0
