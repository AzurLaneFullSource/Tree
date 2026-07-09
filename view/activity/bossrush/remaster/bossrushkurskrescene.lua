local var0_0 = class("BossRushKurskReScene", import("..BossRushKurskScene"))
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
	return "BossRushKurskReUI"
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

function var0_0.CreateVirtualPtActivity(arg0_5, arg1_5)
	local var0_5 = arg1_5:getConfig("config_client")

	var0_5 = type(var0_5) == "table" and var0_5 or {}

	local var1_5 = var0_5.chapter_progress or {}
	local var2_5 = 0

	for iter0_5, iter1_5 in ipairs(arg1_5:GetActiveSeriesIds()) do
		if arg1_5:HasPassSeries(iter1_5) then
			var2_5 = math.max(var2_5, var1_5[iter0_5] or 0)
		end
	end

	return {
		data3 = 0,
		id = arg1_5.id,
		data1 = var2_5,
		data2 = pg.TimeMgr.GetInstance():GetServerTime(),
		data1_list = {},
		data2_list = {},
		data3_list = {},
		getDataConfig = function(arg0_6, arg1_6)
			return var1_0[arg1_6]
		end,
		isEnd = function()
			return false
		end
	}
end

return var0_0
