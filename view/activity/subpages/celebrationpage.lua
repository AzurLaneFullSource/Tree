local var0_0 = class("CelebrationPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtMarks = arg0_1._tf:Find("AD/progress")
	arg0_1.rtFinish = arg0_1._tf:Find("AD/award")
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
		local var0_4 = Context.New({
			mediator = HolidayVillaShopMediator,
			viewComponent = HolidayVillaShopLayer
		})

		arg0_3:emit(ActivityMediator.OPEN_LAYER, var0_4)
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
	local var0_6 = arg0_6.ptData:GetCurrTarget()
	local var1_6 = arg0_6.ptData:GetLevel()
	local var2_6 = arg0_6.rtMarks.childCount

	for iter0_6 = 1, var2_6 do
		local var3_6 = arg0_6.rtMarks:GetChild(iter0_6 - 1)

		setActive(var3_6:Find("icon"), iter0_6 <= var0_6)
		setActive(var3_6:Find("mark"), var0_6 < iter0_6)
	end

	setActive(arg0_6.rtBtns:Find("get"), var1_6 == 0 and var0_6 >= 7)
	setActive(arg0_6.rtBtns:Find("got"), var1_6 > 0)
	setActive(arg0_6.rtBtns:Find("go"), var0_6 < 7)
	setActive(arg0_6.rtBtns:Find("red"), var1_6 == 0 and var0_6 >= 7 and var1_6 ~= 1)
end

return var0_0
