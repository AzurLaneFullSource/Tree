local var0_0 = class("DreamlandHotSpringPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DreamlandHotSpringUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.slots = {}
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("bg/list"), arg0_2:findTF("bg/list/tpl"))
	arg0_2.iconList = {
		"icon_1",
		"icon_2",
		"icon_3"
	}

	setText(arg0_2:findTF("bg/list/tpl/lock/Text"), i18n("dreamland_spring_lock_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:bind(DreamlandScene.ON_SPRING_DATA_UPDATE, function(arg0_5, arg1_5)
		arg0_3:UpdateSpringActUpdate(arg1_5.data)
	end)
	arg0_3:InitSlots()
end

function var0_0.UpdateSpringActUpdate(arg0_6, arg1_6)
	if not arg0_6:isShowing() then
		return
	end

	arg0_6:Flush(arg1_6)
end

function var0_0.InitSlots(arg0_7)
	arg0_7.uiItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_7:UpdateSlot(arg2_8, arg1_8)
		end
	end)
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
	arg0_9:Flush(arg1_9)
end

function var0_0.Flush(arg0_10, arg1_10)
	arg0_10.shipList = arg1_10:GetHotSpringData()

	local var0_10 = arg1_10:GetHotSpringMaxCnt()
	local var1_10 = arg1_10:GetHotSpringAddition()

	setText(arg0_10:findTF("bg/Text"), i18n("dreamland_spring_tip", var1_10))

	arg0_10.gameData = arg1_10

	arg0_10.uiItemList:align(var0_10)
end

function var0_0.UpdateSlot(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.shipList[arg2_11 + 1]
	local var1_11 = arg0_11.gameData:IsLockSpringSlot(arg2_11 + 1)
	local var2_11 = var0_11 and var0_11 > 0

	setActive(arg1_11:Find("add"), not var1_11 and not var2_11)
	setActive(arg1_11:Find("ship"), not var1_11 and var2_11)
	setActive(arg1_11:Find("lock"), var1_11)
	onButton(arg0_11, arg1_11, function()
		if var1_11 then
			return
		end

		local var0_12

		if var2_11 then
			var0_12 = getProxy(BayProxy):getShipById(var0_11)
		end

		arg0_11:emit(DreamlandScene.ON_SPRING_OP)

		local var1_12 = arg0_11.gameData:GetUnlockSpringCnt()

		arg0_11:emit(DreamlandMediator.HOT_SPRING_OP, arg2_11 + 1, var1_12, var0_12)
	end, SFX_PANEL)

	if not var2_11 then
		return
	end

	arg0_11:UpdateShipSlot(arg1_11, var0_11)
end

function var0_0.UpdateShipSlot(arg0_13, arg1_13, arg2_13)
	local var0_13 = getProxy(BayProxy):RawGetShipById(arg2_13)
	local var1_13 = LoadSprite("qicon/" .. var0_13:getPrefab())

	arg1_13:Find("ship"):GetComponent(typeof(Image)).sprite = var1_13

	local var2_13 = math.random(1, #arg0_13.iconList)
	local var3_13 = arg0_13.iconList[var2_13]
	local var4_13

	var4_13.sprite, var4_13 = GetSpriteFromAtlas("ui/DlHotSpringUI_atlas", var3_13), arg1_13:Find("ship/icon"):GetComponent(typeof(Image))

	var4_13:SetNativeSize()
end

function var0_0.Hide(arg0_14)
	var0_0.super.Hide(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf, arg0_14._parentTf)
end

function var0_0.OnDestroy(arg0_15)
	if arg0_15:isShowing() then
		arg0_15:Hide()
	end
end

return var0_0
