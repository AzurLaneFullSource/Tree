local var0_0 = class("BossRushAlvitReScene", import("view.activity.BossRush.Alvit.BossRushAlvitScene"))
local var1_0 = {
	buff_time = "stop",
	unlock_story = "",
	drop_display = "",
	type = 1,
	end_time = "",
	pic_list = "",
	pt_list = "",
	id_2 = 0,
	link_id = 0,
	convert_pay = "",
	drop_client = {
		{
			1,
			1,
			0
		}
	},
	target = {
		999999999
	},
	day_unlock = {
		0
	},
	allplayer = {},
	target_buff = {},
	buff_group = {}
}

function var0_0.getUIName(arg0_1)
	return "BossRushAlvitReUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.ticketText = arg0_2._tf:Find("tickets/Text")
end

function var0_0.SetActivity(arg0_3, arg1_3)
	var0_0.super.SetActivity(arg0_3, arg1_3)
	arg0_3:SetPtActivity(arg0_3:CreateVirtualPtActivity(arg1_3))
end

function var0_0.UpdateBattle(arg0_4)
	var0_0.super.UpdateBattle(arg0_4)

	if arg0_4.ticketText then
		setText(arg0_4.ticketText, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	end
end

function var0_0.UpdateStoryTask(arg0_5)
	return
end

function var0_0.UpdateTpTip(arg0_6)
	setActive(arg0_6.ptTip, false)
end

function var0_0.onBackPressed(arg0_7)
	arg0_7:emit(BaseUI.ON_BACK)
end

function var0_0.CreateVirtualPtActivity(arg0_8, arg1_8)
	local var0_8 = arg1_8:getConfig("config_client")

	var0_8 = type(var0_8) == "table" and var0_8 or {}

	local var1_8 = var0_8.chapter_progress or {}
	local var2_8 = 0

	for iter0_8, iter1_8 in ipairs(arg1_8:GetActiveSeriesIds()) do
		if arg1_8:HasPassSeries(iter1_8) then
			var2_8 = math.max(var2_8, var1_8[iter0_8] or 0)
		end
	end

	return {
		data3 = 0,
		id = arg1_8.id,
		data1 = var2_8,
		data2 = pg.TimeMgr.GetInstance():GetServerTime(),
		data1_list = {},
		data2_list = {},
		data3_list = {},
		getDataConfig = function(arg0_9, arg1_9)
			return var1_0[arg1_9]
		end,
		isEnd = function()
			return false
		end
	}
end

return var0_0
