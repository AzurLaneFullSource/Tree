local var0_0 = class("BossRushEscapeManorPassedLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BossRushEscapeManorPassedUI"
end

function var0_0.didEnter(arg0_2)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)

	local var0_2 = {
		glow = true
	}

	eachChild(arg0_2._tf:Find("Main"), function(arg0_3, arg1_3)
		setActive(arg0_3, var0_2[arg0_3.name] or arg0_3.name == tostring(BossRushEscapeManorPassedLayer.seriesId))
	end)

	local function var1_2(arg0_4, arg1_4)
		setActive(arg0_4:Find("UnFinished"), arg1_4 > 0)
		setActive(arg0_4:Find("Challengeing"), arg1_4 == 0)
		setActive(arg0_4:Find("Finished"), arg1_4 < 0)
	end

	local function var2_2(arg0_5, arg1_5)
		setSlider(arg0_2.rtSlider, 0, arg1_5 - 1, arg0_5 - 1)
		UIItemList.StaticAlign(arg0_2.rtContent, arg0_2.rtTpl, arg1_5 - 1, function(arg0_6, arg1_6, arg2_6)
			arg1_6 = arg1_6 + 1

			if arg0_6 == UIItemList.EventUpdate then
				var1_2(arg2_6:Find("left"), arg1_6 - arg0_5)
				var1_2(arg2_6:Find("right"), arg1_6 + 1 - arg0_5)
			end
		end)
	end

	seriesAsync({
		function(arg0_7)
			var2_2(arg0_2.contextData.curIndex, arg0_2.contextData.maxIndex)
			onDelayTick(arg0_7, 0.5)
		end
	}, function()
		local var0_8 = arg0_2.contextData.curIndex
		local var1_8 = arg0_2.contextData.maxIndex

		var1_2(arg0_2.rtContent:GetChild(var0_8 - 1):Find("left"), -1)

		if var0_8 > 1 then
			var1_2(arg0_2.rtContent:GetChild(var0_8 - 2):Find("right"), -1)
		end

		local function var2_8()
			seriesAsync({
				function(arg0_10)
					var2_2(arg0_2.contextData.curIndex + 1, arg0_2.contextData.maxIndex)
					onDelayTick(arg0_10, 1.5)
				end
			}, function()
				arg0_2:emit(ChallengePassedCombatLoadMediator.FINISH, arg0_2._loadObs)
			end)
		end

		arg0_2:combatPreload(var2_8)
	end)
end

function var0_0.combatPreload(arg0_12, arg1_12)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_12._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_12 = ys.Battle.BattleResourceManager.GetInstance()

	var0_12:Init()

	local var1_12, var2_12 = CombatLoadUI.GetTotalResourceList(arg0_12.contextData)

	for iter0_12, iter1_12 in ipairs(var1_12) do
		var0_12:AddPreloadResource(iter1_12)
	end

	for iter2_12, iter3_12 in ipairs(var2_12) do
		var0_12:AddPreloadCV(iter3_12)
	end

	local function var3_12()
		arg1_12()
	end

	local var4_12 = 0

	local function var5_12(arg0_14)
		local var0_14
		local var1_14 = var4_12 == 0 and 0 or arg0_14 / var4_12

		setSlider(arg0_12.rtSlider, 0, arg0_12.contextData.maxIndex - 1, arg0_12.contextData.curIndex - 1 + var1_14)
	end

	local var6_12 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var6_12, true)

	var4_12 = var0_12:StartPreload(var3_12, var5_12)
end

function var0_0.willExit(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)
end

return var0_0
