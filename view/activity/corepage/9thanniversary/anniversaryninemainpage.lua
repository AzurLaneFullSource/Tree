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
	if arg0_2:GetMallActOpen() then
		onButton(arg0_2, arg0_2.btnGo, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MALL_MAP)
		end, SFX_PANEL)
	else
		onButton(arg0_2, arg0_2.btnGo, function()
			arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, Context.New({
				mediator = MallAwardMediator,
				viewComponent = MallAwardLayer,
				data = {
					awardHandledByParent = true,
					onExit = function()
						arg0_2:refreshRed()
					end
				}
			}))
		end, SFX_PANEL)
	end

	onButton(arg0_2, arg0_2.btnManual, function()
		local var0_6 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = FujinBayMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_6)
	end, SFX_PANEL)
	setText(arg0_2.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_2:refreshRed()
end

function var0_0.GetMallActOpen(arg0_7)
	local var0_7 = arg0_7.coreActivityUI:GetActivityIdByPageClass("AnniversaryNineGamePage")
	local var1_7 = var0_7 and getProxy(ActivityProxy):getActivityById(var0_7)

	return var1_7 ~= nil and not var1_7:isEnd()
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8:refreshRed()
end

function var0_0.refreshRed(arg0_9)
	setActive(arg0_9.redPoint, var0_0.IsMallAwardTip())

	local var0_9, var1_9 = var0_0.GetFujinBayMedalTaskCount()

	setActive(arg0_9.redMalPoint, var1_9 > 0)
end

function var0_0.IsShowReminder(arg0_10)
	return var0_0.IsTip()
end

function var0_0.IsMallAwardTip()
	local var0_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	if not var0_11 or var0_11:isEnd() then
		return false
	end

	return MallAwardLayer.IsAwardTip() or MallAwardLayer.IsInputTip() or MallAwardLayer.IsTaskTip()
end

function var0_0.IsTip()
	return var0_0.IsMallAwardTip() or var0_0.IsFujinBayMedalTaskTip()
end

function var0_0.IsFujinBayMedalTaskTip()
	local var0_13, var1_13 = var0_0.GetFujinBayMedalTaskCount()

	return var1_13 > 0
end

function var0_0.GetFujinBayMedalTaskCount()
	local var0_14 = FujinBayMedalAlbumView.GROUP_ID
	local var1_14 = pg.activity_medal_group[var0_14]
	local var2_14 = var1_14 and var1_14.activity_link or {}
	local var3_14

	for iter0_14, iter1_14 in ipairs(var2_14) do
		local var4_14 = iter1_14[2]
		local var5_14 = getProxy(ActivityProxy):getActivityById(var4_14)

		if var5_14 and not var5_14:isEnd() then
			var3_14 = iter1_14[3]

			break
		end
	end

	if not var3_14 then
		return 0, 0, 0
	end

	local var6_14 = getProxy(TaskProxy)
	local var7_14 = 0
	local var8_14 = 0
	local var9_14 = #var3_14

	for iter2_14, iter3_14 in ipairs(var3_14) do
		local var10_14 = var6_14:getTaskById(iter3_14) or var6_14:getFinishTaskById(iter3_14)

		if var10_14 then
			local var11_14 = var10_14:getTaskStatus()

			if var11_14 == 1 then
				var8_14 = var8_14 + 1
				var7_14 = var7_14 + 1
			elseif var11_14 == 2 then
				var7_14 = var7_14 + 1
			end
		end
	end

	return var7_14, var8_14, var9_14
end

return var0_0
