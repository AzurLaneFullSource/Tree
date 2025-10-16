local var0_0 = class("HolidayVillaWharfLayer", import("view.base.BaseUI"))
local var1_0 = pg.activity_holiday_trans

function var0_0.getUIName(arg0_1)
	return "HolidayVillaWharfUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.closeBtn = arg0_2._tf:Find("closeBtn")
	arg0_2.res = arg0_2._tf:Find("res")
	arg0_2.wharfResCount = arg0_2._tf:Find("frame/resNum")
	arg0_2.transportList = arg0_2._tf:Find("frame/transportList")
	arg0_2.transportCompletePage = arg0_2._tf:Find("transportCompletePage")

	setText(arg0_2._tf:Find("frame/nameBg/name"), i18n("holiday_tip_trans_tip"))
	setText(arg0_2._tf:Find("frame/resDesc"), i18n("holiday_tip_trans_get"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:RefreshData()
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3:Show()
	setActive(arg0_3.transportCompletePage, false)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.InitData(arg0_6)
	arg0_6.activityId = ActivityConst.HOLIDAY_ACT_ID
	arg0_6.taskActivityId = ActivityConst.HOLIDAY_TASK_ID
	arg0_6.activityProxy = getProxy(ActivityProxy)
	arg0_6.taskProxy = getProxy(TaskProxy)
	arg0_6.activity = arg0_6.activityProxy:getActivityById(arg0_6.activityId)
	arg0_6.transTaskIds = arg0_6.activity:getConfig("config_client").task_trans
end

function var0_0.RefreshData(arg0_7)
	arg0_7.activity = arg0_7.activityProxy:getActivityById(arg0_7.activityId)
end

function var0_0.Show(arg0_8)
	local var0_8 = {
		{
			66001,
			arg0_8.activity:getVitemNumber(66001)
		},
		{
			66002,
			arg0_8.activity:getVitemNumber(66002)
		},
		{
			66003,
			arg0_8.activity:getVitemNumber(66003)
		},
		{
			66004,
			arg0_8.activity:getVitemNumber(66004)
		}
	}

	arg0_8:SetRes(arg0_8.res, var0_8)
	setText(arg0_8.wharfResCount, arg0_8.activity:getVitemNumber(66006))

	local var1_8 = true

	for iter0_8, iter1_8 in ipairs(arg0_8.transTaskIds) do
		if not arg0_8.taskProxy:getFinishTaskById(iter1_8) then
			var1_8 = false

			break
		end
	end

	if not var1_8 then
		setText(arg0_8._tf:Find("frame/desc"), i18n("holiday_tip_trans_desc1"))
		arg0_8:SetTransList(1)
	else
		setText(arg0_8._tf:Find("frame/desc"), i18n("holiday_tip_trans_desc2"))
		arg0_8:SetTransList(2)
	end
end

function var0_0.SetTransList(arg0_9, arg1_9)
	local var0_9 = arg0_9.transportList:Find("smallTransport")
	local var1_9 = arg0_9.transportList:Find("middleTransport")
	local var2_9 = arg0_9.transportList:Find("bigTransport")
	local var3_9 = arg0_9.transportList:Find("touristTransport")

	setActive(var0_9, arg1_9 == 1)
	setActive(var1_9, arg1_9 == 1)
	setActive(var2_9, arg1_9 == 1)
	setActive(var3_9, arg1_9 == 2)

	if arg1_9 == 1 then
		arg0_9:SetTransport(var0_9, var1_0[1])
		arg0_9:SetTransport(var1_9, var1_0[2])
		arg0_9:SetTransport(var2_9, var1_0[3])
	elseif arg1_9 == 2 then
		arg0_9:SetTransport(var3_9, var1_0[4])
	end
end

function var0_0.SetTransport(arg0_10, arg1_10, arg2_10)
	setText(arg1_10:Find("name"), arg2_10.name)
	LoadImageSpriteAsync(arg2_10.icon, arg1_10:Find("picture"))

	local var0_10 = arg0_10.taskProxy:getTaskById(arg2_10.cost_task_id):getConfig("target_id_2")[1][2]

	setText(arg1_10:Find("resConsume"), var0_10)

	local var1_10 = Clone(arg2_10.award)

	for iter0_10, iter1_10 in ipairs(var1_10) do
		table.remove(iter1_10, 1)
	end

	arg0_10:SetRes(arg1_10:Find("awards"), var1_10)
	onButton(arg0_10, arg1_10, function()
		if arg0_10.activity:getVitemNumber(66006) < var0_10 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("holiday_tip_trans_not"))

			return
		end

		arg0_10.doingTransCfg = arg2_10

		arg0_10:emit(HolidayVillaWharfMediator.ON_TASK_SUBMIT_ONESTEP, arg0_10.taskActivityId, {
			arg2_10.cost_task_id
		})
	end, SFX_PANEL)
end

function var0_0.SetRes(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 0, arg1_12.childCount - 1 do
		setActive(arg1_12:GetChild(iter0_12), false)
	end

	for iter1_12, iter2_12 in ipairs(arg2_12) do
		local var0_12 = iter2_12[1]
		local var1_12 = iter2_12[2]

		for iter3_12 = 0, arg1_12.childCount - 1 do
			local var2_12 = arg1_12:GetChild(iter3_12)

			if var2_12.name == tostring(var0_12) then
				setActive(var2_12, true)
				setText(var2_12:Find("Text"), var1_12)
			end
		end
	end
end

function var0_0.ShowCompletePage(arg0_13)
	setActive(arg0_13.transportCompletePage, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13.transportCompletePage)
	SetAction(arg0_13.transportCompletePage:Find("ani"), "normal" .. arg0_13.doingTransCfg.id, false)
	setText(arg0_13.transportCompletePage:Find("desc/Text"), arg0_13.doingTransCfg.result_desc)
	setActive(arg0_13.transportCompletePage:Find("desc/triangle"), false)

	local var0_13 = GetOrAddComponent(arg0_13.transportCompletePage:Find("desc/Text"), typeof(Typewriter))

	var0_13:setSpeed(0.05)

	function var0_13.endFunc()
		setActive(arg0_13.transportCompletePage:Find("desc/triangle"), true)
	end

	var0_13:Play()
	onButton(arg0_13, arg0_13.transportCompletePage:Find("bg"), function()
		setActive(arg0_13.transportCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13.transportCompletePage, arg0_13._tf)

		if not arg0_13.hasShowedAwards and #arg0_13.awards > 0 then
			arg0_13.hasShowedAwards = true

			arg0_13:emit(BaseUI.ON_ACHIEVE, arg0_13.awards)
		end
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.transportCompletePage:Find("desc"), function()
		setActive(arg0_13.transportCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13.transportCompletePage, arg0_13._tf)

		if not arg0_13.hasShowedAwards and #arg0_13.awards > 0 then
			arg0_13.hasShowedAwards = true

			arg0_13:emit(BaseUI.ON_ACHIEVE, arg0_13.awards)
		end
	end, SFX_CANCEL)
end

function var0_0.SetAwardsShow(arg0_17, arg1_17)
	arg0_17.awards = arg1_17
	arg0_17.hasShowedAwards = false
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18._tf, arg0_18._parentTf)
end

function var0_0.onBackPressed(arg0_19)
	if isActive(arg0_19.transportCompletePage) then
		setActive(arg0_19.transportCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19.transportCompletePage, arg0_19._tf)

		if not arg0_19.hasShowedAwards and #arg0_19.awards > 0 then
			arg0_19.hasShowedAwards = true

			arg0_19:emit(BaseUI.ON_ACHIEVE, arg0_19.awards)
		end

		return
	end

	arg0_19:closeView()
end

return var0_0
