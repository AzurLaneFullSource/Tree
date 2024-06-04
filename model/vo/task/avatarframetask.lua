local var0 = class("AvatarFrameTask", import(".Task"))

var0.type_task_level = "task_level"
var0.type_task_ship = "task_ship"
var0.fillter_task_type = {
	var0.type_task_level,
	var0.type_task_ship
}

local var1 = var0.fillter_task_type
local var2 = "avatar_task_level"
local var3 = {
	"avatar_upgrad_1",
	"avatar_upgrad_2",
	"avatar_upgrad_3"
}
local var4 = "avatar_task_ship_1"
local var5 = "avatar_task_ship_2"

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.actId = arg1
	arg0.configId = arg2
	arg0.id = arg3.id
	arg0.progress = arg3.progress or 0
	arg0.acceptTime = arg3.accept_time or 0
	arg0.submitTime = arg3.submit_time or 0
end

function var0.IsActEnd(arg0)
	local var0 = pg.activity_event_avatarframe[arg0.configId].link_event
	local var1 = getProxy(ActivityProxy):getActivityById(var0)

	return not var1 or var1:isEnd()
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1 or 0
end

function var0.isFinish(arg0)
	return arg0:getProgress() >= arg0:getConfig("target_num")
end

function var0.getProgress(arg0)
	return arg0.progress or 0
end

function var0.isReceive(arg0)
	return false
end

function var0.getTaskStatus(arg0)
	if arg0.progress >= arg0:getConfig("target_num") then
		return 1
	end

	return 0
end

function var0.onAdded(arg0)
	return
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.isSelectable(arg0)
	return false
end

function var0.judgeOverflow(arg0, arg1, arg2, arg3)
	return false, false
end

function var0.IsUrTask(arg0)
	return false
end

function var0.GetRealType(arg0)
	return 6
end

function var0.IsOverflowShipExpItem(arg0)
	return false
end

function var0.ShowOnTaskScene(arg0)
	return true
end

function var0.getConfig(arg0, arg1)
	if not arg0.configData then
		local var0 = pg.activity_event_avatarframe[arg0.configId]

		if not var0 then
			print("avatart id = " .. arg0.configId .. " is not found")

			return
		end

		local var1 = arg0:getTypeData(var0, arg0.id)

		if not var1 then
			return
		end

		local var2 = Clone(var0.award_display)

		var2[1][3] = var1.award_num
		arg0.configData = {
			level = 1,
			sub_type = 0,
			item_id = var0.pt_id,
			desc = var1.desc,
			target_num = var1.target_num,
			award_num = var1.award_num,
			scene = var1.scene,
			award_display = var2
		}
	end

	return arg0.configData[arg1]
end

function var0.getTypeData(arg0, arg1, arg2)
	for iter0 = 1, #var1 do
		local var0 = var1[iter0]
		local var1 = arg1[var0]

		for iter1, iter2 in ipairs(var1) do
			if iter2[1] == arg2 then
				arg0.avatarType = var0

				return arg0:createData(var0, iter2)
			end
		end
	end
end

function var0.isAvatarTask(arg0)
	return true
end

function var0.createData(arg0, arg1, arg2)
	local var0

	if arg1 == var0.type_task_level then
		local var1, var2, var3, var4, var5, var6 = unpack(arg2)
		local var7 = ""

		if var3 > 0 and var3 <= #var3 then
			var7 = pg.gametip[var3[var3]].tip
		end

		local var8 = var2 * 10 + 1
		local var9 = pg.ship_data_statistics[var8].name
		local var10
		local var11

		for iter0, iter1 in ipairs(var4) do
			assert(pg.chapter_template[iter1] ~= nil, "找不到chapterid = " .. iter1)

			var11 = var11 or {
				"ACTIVITY_MAP",
				{
					pg.chapter_template[iter1].act_id
				}
			}

			if not var10 then
				var10 = pg.chapter_template[iter1].chapter_name
			else
				var10 = var10 .. "," .. pg.chapter_template[iter1].chapter_name
			end
		end

		var0 = {
			target_num = var5,
			award_num = var6,
			scene = var11,
			desc = i18n("avatar_task_level", var7, var9, var10, var5)
		}
	elseif arg1 == var0.type_task_ship then
		local var12, var13, var14, var15 = unpack(arg2)
		local var16 = var13 * 10 + 1
		local var17 = pg.ship_data_statistics[var16].name

		if var14 == 1 then
			var0 = {
				award_num = var15,
				desc = i18n(var4, var17)
			}
		elseif var14 == 2 then
			var0 = {
				award_num = var15,
				desc = i18n(var5, var17),
				scene = {
					"DOCKYARD",
					{
						mode = "overview"
					}
				}
			}
		end
	end

	return setmetatable(var0, {
		__index = {
			award_num = 1,
			target_num = 1,
			desc = ""
		}
	})
end

return var0
