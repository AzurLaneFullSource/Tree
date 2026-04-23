local var0_0 = class("DOACoreActivityMainPage", import("view.activity.CorePage.Helena.HelenaMainPage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.Manual, function()
		local var0_2 = Context.New({
			mediator = DOAYearHotSpringMediator,
			viewComponent = DOAYearHotSpringScene
		})

		arg0_1:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_2)
	end)
end

function var0_0.updateUI(arg0_3)
	if arg0_3.shop_id then
		local var0_3, var1_3 = arg0_3.timeMgr:inTime(pg.shop_template[arg0_3.shop_id].time)
		local var2_3

		if var1_3 then
			local var3_3 = arg0_3.timeMgr:Table2ServerTime(var1_3)

			var2_3 = var0_0:skinCommdityTimeStamps(var3_3)
		end

		setActive(arg0_3.shop_bgtime, var2_3 and var2_3 ~= 0)
		setText(arg0_3.shop_time, var2_3)
		onButton(arg0_3, arg0_3.shop, function()
			if var2_3 == nil then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_3:emit(ActivityMediator.GO_CHANGE_SHOP)
		end)
	end

	local var4_3, var5_3 = arg0_3.timeMgr:inTime(pg.activity_template[arg0_3.activity.id].time)
	local var6_3

	if var5_3 then
		local var7_3 = arg0_3.timeMgr:Table2ServerTime(var5_3)

		var6_3 = var0_0:skinCommdityTimeStamps(var7_3)
	end

	setActive(arg0_3.build_bgtime, var6_3 and var6_3 ~= 0)
	setText(arg0_3.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_3, arg0_3.build, function()
		if var6_3 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end)
	onButton(arg0_3, arg0_3.fight, function()
		arg0_3:emit(ActivityMediator.SKIP_ACTIVITY_MAP, 6036)
	end)
end

return var0_0
