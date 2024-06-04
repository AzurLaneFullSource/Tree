pg = pg or {}
pg.GuildLayerMgr = singletonClass("GuildLayerMgr")

local var0 = pg.GuildLayerMgr

function var0.Ctor(arg0)
	arg0.overlayMain = pg.UIMgr.GetInstance().OverlayMain.transform
	arg0.originLayer = GameObject.Find("UICamera/Canvas")
	arg0.levelGrid = GameObject.Find("LevelCamera/Canvas/UIMain/LevelGrid")
end

function var0.Init(arg0, arg1)
	if arg1 then
		arg1()
	end
end

function var0.BlurTopPanel(arg0, arg1)
	if not arg0.topPanel then
		arg0.topPrevParent = arg1.parent
		arg0.topPanel = arg1
	end

	setParent(arg1, arg0.overlayMain)
	arg1:SetAsFirstSibling()
end

function var0._BlurTopPanel(arg0)
	if arg0.topPanel then
		arg0:BlurTopPanel(arg0.topPanel)
	end
end

function var0.OnShowMsgBox(arg0)
	if arg0.topPanel then
		arg0.topPanel:SetAsFirstSibling()
	end
end

function var0.UnBlurTopPanel(arg0)
	setParent(arg0.topPanel, arg0.originLayer)
end

function var0.Blur(arg0, arg1)
	arg0:UnBlurTopPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg1)
	arg1:SetAsLastSibling()
end

function var0.UnBlur(arg0, arg1, arg2)
	arg0:BlurTopPanel(arg0.topPanel)
	pg.UIMgr.GetInstance():UnblurPanel(arg1, arg2)
end

function var0.BlurForLevel(arg0, arg1)
	setActive(arg0.levelGrid, false)
	arg0:Blur(arg1)
end

function var0.UnBlurForLevel(arg0, arg1, arg2)
	setActive(arg0.levelGrid, true)
	arg0:UnBlur(arg1, arg2)
end

function var0.SetOverlayParent(arg0, arg1, arg2)
	setParent(arg1, arg2 or arg0.overlayMain)
end

function var0.Clear(arg0)
	setParent(arg0.topPanel, arg0.topPrevParent)

	arg0.topPrevParent = nil
	arg0.topPanel = nil
end
