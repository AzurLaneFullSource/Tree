local var0 = class("CollectionEventPtPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.helpBtn = arg0:findTF("help", arg0.bg)
	arg0.shopBtn = arg0:findTF("shop", arg0.bg)
	arg0.eventBtn = arg0:findTF("event", arg0.bg)
	arg0.resTF = arg0:findTF("res", arg0.bg)
	arg0.resIcon = arg0:findTF("icon", arg0.resTF):GetComponent(typeof(Image))
	arg0.resNum = arg0:findTF("num", arg0.resTF):GetComponent(typeof(Text))
end

function var0.OnDataSetting(arg0)
	arg0.shopId = arg0.activity:getConfig("config_client").shopActID
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.commission_event_tip.tip
		})
	end)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = arg0.shopId
		})
	end)
	onButton(arg0, arg0.eventBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)

	local var0 = getProxy(PlayerProxy):getData().id

	if PlayerPrefs.GetInt("ACTIVITY_TYPE_EVENT_" .. arg0.activity.id .. "_" .. var0) == 0 then
		PlayerPrefs.SetInt("ACTIVITY_TYPE_EVENT_" .. arg0.activity.id .. "_" .. var0, 1)
		getProxy(ActivityProxy):updateActivity(arg0.activity)
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = pg.activity_template[arg0.shopId].config_client.pt_id
	local var1 = getProxy(PlayerProxy):getData()

	arg0.resNum.text = var1:getResource(var0)
end

return var0
