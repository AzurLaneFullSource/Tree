local var0_0 = class("FileDownloadPanel", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "FileDownloadBox"
end

function var0_0.OnInit(arg0_2)
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.UpdateView(arg0_3, arg1_3)
	local var0_3 = arg1_3.onYes

	function arg1_3.onYes()
		pg.FileDownloadMgr.GetInstance():SetRemind(arg0_3.curStopValue)
		var0_3()
	end

	arg0_3:PreRefresh(arg1_3)
	setText(arg0_3.contextText, arg1_3.content)

	rtf(arg0_3.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	setActive(arg0_3.toggleTF, not arg1_3.hideToggle)
	arg0_3:PostRefresh(arg1_3)
end

function var0_0.findUI(arg0_5)
	arg0_5.contextText = arg0_5:findTF("Context")
	arg0_5.toggleTF = arg0_5:findTF("Toggle")
	arg0_5.tickTF = arg0_5:findTF("Tip/TickBG/Tick", arg0_5.toggleTF)
end

function var0_0.addListener(arg0_6)
	arg0_6.curStopValue = false

	onToggle(arg0_6, arg0_6.toggleTF, function(arg0_7)
		arg0_6.curStopValue = arg0_7
	end, SFX_CONFIRM, SFX_CANCEL)
end

return var0_0
