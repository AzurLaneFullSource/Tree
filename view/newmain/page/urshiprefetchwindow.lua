local var0_0 = class("UrShipRefetchWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "UrShipReFetchWindow"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shipTpl = arg0_2:findTF("window/content/ships/itemtpl")
	arg0_2.contentTxt = arg0_2:findTF("window/content/Text"):GetComponent(typeof(Text))
	arg0_2.cntTxt = arg0_2:findTF("window/content/count"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("window/confirm_btn")

	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))
	setText(arg0_2.confirmBtn:Find("pic"), i18n("word_take"))
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.Show(arg0_3)
	arg0_3:UpdateUrShipAndContent(arg1_3)
	arg0_3:RegisterEvent(arg1_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER - 1
	})
end

local function var1_0(arg0_4)
	local var0_4 = arg0_4:getConfig("config_id")
	local var1_4 = pg.ship_data_create_exchange[var0_4]
	local var2_4 = var1_4.exchange_request
	local var3_4 = var1_4.exchange_available_times
	local var4_4 = var1_4.exchange_ship_id[1]
	local var5_4 = arg0_4.data1
	local var6_4 = arg0_4.data2
	local var7_4 = math.min(var3_4, var6_4 + 1) * var2_4

	return var5_4, var7_4, var4_4
end

local function var2_0(arg0_5)
	return arg0_5.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.UpdateUrShipAndContent(arg0_6, arg1_6)
	local var0_6 = getProxy(ActivityProxy):getActivityById(arg1_6)
	local var1_6, var2_6, var3_6 = var1_0(var0_6)

	updateDrop(arg0_6.shipTpl, {
		type = DROP_TYPE_SHIP,
		id = var3_6
	})

	arg0_6.contentTxt.text = i18n("urdraw_tip")

	arg0_6:AddTimer(var0_6, var1_6, var2_6)
end

function var0_0.AddTimer(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7:RemoveTimer()

	arg0_7.timer = Timer.New(function()
		local var0_8 = var2_0(arg1_7)

		arg0_7:UpdateTimeTxt(var0_8, arg2_7, arg3_7)
	end, 1, -1)

	arg0_7.timer:Start()
	arg0_7.timer.func()
end

function var0_0.UpdateTimeTxt(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg1_9 == 0 then
		pg.m02:sendNotification(MainUrShipReFetchSequence.ON_TIME_UP)

		return
	end

	local var0_9, var1_9, var2_9, var3_9 = pg.TimeMgr.GetInstance():parseTimeFrom(arg1_9)
	local var4_9 = var0_9 == 0 and var1_9 == 0 and var2_9 == 0 and var3_9 > 0 and var3_9 .. i18n("word_second") or var0_9 .. i18n("word_date") .. var1_9 .. i18n("word_hour") .. var2_9 .. i18n("word_minute")

	arg0_9.cntTxt.text = i18n("urdraw_complement", arg2_9 .. "/" .. arg3_9, var4_9)
end

function var0_0.RemoveTimer(arg0_10)
	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end
end

function var0_0.RegisterEvent(arg0_11, arg1_11)
	onButton(arg0_11, arg0_11.confirmBtn, function()
		pg.m02:sendNotification(GAME.GRAFTING_ACT_OP, {
			cmd = 2,
			id = arg1_11
		})
	end, SFX_CONFIRM)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)
	removeOnButton(arg0_13.confirmBtn)
	arg0_13:RemoveTimer()
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14:isShowing() then
		arg0_14:Hide()
	end
end

return var0_0
