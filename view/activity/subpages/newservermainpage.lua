local var0_0 = class("NewServerMainPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.time = arg0_1:findTF("time", arg0_1.bg)
	arg0_1.shopBtn = arg0_1:findTF("btn_list/shop", arg0_1.bg)
	arg0_1.fightBtn = arg0_1:findTF("btn_list/fight", arg0_1.bg)
	arg0_1.buildBtn = arg0_1:findTF("btn_list/build", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.shopBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEW_SERVER_CARNIVAL, {
			page = NewServerCarnivalScene.SHOP_PAGE
		})
	end)
	onButton(arg0_2, arg0_2.buildBtn, function()
		local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD)

		if var0_4 and not var0_4:isEnd() then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_NEWSERVER
			})
		else
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT)
		end
	end)
	onButton(arg0_2, arg0_2.fightBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end)
	arg0_2:updateTime()
end

function var0_0.updateTime(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance()
	local var1_6 = var0_6:STimeDescS(arg0_6.activity:getStartTime(), "%m.%d")
	local var2_6 = var0_6:STimeDescS(arg0_6.activity.stopTime, "%m.%d %H:%M")

	setText(arg0_6.time, var1_6 .. " - " .. var2_6)
end

function var0_0.OnUpdateFlush(arg0_7)
	return
end

return var0_0
