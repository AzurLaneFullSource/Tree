local var0_0 = class("WSEntranceTpl", import("...BaseEntity"))

var0_0.Fields = {
	markSigns = "table",
	portCamp = "number",
	world = "table",
	transform = "userdata",
	tfMap = "userdata",
	entrance = "table",
	markTFs = "table",
	tfArea = "userdata"
}
var0_0.Listeners = {
	onUpdateDisplayMarks = "OnUpdateDisplayMarks"
}
var0_0.DisplayOrder = {
	"step",
	"task_main",
	"task_collecktion",
	"task",
	"sairen",
	"treasure_sairen",
	"treasure",
	"task_following_main",
	"task_following_boss",
	"task_following"
}
var0_0.prefabName = {
	task_main = "DSJ_BX05_3D",
	buff_a = "buff_a",
	port_gray_2 = "mark_port_gray_2",
	buff_h = "buff_h",
	port_mark_new = "mark_port_tip_new",
	port_2 = "mark_port_2",
	buff_d = "buff_d",
	task_following_main = "DSJ_BX05_3D",
	step = "DSJ_BX05_3D",
	task = "DSJ_BX03_3D",
	treasure_sairen = "DSJ_BX06_3D",
	task_following_boss = "DSJ_BX07_3D",
	buff_d2 = "buff_d2",
	currency = "currency",
	port_gray_1 = "mark_port_gray_1",
	port_1 = "mark_port_1",
	mate = "mate",
	buff_a2 = "buff_a2",
	task_collecktion = "DSJ_BX08_3D",
	task_following = "DSJ_BX03_3D",
	treasure = "DSJ_BX01_3D",
	sairen = "guangzhu",
	core = "core",
	buff_h2 = "buff_h2",
	port_mark = "mark_port_tip"
}
var0_0.offsetField = {
	task_main = "offset_pos",
	task = "offset_pos",
	treasure_sairen = "offset_pos",
	step = "offset_pos",
	task_collecktion = "offset_pos",
	task_following = "offset_pos",
	treasure = "offset_pos",
	task_following_main = "offset_pos",
	task_following_boss = "offset_pos"
}

function var0_0.Build(arg0_1)
	arg0_1.transform = tf(GameObject.New())
end

function var0_0.Setup(arg0_2)
	pg.DelegateInfo.New(arg0_2)
	arg0_2:Init()
end

function var0_0.Dispose(arg0_3)
	pg.DelegateInfo.Dispose(arg0_3)
	arg0_3:RemoveEntranceListener()

	local var0_3 = PoolMgr.GetInstance()

	for iter0_3, iter1_3 in pairs(arg0_3.markTFs) do
		iter1_3.localPosition = Vector3.zero

		var0_3:ReturnPrefab("world/mark/" .. var0_0.prefabName[iter0_3], var0_0.prefabName[iter0_3], go(iter1_3), true)
	end

	Destroy(arg0_3.transform)
	arg0_3:Clear()
end

function var0_0.Init(arg0_4)
	arg0_4.markTFs = {}
end

function var0_0.UpdateEntrance(arg0_5, arg1_5, arg2_5)
	if arg2_5 or arg0_5.entrance ~= arg1_5 then
		arg0_5:RemoveEntranceListener()
		_.each(arg0_5.markTFs, function(arg0_6)
			setActive(arg0_6, false)
		end)

		arg0_5.entrance = arg1_5
		arg0_5.portCamp = arg0_5.entrance:HasPort() and pg.world_port_data[arg0_5.entrance.config.port_map_icon].port_camp or nil

		arg0_5:AddEntranceListener()
		arg0_5:InitMarksValue()

		arg0_5.transform.name = arg0_5.portCamp and "port_" .. arg1_5.id or arg1_5:GetColormaskUniqueID()

		arg0_5:DoUpdateMark(arg0_5:GetShowMark(), true)
	end
end

