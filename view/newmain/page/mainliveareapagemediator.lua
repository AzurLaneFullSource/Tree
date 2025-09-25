local var0_0 = class("MainLiveAreaPageMediator", pm.Mediator)

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
	pg.m02:registerMediator(arg0_1)
end

function var0_0.GoScene(arg0_2, arg1_2, arg2_2)
	arg0_2:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
end

function var0_0.OpenDormSelectLayer(arg0_3)
	arg0_3:sendNotification(GAME.GO_SCENE, SCENE.DORM3DSELECT)
end

function var0_0.GoIsland(arg0_4, arg1_4)
	arg0_4:sendNotification(GAME.ISLAND_ENTER, {
		id = arg1_4
	})
end

function var0_0.Dispose(arg0_5)
	pg.m02:removeMediator(arg0_5.__cname)
end

return var0_0
