local var0 = class("UrShipRefetchWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "UrShipReFetchWindow"
end

function var0.OnLoaded(arg0)
	arg0.shipTpl = arg0:findTF("window/content/ships/itemtpl")
	arg0.contentTxt = arg0:findTF("window/content/Text"):GetComponent(typeof(Text))
	arg0.cntTxt = arg0:findTF("window/content/count"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("window/confirm_btn")

	setText(arg0._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))
	setText(arg0.confirmBtn:Find("pic"), i18n("word_take"))
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:UpdateUrShipAndContent(arg1)
	arg0:RegisterEvent(arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER - 1
	})
end

local function var1(arg0)
	local var0 = arg0:getConfig("config_id")
	local var1 = pg.ship_data_create_exchange[var0]
	local var2 = var1.exchange_request
	local var3 = var1.exchange_available_times
	local var4 = var1.exchange_ship_id[1]
	local var5 = arg0.data1
	local var6 = arg0.data2
	local var7 = math.min(var3, var6 + 1) * var2

	return var5, var7, var4
end

local function var2(arg0)
	return arg0.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.UpdateUrShipAndContent(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(arg1)
	local var1, var2, var3 = var1(var0)

	updateDrop(arg0.shipTpl, {
		type = DROP_TYPE_SHIP,
		id = var3
	})

	arg0.contentTxt.text = i18n("urdraw_tip")

	arg0:AddTimer(var0, var1, var2)
end

function var0.AddTimer(arg0, arg1, arg2, arg3)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = var2(arg1)

		arg0:UpdateTimeTxt(var0, arg2, arg3)
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.UpdateTimeTxt(arg0, arg1, arg2, arg3)
	if arg1 == 0 then
		pg.m02:sendNotification(MainUrShipReFetchSequence.ON_TIME_UP)

		return
	end

	local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(arg1)
	local var4 = var0 == 0 and var1 == 0 and var2 == 0 and var3 > 0 and var3 .. i18n("word_second") or var0 .. i18n("word_date") .. var1 .. i18n("word_hour") .. var2 .. i18n("word_minute")

	arg0.cntTxt.text = i18n("urdraw_complement", arg2 .. "/" .. arg3, var4)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.RegisterEvent(arg0, arg1)
	onButton(arg0, arg0.confirmBtn, function()
		pg.m02:sendNotification(GAME.GRAFTING_ACT_OP, {
			cmd = 2,
			id = arg1
		})
	end, SFX_CONFIRM)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	removeOnButton(arg0.confirmBtn)
	arg0:RemoveTimer()
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
