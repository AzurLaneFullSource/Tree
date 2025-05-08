local var0_0 = class("PlayerInputManager")
local var1_0 = require("Framework.toLua.UnityEngine.Vector3")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.inputController = IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController))
	arg0_1.inputCommandQueue = {}

	function var0_0.UpdateMoveFunc(arg0_2)
		local var0_2 = var1_0(arg0_2.x, 0, arg0_2.y)
		local var1_2 = arg0_2.magnitude

		table.insert(arg0_1.inputCommandQueue, {
			Execute = function()
				arg1_1:NotifiyCore(ISLAND_EVT.MOVE_PLAYER, {
					targetDir = var0_2,
					force = var1_2
				})
			end
		})
	end

	arg0_1.inputController:AddUpdateMoveFunc(var0_0.UpdateMoveFunc)

	function var0_0.CancelMoveFunc(arg0_4)
		table.insert(arg0_1.inputCommandQueue, {
			Execute = function()
				arg1_1:NotifiyCore(ISLAND_EVT.STOP_MOVE_PLAYER)
			end
		})
	end

	arg0_1.inputController:AddCancelMoveFunc(var0_0.CancelMoveFunc)

	function var0_0.UpdateJumpFunc(arg0_6)
		table.insert(arg0_1.inputCommandQueue, {
			Execute = function()
				arg1_1:NotifiyCore(ISLAND_EVT.JUMP_PLAYER)
			end
		})
	end

	arg0_1.inputController:AddUpdateJumpFunc(var0_0.UpdateJumpFunc)

	function var0_0.UpdateSprintFuc(arg0_8)
		table.insert(arg0_1.inputCommandQueue, {
			Execute = function()
				arg1_1:NotifiyCore(ISLAND_EVT.SPRINT_PLAYER)
			end
		})
	end

	arg0_1.inputController:AddUpdateSprintFunc(var0_0.UpdateSprintFuc)

	function var0_0.CancelSprintFuc(arg0_10)
		table.insert(arg0_1.inputCommandQueue, {
			Execute = function()
				arg1_1:NotifiyCore(ISLAND_EVT.STOP_SPRINT_PLAYER)
			end
		})
	end

	arg0_1.inputController:AddCancelSprintFunc(var0_0.CancelSprintFuc)
end

function var0_0.Update(arg0_12)
	if #arg0_12.inputCommandQueue == 0 then
		return
	end

	while #arg0_12.inputCommandQueue > 0 do
		arg0_12.inputCommandQueue[1]:Execute()
		table.remove(arg0_12.inputCommandQueue, 1)
	end
end

function var0_0.Dispose(arg0_13)
	arg0_13.inputController:RemoveUpdateMoveFunc(var0_0.UpdateMoveFunc)
	arg0_13.inputController:RemoveCancelMoveFunc(var0_0.CancelMoveFunc)
	arg0_13.inputController:RemoveUpdateJumpFunc(var0_0.UpdateJumpFunc)
	arg0_13.inputController:RemoveUpdateSprintFunc(var0_0.UpdateSprintFuc)
	arg0_13.inputController:RemoveCancelSprintFunc(var0_0.CancelSprintFuc)

	arg0_13.inputController = nil
end

return var0_0
