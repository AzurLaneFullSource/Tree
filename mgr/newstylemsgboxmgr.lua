pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("NewStyleMsgboxMgr")

var0_0.NewStyleMsgboxMgr = var1_0
var1_0.TYPE_MSGBOX = 1
var1_0.TYPE_DROP = 2
var1_0.TYPE_DROP_CLIENT = 3
var1_0.UI_NAME_DIC = {
	[var1_0.TYPE_MSGBOX] = "DormStyleMsgboxUI",
	[var1_0.TYPE_DROP] = "DormStyleDropMsgboxUI",
	[var1_0.TYPE_DROP_CLIENT] = "DormStyleDropMsgboxUI"
}
var1_0.BUTTON_TYPE = {
	confirm = "btn_confirm",
	cancel = "btn_cancel",
	blue = "btn_confirm",
	gray = "btn_cancel"
}

function var1_0.Init(arg0_1, arg1_1)
	print("initializing new style msgbox manager...")

	arg0_1.showList = {}
	arg0_1.rtDic = {}

	existCall(arg1_1)
end

function var1_0.Show(arg0_2, ...)
	table.insert(arg0_2.showList, packEx(...))

	if #arg0_2.showList == 1 then
		arg0_2:DoShow(unpackEx(arg0_2.showList[1]))
	end
end

function var1_0.DoShow(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	if not arg0_3.rtDic[arg1_3] then
		table.insert(var0_3, function(arg0_4)
			var0_0.UIMgr.GetInstance():LoadingOn()
			PoolMgr.GetInstance():GetUI(var1_0.UI_NAME_DIC[arg1_3], true, function(arg0_5)
				setParent(arg0_5, var0_0.UIMgr.GetInstance().OverlayMain, false)

				arg0_3.rtDic[arg1_3] = arg0_5.transform

				var0_0.UIMgr.GetInstance():LoadingOff()
				arg0_4()
			end)
		end)
	end

	seriesAsync(var0_3, function()
		arg0_3._tf = arg0_3.rtDic[arg1_3]

		arg0_3:CommonSetting(arg2_3)
		arg0_3:DisplaySetting(arg1_3, arg2_3)
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, arg2_3.blurParams or {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setActive(arg0_3._tf, true)
	end)
end

function var1_0.Hide(arg0_7)
	if not arg0_7._tf then
		return
	end

	setActive(arg0_7._tf, false)
	arg0_7:Clear()
	var0_0.UIMgr.GetInstance():UnblurPanel(arg0_7._tf, var0_0.UIMgr.GetInstance().OverlayMain)

	arg0_7._tf = nil

	table.remove(arg0_7.showList, 1)

	if #arg0_7.showList > 0 then
		arg0_7:DoShow(unpackEx(arg0_7.showList[1]))
	end
end

function var1_0.CommonSetting(arg0_8, arg1_8)
	var0_0.DelegateInfo.New(arg0_8)
	setText(arg0_8._tf:Find("window/top/title"), arg1_8.title or i18n("words_information"))

	function arg0_8.hideCall()
		arg0_8.hideCall = nil

		existCall(arg1_8.onClose)
	end

	onButton(arg0_8, arg0_8._tf:Find("bg"), function()
		existCall(arg0_8.hideCall)
		arg0_8:Hide()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._tf:Find("window/top/btn_close"), function()
		existCall(arg0_8.hideCall)
		arg0_8:Hide()
	end, SFX_CANCEL)

	function arg0_8.confirmCall()
		arg0_8.confirmCall = nil

		existCall(arg1_8.onConfirm)
	end

	local var0_8 = arg1_8.btnList or {
		{
			type = var1_0.BUTTON_TYPE.cancel,
			name = i18n("msgbox_text_cancel"),
			func = function()
				existCall(arg0_8.hideCall)
			end,
			sound = SFX_CANCEL
		},
		{
			type = var1_0.BUTTON_TYPE.confirm,
			name = i18n("msgbox_text_confirm"),
			func = function()
				existCall(arg0_8.confirmCall)
			end,
			sound = SFX_CONFIRM
		}
	}
	local var1_8 = arg0_8._tf:Find("window/bottom/button_container")

	eachChild(var1_8, function(arg0_15)
		setActive(arg0_15, false)
	end)

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var2_8 = var1_8:Find(iter1_8.type)

		if var2_8:GetSiblingIndex() < var1_8.childCount - iter0_8 + 1 then
			var2_8:SetAsLastSibling()
			setActive(var2_8, true)
		else
			var2_8 = cloneTplTo(var2_8, var1_8, var2_8.name)
		end

		setText(var2_8:Find("Text"), iter1_8.name)
		onButton(arg0_8, var2_8, function()
			existCall(iter1_8.func)
			arg0_8:Hide()
		end, iter1_8.sound or SFX_CONFIRM)
	end

	onButton(arg0_8, arg0_8._tf:Find("window/top/btn_close"), function()
		existCall(arg0_8.hideCall)
		arg0_8:Hide()
	end, SFX_CANCEL)
end

function var1_0.Clear(arg0_18)
	var0_0.DelegateInfo.Dispose(arg0_18)

	arg0_18.hideCall = nil
	arg0_18.confirmCall = nil
end

function var1_0.DisplaySetting(arg0_19, arg1_19, arg2_19)
	switch(arg1_19, {
		[var1_0.TYPE_MSGBOX] = function(arg0_20)
			setText(arg0_19._tf:Find("window/middle/content"), arg0_20.contentText)
		end,
		[var1_0.TYPE_DROP] = function(arg0_21)
			local var0_21 = arg0_21.drop
			local var1_21 = arg0_19._tf:Find("window/middle")

			updateDorm3dIcon(var1_21:Find("Dorm3dIconTpl"), arg0_21.drop)
			setText(var1_21:Find("info/name"), var0_21:getName())
			setText(var1_21:Find("info/desc"), cancelColorRich(var0_21.desc))

			local var2_21, var3_21 = var0_21:getOwnedCount()

			setActive(var1_21:Find("info/count"), var3_21)

			if var3_21 then
				setText(var1_21:Find("info/count"), i18n("dorm3d_item_num") .. string.format("<color=#39bfff>%d</color>", var2_21))
			end
		end,
		[var1_0.TYPE_DROP_CLIENT] = function(arg0_22)
			local var0_22 = arg0_19._tf:Find("window/middle")

			Dorm3dIconHelper.UpdateDorm3dIcon(var0_22:Find("Dorm3dIconTpl"), arg0_22.data)
			setActive(var0_22:Find("info/count"), false)
			setActive(var0_22:Find("Dorm3dIconTpl/count"), false)

			local var1_22 = Dorm3dIconHelper.Data2Config(arg0_22.data)

			setText(var0_22:Find("info/name"), var1_22.name)
			setText(var0_22:Find("info/desc"), var1_22.desc)
		end
	}, nil, arg2_19)
end

function var1_0.emit(arg0_23, arg1_23, ...)
	if not arg0_23.analogyMediator then
		arg0_23.analogyMediator = {
			addSubLayers = function(arg0_24, arg1_24)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_24
				})
			end,
			sendNotification = function(arg0_25, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_23
		}
	end

	return ContextMediator.CommonBindDic[arg1_23](arg0_23.analogyMediator, arg1_23, ...)
end

function var1_0.closeView(arg0_26)
	arg0_26:hide()
end
