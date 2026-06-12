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
	onButton(arg0_2, arg0_2.btnManual, function()
		local var0_5 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = FujinBayMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_5)
	end, SFX_PANEL)
	setText(arg0_2.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_2:refreshRed()
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:refreshRed()
end

function var0_0.refreshRed(arg0_7)
	setActive(arg0_7.redPoint, var0_0.IsMallAwardTip())

	local var0_7, var1_7 = var0_0.GetFujinBayMedalTaskCount()

	setActive(arg0_7.redMalPoint, var1_7 > 0)
end

function var0_0.IsShowReminder(arg0_8)
	return var0_0.IsTip()
end

function var0_0.IsMallAwardTip()
	local var0_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	if not var0_9 or var0_9:isEnd() then
		return false
	end

	return MallAwardLayer.IsAwardTip() or MallAwardLayer.IsInputTip() or MallAwardLayer.IsTaskTip()
end

function var0_0.IsTip()
	return var0_0.IsMallAwardTip() or var0_0.IsFujinBayMedalTaskTip()
end

function var0_0.IsFujinBayMedalTaskTip()
	local var0_11, var1_11 = var0_0.GetFujinBayMedalTaskCount()

	return var1_11 > 0
end

function var0_0.GetFujinBayMedalTaskCount()
	local var0_12 = FujinBayMedalAlbumView.GROUP_ID
	local var1_12 = pg.activity_medal_group[var0_12]
	local var2_12 = var1_12 and var1_12.activity_link or {}
	local var3_12

	for iter0_12, iter1_12 in ipairs(var2_12) do
		local var4_12 = iter1_12[2]
		local var5_12 = getProxy(ActivityProxy):getActivityById(var4_12)

		if var5_12 and not var5_12:isEnd() then
			var3_12 = iter1_12[3]

			break
		end
	end

	if not var3_12 then
		return 0, 0, 0
	end

	local var6_12 = getProxy(TaskProxy)
	local var7_12 = 0
	local var8_12 = 0
	local var9_12 = #var3_12

	for iter2_12, iter3_12 in ipairs(var3_12) do
		local var10_12 = var6_12:getTaskById(iter3_12) or var6_12:getFinishTaskById(iter3_12)

		if var10_12 then
			local var11_12 = var10_12:getTaskStatus()

			if var11_12 == 1 then
				var8_12 = var8_12 + 1
				var7_12 = var7_12 + 1
			elseif var11_12 == 2 then
				var7_12 = var7_12 + 1
			end
		end
	end

	return var7_12, var8_12, var9_12
end

return var0_0
