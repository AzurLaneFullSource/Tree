local var0_0 = class("BossRushSardiniaPassedLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BossRushSardiniaPassedUI"
end

function var0_0.didEnter(arg0_2)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)

	local var0_2 = {
		glow = true
	}

	eachChild(arg0_2._tf:Find("Main"), function(arg0_3, arg1_3)
		setActive(arg0_3, var0_2[arg0_3.name] or arg0_3.name == tostring(BossRushVerZenkerPassedLayer.seriesId))
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
		end,
		function(arg0_8)
			local var0_8 = arg0_2.contextData.curIndex
			local var1_8 = arg0_2.contextData.maxIndex

			var1_2(arg0_2.rtContent:GetChild(var0_8 - 1):Find("left"), -1)

			if var0_8 > 1 then
				var1_2(arg0_2.rtContent:GetChild(var0_8 - 2):Find("right"), -1)
			end

			LeanTween.value(0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_9)
				setSlider(arg0_2.rtSlider, 0, var1_8 - 1, var0_8 - 1 + arg0_9)
			end)):setEaseOutCubic():setOnComplete(System.Action(arg0_8))
		end,
		function(arg0_10)
			var2_2(arg0_2.contextData.curIndex + 1, arg0_2.contextData.maxIndex)
			onDelayTick(arg0_10, 1.5)
		end
	}, function()
		arg0_2:closeView()
	end)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
