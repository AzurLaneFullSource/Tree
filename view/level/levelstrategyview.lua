local var0_0 = class("LevelStrategyView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelStrategyView"
end

function var0_0.downloadLevelStrategyRes(arg0_2, arg1_2, arg2_2)
	local var0_2 = pg.strategy_data_template[arg1_2.id]
	local var1_2 = {}

	if var0_2 and noEmptyStr(var0_2.icon) then
		local var2_2 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_2.icon)

		table.insert(var1_2, var2_2)
	end

	SplitPackConst.DownloadByLuaArr(var1_2, function()
		if arg0_2._state == var0_0.STATES.DESTROY then
			return
		end

		arg2_2(var0_2)
	end)
end

function var0_0.OnInit(arg0_4)
	arg0_4:InitUI()
	setActive(arg0_4._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.OnDestroy(arg0_5)
	arg0_5.onConfirm = nil
	arg0_5.onCancel = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._tf, arg0_5._parentTf)
end

function var0_0.setCBFunc(arg0_6, arg1_6, arg2_6)
	arg0_6.onConfirm = arg1_6
	arg0_6.onCancel = arg2_6
end

function var0_0.InitUI(arg0_7)
	arg0_7.icon = arg0_7._tf:Find("window/panel/item/icon_bg/icon")
	arg0_7.count = arg0_7._tf:Find("window/panel/item/icon_bg/count")
	arg0_7.name = arg0_7._tf:Find("window/panel/item/name")
	arg0_7.desc = arg0_7._tf:Find("window/panel/item/desc")
	arg0_7.btnCancel = arg0_7._tf:Find("window/panel/actions/cancel_button")
	arg0_7.btnUse = arg0_7._tf:Find("window/panel/actions/use_button")
	arg0_7.btnBack = arg0_7._tf:Find("top/btnBack")
	arg0_7.tips = arg0_7._tf:Find("window/panel/tips")
	arg0_7.txSwitch = findTF(arg0_7.btnUse, "switch")
	arg0_7.txUse = findTF(arg0_7.btnUse, "use")
end

function var0_0.set(arg0_8, arg1_8)
	arg0_8.strategy = arg1_8

	arg0_8:downloadLevelStrategyRes(arg1_8, function(arg0_9)
		arg0_8:setAfterDownload(arg1_8, arg0_9)
	end)
end

function var0_0.setAfterDownload(arg0_10, arg1_10, arg2_10)
	GetImageSpriteFromAtlasAsync("strategyicon/" .. arg2_10.icon, "", arg0_10.icon)

	if arg2_10.type == 1 then
		setText(arg0_10.count, "")
		setActive(arg0_10.tips, true)
		setActive(arg0_10.txSwitch, true)
		setActive(arg0_10.txUse, false)
	else
		setText(arg0_10.count, arg1_10.count)
		setActive(arg0_10.tips, false)
		setActive(arg0_10.txSwitch, false)
		setActive(arg0_10.txUse, true)
	end

	setText(arg0_10.name, arg2_10.name)
	setText(arg0_10.desc, arg2_10.desc)
	onButton(arg0_10, arg0_10.btnBack, function()
		if arg0_10.onCancel then
			arg0_10.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.btnCancel, function()
		if arg0_10.onCancel then
			arg0_10.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.btnUse, function()
		if arg0_10.onConfirm then
			arg0_10.onConfirm()
		end
	end, SFX_CONFIRM)
end

return var0_0
