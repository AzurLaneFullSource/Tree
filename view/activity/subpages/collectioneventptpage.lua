local var0_0 = class("CollectionEventPtPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.helpBtn = arg0_1:findTF("help", arg0_1.bg)
	arg0_1.shopBtn = arg0_1:findTF("shop", arg0_1.bg)
	arg0_1.eventBtn = arg0_1:findTF("event", arg0_1.bg)
	arg0_1.resTF = arg0_1:findTF("res", arg0_1.bg)
	arg0_1.resIcon = arg0_1:findTF("icon", arg0_1.resTF):GetComponent(typeof(Image))
	arg0_1.resNum = arg0_1:findTF("num", arg0_1.resTF):GetComponent(typeof(Text))
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.shopId = arg0_2.activity:getConfig("config_client").shopActID
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.commission_event_tip.tip
		})
	end)
	onButton(arg0_3, arg0_3.shopBtn, function()
		arg0_3:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0_3.shopId
		})
	end)
	onButton(arg0_3, arg0_3.eventBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)

	local var0_3 = getProxy(PlayerProxy):getData().id

	if PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0_3.activity.id .. "_" .. var0_3) == 0 then
		PlayerPrefs.SetInt("ACTIVITY_TYPE_EVENT_" .. arg0_3.activity.id .. "_" .. var0_3, 1)
		getProxy(ActivityProxy):updateActivity(arg0_3.activity)
	end
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = pg.activity_template[arg0_7.shopId].config_client.pt_id
	local var1_7 = getProxy(PlayerProxy):getData()

	arg0_7.resNum.text = var1_7:getResource(var0_7)
end

return var0_0
