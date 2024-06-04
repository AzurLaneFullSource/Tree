local var0 = class("ActivityBossSurugaScene", import(".ActivityBossSceneTemplate"))

function var0.getUIName(arg0)
	return "ActivityBossUI"
end

function var0.preload(arg0, arg1)
	local var0 = PoolMgr.GetInstance()

	var0:GetPrefab("ui/cysx_fk", "cysx_fk", true, function(arg0)
		var0:ReturnPrefab("ui/cysx_fk", "cysx_fk", arg0)
		arg1()
	end)
end

function var0.init(arg0)
	var0.super.init(arg0)
	setText(arg0.rankTF:Find("title/Text"), i18n("word_billboard"))

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	arg0.loader:GetPrefab("ui/cysx_fk", "cysx_fk", function(arg0)
		setParent(arg0, arg0.left)
		setAnchoredPosition(arg0, Vector2(69, 295))
		arg0.transform:SetAsFirstSibling()
	end)
end

function var0.UpdateRank(arg0, arg1)
	arg1 = arg1 or {}

	for iter0 = 1, #arg0.rankList do
		local var0 = arg0.rankList[iter0]

		setActive(var0, iter0 <= #arg1)

		if iter0 <= #arg1 then
			local var1 = var0:Find("name/Text")

			setText(var1, tostring(arg1[iter0].name))
			setText(var0:Find("num/Text"), "NO." .. iter0)
		end
	end
end

function var0.UpdateDropItems(arg0)
	for iter0, iter1 in ipairs(arg0.contextData.DisplayItems or {}) do
		local var0 = arg0:findTF("milestone/item", arg0.barList[iter0])
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

function var0.willExit(arg0)
	var0.super.willExit(arg0)
	arg0.loader:Clear()
end

return var0
