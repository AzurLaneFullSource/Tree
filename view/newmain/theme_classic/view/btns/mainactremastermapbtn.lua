local var0_0 = class("MainActRemasterMapBtn", import(".MainActMapBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_remaster_map"
end

function var0_0.GetLinkConfig(arg0_2)
	local var0_2 = getProxy(ActivityRemasterProxy):GetActiveActID()

	if not var0_2 or var0_2 <= 0 then
		return nil
	end

	return {
		param = "0",
		name = "event_remaster_map",
		type = 0,
		text_pic = "text_event_map",
		id = 1,
		group_id = 1,
		order = 1,
		pic = var0_2 .. "",
		time = {
			"default",
			51033
		}
	}
end

function var0_0.InShowTime(arg0_3)
	if not getProxy(ActivityRemasterProxy):IsActivating() then
		return false
	end

	local var0_3 = arg0_3:GetActivity()

	if not var0_3 or var0_3:isEnd() then
		return false
	end

	arg0_3.config = arg0_3:GetLinkConfig()

	return true
end

function var0_0.GetActivity(arg0_4)
	local var0_4 = {
		ActivityConst.ACTIVITY_TYPE_BOSSRUSH,
		ActivityConst.ACTIVITY_TYPE_ZPROJECT
	}
	local var1_4 = getProxy(ActivityRemasterProxy):GetActiveActID()
	local var2_4 = pg.activity_re[var1_4]

	for iter0_4, iter1_4 in ipairs(var2_4.act_id) do
		local var3_4 = pg.activity_template[iter1_4]

		if var3_4 and table.contains(var0_4, var3_4.type) then
			local var4_4 = getProxy(ActivityProxy):getActivityById(iter1_4)

			if var4_4 and not var4_4:isEnd() then
				return var4_4
			end
		end
	end

	return nil
end

function var0_0.ResPath(arg0_5)
	return "ActRemasterMapBtn"
end

return var0_0
