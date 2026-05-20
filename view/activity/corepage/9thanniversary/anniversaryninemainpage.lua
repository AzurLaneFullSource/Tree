local var0_0 = class("AnniversaryNineMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnGo = arg0_1.AD:Find("title/btn_act")
	arg0_1.btnManual = arg0_1.AD:Find("TopPage/top/manual")
	arg0_1.Txtmanual = arg0_1.btnManual:Find("Text")
	arg0_1.redPoint = arg0_1.btnGo:Find("red_point")
	arg0_1.redMalPoint = arg0_1.btnManual:Find("tip")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnGo, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MALL_MAP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnManual, function()
		local var0_4 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = FujinBayMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_4)
	end, SFX_PANEL)
	setText(arg0_2.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_2:refreshRed()
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:refreshRed()
end

function var0_0.refreshRed(arg0_6)
	setActive(arg0_6.redPoint, MallMapScene.IsEntranceTip())

	local var0_6, var1_6 = var0_0.GetFujinBayMedalTaskCount()

	setActive(arg0_6.redMalPoint, var1_6 > 0)
end

function var0_0.IsShowReminder(arg0_7)
	return var0_0.IsTip()
end

function var0_0.IsTip()
	return MallMapScene.IsEntranceTip() or var0_0.IsFujinBayMedalTaskTip()
end

function var0_0.IsFujinBayMedalTaskTip()
	local var0_9, var1_9 = var0_0.GetFujinBayMedalTaskCount()

	return var1_9 > 0
end

function var0_0.GetFujinBayMedalTaskCount()
	local var0_10 = FujinBayMedalAlbumView.GROUP_ID
	local var1_10 = pg.activity_medal_group[var0_10]
	local var2_10 = var1_10 and var1_10.activity_link or {}
	local var3_10

	for iter0_10, iter1_10 in ipairs(var2_10) do
		local var4_10 = iter1_10[2]
		local var5_10 = getProxy(ActivityProxy):getActivityById(var4_10)

		if var5_10 and not var5_10:isEnd() then
			var3_10 = iter1_10[3]

			break
		end
	end

	if not var3_10 then
		return 0, 0, 0
	end

	local var6_10 = getProxy(TaskProxy)
	local var7_10 = 0
	local var8_10 = 0
	local var9_10 = #var3_10

	for iter2_10, iter3_10 in ipairs(var3_10) do
		local var10_10 = var6_10:getTaskById(iter3_10) or var6_10:getFinishTaskById(iter3_10)

		if var10_10 then
			local var11_10 = var10_10:getTaskStatus()

			if var11_10 == 1 then
				var8_10 = var8_10 + 1
				var7_10 = var7_10 + 1
			elseif var11_10 == 2 then
				var7_10 = var7_10 + 1
			end
		end
	end

	return var7_10, var8_10, var9_10
end

return var0_0
