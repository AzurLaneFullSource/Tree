local var0_0 = class("BossRushVerZenkerPassedLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BossRushVerZenkerPassedUI"
end

function var0_0.didEnter(arg0_2)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)

	local var0_2 = {
		word = true,
		glow = true
	}

	eachChild(arg0_2._tf:Find("main"), function(arg0_3, arg1_3)
		setActive(arg0_3, var0_2[arg0_3.name] or arg0_3.name == tostring(BossRushVerZenkerPassedLayer.seriesId))
	end)
	eachChild(arg0_2._tf:Find("Image/content"), function(arg0_4, arg1_4)
		setActive(arg0_4, arg1_4 < arg0_2.contextData.maxIndex)
	end)

	local function var1_2()
		seriesAsync({
			function(arg0_6)
				triggerToggle(arg0_2._tf:Find("Image/content"):GetChild(arg0_2.contextData.curIndex - 1), true)
				onDelayTick(arg0_6, 1.5)
			end,
			function(arg0_7)
				triggerToggle(arg0_2._tf:Find("Image/content"):GetChild(arg0_2.contextData.curIndex), true)
				onDelayTick(arg0_7, 1.5)
			end
		}, function()
			arg0_2:emit(ChallengePassedCombatLoadMediator.FINISH, arg0_2._loadObs)
		end)
	end

	arg0_2:combatPreload(var1_2)
end

function var0_0.combatPreload(arg0_9, arg1_9)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_9._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_9 = ys.Battle.BattleResourceManager.GetInstance()

	var0_9:Init()

	local var1_9, var2_9 = CombatLoadUI.GetTotalResourceList(arg0_9.contextData)

	for iter0_9, iter1_9 in ipairs(var1_9) do
		var0_9:AddPreloadResource(iter1_9)
	end

	for iter2_9, iter3_9 in ipairs(var2_9) do
		var0_9:AddPreloadCV(iter3_9)
	end

	local function var3_9()
		arg1_9()
	end

	local var4_9 = 0

	local function var5_9(arg0_11)
		return
	end

	local var6_9 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var6_9, true)

	local var7_9 = var0_9:StartPreload(var3_9, var5_9)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
