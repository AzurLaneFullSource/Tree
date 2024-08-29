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

function var0_0.setTaskFinish(arg0_9)
	arg0_9.submitTime = 1

	arg0_9:updateProgress(arg0_9:getConfig("target_num"))
end

function var0_0.updateProgress(arg0_10, arg1_10)
	arg0_10.progress = arg1_10
end

function var0_0.isSelectable(arg0_11)
	return false
end

function var0_0.judgeOverflow(arg0_12, arg1_12, arg2_12, arg3_12)
	return false, false
end

function var0_0.IsUrTask(arg0_13)
	return false
end

function var0_0.GetRealType(arg0_14)
	return 6
end

function var0_0.IsOverflowShipExpItem(arg0_15)
	return false
end

function var0_0.ShowOnTaskScene(arg0_16)
	return true
end

function var0_0.getConfig(arg0_17, arg1_17)
	if not arg0_17.configData then
		local var0_17 = pg.activity_event_avatarframe[arg0_17.configId]

		if not var0_17 then
			print("avatart id = " .. arg0_17.configId .. " is not found")

			return
		end

		local var1_17 = arg0_17:getTypeData(var0_17, arg0_17.id)

		if not var1_17 then
			return
		end

		local var2_17 = Clone(var0_17.award_display)

		var2_17[1][3] = var1_17.award_num
		arg0_17.configData = {
			level = 1,
			sub_type = 0,
			item_id = var0_17.pt_id,
			desc = var1_17.desc,
			target_num = var1_17.target_num,
			award_num = var1_17.award_num,
			scene = var1_17.scene,
			award_display = var2_17
		}
	end

	return arg0_17.configData[arg1_17]
end

function var0_0.getTypeData(arg0_18, arg1_18, arg2_18)
	for iter0_18 = 1, #var1_0 do
		local var0_18 = var1_0[iter0_18]
		local var1_18 = arg1_18[var0_18]

		for iter1_18, iter2_18 in ipairs(var1_18) do
			if iter2_18[1] == arg2_18 then
				arg0_18.avatarType = var0_18

				return arg0_18:createData(var0_18, iter2_18)
			end
		end
	end
end

function var0_0.isAvatarTask(arg0_19)
	return true
end

function var0_0.getActId(arg0_20)
	return arg0_20._actId
end

function var0_0.createData(arg0_21, arg1_21, arg2_21)
	local var0_21

	if arg1_21 == var0_0.type_task_level then
		local var1_21, var2_21, var3_21, var4_21, var5_21, var6_21 = unpack(arg2_21)
		local var7_21 = ""

		if var3_21 > 0 and var3_21 <= #var3_0 then
			var7_21 = pg.gametip[var3_0[var3_21]].tip
		end

		local var8_21 = var2_21 * 10 + 1
		local var9_21 = pg.ship_data_statistics[var8_21].name
		local var10_21
		local var11_21

		for iter0_21, iter1_21 in ipairs(var4_21) do
			assert(pg.chapter_template[iter1_21] ~= nil, "找不到chapterid = " .. iter1_21)

			var11_21 = var11_21 or {
				"ACTIVITY_MAP",
				{
					pg.chapter_template[iter1_21].act_id
				}
			}

			if not var10_21 then
				var10_21 = pg.chapter_template[iter1_21].chapter_name
			else
				var10_21 = var10_21 .. "," .. pg.chapter_template[iter1_21].chapter_name
			end
		end

		var0_21 = {
			target_num = var5_21,
			award_num = var6_21,
			scene = var11_21,
			desc = i18n("avatar_task_level", var7_21, var9_21, var10_21, var5_21)
		}
	elseif arg1_21 == var0_0.type_task_ship then
		local var12_21, var13_21, var14_21, var15_21 = unpack(arg2_21)
		local var16_21 = var13_21 * 10 + 1
		local var17_21 = pg.ship_data_statistics[var16_21].name

		if var14_21 == 1 then
			var0_21 = {
				award_num = var15_21,
				desc = i18n(var4_0, var17_21)
			}
		elseif var14_21 == 2 then
			var0_21 = {
				award_num = var15_21,
				desc = i18n(var5_0, var17_21),
				scene = {
					"DOCKYARD",
					{
						mode = "overview"
					}
				}
			}
		end
	end

	return setmetatable(var0_21, {
		__index = {
			award_num = 1,
			target_num = 1,
			desc = ""
		}
	})
end

return var0_0
