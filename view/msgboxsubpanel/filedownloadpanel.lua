local var0 = class("FileDownloadPanel", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "FileDownloadBox"
end

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:addListener()
end

function var0.UpdateView(arg0, arg1)
	local var0 = arg1.onYes

	function arg1.onYes()
		pg.FileDownloadMgr.GetInstance():SetRemind(arg0.curStopValue)
		var0()
	end

	arg0:PreRefresh(arg1)
	setText(arg0.contextText, arg1.content)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	arg0:PostRefresh(arg1)
end

function var0.findUI(arg0)
	arg0.contextText = arg0:findTF("Context")
	arg0.toggleTF = arg0:findTF("Toggle")
	arg0.tickTF = arg0:findTF("Tip/TickBG/Tick", arg0.toggleTF)
end

function var0.addListener(arg0)
	arg0.curStopValue = false

	onToggle(arg0, arg0.toggleTF, function(arg0)
		arg0.curStopValue = arg0
	end, SFX_CONFIRM, SFX_CANCEL)
end

return var0
