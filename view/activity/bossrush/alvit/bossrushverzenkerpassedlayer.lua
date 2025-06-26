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
	seriesAsync({
		function(arg0_5)
			triggerToggle(arg0_2._tf:Find("Image/content"):GetChild(arg0_2.contextData.curIndex - 1), true)
			onDelayTick(arg0_5, 1.5)
		end,
		function(arg0_6)
			triggerToggle(arg0_2._tf:Find("Image/content"):GetChild(arg0_2.contextData.curIndex), true)
			onDelayTick(arg0_6, 1.5)
		end
	}, function()
		arg0_2:closeView()
	end)
end

function var0_0.willExit(arg0_8)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf)
end

return var0_0
