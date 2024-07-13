local var0_0 = class("AvatarFrameTask", import(".Task"))

var0_0.type_task_level = "task_level"
var0_0.type_task_ship = "task_ship"
var0_0.fillter_task_type = {
	var0_0.type_task_level,
	var0_0.type_task_ship
}

local var1_0 = var0_0.fillter_task_type
local var2_0 = "avatar_task_level"
local var3_0 = {
	"avatar_upgrad_1",
	"avatar_upgrad_2",
	"avatar_upgrad_3"
}
local var4_0 = "avatar_task_ship_1"
local var5_0 = "avatar_task_ship_2"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._actId = arg1_1
	arg0_1.configId = arg2_1
	arg0_1.id = arg3_1.id
	arg0_1.progress = arg3_1.progress or 0
	arg0_1.acceptTime = arg3_1.accept_time or 0
	arg0_1.submitTime = arg3_1.submit_time or 0
end

function var0_0.IsActEnd(arg0_2)
	local var0_2 = pg.activity_event_avatarframe[arg0_2.configId].link_event
	local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

	return not var1_2 or var1_2:isEnd()
end

function var0_0.updateProgress(arg0_3, arg1_3)
	arg0_3.progress = arg1_3 or 0
end

function var0_0.isFinish(arg0_4)
	return arg0_4:getProgress() >= arg0_4:getConfig("target_num")
end

function var0_0.getProgress(arg0_5)
	return arg0_5.progress or 0
end

function var0_0.isReceive(arg0_6)
	return false
end

function var0_0.getTaskStatus(arg0_7)
	if arg0_7.progress >= arg0_7:getConfig("target_num") then
		return 1
	end

	return 0
end

function var0_0.onAdded(arg0_8)
	return
end

function var0_0.updateProgress(arg0_9, arg1_9)
	arg0_9.progress = arg1_9
end

function var0_0.isSelectable(arg0_10)
	return false
end

function var0_0.judgeOverflow(arg0_11, arg1_11, arg2_11, arg3_11)
	return false, false
end

function var0_0.IsUrTask(arg0_12)
	return false
end

function var0_0.GetRealType(arg0_13)
	return 6
end

function var0_0.IsOverflowShipExpItem(arg0_14)
	return false
end

function var0_0.ShowOnTaskScene(arg0_15)
	return true
end

function var0_0.getConfig(arg0_16, arg1_16)
	if not arg0_16.configData then
		local var0_16 = pg.activity_event_avatarframe[arg0_16.configId]

		if not var0_16 then
			print("avatart id = " .. arg0_16.configId .. " is not found")

			return
		end

		local var1_16 = arg0_16:getTypeData(var0_16, arg0_16.id)

		if not var1_16 then
			return
		end

		local var2_16 = Clone(var0_16.award_display)

		var2_16[1][3] = var1_16.award_num
		arg0_16.configData = {
			level = 1,
			sub_type = 0,
			item_id = var0_16.pt_id,
			desc = var1_16.desc,
			target_num = var1_16.target_num,
			award_num = var1_16.award_num,
			scene = var1_16.scene,
			award_display = var2_16
		}
	end

	return arg0_16.configData[arg1_16]
end

function var0_0.getTypeData(arg0_17, arg1_17, arg2_17)
	for iter0_17 = 1, #var1_0 do
		local var0_17 = var1_0[iter0_17]
		local var1_17 = arg1_17[var0_17]

		for iter1_17, iter2_17 in ipairs(var1_17) do
			if iter2_17[1] == arg2_17 then
				arg0_17.avatarType = var0_17

				return arg0_17:createData(var0_17, iter2_17)
			end
		end
	end
end

function var0_0.isAvatarTask(arg0_18)
	return true
end

function var0_0.getActId(arg0_19)
	return arg0_19._actId
end

function var0_0.createData(arg0_20, arg1_20, arg2_20)
	local var0_20

	if arg1_20 == var0_0.type_task_level then
		local var1_20, var2_20, var3_20, var4_20, var5_20, var6_20 = unpack(arg2_20)
		local var7_20 = ""

		if var3_20 > 0 and var3_20 <= #var3_0 then
			var7_20 = pg.gametip[var3_0[var3_20]].tip
		end

		local var8_20 = var2_20 * 10 + 1
		local var9_20 = pg.ship_data_statistics[var8_20].name
		local var10_20
		local var11_20

		for iter0_20, iter1_20 in ipairs(var4_20) do
			assert(pg.chapter_template[iter1_20] ~= nil, "找不到chapterid = " .. iter1_20)

			var11_20 = var11_20 or {
				"ACTIVITY_MAP",
				{
					pg.chapter_template[iter1_20].act_id
				}
			}

			if not var10_20 then
				var10_20 = pg.chapter_template[iter1_20].chapter_name
			else
				var10_20 = var10_20 .. "," .. pg.chapter_template[iter1_20].chapter_name
			end
		end

		var0_20 = {
			target_num = var5_20,
			award_num = var6_20,
			scene = var11_20,
			desc = i18n("avatar_task_level", var7_20, var9_20, var10_20, var5_20)
		}
	elseif arg1_20 == var0_0.type_task_ship then
		local var12_20, var13_20, var14_20, var15_20 = unpack(arg2_20)
		local var16_20 = var13_20 * 10 + 1
		local var17_20 = pg.ship_data_statistics[var16_20].name

		if var14_20 == 1 then
			var0_20 = {
				award_num = var15_20,
				desc = i18n(var4_0, var17_20)
			}
		elseif var14_20 == 2 then
			var0_20 = {
				award_num = var15_20,
				desc = i18n(var5_0, var17_20),
				scene = {
					"DOCKYARD",
					{
						mode = "overview"
					}
				}
			}
		end
	end

	return setmetatable(var0_20, {
		__index = {
			award_num = 1,
			target_num = 1,
			desc = ""
		}
	})
end

return var0_0
