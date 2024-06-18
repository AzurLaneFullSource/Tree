local var0_0 = class("AnniversarySixInvitationPage", import("...base.BaseActivityPage"))

function var0_0.OnDataSetting(arg0_1)
	if arg0_1.ptData then
		arg0_1.ptData:Update(arg0_1.activity)
	else
		arg0_1.ptData = ActivityPtData.New(arg0_1.activity)
	end
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.rtMarks = arg0_2._tf:Find("AD/progress")
	arg0_2.rtFinish = arg0_2._tf:Find("AD/award")

	local var0_2 = arg0_2._tf:Find("AD/btn_list")

	onButton(arg0_2, var0_2:Find("go"), function()
		local var0_3 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_4)
			return arg0_4:getConfig("config_id") == 3
		end)

		if not var0_3 or var0_3:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		local var1_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		if var1_3 and not var1_3:isEnd() then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				wraps = SixthAnniversaryIslandScene.SHOP
			})
		else
			arg0_2:emit(ActivityMediator.OPEN_LAYER, Context.New({
				mediator = SixthAnniversaryIslandShopMediator,
				viewComponent = SixthAnniversaryIslandShopLayer
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_2, var0_2:Find("get"), function()
		local var0_5, var1_5 = arg0_2.ptData:GetResProgress()

		arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.ptData:GetId(),
			arg1 = var1_5
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6, var1_6 = arg0_6.ptData:GetResProgress()
	local var2_6 = arg0_6.ptData:CanGetAward()
	local var3_6 = arg0_6.ptData:CanGetNextAward()
	local var4_6 = arg0_6._tf:Find("AD/btn_list")

	setActive(var4_6:Find("get"), var2_6)
	setActive(var4_6:Find("got"), not var3_6)
	setActive(var4_6:Find("go"), not var2_6 and var3_6)

	if var3_6 then
		var0_6 = math.min(var0_6, var1_6)
	else
		var0_6 = var1_6 + 1
	end

	local var5_6 = arg0_6.rtMarks.childCount

	for iter0_6 = 1, var5_6 do
		local var6_6 = arg0_6.rtMarks:GetChild(iter0_6 - 1)

		setActive(var6_6:Find("mark"), iter0_6 < var0_6)
		setActive(var6_6:Find("icon"), iter0_6 == var0_6)
	end

	setGray(arg0_6.rtFinish:Find("Image"), not var3_6)
	setActive(arg0_6.rtFinish:Find("got"), not var3_6)
end

return var0_0
