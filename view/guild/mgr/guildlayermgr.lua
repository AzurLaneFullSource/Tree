pg = pg or {}
pg.GuildLayerMgr = singletonClass("GuildLayerMgr")

local var0_0 = pg.GuildLayerMgr

function var0_0.Ctor(arg0_1)
	arg0_1.overlayMain = pg.UIMgr.GetInstance().OverlayMain.transform
	arg0_1.originLayer = GameObject.Find("UICamera/Canvas")
	arg0_1.levelGrid = GameObject.Find("LevelCamera/Canvas/UIMain/LevelGrid")
end

function var0_0.Init(arg0_2, arg1_2)
	if arg1_2 then
		arg1_2()
	end
end

function var0_0.BlurTopPanel(arg0_3, arg1_3)
	if not arg0_3.topPanel then
		arg0_3.topPrevParent = arg1_3.parent
		arg0_3.topPanel = arg1_3
	end

	setParent(arg1_3, arg0_3.overlayMain)
	arg1_3:SetAsFirstSibling()
end

function var0_0._BlurTopPanel(arg0_4)
	if arg0_4.topPanel then
		arg0_4:BlurTopPanel(arg0_4.topPanel)
	end
end

function var0_0.OnShowMsgBox(arg0_5)
	if arg0_5.topPanel then
		arg0_5.topPanel:SetAsFirstSibling()
	end
end

function var0_0.UnBlurTopPanel(arg0_6)
	setParent(arg0_6.topPanel, arg0_6.originLayer)
end

function var0_0.Blur(arg0_7, arg1_7)
	arg0_7:UnBlurTopPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg1_7)
	arg1_7:SetAsLastSibling()
end

function var0_0.UnBlur(arg0_8, arg1_8, arg2_8)
	arg0_8:BlurTopPanel(arg0_8.topPanel)
	pg.UIMgr.GetInstance():UnblurPanel(arg1_8, arg2_8)
end

function var0_0.BlurForLevel(arg0_9, arg1_9)
	setActive(arg0_9.levelGrid, false)
	arg0_9:Blur(arg1_9)
end

function var0_0.UnBlurForLevel(arg0_10, arg1_10, arg2_10)
	setActive(arg0_10.levelGrid, true)
	arg0_10:UnBlur(arg1_10, arg2_10)
end

function var0_0.SetOverlayParent(arg0_11, arg1_11, arg2_11)
	setParent(arg1_11, arg2_11 or arg0_11.overlayMain)
end

function var0_0.Clear(arg0_12)
	setParent(arg0_12.topPanel, arg0_12.topPrevParent)

	arg0_12.topPrevParent = nil
	arg0_12.topPanel = nil
end
