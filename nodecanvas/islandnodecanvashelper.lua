function _IslandFindUnit(arg0_1, arg1_1)
	if not _IslandCore then
		return nil
	end

	local var0_1 = _IslandCore:GetView():GetUnitModuleWithType(arg0_1, arg1_1)

	if not var0_1 then
		return nil
	end

	return var0_1._go
end

function _IslandDestoryUnit(arg0_2, arg1_2)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.RMOVE_UNIT, arg0_2, arg1_2)
end

function _IslandMoveUnit(arg0_3, arg1_3, arg2_3, arg3_3)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.MOVE_UNIT, {
		id = arg1_3,
		type = arg0_3,
		position = arg2_3,
		speed = arg3_3
	})
end

function _IslandStopMoveUnit(arg0_4, arg1_4)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.STOP_MOVE_UNIT, {
		id = arg1_4,
		type = arg0_4
	})
end

function _IslandPlayBubble(arg0_5, arg1_5)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.PLAY_BUBBLE, {
		name = arg0_5,
		callback = arg1_5
	})
end

function _IslandChangeDelegateSlotModel(arg0_6, arg1_6, arg2_6)
	if not _IslandCore then
		return nil
	end

	getProxy(IslandProxy):GetIsland():DispatchEvent(ISLAND_EVT.CHANGE_SLOT_MODEL, {
		id = arg1_6,
		type = arg0_6,
		modelId = arg2_6
	})
end

function _IslandStartDelegateSlotPerform(arg0_7, arg1_7)
	if not _IslandCore then
		return nil
	end

	local var0_7 = getProxy(IslandProxy):GetIsland()

	_IslandCore:Link(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, {
		id = arg1_7,
		type = arg0_7
	})
end
