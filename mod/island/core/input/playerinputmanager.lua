local var0_0 = class("PlayerInputManager")
local var1_0 = require("Framework.toLua.UnityEngine.Vector3")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.inputController = IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController))
	arg0_1.controller = arg1_1
	arg0_1.inputCommandQueue = {}
	arg0_1.isInit = false
end

function var0_0.IsInit(arg0_2)
	return arg0_2.isInit
end

function var0_0.Init(arg0_3)
	arg0_3.isInit = true

	local var0_3 = arg0_3.controller

	function var0_0.UpdateMoveFunc(arg0_4)
		local var0_4 = var1_0(arg0_4.x, 0, arg0_4.y)

		var0_3:NotifiyCore(ISLAND_EVT.MOVE_PLAYER_BEFORE)

		local var1_4 = arg0_4.magnitude

		table.insert(arg0_3.inputCommandQueue, {
			Execute = function()
				var0_3:NotifiyCore(ISLAND_EVT.MOVE_PLAYER, {
					targetDir = var0_4,
					force = var1_4
				})
			end
		})
	end

	arg0_3.inputController:AddUpdateMoveFunc(var0_0.UpdateMoveFunc)

	function var0_0.CancelMoveFunc(arg0_6)
		table.insert(arg0_3.inputCommandQueue, {
			Execute = function()
				var0_3:NotifiyCore(ISLAND_EVT.STOP_MOVE_PLAYER)
			end
		})
	end

	arg0_3.inputController:AddCancelMoveFunc(var0_0.CancelMoveFunc)

	function var0_0.UpdateJumpFunc(arg0_8)
		table.insert(arg0_3.inputCommandQueue, {
			Execute = function()
				var0_3:NotifiyCore(ISLAND_EVT.JUMP_PLAYER)
			end
		})
	end

	arg0_3.inputController:AddUpdateJumpFunc(var0_0.UpdateJumpFunc)

	function var0_0.UpdateSprintFuc(arg0_10)
		table.insert(arg0_3.inputCommandQueue, {
			Execute = function()
				var0_3:NotifiyCore(ISLAND_EVT.SPRINT_PLAYER)
			end
		})
	end

	arg0_3.inputController:AddUpdateSprintFunc(var0_0.UpdateSprintFuc)

	function var0_0.CancelSprintFuc(arg0_12)
		table.insert(arg0_3.inputCommandQueue, {
			Execute = function()
				var0_3:NotifiyCore(ISLAND_EVT.STOP_SPRINT_PLAYER)
			end
		})
	end

	arg0_3.inputController:AddCancelSprintFunc(var0_0.CancelSprintFuc)
end

function var0_0.Update(arg0_14)
	if not arg0_14.isInit then
		return
	end

	if #arg0_14.inputCommandQueue == 0 then
		return
	end

	while #arg0_14.inputCommandQueue > 0 do
		local var0_14 = arg0_14.inputCommandQueue[1]

		table.remove(arg0_14.inputCommandQueue, 1)

		if not arg0_14.disablePlayerHandle then
			var0_14:Execute()
		end
	end
end

function var0_0.Dispose(arg0_15)
	if not arg0_15.isInit then
		return
	end

	arg0_15.inputController:RemoveUpdateMoveFunc(var0_0.UpdateMoveFunc)
	arg0_15.inputController:RemoveCancelMoveFunc(var0_0.CancelMoveFunc)
	arg0_15.inputController:RemoveUpdateJumpFunc(var0_0.UpdateJumpFunc)
	arg0_15.inputController:RemoveUpdateSprintFunc(var0_0.UpdateSprintFuc)
	arg0_15.inputController:RemoveCancelSprintFunc(var0_0.CancelSprintFuc)

	arg0_15.inputController = nil
end

function var0_0.UpdataWorkStateFunc(arg0_16, arg1_16, arg2_16)
	table.insert(arg0_16.inputCommandQueue, {
		Execute = function()
			arg0_16.controller:NotifiyCore(ISLAND_EVT.SET_PLAYER_WORK, arg1_16, arg2_16)
		end
	})
end

function var0_0.DisablePlayerHandle(arg0_18)
	arg0_18.disablePlayerHandle = true
end

function var0_0.EnablePlayerHandle(arg0_19)
	arg0_19.disablePlayerHandle = false
end

function var0_0.DisableInput(arg0_20)
	while #arg0_20.inputCommandQueue > 0 do
		table.remove(arg0_20.inputCommandQueue, 1)
	end

	arg0_20.inputController:DisablePlayerAllOp()
end

function var0_0.EnableInput(arg0_21)
	arg0_21.inputController:EnablePlayerAllOp()
end

return var0_0
