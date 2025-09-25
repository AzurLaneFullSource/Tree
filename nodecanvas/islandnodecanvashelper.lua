function _IslandFindUnit(arg0_1, arg1_1)
	local var0_1 = _IslandGetUnit(arg0_1, arg1_1)

	return var0_1 and var0_1._go
end

function _IslandGetUnit(arg0_2, arg1_2)
	if not _IslandCore then
		return nil
	end

	local var0_2 = _IslandCore:GetView():GetUnitModuleWithType(arg0_2, arg1_2)

	if not var0_2 then
		return nil
	end

	return var0_2
end

function _IslandDestoryUnit(arg0_3, arg1_3)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.RMOVE_UNIT, arg0_3, arg1_3)
end

function _IslandMoveUnit(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.MOVE_UNIT, {
		id = arg1_4,
		type = arg0_4,
		position = arg2_4,
		speed = arg3_4,
		charaRadius = arg4_4
	})
end

function _IslandStopMoveUnit(arg0_5, arg1_5)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.STOP_MOVE_UNIT, {
		id = arg1_5,
		type = arg0_5
	})
end

function _IslandPlayBubble(arg0_6, arg1_6)
	if not _IslandCore then
		return nil
	end

	_IslandCore:Link(ISLAND_EVT.PLAY_BUBBLE, {
		name = arg0_6,
		callback = arg1_6
	})
end

function _IslandChangeDelegateSlotModel(arg0_7, arg1_7, arg2_7)
	if not _IslandCore then
		return nil
	end

	getProxy(IslandProxy):GetIsland():DispatchEvent(ISLAND_EVT.CHANGE_SLOT_MODEL, {
		id = arg1_7,
		type = arg0_7,
		modelId = arg2_7
	})
end

function _IslandStartDelegateSlotPerform(arg0_8, arg1_8)
	if not _IslandCore then
		return nil
	end

	local var0_8 = getProxy(IslandProxy):GetIsland()

	_IslandCore:Link(ISLAND_EVT.START_DELEGATE_SLOT_PERFORM, {
		id = arg1_8,
		type = arg0_8
	})
end
