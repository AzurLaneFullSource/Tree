local var0 = class("NewServerMainPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.time = arg0:findTF("time", arg0.bg)
	arg0.shopBtn = arg0:findTF("btn_list/shop", arg0.bg)
	arg0.fightBtn = arg0:findTF("btn_list/fight", arg0.bg)
	arg0.buildBtn = arg0:findTF("btn_list/build", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.shopBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEW_SERVER_CARNIVAL, {
			page = NewServerCarnivalScene.SHOP_PAGE
		})
	end)
	onButton(arg0, arg0.buildBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD)

		if var0 and not var0:isEnd() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_NEWSERVER
			})
		else
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT)
		end
	end)
	onButton(arg0, arg0.fightBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end)
	arg0:updateTime()
end

function var0.updateTime(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:STimeDescS(arg0.activity:getStartTime(), "%m.%d")
	local var2 = var0:STimeDescS(arg0.activity.stopTime, "%m.%d %H:%M")

	setText(arg0.time, var1 .. " - " .. var2)
end

function var0.OnUpdateFlush(arg0)
	return
end

return var0
