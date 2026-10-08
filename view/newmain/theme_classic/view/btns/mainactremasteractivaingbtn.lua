local var0_0 = class("MainActRemasterActivaingBtn", import(".MainActRemasterBtn"))

function var0_0.GetLinkConfig(arg0_1)
	local var0_1 = getProxy(ActivityRemasterProxy).activeActID
	local var1_1 = pg.activity_re[var0_1]
	local var2_1 = "event_actremaster"
	local var3_1 = "text_event_all"

	if var1_1 then
		var2_1 = var1_1.link_button_pic
		var3_1 = var1_1.link_button_text
	end

	return {
		param = "0",
		name = "event_actremaster",
		type = 3,
		id = 1,
		group_id = 1,
		order = 1,
		pic = var2_1,
		text_pic = var3_1,
		time = {
			"default",
			51033
		}
	}
end

function var0_0.InShowTime(arg0_2)
	arg0_2.config = arg0_2:GetLinkConfig()

	return getProxy(ActivityRemasterProxy):IsShowTime()
end

function var0_0.Register(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		local var0_4 = getProxy(ActivityRemasterProxy):GetActivaingReamsterData()

		if not var0_4 then
			arg0_3:emit(NewMainMediator.SKIP_ACTIVITY)
		else
			local var1_4 = var0_4:GetFirstOpenActId()

			arg0_3:emit(NewMainMediator.SKIP_ACTIVITY, var1_4)
		end
	end, SFX_MAIN)
end

function var0_0.OnInit(arg0_5)
	local var0_5 = getProxy(ActivityRemasterProxy).activeActID

	if not var0_5 then
		setActive(arg0_5.tipTr.gameObject, false)

		return
	end

	local var1_5 = pg.activity_re[var0_5]

	if not var1_5 then
		setActive(arg0_5.tipTr.gameObject, false)

		return
	end

	local var2_5 = _.map(var1_5.act_time, function(arg0_6)
		return arg0_6[1]
	end)
	local var3_5 = ""

	for iter0_5, iter1_5 in ipairs(var2_5) do
		local var4_5 = pg.activity_template[iter1_5]

		if var4_5 and var4_5.page_core and var4_5.page_core ~= "" then
			var3_5 = var4_5.page_core

			break
		end
	end

	if var3_5 == "" then
		setActive(arg0_5.tipTr.gameObject, false)

		return
	end

	local var5_5 = getProxy(ActivityProxy):getCorePanelActivities(var3_5)

	setActive(arg0_5.tipTr.gameObject, _.any(var5_5, function(arg0_7)
		return arg0_7:readyToAchieve()
	end))
end

return var0_0
