local var0 = class("WSEntranceTpl", import("...BaseEntity"))

var0.Fields = {
	markSigns = "table",
	portCamp = "number",
	world = "table",
	transform = "userdata",
	tfMap = "userdata",
	entrance = "table",
	markTFs = "table",
	tfArea = "userdata"
}
var0.Listeners = {
	onUpdateDisplayMarks = "OnUpdateDisplayMarks"
}
var0.DisplayOrder = {
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
var0.prefabName = {
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
var0.offsetField = {
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

function var0.Build(arg0)
	arg0.transform = tf(GameObject.New())
end

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:RemoveEntranceListener()

	local var0 = PoolMgr.GetInstance()

	for iter0, iter1 in pairs(arg0.markTFs) do
		iter1.localPosition = Vector3.zero

		var0:ReturnPrefab("world/mark/" .. var0.prefabName[iter0], var0.prefabName[iter0], go(iter1), true)
	end

	Destroy(arg0.transform)
	arg0:Clear()
end

function var0.Init(arg0)
	arg0.markTFs = {}
end

function var0.UpdateEntrance(arg0, arg1, arg2)
	if arg2 or arg0.entrance ~= arg1 then
		arg0:RemoveEntranceListener()
		_.each(arg0.markTFs, function(arg0)
			setActive(arg0, false)
		end)

		arg0.entrance = arg1
		arg0.portCamp = arg0.entrance:HasPort() and pg.world_port_data[arg0.entrance.config.port_map_icon].port_camp or nil

		arg0:AddEntranceListener()
		arg0:InitMarksValue()

		arg0.transform.name = arg0.portCamp and "port_" .. arg1.id or arg1:GetColormaskUniqueID()

		arg0:DoUpdateMark(arg0:GetShowMark(), true)
	end
end

function var0.InitMarksValue(arg0)
	arg0.markSigns = {}

	local var0 = arg0.entrance:GetDisplayMarks()

	for iter0, iter1 in pairs(var0) do
		arg0.markSigns[iter0] = iter1 > 0
	end
end

function var0.AddEntranceListener(arg0)
	if arg0.entrance then
		arg0.entrance:AddListener(WorldEntrance.EventUpdateDisplayMarks, arg0.onUpdateDisplayMarks)
	end
end

function var0.RemoveEntranceListener(arg0)
	if arg0.entrance then
		arg0.entrance:RemoveListener(WorldEntrance.EventUpdateDisplayMarks, arg0.onUpdateDisplayMarks)
	end
end

function var0.LoadPrefab(arg0, arg1, arg2)
	local var0 = PoolMgr.GetInstance()

	var0:GetPrefab("world/mark/" .. var0.prefabName[arg1], var0.prefabName[arg1], true, function(arg0)
		if arg0.markTFs and not arg0.markTFs[arg1] then
			arg0.markTFs[arg1] = tf(arg0)

			SetParent(arg0.markTFs[arg1], arg0.transform, false)

			arg0.markTFs[arg1].localPosition = arg0:GetPrefabOffset(arg1)

			if arg2 then
				SetParent(arg0.markTFs[arg1], arg2, true)
			end

			setActive(arg0.markTFs[arg1], true)
		else
			var0:ReturnPrefab("world/mark/" .. var0.prefabName[arg1], var0.prefabName[arg1], arg0, true)
		end
	end)
end

function var0.GetPrefabOffset(arg0, arg1)
	local var0 = var0.offsetField[arg1] and arg0.entrance.config[var0.offsetField[arg1]] or {
		0,
		0
	}

	return Vector3(var0[1] / PIXEL_PER_UNIT, 0, var0[2] / PIXEL_PER_UNIT)
end

function var0.UpdateMark(arg0, arg1, arg2)
	arg0:DoUpdateMark(arg0:GetShowMark(), false)

	arg0.markSigns[arg1] = arg2

	arg0:DoUpdateMark(arg0:GetShowMark(), true)
end

function var0.OnUpdateDisplayMarks(arg0, arg1, arg2, arg3, arg4)
	arg0:UpdateMark(arg3, arg4)
end

function var0.DoUpdateMark(arg0, arg1, arg2, arg3)
	if arg1 then
		if arg0.markTFs[arg1] then
			setActive(arg0.markTFs[arg1], arg2)
		elseif arg2 then
			arg0:LoadPrefab(arg1, arg3)
		end
	end
end

function var0.GetShowMark(arg0)
	for iter0, iter1 in ipairs(var0.DisplayOrder) do
		if arg0.markSigns[iter1] then
			return iter1
		end
	end
end

function var0.UpdatePort(arg0, arg1, arg2, arg3)
	arg0:DoUpdateMark("port_" .. arg0.portCamp, arg1)
	arg0:DoUpdateMark("port_gray_" .. arg0.portCamp, not arg1)
	arg0:DoUpdateMark("port_mark", arg2)
	arg0:DoUpdateMark("port_mark_new", arg3)
end

function var0.UpdatePressingAward(arg0)
	local var0 = nowWorld():GetPressingAward(arg0.entrance.id)

	if var0 then
		local var1 = pg.world_event_complete[var0.id]

		arg0:DoUpdateMark(var1.map_icon, var0.flag, arg0.tfMap)
	end
end

return var0
