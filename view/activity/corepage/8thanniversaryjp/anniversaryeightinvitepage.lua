local var0_0 = class("AnniversaryEightInvitePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtMarks = arg0_1._tf:Find("AD/image_02/progress")
	arg0_1.rtFinish = arg0_1._tf:Find("AD/image_02/award")
	arg0_1.rtBtns = arg0_1._tf:Find("AD/btn_list")
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.rtBtns:Find("go"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CITY_REBUILD_MAP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rtBtns:Find("get"), function()
		local var0_5 = arg0_3.ptData:GetCurrTarget()

		arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 4,
			activity_id = arg0_3.ptData:GetId(),
			arg1 = var0_5
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6.ptData:GetResProgress()
	local var3_6 = arg0_6.rtMarks.childCount
	local var4_6 = arg0_6.ptData:GetDroptItemState(arg0_6.ptData:GetCurrLevel())

	for iter0_6 = 1, var3_6 do
		local var5_6 = arg0_6.rtMarks:GetChild(iter0_6 - 1)

		setActive(var5_6:Find("mark"), iter0_6 <= var0_6)
	end

	setActive(arg0_6.rtBtns:Find("get"), var4_6 == ActivityPtData.STATE_CAN_GET and var1_6 <= var0_6)
	setActive(arg0_6.rtBtns:Find("got"), var4_6 == ActivityPtData.STATE_GOT and var1_6 <= var0_6)
	setActive(arg0_6.rtBtns:Find("red"), var4_6 == ActivityPtData.STATE_CAN_GET and var1_6 <= var0_6)
	setActive(arg0_6.rtBtns:Find("go"), var0_6 < var1_6)
	setActive(arg0_6.rtFinish, var4_6 == ActivityPtData.STATE_GOT)
end

return var0_0