function var0_0.InitMarksValue(arg0_7)
	arg0_7.markSigns = {}

	local var0_7 = arg0_7.entrance:GetDisplayMarks()

	for iter0_7, iter1_7 in pairs(var0_7) do
		arg0_7.markSigns[iter0_7] = iter1_7 > 0
	end
end

function var0_0.AddEntranceListener(arg0_8)
	if arg0_8.entrance then
		arg0_8.entrance:AddListener(WorldEntrance.EventUpdateDisplayMarks, arg0_8.onUpdateDisplayMarks)
	end
end

function var0_0.RemoveEntranceListener(arg0_9)
	if arg0_9.entrance then
		arg0_9.entrance:RemoveListener(WorldEntrance.EventUpdateDisplayMarks, arg0_9.onUpdateDisplayMarks)
	end
end

function var0_0.LoadPrefab(arg0_10, arg1_10, arg2_10)
	local var0_10 = PoolMgr.GetInstance()

	var0_10:GetPrefab("world/mark/" .. var0_0.prefabName[arg1_10], var0_0.prefabName[arg1_10], true, function(arg0_11)
		if arg0_10.markTFs and not arg0_10.markTFs[arg1_10] then
			arg0_10.markTFs[arg1_10] = tf(arg0_11)

			SetParent(arg0_10.markTFs[arg1_10], arg0_10.transform, false)

			arg0_10.markTFs[arg1_10].localPosition = arg0_10:GetPrefabOffset(arg1_10)

			if arg2_10 then
				SetParent(arg0_10.markTFs[arg1_10], arg2_10, true)
			end

			setActive(arg0_10.markTFs[arg1_10], true)
		else
			var0_10:ReturnPrefab("world/mark/" .. var0_0.prefabName[arg1_10], var0_0.prefabName[arg1_10], arg0_11, true)
		end
	end)
end

function var0_0.GetPrefabOffset(arg0_12, arg1_12)
	local var0_12 = var0_0.offsetField[arg1_12] and arg0_12.entrance.config[var0_0.offsetField[arg1_12]] or {
		0,
		0
	}

	return Vector3(var0_12[1] / PIXEL_PER_UNIT, 0, var0_12[2] / PIXEL_PER_UNIT)
end

function var0_0.UpdateMark(arg0_13, arg1_13, arg2_13)
	arg0_13:DoUpdateMark(arg0_13:GetShowMark(), false)

	arg0_13.markSigns[arg1_13] = arg2_13

	arg0_13:DoUpdateMark(arg0_13:GetShowMark(), true)
end

function var0_0.OnUpdateDisplayMarks(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	arg0_14:UpdateMark(arg3_14, arg4_14)
end

function var0_0.DoUpdateMark(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg1_15 then
		if arg0_15.markTFs[arg1_15] then
			setActive(arg0_15.markTFs[arg1_15], arg2_15)
		elseif arg2_15 then
			arg0_15:LoadPrefab(arg1_15, arg3_15)
		end
	end
end

function var0_0.GetShowMark(arg0_16)
	for iter0_16, iter1_16 in ipairs(var0_0.DisplayOrder) do
		if arg0_16.markSigns[iter1_16] then
			return iter1_16
		end
	end
end

function var0_0.UpdatePort(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17:DoUpdateMark("port_" .. arg0_17.portCamp, arg1_17)
	arg0_17:DoUpdateMark("port_gray_" .. arg0_17.portCamp, not arg1_17)
	arg0_17:DoUpdateMark("port_mark", arg2_17)
	arg0_17:DoUpdateMark("port_mark_new", arg3_17)
end

function var0_0.UpdatePressingAward(arg0_18)
	local var0_18 = nowWorld():GetPressingAward(arg0_18.entrance.id)

	if var0_18 then
		local var1_18 = pg.world_event_complete[var0_18.id]

		arg0_18:DoUpdateMark(var1_18.map_icon, var0_18.flag, arg0_18.tfMap)
	end
end

return var0_0
